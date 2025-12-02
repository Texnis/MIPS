library IEEE;
use IEEE.std_logic_1164.all;

entity Mux32_2to1_tb is
end Mux32_2to1_tb;

architecture testbench of Mux32_2to1_tb is
    -- Component declaration
    component MUX2_32 
        port (
            MUXin1 : in std_logic_vector(31 downto 0);
            MUXin2 : in std_logic_vector(31 downto 0);
            MUXout : out std_logic_vector(31 downto 0);
            sel : in std_logic
        );
    end component;
    
    -- Test signals
    signal MUXin1_tb : std_logic_vector(31 downto 0);
    signal MUXin2_tb : std_logic_vector(31 downto 0);
    signal MUXout_tb : std_logic_vector(31 downto 0);
    signal sel_tb : std_logic;
    
begin
    -- Component instantiation
    UUT: MUX2_32
        port map (
            MUXin1 => MUXin1_tb,
            MUXin2 => MUXin2_tb,
            MUXout => MUXout_tb,
            sel => sel_tb
        );
    
    -- Test process
    stimulus_process: process
    begin
        -- Setup test inputs
        MUXin1_tb <= x"CCCCCCCC";  -- ???????0
        MUXin2_tb <= x"BBBBBBBB";  -- ???????1
        
        -- Test case 1: sel = 1 (should select input2)
        sel_tb <= '1';
        wait for 10 ns;
        
        -- Test case 2: sel = 0 (should select input1)
        sel_tb <= '0';
        wait for 10 ns;
        
        -- End simulation
        wait;
    end process;
    
end testbench;
