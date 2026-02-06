# dl GPU Usage Examples

Practical examples and workflows for common dl GPU tasks.

## Deep Learning Training

### Monitor Training Progress

**Real-time training monitoring:**
```bash
watch -n 1 'dlsmi --query-gpu=index,utilization.gpu,utilization.memory,memory.used,temperature.gpu --format=csv'
```

**Check if all GPUs are utilized:**
```bash
dlsmi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk -F, '$1 < 80 {print "GPU " NR-1 " underutilized: " $1 "%"}'
```

**Memory-efficient training check:**
```bash
dlsmi --query-gpu=index,memory.used,memory.total --format=csv | awk -F, '{printf "GPU %s: %.2f GB / %.2f GB\n", $1, $2/1024, $3/1024}'
```

### Training Optimization

**Find coldest GPU for new task:**
```bash
dlsmi --query-gpu=index,temperature.gpu --format=csv,noheader,nounits | sort -t',' -k2 -n | head -1 | cut -d',' -f1
```

**Balance workload across GPUs:**
```bash
# Get GPU with lowest utilization
dlsmi --query-gpu=index,utilization.gpu --format=csv,noheader,nounits | sort -t',' -k2 -n | head -1 | cut -d',' -f1
```

**Check for thermal throttling during training:**
```bash
dlsmi --query-gpu=index,temperature.gpu,clocks_event_reasons.hw_thermal_slowdown --format=csv
```

## Model Inference

### Batch Inference Monitoring

**Monitor GPU memory during inference:**
```bash
dlsmi --query-gpu=index,memory.used,memory.free --format=csv
```

**Track inference throughput:**
```bash
# Monitor GPU utilization as proxy for throughput
dlsmi --query-gpu=index,utilization.gpu --format=csv,noheader,nounits -l 1
```

### Multi-Model Deployment

**Check which processes are running on which GPUs:**
```bash
dlsmi --query-compute-apps=pid,used_memory,gpu_bus_id,name --format=csv
```

**Find GPU with most available memory:**
```bash
dlsmi --query-gpu=index,memory.free --format=csv,noheader,nounits | sort -t',' -k2 -nr | head -1 | cut -d',' -f1
```

## Performance Debugging

### Identify Bottlenecks

**Check if GPU is compute-bound:**
```bash
dlsmi --query-gpu=utilization.gpu,utilization.memory --format=csv,noheader,nounits
```
- High GPU util, low memory util → Compute-bound
- Low GPU util, high memory util → Memory-bandwidth bound

**Check for clock throttling:**
```bash
dlsmi --query-gpu=index,clocks.current.sm,clocks.max.sm,clocks_event_reasons --format=csv
```

**Analyze power efficiency:**
```bash
dlsmi --query-gpu=index,utilization.gpu,power.draw --format=csv,noheader,nounits | awk -F, '{eff=$1/$2; printf "GPU %s: %.2f util/W\n", $1, eff}'
```

### Performance Profiling

**Capture performance state during workload:**
```bash
dlsmi -l 1 --query-gpu=index,pstate,clocks.current.sm,clocks.current.memory,utilization.gpu,temperature.gpu,power.draw --format=csv > profile.csv
```

**Check PCIe bandwidth utilization:**
```bash
dlsmi --query-gpu=index,pcie.link.gen.current,pcie.link.width.current,utilization.memory --format=csv
```

## System Administration

### Health Monitoring

**Daily health check:**
```bash
#!/bin/bash
echo "=== dl GPU Health Check ==="
echo "Date: $(date)"
echo ""
echo "Temperature Status:"
dlsmi --query-gpu=index,temperature.gpu,temperature.gpu.tlimit --format=csv
echo ""
echo "Memory Status:"
dlsmi --query-gpu=index,memory.used,memory.total --format=csv
echo ""
echo "ECC Errors:"
dlsmi --query-gpu=index,ecc.errors.corrected.volatile.total,ecc.errors.uncorrected.volatile.total --format=csv
echo ""
echo "Running Processes:"
dlsmi --query-compute-apps=pid,used_memory,gpu_bus_id --format=csv
```

**Alert on high temperature:**
```bash
dlsmi --query-gpu=index,temperature.gpu --format=csv,noheader,nounits | awk -F, '$2 > 80 {print "WARNING: GPU " $1 " at " $2 "°C"}'
```

**Check for hardware errors:**
```bash
dlsmi --query-gpu=index,ecc.errors.uncorrected.volatile.total,retired_pages.double_bit.count --format=csv | grep -v ",0,0"
```

### Resource Allocation

**List all GPUs with free memory:**
```bash
dlsmi --query-gpu=index,memory.free,memory.total --format=csv | awk -F, '{printf "GPU %s: %.1f GB free (%.1f%%)\n", $1, $2/1024, 100*$2/$3}'
```

**Find GPU meeting memory requirement:**
```bash
REQUIRED_MB=10240
dlsmi --query-gpu=index,memory.free --format=csv,noheader,nounits | awk -F, -v req=$REQUIRED_MB '$2 > req {print $1}'
```

**Generate GPU inventory:**
```bash
echo "=== GPU Inventory ==="
echo ""
echo "Total GPUs: $(dlsmi --query-gpu=count --format=csv,noheader,nounits)"
echo ""
echo "GPU Details:"
dlsmi --query-gpu=index,name,serial,memory.total --format=csv
```

## Multi-GPU Workloads

### Check P2P Capability

```bash
dlsmi topo -p2p
```

**Interpretation:**
- `X` on both read and write → P2P available
- `X` on read only → Read-only P2P
- Empty → No P2P, must go through CPU

### Find GPU Pairs for Multi-GPU Training

**Best pairs (same board):**
```bash
dlsmi topo -m | grep -E "^(GPU|NUMA)" | paste - -
```

**Find GPUs on same board:**
```bash
dlsmi --query-gpu=index,board_id --format=csv | awk -F, '{a[$2] = a[$2] "," $1} END {for (b in a) print "Board " b ":" a[b]}'
```

### Distributed Training Setup

**Check topology for optimal GPU placement:**
```bash
dlsmi topo -m
dlsmi --query-gpu=index,pcie.link.gen.current,pcie.link.width.current --format=csv
```

## Troubleshooting Scenarios

### Scenario: Training Slowdown

**Diagnosis:**
```bash
# Check utilization
dlsmi --query-gpu=utilization.gpu --format=csv,noheader,nounits

# Check for throttling
dlsmi --query-gpu=clocks_event_reasons --format=csv

# Check temperature
dlsmi --query-gpu=temperature.gpu --format=csv,noheader,nounits

# Check performance state
dlsmi --query-gpu=pstate --format=csv,noheader,nounits
```

### Scenario: Out of Memory

**Diagnosis:**
```bash
# Check memory usage by process
dlsmi --query-compute-apps=pid,used_memory,gpu_bus_id --format=csv

# Check total memory
dlsmi --query-gpu=index,memory.used,memory.free,memory.total --format=csv

# Find memory leaks (monitor over time)
dlsmi -l 10 --query-gpu=index,memory.used --format=csv
```

### Scenario: GPU Not Detected

**Diagnosis:**
```bash
# Check if GPU visible in lspci
lspci | grep -i co-processor

# Check kernel driver
lsmod | grep denglin

# Check kernel messages
dmesg | grep -i denglin | tail -20

# Verify driver is loaded
dkms status denglin
```

### Scenario: High Temperature

**Diagnosis:**
```bash
# Check temperature vs limit
dlsmi --query-gpu=index,temperature.gpu,temperature.gpu.tlimit --format=csv

# Check for thermal throttling
dlsmi --query-gpu=clocks_event_reasons.hw_thermal_slowdown --format=csv,noheader,nounits

# Check fan speed
dlsmi --query-gpu=fan.speed --format=csv,noheader,nounits

# Monitor over time
dlsmi -l 5 --query-gpu=temperature.gpu --format=csv,noheader,nounits
```

## Automation Scripts

### GPU Selection Script

```bash
#!/bin/bash
# Select GPU with most free memory and lowest temperature
FREE_MEM=$(dlsmi --query-gpu=index,memory.free --format=csv,noheader,nounits | sort -t',' -k2 -nr | head -1 | cut -d',' -f1)
TEMP=$(dlsmi --query-gpu=index,temperature.gpu --format=csv,noheader,nounits | sort -t',' -k2 -n | head -1 | cut -d',' -f1)

# Use GPU with most free memory if within 10°C of coolest
COOLEST_TEMP=$(dlsmi --query-gpu=temperature.gpu --format=csv,noheader,nounits | sort -n | head -1)
FREE_GPU_TEMP=$(dlsmi -i $FREE_MEM --query-gpu=temperature.gpu --format=csv,noheader,nounits)

if [ $(($FREE_GPU_TEMP - $COOLEST_TEMP)) -lt 10 ]; then
    echo $FREE_MEM
else
    echo $TEMP
fi
```

### Batch Job Script

```bash
#!/bin/bash
# Wait for GPU to be available, then run job
GPU_ID=$1
COMMAND="${@:2}"

while true; do
    UTIL=$(dlsmi -i $GPU_ID --query-gpu=utilization.gpu --format=csv,noheader,nounits)
    if [ "$UTIL" -lt 10 ]; then
        echo "GPU $GPU_ID available. Running: $COMMAND"
        CUDA_VISIBLE_DEVICES=$GPU_ID $COMMAND
        break
    fi
    echo "GPU $GPU_ID busy ($UTIL% util). Waiting..."
    sleep 10
done
```

### Log Analysis

```bash
# Parse CSV logs from dlsmi monitoring
# Extract average utilization
awk -F, 'NR>1 {sum+=$4; count++} END {print "Average GPU util:", sum/count "%"}' profile.csv

# Find peak memory usage
awk -F, 'NR>1 {if ($6 > max) {max=$6; gpu=$1}} END {print "Peak memory:", max "MiB on GPU", gpu}' profile.csv

# Temperature over time graph (requires gnuplot)
awk -F, 'NR>1 {print NR-1, $3}' profile.csv > temp.dat && gnuplot -e "plot 'temp.dat' with lines"
```

## Development Tools Integration

### With Python

```python
import subprocess

def get_gpu_utilization():
    result = subprocess.run(['dlsmi', '--query-gpu=utilization.gpu', '--format=csv,noheader,nounits'],
                          capture_output=True, text=True)
    return [int(x) for x in result.stdout.strip().split('\n')]

def get_free_memory():
    result = subprocess.run(['dlsmi', '--query-gpu=memory.free', '--format=csv,noheader,nounits'],
                          capture_output=True, text=True)
    return [int(x) for x in result.stdout.strip().split('\n')]

# Select GPU with most free memory
def select_gpu():
    free_mem = get_free_memory()
    return free_mem.index(max(free_mem))
```

### With Shell Scripts

```bash
# Get GPU count
GPU_COUNT=$(dlsmi --query-gpu=count --format=csv,noheader,nounits)

# Loop through all GPUs
for i in $(seq 0 $(($GPU_COUNT - 1))); do
    echo "GPU $i: $(dlsmi -i $i --query-gpu=name --format=csv,noheader)"
done
```
