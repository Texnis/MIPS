library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Datamem_tb is
end Datamem_tb;

architecture Behavioral of Datamem_tb is

    component Memory
        port (
            CLK       : in  std_logic;
            InRAM         : in std_logic_vector(31 downto 0);
            WriteData     : in std_logic_vector(31 downto 0);
            MemWrite      : in std_logic;
            MemRead       : in std_logic;
            outRAM        : out std_logic_vector(31 downto 0);
            reset         : in std_logic
        );
    end component;

    -- Signals
    signal CLK          : std_logic := '0'; 
    signal InRAM        : std_logic_vector(31 downto 0);
    signal WriteData    : std_logic_vector(31 downto 0);
    signal MemWrite     : std_logic := '0';
    signal MemRead      : std_logic := '0';
    signal outRAM       : std_logic_vector(31 downto 0);
    signal reset        : std_logic := '0';

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Memory
        port map (
            CLK           => CLK,
            InRAM         => InRAM,
            WriteData     => WriteData,
            MemWrite      => MemWrite,
            MemRead       => MemRead,
            outRAM        => outRAM,
            reset         => reset
        );

    -- Clock process
    clk_process : process
    begin
        while now < 200 ns loop  
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        -- Reset low
        reset <= '0';
        wait for 10 ns;

        -- Write 9 to memory address 2
        InRAM <= std_logic_vector(to_unsigned(2, 32));
        WriteData <= std_logic_vector(to_signed(9, 32));
        MemWrite <= '1';
        wait for 10 ns;
        MemWrite <= '0';

        -- Write 4 to memory address 3
        InRAM <= std_logic_vector(to_unsigned(3, 32));
        WriteData <= std_logic_vector(to_signed(4, 32));
        MemWrite <= '1';
        wait for 10 ns;
        MemWrite <= '0';

        -- Read memory address 2
        InRAM <= std_logic_vector(to_unsigned(2, 32));
        MemRead <= '1';
        wait for 10 ns;
        MemRead <= '0';

        wait;
    end process;

end Behavioral;
