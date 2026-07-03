# Amba-APB-Slave-verification
# APB Slave Design (Verilog)

## Overview

This repository contains a simple **AMBA APB (Advanced Peripheral Bus) Slave** implemented in Verilog. The design demonstrates the basic operation of an APB peripheral, including read and write transactions, programmable wait states, memory-mapped storage, and error generation for invalid addresses.

The project is intended for students and engineers learning digital design, computer architecture, and SoC bus protocols.

---

## Features

* AMBA APB Slave implementation in Verilog
* 8-bit address bus
* 8-bit data bus
* Supports read and write operations
* Programmable wait states using a parameter
* Internal 8-byte memory
* Invalid address detection using `PSLVERR`
* Active-low asynchronous reset
* Simple and easy-to-understand RTL implementation

---

## Module Interface

| Signal    | Direction | Width | Description                            |
| --------- | --------- | ----: | -------------------------------------- |
| `PCLK`    | Input     |     1 | APB clock                              |
| `PRESETn` | Input     |     1 | Active-low reset                       |
| `PSEL`    | Input     |     1 | Slave select                           |
| `PENABLE` | Input     |     1 | Access phase signal                    |
| `PWRITE`  | Input     |     1 | Write enable (`1` = Write, `0` = Read) |
| `PADDR`   | Input     |     8 | Address bus                            |
| `PWDATA`  | Input     |     8 | Write data                             |
| `PRDATA`  | Output    |     8 | Read data                              |
| `PREADY`  | Output    |     1 | Transfer complete signal               |
| `PSLVERR` | Output    |     1 | Slave error signal                     |

---

## Design Description

The APB slave contains:

* An internal memory array of **8 locations**, each **8 bits wide**
* A programmable wait-state generator
* Transaction control logic
* Read and write controller
* Error detection logic

The slave begins processing a transaction when both `PSEL` and `PENABLE` are asserted. It waits for a programmable number of clock cycles before asserting `PREADY` to complete the transfer.

---

## Internal Memory

The slave contains the following memory:

| Memory     | Size      |
| ---------- | --------- |
| `mem[0:7]` | 8 × 8-bit |

Only the lower three address bits (`PADDR[2:0]`) are used to access memory locations.

Example:

| Address | Memory Location |
| ------- | --------------- |
| `0x00`  | `mem[0]`        |
| `0x01`  | `mem[1]`        |
| `0x02`  | `mem[2]`        |
| `0x03`  | `mem[3]`        |
| `0x04`  | `mem[4]`        |
| `0x05`  | `mem[5]`        |
| `0x06`  | `mem[6]`        |
| `0x07`  | `mem[7]`        |

---

## Wait State Generation

The number of wait states is controlled by the parameter:

```verilog
parameter N = 4;
```

The slave counts clock cycles after entering the access phase and asserts `PREADY` after `N` cycles.

Changing `N` changes the response time of the slave.

---

## Write Operation

During a write transaction:

1. Master selects the slave using `PSEL`.
2. Access phase begins by asserting `PENABLE`.
3. Slave starts the wait-state counter.
4. After the programmed delay:

   * `PREADY` is asserted.
   * Data on `PWDATA` is written into memory.
5. If the address is invalid, `PSLVERR` is asserted.

---

## Read Operation

During a read transaction:

1. Master selects the slave.
2. Slave waits for the programmed number of cycles.
3. `PREADY` is asserted.
4. Requested memory contents are placed on `PRDATA`.

---

## Invalid Address Detection

The following addresses are considered invalid for write operations:

* `0x10`
* `0x11`

For these addresses:

* No write operation occurs.
* `PSLVERR` is asserted for one clock cycle.

---

## Reset Operation

When `PRESETn` is driven low:

* Internal memory is cleared.
* `PRDATA` is reset to zero.
* `PREADY` is deasserted.
* `PSLVERR` is cleared.
* Wait counter is reset.
* Transaction state is cleared.

---

## Repository Structure

```text
.
├── rtl/
│   └── apb_slave.v
├── tb/
│   └── apb_slave_tb.v
├── README.md
```

> Update the directory names if your repository structure is different.

---

## Simulation

The design can be simulated using any Verilog simulator such as:

* ModelSim / QuestaSim
* Synopsys VCS
* Cadence Xcelium
* Verilator
* Icarus Verilog

Example using Icarus Verilog:

```bash
iverilog -o sim rtl/apb_slave.v tb/apb_slave_tb.v
vvp sim
```

---

## Applications

This project is suitable for:

* Learning the AMBA APB protocol
* Verilog RTL practice
* FPGA laboratory experiments
* UVM verification practice
* Digital design coursework
* SoC bus interface demonstrations

---

## Future Enhancements

Possible improvements include:

* Full APB3/APB4 protocol compliance
* Configurable memory size
* Address decoder
* Register-based peripheral implementation
* Read error generation
* Byte-enable support
* Interrupt generation
* UVM-based verification environment
* Functional coverage
* SystemVerilog Assertions (SVA)

---

## Contributor

**Anuj Deep**
**Registration Number:** 20234503

---

## License

This project is intended for educational and learning purposes. Feel free to use, modify, and extend the design for academic and personal projects.
