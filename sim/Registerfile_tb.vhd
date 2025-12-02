library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Registerfile_tb is
end Registerfile_tb;

architecture Behavioral of Registerfile_tb is

    component Registers
        port (
            clk         : in  std_logic;
            RegIn1      : in  std_logic_vector(4 downto 0);
            RegIn2      : in  std_logic_vector(4 downto 0);
            RegWriteIn  : in  std_logic_vector(4 downto 0);
            DataWriteIn : in  std_logic_vector(31 downto 0);
            RegWrite    : in  std_logic;
            RegOut1     : out std_logic_vector(31 downto 0);
            RegOut2     : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals
    signal clk         : std_logic := '0';
    signal RegIn1      : std_logic_vector(4 downto 0);
    signal RegIn2      : std_logic_vector(4 downto 0);
    signal RegWriteIn  : std_logic_vector(4 downto 0);
    signal DataWriteIn : std_logic_vector(31 downto 0);
    signal RegWrite    : std_logic;
    signal RegOut1     : std_logic_vector(31 downto 0);
    signal RegOut2     : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: Registers
        port map (
            clk         => clk,
            RegIn1      => RegIn1,
            RegIn2      => RegIn2,
            RegWriteIn  => RegWriteIn,
            DataWriteIn => DataWriteIn,
            RegWrite    => RegWrite,
            RegOut1     => RegOut1,
            RegOut2     => RegOut2
        );

    -- Clock process
    clk_process : process
    begin
        while now < 200 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Test process
    stim_proc: process
    begin
        -- ??????? ??? 6 ???? ?????????? $4
        RegWrite <= '1';
        RegWriteIn <= "00100"; -- $4
        DataWriteIn <= std_logic_vector(to_signed(6, 32));
        wait for CLK_PERIOD;

        -- ??????? ??? 9 ???? ?????????? $5
        RegWriteIn <= "00101"; -- $5
        DataWriteIn <= std_logic_vector(to_signed(9, 32));
        wait for CLK_PERIOD;

        -- ??????? ??? 3 ???? ?????????? $6
        RegWriteIn <= "00110"; -- $6
        DataWriteIn <= std_logic_vector(to_signed(3, 32));
        wait for CLK_PERIOD;

        -- ???????? ??? ??????????? $4 ??? $5
        RegWrite <= '0'; 
        RegIn1 <= "00100"; -- $4
        RegIn2 <= "00101"; -- $5
        wait for CLK_PERIOD;

       
        wait for 10 ns;


        wait;
    end process;

end Behavioral;

