library IEEE;
use IEEE.std_logic_1164.all;

entity Signextension_tb is
end Signextension_tb;

architecture Signextension_tb of Signextension_tb is
    -- Component declaration
    component SignExtend
        port (
            SignExIn  : in  std_logic_vector(15 downto 0);
            SignExOut : out std_logic_vector(31 downto 0)
        );
    end component;
    
    -- Test signals
    signal SignExIn_tb  : std_logic_vector(15 downto 0);
    signal SignExOut_tb : std_logic_vector(31 downto 0);
    
begin
    -- Component instantiation
    UUT: SignExtend
        port map (
            SignExIn  => SignExIn_tb,
            SignExOut => SignExOut_tb
        );
    
    -- Test process
    stimulus_process: process
    begin
        -- Test case 1: 0xFAAA (negative number)
        SignExIn_tb <= x"FAAA";
        wait for 10 ns;
        
        -- Test case 2: 0xAFFF (negative number)  
        SignExIn_tb <= x"AFFF";
        wait for 10 ns;
        
        -- Test case 3: 0x5444 (positive number)
        SignExIn_tb <= x"5444";
        wait for 10 ns;
        
        -- End simulation
        wait;
    end process;
    
end Signextension_tb;
