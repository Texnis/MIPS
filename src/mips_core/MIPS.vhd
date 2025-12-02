library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY MIPS IS
  port (
    CLK     : in  std_logic;
    Rst     : in  std_logic;
    outMIPS : out std_logic_vector(31 downto 0);
    
    -- Debug outputs for waveforms
    debug_PC : out std_logic_vector(31 downto 0);
    debug_instruction : out std_logic_vector(31 downto 0);
    debug_reg_data1 : out std_logic_vector(31 downto 0);
    debug_reg_data2 : out std_logic_vector(31 downto 0);
    debug_alu_result : out std_logic_vector(31 downto 0);
    debug_mem_data : out std_logic_vector(31 downto 0);
    debug_write_reg : out std_logic_vector(4 downto 0);
    debug_write_data : out std_logic_vector(31 downto 0);
    debug_mem_addr : out std_logic_vector(31 downto 0);
    debug_controls : out std_logic_vector(7 downto 0) -- RegWrite, ALUSrc, MemWrite, MemRead, RegDst, MemToReg, Jump, Branch
  );
END MIPS;

ARCHITECTURE MIPS_1 of MIPS is

  component FullAdder
    port (
      in1, in2 : in  std_logic_vector(31 downto 0);
      carryin  : in  std_logic_vector(0 downto 0);
      sum      : out std_logic_vector(31 downto 0);
      carryout : out std_logic);
  end component;

  component ALU
    port (
      in1 : in std_logic_vector(31 downto 0);
      in2 : in std_logic_vector(31 downto 0);
      op  : in std_logic_vector(3 downto 0);
      outALU  : out std_logic_vector(31 downto 0);
      Zero    : out std_logic);
  end component;

  component ProgramCounter
    port (
      inPC  : in  std_logic_vector(31 downto 0);
      outPC : out std_logic_vector(31 downto 0);
      CLK   : in  std_logic;
      Rst   : in  std_logic);
  end component;

  component InstructionMemory
    port (
      inIM  : in  std_logic_vector(31 downto 0);
      outIM : out std_logic_vector(31 downto 0));
  end component;

  component Registers
    port (
      CLK         : in  std_logic;
      RegIn1      : in  std_logic_vector(4 downto 0);
      RegIn2      : in  std_logic_vector(4 downto 0);
      RegWriteIn  : in  std_logic_vector(4 downto 0);
      DataWriteIn : in  std_logic_vector(31 downto 0);
      RegWrite    : in  std_logic;
      RegOut1     : out std_logic_vector(31 downto 0);
      RegOut2     : out std_logic_vector(31 downto 0));
  end component;

  component ALUControl
    port (
      ALUOp       : in  std_logic_vector(2 downto 0);
      Funct       : in  std_logic_vector(5 downto 0);
      ALUCont_out : out std_logic_vector(3 downto 0));
  end component;

  component OutputControl
    port (
      CLK         : in std_logic;
      OC_in       : in  std_logic_vector(5 downto 0);
      RegWrite    : out std_logic;
      ALUSrc      : out std_logic;
      ALUOp       : out std_logic_vector(2 downto 0);
      MemWrite    : out std_logic;
      MemRead     : out std_logic;
      RegDst      : out std_logic;
      MemToReg    : out std_logic;
      Jump        : out std_logic;
      Branch      : out std_logic);
  end component;

  component Memory
    port (
      CLK       : in  std_logic;
      inRAM     : in  std_logic_vector(31 downto 0);
      WriteData : in  std_logic_vector(31 downto 0);
      MemWrite  : in  std_logic;
      MemRead   : in  std_logic;
      outRAM    : out std_logic_vector(31 downto 0);
      reset     : in  std_logic);
  end component;

  component MUX2_5
    port (
      MUXin1  :  in  std_logic_vector(4 downto 0);
      MUXin2  :  in  std_logic_vector(4 downto 0);
      MUXout  :  out std_logic_vector(4 downto 0);
      sel     :  in  std_logic);
  end component;

  component MUX2_32
    port (
      MUXin1  :  in  std_logic_vector(31 downto 0);
      MUXin2  :  in  std_logic_vector(31 downto 0);
      MUXout  :  out std_logic_vector(31 downto 0);
      sel     :  in  std_logic);
  end component;

  component SignExtend
    port (
      SignExIn  :  in  std_logic_vector(15 downto 0);
      SignExOut :  out std_logic_vector(31 downto 0));
  end component;

  -- Signals
  signal RegWrite, ALUSrc, MemWrite, MemRead, RegDst, MemToReg, Jump, Zero, Branch, BranchTaken : std_logic;
  signal PC_FA_IM, FA_PC_OUT, OUT_IM, ONE, outALU : std_logic_vector(31 downto 0);
  signal ALUOp : std_logic_vector(2 downto 0);
  signal RegOut1, RegOut2, DataWriteIn, MUXaluOut, SignExOut, outRAM, ShiftJump2MuxJump, MuxJump2PC, MuxBranch2MuxJump, ALUbranchOut, PC_plus_1, PC_branch_target : std_logic_vector(31 downto 0);
  signal ALUControl_out : std_logic_vector(3 downto 0);
  signal MUXregOut : std_logic_vector(4 downto 0);

BEGIN

  -- PC increment and branch calc
  ONE <= std_logic_vector(to_unsigned(1,32));
  PC_plus_1 <= std_logic_vector(unsigned(PC_FA_IM) + unsigned(ONE));
  

  PC_branch_target <= std_logic_vector(signed(PC_plus_1) + signed(SignExOut));

  -- Program Counter
  PC1: ProgramCounter
    port map(
      inPC  => MuxJump2PC,
      outPC => PC_FA_IM,
      CLK   => CLK,
      Rst   => Rst);

  -- Instruction Memory
  IM1: InstructionMemory
    port map(
      inIM  => PC_FA_IM,
      outIM => OUT_IM);

  -- Register File
  REG1: Registers
    port map(
      CLK         => CLK,
      RegIn1      => OUT_IM(25 downto 21),
      RegIn2      => OUT_IM(20 downto 16),
      RegWriteIn  => MUXregOut,
      DataWriteIn => DataWriteIn,
      RegWrite    => RegWrite,
      RegOut1     => RegOut1,
      RegOut2     => RegOut2);

  -- Main Control Unit
  OC1: OutputControl
    port map(
      CLK      => CLK,
      OC_in    => OUT_IM(31 downto 26),
      RegWrite => RegWrite,
      ALUSrc   => ALUSrc,
      ALUOp    => ALUOp,
      MemWrite => MemWrite,
      MemRead  => MemRead,
      RegDst   => RegDst,
      MemToReg => MemToReg,
      Jump     => Jump,
      Branch   => Branch);

  -- ALU Control Unit
  ALUC_1: ALUControl
    port map(
      ALUOp       => ALUOp,
      Funct       => OUT_IM(5 downto 0),
      ALUCont_out => ALUControl_out);

  -- ALU
  ALU1: ALU
    port map(
      in1    => RegOut1,
      in2    => MUXaluOut,
      op     => ALUControl_out,
      outALU => outALU,
      Zero   => Zero);

  -- Data Memory
  RAM1: Memory
    port map(
      CLK       => CLK,
      inRAM     => outALU,
      WriteData => RegOut2,
      MemWrite  => MemWrite,
      MemRead   => MemRead,
      outRAM    => outRAM,
      reset     => Rst);

  -- MUXes
  MUXreg: MUX2_5
    port map(
      MUXin1 => OUT_IM(20 downto 16),
      MUXin2 => OUT_IM(15 downto 11),
      MUXout => MUXregOut,
      sel    => RegDst);

  MUXaluIn: MUX2_32
    port map(
      MUXin1 => RegOut2,
      MUXin2 => SignExOut,
      MUXout => MUXaluOut,
      sel    => ALUSrc);

  MUXram: MUX2_32
    port map(
      MUXin1 => outALU,
      MUXin2 => outRAM,
      MUXout => DataWriteIn,
      sel    => MemToReg);

  ShiftJump2MuxJump <= PC_plus_1(31 downto 28) & OUT_IM(25 downto 0) & "00";

  MUXjump: MUX2_32
    port map(
      MUXin1 => MuxBranch2MuxJump,
      MUXin2 => ShiftJump2MuxJump,
      MUXout => MuxJump2PC,
      sel    => Jump);

  --  Complete branch logic for both beq and bne
  -- beq (000100): branch if equal (Zero = '1')
  -- bne (000101): branch if not equal (Zero = '0')
  BranchTaken <= Branch and Zero when OUT_IM(31 downto 26) = "000100" else      -- beq
                 Branch and (not Zero) when OUT_IM(31 downto 26) = "000101" else -- bne
                 '0';

  MUXbranch: MUX2_32
    port map(
      MUXin1 => PC_plus_1,
      MUXin2 => PC_branch_target,
      MUXout => MuxBranch2MuxJump,
      sel    => BranchTaken);

  SignEx1: SignExtend
    port map(
      SignExIn  => OUT_IM(15 downto 0),
      SignExOut => SignExOut);

  -- Debug output connections
  debug_PC <= PC_FA_IM;
  debug_instruction <= OUT_IM;
  debug_reg_data1 <= RegOut1;
  debug_reg_data2 <= RegOut2;
  debug_alu_result <= outALU;
  debug_mem_data <= outRAM;
  debug_write_reg <= MUXregOut;
  debug_write_data <= DataWriteIn;
  debug_mem_addr <= outALU when (MemRead = '1' or MemWrite = '1') else (others => '0');
  debug_controls <= RegWrite & ALUSrc & MemWrite & MemRead & RegDst & MemToReg & Jump & Branch;

  outMIPS <= outALU;

END MIPS_1;
