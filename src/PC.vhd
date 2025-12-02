library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ProgramCounter IS
    port (
        inPC  : in  std_logic_vector(31 downto 0);
        outPC : out std_logic_vector(31 downto 0);
        CLK   : in  std_logic;
        Rst   : in  std_logic
    );
END ProgramCounter;

ARCHITECTURE ProgramCounter_1 of ProgramCounter IS
BEGIN
    reg: process(CLK,Rst)
    begin
        if Rst = '1' then
            outPC <= (others => '0');  -- clear PC on reset
        elsif rising_edge(CLK) then
            outPC <= inPC;             -- update PC on clock edge
        end if;
    end process;
END ProgramCounter_1;
