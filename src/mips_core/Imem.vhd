library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY InstructionMemory IS
  port (
    inIM  : in  std_logic_vector(31 downto 0);
    outIM : out std_logic_vector(31 downto 0)
  );
END InstructionMemory;

ARCHITECTURE InstructionMemory_1 of InstructionMemory IS

  type mem_type is array (natural range <>) of std_logic_vector(31 downto 0);
  signal mem : mem_type(0 to 255) := (
    0 => x"20000000",  -- addi $0, $0, 0
    1 => x"20040000",  -- addi $4, $0, 0
    2 => x"20030001",  -- addi $3, $0, 1
    3 => x"20050003",  -- addi $5, $0, 3
    4 => x"AC830000",  -- sw $3, 0($4)
    5 => x"20630001",  -- addi $3, $3, 1
    6 => x"20840001",  -- addi $4, $4, 1
    7 => x"20A5FFFF",  -- addi $5, $5, -1
    8 => x"14A0FFFB",  -- bne $5, $0, L1 (-5)
    others => x"00000000"
  );

  signal FullInstruction : std_logic_vector(31 downto 0);

BEGIN

  process(inIM)
    variable addr : integer;
  begin
    addr := to_integer(unsigned(inIM));

    if (addr >= 0 and addr <= 255) then
      FullInstruction <= mem(addr);
    else
      FullInstruction <= x"00000000";
      assert false 
        report "Instruction fetch out of bounds: PC = " & integer'image(addr)
        severity note;
    end if;
  end process;

  outIM <= FullInstruction;

END InstructionMemory_1;
