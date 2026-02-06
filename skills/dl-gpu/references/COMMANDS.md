# dl GPU Command Reference

Complete reference for `dlsmi` command-line tool.

## Basic Commands

### Display GPU Summary

```bash
dlsmi
```

Shows comprehensive GPU status including:
- GPU name and PCI bus ID
- Temperature, fan speed, power usage
- Memory usage per cluster
- GPU utilization
- Performance state (P0-P12)

### List GPUs

```bash
dlsmi --list-gpus
```

Lists all GPUs detected in the system.

## Query Commands

### Query GPU Properties

```bash
dlsmi --query-gpu=<properties> --format=csv
```

**Available properties:**

- `index` - GPU index (0-based)
- `name` - GPU product name
- `uuid` - Globally unique identifier
- `pci.bus_id` - PCI bus ID
- `serial` - Serial number

**Temperature:**
- `temperature.gpu` - Core GPU temperature
- `temperature.gpu.tlimit` - Temperature limit
- `temperature.memory` - HBM memory temperature

**Memory:**
- `memory.total` - Total GPU memory
- `memory.used` - Used memory
- `memory.free` - Free memory
- `memory.reserved` - Reserved by driver

**Utilization:**
- `utilization.gpu` - GPU utilization %
- `utilization.memory` - Memory utilization %
- `utilization.encoder` - Encoder utilization %
- `utilization.decoder` - Decoder utilization %

**Power:**
- `power.draw` - Current power draw (W)
- `power.draw.average` - Average power draw
- `power.draw.instant` - Instant power draw
- `power.limit` - Power limit (W)
- `power.min_limit` - Minimum power limit
- `power.max_limit` - Maximum power limit

**Clocks:**
- `clocks.current.sm` - Current SM clock speed
- `clocks.current.memory` - Current memory clock speed
- `clocks.current.graphics` - Current graphics clock
- `clocks.max.sm` - Maximum SM clock
- `clocks.max.memory` - Maximum memory clock

**Performance:**
- `pstate` - Performance state (P0-P12)
- `fan.speed` - Fan speed percentage

**PCIe:**
- `pcie.link.gen.current` - Current PCIe generation
- `pcie.link.gen.max` - Maximum PCIe generation
- `pcie.link.width.current` - Current PCIe width
- `pcie.link.width.max` - Maximum PCIe width

**MIG:**
- `mig.mode.current` - Current MIG mode
- `mig.mode.pending` - Pending MIG mode

### Query Format Options

```bash
--format=csv              # Comma-separated values
--format=csv,noheader     # Skip header row
--format=csv,noheader,nounits  # Skip header and units
--format=csv,nounits      # Skip units only
```

### Query Compute Apps

```bash
dlsmi --query-compute-apps=<properties> --format=csv
```

**Available properties:**
- `pid` - Process ID
- `used_memory` - Memory used by process
- `gpu_bus_id` - GPU PCI bus ID
- `name` - Process name

## Monitoring Commands

### Continuous Monitoring

```bash
# Update every N seconds
dlsmi -l <seconds>

# Update every N milliseconds
dlsmi -lms <milliseconds>

# Example: Update every 1 second
dlsmi -l 1

# Example: Update every 500ms
dlsmi -lms 500
```

### Log to File

```bash
dlsmi --filename=<logfile>
dlsmi -l 5 --filename=gpu_monitor.log
```

## Targeting Specific GPUs

### By Index

```bash
dlsmi -i 0 --query-gpu=temperature.gpu --format=csv,noheader,nounits
dlsmi -i 0,1,2 --query-gpu=name,temperature.gpu --format=csv
```

### By PCI Bus ID

```bash
dlsmi -i 0000:01:00.0 --query-gpu=name --format=csv,noheader
```

### By UUID

```bash
dlsmi -i GPU-<uuid> --query-gpu=name --format=csv,noheader
```

## Device Modification Commands

**NOTE: These operations require root privileges and can affect system stability.**

### GPU Reset

```bash
# Reset GPU hardware state
sudo dlsmi -i 0 -r

# Reset and rescan from PCIe tree
sudo dlsmi -i 0 -rr

# Rescan GPU from PCIe tree
sudo dlsmi --gpu-rescan
```

### Clock Management

```bash
# Lock GPU clock (min,max or single value)
sudo dlsmi -i 0 -lgc 1500,1500
sudo dlsmi -i 0 -lgc 1500

# Reset GPU clocks to default
sudo dlsmi -i 0 -rgc

# Lock memory clock
sudo dlsmi -i 0 -lmc 5000,5000

# Reset memory clocks
sudo dlsmi -i 0 -rmc

# Set application clocks
sudo dlsmi -i 0 -ac 5000,1500

# Reset application clocks
sudo dlsmi -i 0 -rac
```

### Multi-Instance GPU (MIG)

```bash
# Enable MIG mode
sudo dlsmi -i 0 -mig 1

# Disable MIG mode
sudo dlsmi -i 0 -mig 0
```

### PCIe Configuration

```bash
# Set peer BAR mode (0=truncated, 1=full_ranged)
sudo dlsmi -i 0 -pbm 1

# Set PCIe Maximum Payload Size
sudo dlsmi -i 0 -mps 4

# Set PCIe Maximum Read Request Size
sudo dlsmi -i 0 -mrrs 4
```

## Topology Commands

### Display Topology Matrix

```bash
dlsmi topo -m
```

Shows GPU-to-GPU communication paths and bandwidth.

### Display P2P Capabilities

```bash
dlsmi topo -p2p
```

Shows peer-to-peer capabilities between GPUs.

### Find Nearest GPUs

```bash
dlsmi topo -i <gpu_id> -n <level>
```

**Levels:**
- 0: Single PCIe switch on dual GPU board
- 1: Single PCIe switch
- 2: Multiple PCIe switches
- 3: PCIe host bridge
- 4: On-CPU interconnect link
- 5: SMP interconnect link between NUMA nodes

### Display GPU Path

```bash
dlsmi topo -i <gpu_id1>,<gpu_id2> -p
```

Shows the most direct path between two GPUs.

## Special Commands

### DDR Utilization

```bash
dlsmi ddr_util
dlsmi ddr_util -i 0 -l 1
```

Display or monitor DDR memory utilization.

### Statistics (Experimental)

```bash
dlsmi stats
```

Display device statistics.

## XML Output

```bash
# Generate XML output
dlsmi -q -x

# Generate XML with DTD
dlsmi -q -x --dtd
```

## Help Commands

```bash
dlsmi --help
dlsmi --help-query-gpu
dlsmi --help-query-compute-apps
dlsmi topo -h
dlsmi stats -h
```

## Common Query Combinations

### Full GPU Status

```bash
dlsmi --query-gpu=index,name,temperature.gpu,utilization.gpu,utilization.memory,memory.used,memory.free,memory.total,power.draw,pstate --format=csv
```

### Thermal Status

```bash
dlsmi --query-gpu=index,temperature.gpu,temperature.gpu.tlimit,fan.speed --format=csv
```

### Memory Status

```bash
dlsmi --query-gpu=index,memory.used,memory.free,memory.total,memory.reserved --format=csv
```

### Power Status

```bash
dlsmi --query-gpu=index,power.draw,power.limit,enforced.power.limit,power.default_limit --format=csv
```

### PCIe Status

```bash
dlsmi --query-gpu=index,pcie.link.gen.current,pcie.link.width.current,pcie.link.gen.max,pcie.link.width.max --format=csv
```

### Clock Status

```bash
dlsmi --query-gpu=index,clocks.current.sm,clocks.current.memory,clocks.max.sm,clocks.max.memory --format=csv
```

### Throttling Reasons

```bash
dlsmi --query-gpu=index,clocks_event_reasons.gpu_idle,clocks_event_reasons.hw_thermal_slowdown,clocks_event_reasons.hw_power_brake_slowdown,clocks_event_reasons.sw_power_cap --format=csv
```

### ECC Errors

```bash
dlsmi --query-gpu=index,ecc.errors.corrected.volatile.total,ecc.errors.uncorrected.volatile.total --format=csv
```
