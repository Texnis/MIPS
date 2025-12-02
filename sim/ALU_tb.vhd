library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is

    component ALU
        port (
            in1    : in  std_logic_vector(31 downto 0);
            in2    : in  std_logic_vector(31 downto 0);
            op     : in  std_logic_vector(3 downto 0);
            outALU : out std_logic_vector(31 downto 0);
            zero   : out std_logic
        );
    end component;

    signal in1, in2, outALU : std_logic_vector(31 downto 0);
    signal op               : std_logic_vector(3 downto 0);
    signal zero             : std_logic;

begin

    uut: ALU
        port map (
            in1    => in1,
            in2    => in2,
            op     => op,
            outALU => outALU,
            zero   => zero
        );

    process
    begin
        -- 1. add: 7 + (-3) = 4
        in1 <= std_logic_vector(to_signed(7, 32));
        in2 <= std_logic_vector(to_signed(-3, 32));
        op  <= "0001";  -- add
        wait for 10 ns;

        -- 2. add: 6 + (-6) = 0 (zero flag should be '1' if op=1010)
        in1 <= std_logic_vector(to_signed(6, 32));
        in2 <= std_logic_vector(to_signed(-6, 32));
        op  <= "0001";  -- add
        wait for 10 ns;

        -- 3. sub: 5 - 8 = -3 ? simulate as 5 + (-8)
        in1 <= std_logic_vector(to_signed(5, 32));
        in2 <= std_logic_vector(to_signed(-8, 32));
        op  <= "0001";  -- add/sub using negative in2
        wait for 10 ns;

        -- 4. addi: same as add
        in1 <= std_logic_vector(to_signed(10, 32));
        in2 <= std_logic_vector(to_signed(2, 32));  -- immediate
        op  <= "0001";  -- add
        wait for 10 ns;

        -- 5. lw/sw: base + offset
        in1 <= std_logic_vector(to_signed(100, 32));  -- base
        in2 <= std_logic_vector(to_signed(16, 32));   -- offset
        op  <= "0001";  -- add
        wait for 10 ns;

        -- 6. bne: test when in1 /= in2
        in1 <= std_logic_vector(to_signed(5, 32));
        in2 <= std_logic_vector(to_signed(7, 32));
        op  <= "1011";  -- bne
        wait for 10 ns;

        -- 7. bne: test when in1 = in2 (zero = '0')
        in1 <= std_logic_vector(to_signed(8, 32));
        in2 <= std_logic_vector(to_signed(8, 32));
        op  <= "1011";  -- bne
        wait for 10 ns;

        wait;
    end process;

end Behavioral;
