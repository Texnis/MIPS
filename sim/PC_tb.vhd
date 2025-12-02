library ieee;
use ieee.std_logic_1164.all;

entity PC_tb is
end PC_tb;

architecture PC_tb of PC_tb is
    -- Component declaration
    component ProgramCounter
        port (
            InPC  : in  std_logic_vector(31 downto 0);
            OutPC : out std_logic_vector(31 downto 0);
            CLK   : in  std_logic;
            Rst   : in  std_logic
        );
    end component;

    -- Signal declarations
    signal InPC_tb  : std_logic_vector(31 downto 0);
    signal OutPC_tb : std_logic_vector(31 downto 0);
    signal CLK_tb   : std_logic := '0';
    signal Rst_tb   : std_logic := '0';

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

begin
  
    uut: ProgramCounter
        port map (
            InPC  => InPC_tb,
            OutPC => OutPC_tb,
            CLK   => CLK_tb,
            Rst   => Rst_tb
        );

    -- Clock process
    CLK_process: process
    begin
        CLK_tb <= '0';
        wait for CLK_PERIOD/2;
        CLK_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

  
    stim_proc: process
    begin
     
        wait for 10 ns;
        
        -- Test reset functionality
        Rst_tb <= '1';
        InPC_tb <= x"12345678";  -- Should be ignored during reset
        wait for 20 ns;
        Rst_tb <= '0';
        wait for 10 ns;
        
        -- Test 1: Write and read 0xAAAACCCC
        InPC_tb <= x"AAAACCCC";
        wait for 20 ns;  -- Wait for clock edge
        
        -- Test 2: Write and read 0xFFFFBBBB   
        InPC_tb <= x"FFFFBBBB";
        wait for 20 ns;  -- Wait for clock edge
        

        wait;
    end process;

end PC_tb;
