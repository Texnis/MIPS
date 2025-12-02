library ieee;
use ieee.std_logic_1164.all;

entity ALUControl is port (
    ALUOp        : in  std_logic_vector(2 downto 0);
    Funct        : in  std_logic_vector(5 downto 0);
    ALUCont_out  : out std_logic_vector(3 downto 0));
end ALUControl;

architecture ALUControl_1 of ALUControl is
    signal regALUControl_Funct: std_logic_vector(3 downto 0) := 
        (others=>'0');
    signal regALUControl_op: std_logic_vector(3 downto 0) := 
        (others=>'0');

begin
    -- Funct is defined only for R type
    with Funct select
        regALUControl_Funct <=
            "0001" when "100000", --0x20
            "0010" when "100100", --0x24
            "0011" when "100101", --0x25
            "0100" when "100111", --0x27
            "0101" when "001100", --0x0C
            "0110" when "001101", --0x0D
            "0111" when "000000", --0x00
            "1000" when "000010", --0x02
            "1100" when "101010", --0x2A slt
            "1111" when others;

    with ALUOp select
        regALUControl_op <=
            "0001" when "001",    -- load: add base and relative address
            "1010" when "010",    -- beq
            "1011" when "011",    -- bne
            "0001" when "100",    -- addi
            "1111" when others;

    with ALUOp select
        ALUCont_out <=
            regALUControl_Funct when "000",
            regALUControl_op when others;

end ALUControl_1;
