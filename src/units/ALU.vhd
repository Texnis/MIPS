library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
                                 
ENTITY alu IS                                    
	port (
		in1    : in  std_logic_vector(31 downto 0);
		in2    : in  std_logic_vector(31 downto 0);
		op     : in  std_logic_vector(3 downto 0);
		outALU : out std_logic_vector(31 downto 0);
		Zero   : out std_logic);
END alu;

ARCHITECTURE ALU_1 of ALU is
	component FullAdder
		port (
			in1, in2 : in  std_logic_vector(31 downto 0);
			carryin  : in  std_logic_vector(0 downto 0);
			sum      : out std_logic_vector(31 downto 0);
			carryout : out std_ulogic);
	end component;
	component Shifter
		port (
			Sin  : in  std_logic_vector(31 downto 0);
			Sout : out std_logic_vector(31 downto 0);
			opS  : in  std_ulogic;                         
			num  : in  std_logic_vector(4 downto 0));    
	end component;
	signal op_shifter: std_logic;
	signal carryout:   std_logic;
	signal out_FA:     std_logic_vector(31 downto 0);
	signal out_SH:     std_logic_vector(31 downto 0);
	signal x:          std_logic_vector(31 downto 0) := (others=>'X');
	signal slt_result: std_logic_vector(31 downto 0);
BEGIN

	op_shifter	<=
		'0' when op="0111" else
		'1' when op="1000" else
		'X';
		
	FA_ALU: FullAdder port map(in1 => in1, in2 => in2, carryin => "0", sum => out_FA, carryout=>carryout);
	SH_ALU: Shifter	  port map(Sin => in1, Sout => out_SH, opS => op_shifter, num => in2(4 downto 0)); 
	
	slt_result <=
		std_logic_vector(to_unsigned(1,32)) when (to_integer(signed(in1)) < to_integer(signed(in2))) else
		std_logic_vector(to_unsigned(0,32));
		
	with op select
		outALU <=
			-- sum:
			out_FA when "0001",
			-- and:
			in1 and in2 when "0010",
			-- or:
			in1 or in2 when "0011",
			-- nor:
			in1 nor in2 when "0100",
			-- and immediate:
			in1 and in2 when "0101",
			-- or immediate:
			in1 or in2 when "0110",
			-- shift left:
			out_SH  when "0111",
			-- shift right
			out_SH  when "1000",
			-- slt
			slt_result when "1100",
			-- addi
			out_FA when "1101",
		
			std_logic_vector(signed(in1) - signed(in2)) when "1010", -- beq comparison
			std_logic_vector(signed(in1) - signed(in2)) when "1011", -- bne comparison
			x when others;
	
	-- Zero = '1' when ALU result is zero (registers are equal)
	-- Zero = '0' when ALU result is non-zero (registers are not equal)
	Zero <=
		'1' when (in1 = in2) else
		'0';
		
END ALU_1;