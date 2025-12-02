library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Registers is
	port (
		CLK         : in  std_logic;               
		RegIn1      : in  std_logic_vector(4 downto 0);
		RegIn2      : in  std_logic_vector(4 downto 0);
		RegWriteIn  : in  std_logic_vector(4 downto 0);
		DataWriteIn : in  std_logic_vector(31 downto 0);
		RegWrite    : in  std_logic;
		RegOut1     : out std_logic_vector(31 downto 0);
		RegOut2     : out std_logic_vector(31 downto 0));
END Registers;

ARCHITECTURE Registers_1 of Registers is
	type registers is array (0 to 31) of std_logic_vector(31 downto 0);
	signal regs: registers := (others=> (others => '0'));
BEGIN

	RegOut1 <= regs(to_integer(unsigned(RegIn1))) when to_integer(unsigned(RegIn1)) /= 0 else (others => '0');
	RegOut2 <= regs(to_integer(unsigned(RegIn2))) when to_integer(unsigned(RegIn2)) /= 0 else (others => '0');
	

	write_process: process(CLK)
	begin
		if rising_edge(CLK) then
			-- Write to register if RegWrite is enabled and not writing to register 0
			if RegWrite = '1' and to_integer(unsigned(RegWriteIn)) /= 0 then
				regs(to_integer(unsigned(RegWriteIn))) <= DataWriteIn;
			end if;
		end if;
	end process;

END Registers_1;