library ieee;
use ieee.std_logic_1164.all;

entity Mux2to1_5_tb is
end Mux2to1_5_tb;

architecture Mux2to1_5_tb of Mux2to1_5_tb is
    -- Component declaration
    component MUX2_5
        port (
            MUXin1 : in  std_logic_vector(4 downto 0);
            MUXin2 : in  std_logic_vector(4 downto 0);
            MUXout : out std_logic_vector(4 downto 0);
            sel    : in  std_logic
        );
    end component;

    -- Signal declarations
    signal MUXin1_tb : std_logic_vector(4 downto 0);
    signal MUXin2_tb : std_logic_vector(4 downto 0);
    signal MUXout_tb : std_logic_vector(4 downto 0);
    signal sel_tb    : std_logic;

begin
  
    uut: MUX2_5
        port map (
            MUXin1 => MUXin1_tb,
            MUXin2 => MUXin2_tb,
            MUXout => MUXout_tb,
            sel    => sel_tb
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Wait for initial setup
        wait for 10 ns;
        
        
        -- ???????0 ? ???????1 ? ??????? 
        -- 0x1C ? 0x0A ? 1 
        -- 0x1C - 0x0B - 0
        
        -- Test 1: Input0=0x1C, Input1=0x0A, Select=1 (should output 0x0A)
        MUXin1_tb <= "11100";  -- 0x1C
        MUXin2_tb <= "01010";  -- 0x0A
        sel_tb <= '1';
        wait for 20 ns;
        
        -- Test 2: Input0=0x1C, Input1=0x0B, Select=0 (should output 0x1C)
        MUXin1_tb <= "11100";  -- 0x1C
        MUXin2_tb <= "01011";  -- 0x0B
        sel_tb <= '0';
        wait for 20 ns;
        
       

        wait;
    end process;

end Mux2to1_5_tb;
