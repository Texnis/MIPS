library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Leftshift_tb is
end Leftshift_tb;

architecture testbench of Leftshift_tb is
    -- Component declaration
    component Shifter 
        port (
            Sin  : in  std_logic_vector(31 downto 0);
            Sout : out std_logic_vector(31 downto 0);
            opS   : in  std_ulogic;
            num  : in  std_logic_vector(4 downto 0)
        );
    end component;
    
    -- Test signals
    signal Sin_tb  : std_logic_vector(31 downto 0);
    signal Sout_tb : std_logic_vector(31 downto 0);
    signal op_tb   : std_ulogic;
    signal num_tb  : std_logic_vector(4 downto 0);
    
begin
    -- Component instantiation
    UUT: Shifter
        port map (
            Sin  => Sin_tb,
            Sout => Sout_tb,
            opS   => op_tb,
            num  => num_tb
        );
    
    -- Test process
    stimulus_process: process
    begin
        -- Test case: 0x0FFFFFFF left shift by 2 positions
        Sin_tb <= x"0FFFFFFF";
        op_tb  <= '0';  -- left shift
        num_tb <= "00010";  -- shift by 2
        wait for 10 ns;
        
        
        -- Test: shift 0x80000000 right by 1
        Sin_tb <= x"0FFFFFFF";
        op_tb  <= '1';  -- right shift
        num_tb <= "00010";
        wait for 10 ns;

        wait;
    end process;
    
end testbench;
