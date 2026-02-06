---
name: dl-gpu
description: Comprehensive monitoring and management for dl GPUs using dlsmi command-line tool. Use when users need to monitor GPU status (temperature, memory, utilization, power), query GPU information and metrics, check running processes on GPUs, perform GPU management operations (reset, topology, P2P), troubleshoot GPU issues, or optimize GPU performance for AI/ML workloads. Includes commands for deep learning training monitoring, model inference, and performance debugging.
---

# dl GPU

Monitor and manage dl GPUs using the `dlsmi` command-line interface.

## Quick Start

```bash
# View all GPU status
dlsmi

# Query specific GPU metrics
dlsmi --query-gpu=index,name,temperature.gpu,utilization.gpu,memory.used,memory.total --format=csv

# Monitor continuously (update every 1 second)
dlsmi -l 1

# Check running processes
dlsmi --query-compute-apps=pid,used_memory,gpu_bus_id --format=csv
```

## Common Tasks

### Monitor GPU Status

**Basic status overview:**
```bash
dlsmi
```

**Detailed metrics query:**
```bash
dlsmi --query-gpu=index,name,temperature.gpu,utilization.gpu,utilization.memory,memory.used,memory.free,memory.total,power.draw,pstate --format=csv
```

**Continuous monitoring:**
```bash
# Update every second
dlsmi -l 1

# Update every 500ms
dlsmi -lms 500
```

### Find Specific Information

**Hottest GPU:**
```bash
dlsmi --query-gpu=index,temperature.gpu --format=csv,noheader,nounits | sort -t',' -k2 -nr | head -1
```

**GPU with most free memory:**
```bash
dlsmi --query-gpu=index,memory.free --format=csv,noheader,nounits | sort -t',' -k2 -nr | head -1
```

**GPU with highest utilization:**
```bash
dlsmi --query-gpu=index,utilization.gpu --format=csv,noheader,nounits | sort -t',' -k2 -nr | head -1
```

### Check Running Processes

```bash
# List all compute processes
dlsmi --query-compute-apps=pid,used_memory,gpu_bus_id --format=csv

# Include process names
dlsmi --query-compute-apps=pid,used_memory,gpu_bus_id,name --format=csv
```

### Query Specific Metrics

**Temperature:**
```bash
dlsmi --query-gpu=temperature.gpu --format=csv,noheader,nounits
```

**Memory usage:**
```bash
dlsmi --query-gpu=memory.used,memory.free,memory.total --format=csv
```

**Power consumption:**
```bash
dlsmi --query-gpu=power.draw,power.limit --format=csv,noheader,nounits
```

**Clock speeds:**
```bash
dlsmi --query-gpu=clocks.current.sm,clocks.current.memory --format=csv,noheader,nounits
```

**PCIe link status:**
```bash
dlsmi --query-gpu=pcie.link.gen.current,pcie.link.width.current --format=csv,noheader,nounits
```

### Target Specific GPUs

```bash
# Query GPU 0 only
dlsmi -i 0 --query-gpu=temperature.gpu --format=csv,noheader,nounits

# Query GPUs 0, 1, and 2
dlsmi -i 0,1,2 --query-gpu=name,temperature.gpu --format=csv

# Query by PCI bus ID
dlsmi -i 0000:01:00.0 --query-gpu=name --format=csv,noheader
```

## Deep Learning Monitoring

**Training workload monitoring:**
```bash
dlsmi --query-gpu=index,utilization.gpu,utilization.memory,memory.used,temperature.gpu,power.draw --format=csv -l 1
```

**Memory tracking for large models:**
```bash
dlsmi --query-gpu=index,memory.used,memory.free,memory.total --format=csv
```

**Performance debugging:**
```bash
dlsmi --query-gpu=clocks.current.sm,clocks.current.memory,utilization.gpu,temperature.gpu,power.draw --format=csv
```

## Advanced Operations

### Topology and P2P

```bash
# Display GPU topology
dlsmi topo -m

# Display P2P capabilities
dlsmi topo -p2p

# Find nearest GPUs
dlsmi topo -i 0 -n 0
```

### GPU Reset

```bash
# Reset specific GPU (use with caution!)
sudo dlsmi -i 0 -r

# Reset and rescan
sudo dlsmi -i 0 -rr
```

### Multi-Instance GPU (MIG)

```bash
# Check MIG status
dlsmi --query-gpu=mig.mode.current --format=csv,noheader

# Enable MIG (requires root)
sudo dlsmi -i 0 -mig 1
```

## Troubleshooting

### GPU Not Detected

```bash
# Check if GPU is visible in lspci
lspci | grep -i co-processor

# Check kernel driver
lsmod | grep denglin

# Check driver module status
dkms status denglin
```

### High Temperature

```bash
# Check temperature vs limit
dlsmi --query-gpu=index,temperature.gpu,temperature.gpu.tlimit --format=csv

# Check for thermal throttling
dlsmi --query-gpu=clocks_event_reasons.hw_thermal_slowdown --format=csv,noheader
```

### Out of Memory

```bash
# Check memory usage by process
dlsmi --query-compute-apps=pid,used_memory,gpu_bus_id --format=csv

# Check total memory usage
dlsmi --query-gpu=index,memory.used,memory.free,memory.total --format=csv
```

### Performance Issues

```bash
# Check for clock throttling reasons
dlsmi --query-gpu=clocks_event_reasons.gpu_idle,clocks_event_reasons.hw_slowdown,clocks_event_reasons.sw_power_cap --format=csv

# Check performance state
dlsmi --query-gpu=pstate --format=csv,noheader,nounits
```

## Resources

For detailed command reference and advanced options, see [COMMANDS.md](references/COMMANDS.md).

For use case examples and workflows, see [EXAMPLES.md](references/EXAMPLES.md).
