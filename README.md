# MIPS Single-Cycle Processor (VHDL Implementation)

This repository contains the VHDL implementation and extensive verification of a single-cycle MIPS processor, designed to execute a subset of the MIPS Instruction Set Architecture (ISA).

## Documentation Language

This repository includes comprehensive documentation:

- **[Documentation.pdf](Documentation.pdf)** - Detailed technical documentation (in Greek) covering:
  - Individual component implementation and testing
  - Complete processor architecture
  - Simulation results and waveform analysis
  - Control signal verification
  - Test program execution traces

All code comments and this README are provided in English, while the detailed technical report is in Greek.

## Project Overview

The project follows a standard hierarchical design methodology, where individual data path components (units) are first developed and tested before being integrated into the top-level MIPS entity.

The design is organized to clearly separate the hardware logic from the verification environment, following the structure:

- `src/`: All VHDL files describing the hardware.
- `sim/`: All VHDL testbenches and simulation scripts.

## Implemented MIPS Instruction Set

This MIPS processor supports the following specific instruction subset, as detailed in the project's VHDL code and simulation:

### R-Type (Arithmetic & Logic)

| Instruction | Opcode | Funct  | Description              |
|-------------|--------|--------|--------------------------|
| add         | 000000 | 100000 | Register addition        |
| sub         | 000000 | 100010 | Register subtraction     |
| and         | 000000 | 100100 | Bitwise AND              |
| or          | 000000 | 100101 | Bitwise OR               |
| slt         | 000000 | 101010 | Set on Less Than         |
| sll/srl     | 000000 | 000010 | Shift Left/Right Logical |

### I-Type (Immediate & Data Transfer)

| Instruction | Opcode | Description                    |
|-------------|--------|--------------------------------|
| addi        | 001000 | Add Immediate                  |
| lw          | 100011 | Load Word from Data Memory     |
| sw          | 101011 | Store Word to Data Memory      |
| beq         | 000100 | Branch if Equal                |
| bne         | 000101 | Branch if Not Equal            |

### J-Type (Jump)

| Instruction | Opcode | Description       |
|-------------|--------|-------------------|
| j           | 000010 | Jump to Address   |

## Processor Architecture

The processor adheres to the classical single-cycle design, where every instruction is completed in one clock cycle. The design comprises the following major functional blocks:

### Core Components

- **Program Counter (PC)**: Maintains the address of the current instruction. Increments by 1 each cycle, with support for branch and jump operations.
- **Instruction Memory**: Stores the program instructions to be executed.
- **Register File**: Contains 32 general-purpose registers. Register $0 is hardwired to zero.
- **ALU (Arithmetic Logic Unit)**: Executes arithmetic and logic operations (add, sub, and, or, slt, shifts). Includes a zero flag for branch operations.
- **ALU Control Unit**: Decodes the function field and ALUOp signals to generate specific ALU control signals.
- **Data Memory**: Stores program data for load/store operations (lw/sw instructions).
- **Main Control Unit**: Decodes instruction opcodes and generates control signals (RegWrite, ALUSrc, MemWrite, MemRead, Branch, Jump, etc.).
- **Sign Extender**: Extends 16-bit immediate values to 32-bit signed numbers.
- **Multiplexers**: Various 2-to-1 multiplexers for selecting between different data paths (5-bit and 32-bit versions).
- **Adders**: 32-bit adders for PC increment and branch target calculation.
- **Left Shift**: Shifts values left by 2 positions (for jump and branch address calculation).

### Data Path

- **Instruction Fetch**: PC, Instruction Memory, and PC+1 Adder
- **Decode/Write-back**: Register File, Main Control Unit, and Register Destination Multiplexer
- **Execute**: ALU, ALU Control Unit, and Sign Extender
- **Memory Access**: Data Memory with MemRead/MemWrite control
- **Control Flow**: Branch logic (using zero flag) and Jump logic

  ## Repository Structure

The VHDL code and testbenches are organized into the following clear directory structure for easy navigation and synthesis:

```
.
├── src/
│   ├── mips_core/
│   │   └── MIPS.vhd                # Top-Level MIPS Processor Entity
│   └── units/
│       ├── alu.vhd                 # ALU with integrated full adder, shifter, and SLT
│       ├── registers.vhd           # Register File (32 registers)
│       ├── memory.vhd              # Data Memory
│       ├── InstructionMemory.vhd   # Instruction Memory
│       ├── ProgramCounter.vhd      # Program Counter
│       ├── SignExtend.vhd          # Sign Extension Unit
│       ├── Adder32bit.vhd          # 32-bit Adder
│       ├── LeftShift.vhd           # Left Shift Unit
│       ├── mux_5bit.vhd            # 5-bit 2-to-1 Multiplexer
│       └── mux_32bit.vhd           # 32-bit 2-to-1 Multiplexer
│       ├── OutputControl.vhd       # Main Control Unit (Opcode Decoder)
│       └── ALUControl.vhd          # ALU Control Unit (Function Code Decoder)
│
├── sim/
│   ├── mips_core_tb/
│   │   └── mips_tb.vhd             # Top-Level Integration Testbench
│   └── unit_tests/
│       ├── alu_tb.vhd              # ALU Testbench
│       ├── registers_tb.vhd        # Register File Testbench
│       ├── memory_tb.vhd           # Data Memory Testbench
│       ├── InstructionMemory_tb.vhd
│       ├── OutputControl_tb.vhd
│       ├── ALUControl_tb.vhd
│       ├── ProgramCounter_tb.vhd
│       └── (other component testbenches)
│
├── Documentation.pdf               # Detailed documantation in Greek
│
└── README.md
```

## Simulation and Testing

### Simulation Tool

All simulations and testing were performed using **ModelSim-Altera 10.1d (Quartus II 13.1)**, a industry-standard HDL simulator for VHDL verification.

**Important Note for ModelSim Users:** To successfully compile and simulate this project, all VHDL component files must be added to the same ModelSim project/library. Ensure that all files from the `src/` directory are compiled in the correct order (units before top-level entities) within the same working library.


### Clock Configuration

The system clock is configured for **200 MHz** (period of 5 ns):
- High pulse: 2.5 ns
- Low pulse: 2.5 ns
- Complete cycle: 5 ns

### Reset Behavior

The processor includes a reset signal that:
- When asserted (Rst = 1): Initializes PC to 0
- Reset duration: 12.5 ns (2.5 clock cycles)
- After reset (Rst = 0): Normal operation begins

### Verification Strategy

Comprehensive verification is performed at two levels:

1. **Unit Testing**: Each component is individually tested with dedicated testbenches to verify correct functionality:
   - ALU operations (add, sub, and, or, slt, shifts)
   - Register file read/write operations
   - Memory read/write operations
   - Control signal generation
   - PC increment and branching

2. **Integration Testing**: The complete MIPS processor is tested with full programs including:
   - Sequential instruction execution
   - Loop implementation using branch instructions
   - Memory operations (load/store)
   - Register manipulation

### Test Program Example

The testbench includes a loop program that demonstrates:
- Immediate arithmetic (addi)
- Memory store operations (sw)
- Branch on not equal (bne)
- Proper PC increment and branch target calculation

```
addi $0, $0, 0
addi $4, $0, 0

addi $3, $0, 1      # Initialize counter
addi $5, $0, 3      # Set loop limit
Loop:
    sw $3, 0($4)    # Store to memory
    addi $3, $3, 1  # Increment counter
    addi $4, $4, 1  # Increment address
    addi $5, $5, -1 # Decrement limit
    bne $5, $0, -5  # Branch back if not zero
```

## Key Features

- **Single-cycle execution**: Each instruction completes in one clock cycle
- **Harvard architecture**: Separate instruction and data memories
- **Full control path**: Comprehensive control signal generation for all supported instructions
- **Zero flag**: Used for conditional branching (beq/bne)
- **Register $0 protection**: Hardware-enforced zero value in register $0
- **Comprehensive debugging**: Debug signals for monitoring internal processor state

## Testing Results

All simulations confirm correct execution of:
- Arithmetic operations with proper ALU result calculation
- Control flow operations (branches and jumps)
- Memory operations with correct addressing
- Register file operations with $0 protection
- Multi-instruction programs with loops

Results of the simulation are included in the **[Documentation.pdf](Documentation.pdf)** , with a detailed explanation of the wavefroms.

The processor successfully executes test programs with proper timing at 200 MHz operation frequency.
