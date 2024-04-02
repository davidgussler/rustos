<!---
Markdown description for SystemRDL register map.

Don't override. Generated from: examp_regs
  - examp_regs.rdl
-->

## examp_regs address map

- Absolute Address: 0x0
- Base Offset: 0x0
- Size: 0x20

<p>Example register description.</p>

|Offset|Identifier|         Name        |
|------|----------|---------------------|
| 0x00 |scratchpad| Scratchpad Register |
| 0x04 |  version |FPGA Verison Register|
| 0x08 |  control |   Control Register  |
| 0x0C |  status  |   Status Register   |
| 0x10 | mixed[4] |    Mixed Register   |
| 0x14 | mixed[4] |    Mixed Register   |
| 0x18 | mixed[4] |    Mixed Register   |
| 0x1C | mixed[4] |    Mixed Register   |

### scratchpad register

- Absolute Address: 0x0
- Base Offset: 0x0
- Size: 0x4

<p>Scratchpad register for FPGA firmware testing.</p>

|Bits|Identifier|Access|Reset|Name|
|----|----------|------|-----|----|
|31:0|scratchpad|  rw  | 0x0 |  — |

### version register

- Absolute Address: 0x4
- Base Offset: 0x4
- Size: 0x4

<p>Read-only FPGA version register. A new version here indicates 
that the FPGA HDL has changed in some meaningful way.</p>

| Bits|Identifier|Access|Reset|Name|
|-----|----------|------|-----|----|
| 15:0|   minor  |   r  |  —  |  — |
|31:16|   major  |   r  |  —  |  — |

### control register

- Absolute Address: 0x8
- Base Offset: 0x8
- Size: 0x4

<p>Overall control register.</p>

|Bits|Identifier|Access|Reset|   Name  |
|----|----------|------|-----|---------|
|  0 |   ctl0   |  rw  | 0x1 |Control 0|
|  1 |   ctl1   |  rw  | 0x1 |Control 1|

### status register

- Absolute Address: 0xC
- Base Offset: 0xC
- Size: 0x4

<p>Overall status register.</p>

|Bits|Identifier|Access|Reset|  Name  |
|----|----------|------|-----|--------|
|  0 |   sts0   |   r  |  —  |Status 0|
|  1 |   sts1   |   r  |  —  |Status 1|

### mixed register

- Absolute Address: 0x10
- Base Offset: 0x10
- Size: 0x4
- Array Dimensions: [4]
- Array Stride: 0x4
- Total Size: 0x10

<p>Mixed register with loads of functionality.</p>

|Bits|Identifier| Access|Reset|            Name           |
|----|----------|-------|-----|---------------------------|
| 7:0|  count0  |   r   | 0x0 |Incrementing Count Register|
|15:8|  events  |r, rclr| 0x0 |      Events Register      |

#### events field

<p>Description of events register.</p>

### mixed register

- Absolute Address: 0x14
- Base Offset: 0x10
- Size: 0x4
- Array Dimensions: [4]
- Array Stride: 0x4
- Total Size: 0x10

<p>Mixed register with loads of functionality.</p>

|Bits|Identifier| Access|Reset|            Name           |
|----|----------|-------|-----|---------------------------|
| 7:0|  count0  |   r   | 0x0 |Incrementing Count Register|
|15:8|  events  |r, rclr| 0x0 |      Events Register      |

#### events field

<p>Description of events register.</p>

### mixed register

- Absolute Address: 0x18
- Base Offset: 0x10
- Size: 0x4
- Array Dimensions: [4]
- Array Stride: 0x4
- Total Size: 0x10

<p>Mixed register with loads of functionality.</p>

|Bits|Identifier| Access|Reset|            Name           |
|----|----------|-------|-----|---------------------------|
| 7:0|  count0  |   r   | 0x0 |Incrementing Count Register|
|15:8|  events  |r, rclr| 0x0 |      Events Register      |

#### events field

<p>Description of events register.</p>

### mixed register

- Absolute Address: 0x1C
- Base Offset: 0x10
- Size: 0x4
- Array Dimensions: [4]
- Array Stride: 0x4
- Total Size: 0x10

<p>Mixed register with loads of functionality.</p>

|Bits|Identifier| Access|Reset|            Name           |
|----|----------|-------|-----|---------------------------|
| 7:0|  count0  |   r   | 0x0 |Incrementing Count Register|
|15:8|  events  |r, rclr| 0x0 |      Events Register      |

#### events field

<p>Description of events register.</p>
