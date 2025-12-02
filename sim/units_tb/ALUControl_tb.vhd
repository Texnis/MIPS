library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUControl_tb is
end ALUControl_tb;

architecture Behavioral of ALUControl_tb is

    component ALUControl
        port (
            ALUOp        : in  std_logic_vector(2 downto 0);
            Funct        : in  std_logic_vector(5 downto 0);
            ALUCont_out  : out std_logic_vector(3 downto 0)
        );
    end component;

    signal ALUOp       : std_logic_vector(2 downto 0);
    signal Funct       : std_logic_vector(5 downto 0);
    signal ALUCont_out : std_logic_vector(3 downto 0);

begin

    uut: ALUControl
        port map (
            ALUOp        => ALUOp,
            Funct        => Funct,
            ALUCont_out  => ALUCont_out
        );

    process
    begin
        -- R-type: add => ALUOp = "000", Funct = "100000" (0x20) => ALUCont = "0001"
        ALUOp <= "000";
        Funct <= "100000";  -- add
        wait for 10 ns;

        -- R-type: sub => Funct = "100010" 
        Funct <= "100010";
        wait for 10 ns;

        -- R-type: and => Funct = "100100" => "0010"
        Funct <= "100100";
        wait for 10 ns;

        -- R-type: or => Funct = "100101" => "0011"
        Funct <= "100101";
        wait for 10 ns;

        -- R-type: slt => Funct = "101010" => "1100"
        Funct <= "101010";
        wait for 10 ns;

        -- I-type: lw/sw => ALUOp = "001" => should output "0001" (add)
        ALUOp <= "001";
        wait for 10 ns;

        -- I-type: beq => ALUOp = "010" => "1010"
        ALUOp <= "010";
        wait for 10 ns;

        -- I-type: bne => ALUOp = "011" => "1011"
        ALUOp <= "011";
        wait for 10 ns;

        -- I-type: addi => ALUOp = "100" => "0001"
        ALUOp <= "100";
        wait for 10 ns;

        wait;
    end process;

end Behavioral;
