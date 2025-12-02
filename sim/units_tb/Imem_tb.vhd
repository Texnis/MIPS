library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Imem_tb is
end Imem_tb;

architecture Behavioral of Imem_tb is

    component InstructionMemory
        port (
            inIM  : in  std_logic_vector(31 downto 0);
            outIM : out std_logic_vector(31 downto 0)
        );
    end component;

    signal inIM  : std_logic_vector(31 downto 0);
    signal outIM : std_logic_vector(31 downto 0);

begin

    uut: InstructionMemory
        port map (
            inIM  => inIM,
            outIM => outIM
        );

    process
    begin
    
        wait for 10 ns;

        inIM <= std_logic_vector(to_unsigned(4, 32));
        wait for 10 ns;

    
        wait;
    end process;

end Behavioral;
