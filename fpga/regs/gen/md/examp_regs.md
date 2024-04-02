<!---
Markdown description for SystemRDL register map.

Don't override. Generated from: examp_regs
  - common.rdl
  - examp_regs.rdl
-->

## examp_regs address map

- Absolute Address: 0x0
- Base Offset: 0x0
- Size: 0x2C

<p>Example register description.</p>

|Offset| Identifier|        Name        |
|------|-----------|--------------------|
| 0x00 |   common  |Common Register File|
| 0x10 |  control  |  Control Register  |
| 0x14 |   status  |   Status Register  |
| 0x18 |    hwrw   |          —         |
| 0x1C |wr_pulse[2]|          —         |
| 0x20 |wr_pulse[2]|          —         |
| 0x24 |  cntr[2]  |          —         |
| 0x28 |  cntr[2]  |          —         |

## common register file

- Absolute Address: 0x0
- Base Offset: 0x0
- Size: 0x10

<p>These registers should be instantiated at the base address of an fpga.</p>

|Offset|Identifier|        Name       |
|------|----------|-------------------|
|  0x0 |scratchpad|Scratchpad Register|
|  0x4 |    id    |    ID Register    |
|  0x8 |  version |  Version Register |
|  0xC |    git   | Git Hash Register |

### scratchpad register

- Absolute Address: 0x0
- Base Offset: 0x0
- Size: 0x4

<p>Scratchpad register for testing.</p>

|Bits|Identifier|Access|   Reset  |Name|
|----|----------|------|----------|----|
|31:0|scratchpad|  rw  |0x12345678|  — |

### id register

- Absolute Address: 0x4
- Base Offset: 0x4
- Size: 0x4

<p>Read-only ID register. This is a unique identification number for this fpga design.</p>

|Bits|Identifier|Access|Reset|Name|
|----|----------|------|-----|----|
|31:0|    id    |   r  |  —  |  — |

### version register

- Absolute Address: 0x8
- Base Offset: 0x8
- Size: 0x4

<p>Read-only version register. Semantic versioning is used. In short: 
MAJOR version = incompatible API change;
MINOR version = new functionality added in a backward compatible manner;
PATCH version = backward compatible bug fix; 
For more information, see https://semver.org</p>

| Bits|Identifier|Access|Reset|Name|
|-----|----------|------|-----|----|
| 7:0 |   patch  |   r  |  —  |  — |
| 15:8|   minor  |   r  |  —  |  — |
|23:16|   major  |   r  |  —  |  — |

### git register

- Absolute Address: 0xC
- Base Offset: 0xC
- Size: 0x4

<p>The last 8 characters of the git commit hash for this fpga design.</p>

|Bits|Identifier|Access|Reset|Name|
|----|----------|------|-----|----|
|31:0|    git   |   r  |  —  |  — |

### control register

- Absolute Address: 0x10
- Base Offset: 0x10
- Size: 0x4

<p>Overall control register.</p>

|Bits|Identifier|Access|Reset|Name|
|----|----------|------|-----|----|
|  0 |   ctl0   |  rw  | 0x1 |  — |
|  1 |   ctl1   |  rw  | 0x1 |  — |

### status register

- Absolute Address: 0x14
- Base Offset: 0x14
- Size: 0x4

<p>Overall status register.</p>

|Bits|Identifier|Access|Reset|  Name  |
|----|----------|------|-----|--------|
|  0 |   sts0   |   r  |  —  |Status 0|
|  1 |   sts1   |   r  |  —  |Status 1|

### hwrw register

- Absolute Address: 0x18
- Base Offset: 0x18
- Size: 0x4

<p>SW and HW can write, we flag needed to trigger write from hw. Also include outputs for swacc (rd / wr) and swmod (wr)</p>

|Bits|Identifier|Access|Reset|Name|
|----|----------|------|-----|----|
|31:0|   data   |  rw  | 0xB |  — |

### wr_pulse register

- Absolute Address: 0x1C
- Base Offset: 0x1C
- Size: 0x4
- Array Dimensions: [2]
- Array Stride: 0x4
- Total Size: 0x8

<p>Write pulse register. Just a write pulse</p>

|Bits|Identifier|Access|Reset|Name|
|----|----------|------|-----|----|
|  0 |   data   |   w  | 0x0 |  — |

### wr_pulse register

- Absolute Address: 0x20
- Base Offset: 0x1C
- Size: 0x4
- Array Dimensions: [2]
- Array Stride: 0x4
- Total Size: 0x8

<p>Write pulse register. Just a write pulse</p>

|Bits|Identifier|Access|Reset|Name|
|----|----------|------|-----|----|
|  0 |   data   |   w  | 0x0 |  — |

### cntr register

- Absolute Address: 0x24
- Base Offset: 0x24
- Size: 0x4
- Array Dimensions: [2]
- Array Stride: 0x4
- Total Size: 0x8

<p>Counter register. Just a simple up counter</p>

|Bits|Identifier|Access|Reset|Name|
|----|----------|------|-----|----|
|15:0|    cnt   |   r  | 0x0 |  — |

### cntr register

- Absolute Address: 0x28
- Base Offset: 0x24
- Size: 0x4
- Array Dimensions: [2]
- Array Stride: 0x4
- Total Size: 0x8

<p>Counter register. Just a simple up counter</p>

|Bits|Identifier|Access|Reset|Name|
|----|----------|------|-----|----|
|15:0|    cnt   |   r  | 0x0 |  — |
