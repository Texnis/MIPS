library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder32_tb is
end Adder32_tb;

architecture testbench of Adder32_tb is
    -- Component declaration
    component FullAdder 
        port (
            in1, in2    : in  std_logic_vector(31 downto 0);
            carryin     : in  std_logic_vector(0 downto 0);
            sum         : out std_logic_vector(31 downto 0);
            carryout    : out std_logic
        );
    end component;
    
    -- Test signals
    signal in1_tb      : std_logic_vector(31 downto 0);
    signal in2_tb      : std_logic_vector(31 downto 0);
    signal carryin_tb  : std_logic_vector(0 downto 0);
    signal sum_tb      : std_logic_vector(31 downto 0);
    signal carryout_tb : std_logic;
    
begin
    -- Component instantiation
    UUT: FullAdder
        port map (
            in1 => in1_tb,
            in2 => in2_tb,
            carryin => carryin_tb,
            sum => sum_tb,
            carryout => carryout_tb
        );
    
    -- Test process
    stimulus_process: process
    begin
        -- No carry in for both tests
        carryin_tb <= "0";
        
        -- Test case 1: 0xCCCCCCCC + 0xBBBBBBBB
        in1_tb <= x"CCCCCCCC";
        in2_tb <= x"BBBBBBBB";
        wait for 10 ns;
        
        -- Test case 2: 0xBBBBBBBB + 0x55555556
        in1_tb <= x"BBBBBBBB";
        in2_tb <= x"55555556";
        wait for 10 ns;
        
        -- End simulation
        wait;
    end process;
    
end testbench;
