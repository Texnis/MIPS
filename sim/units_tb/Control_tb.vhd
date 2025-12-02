library ieee;
use ieee.std_logic_1164.all;

entity Control_tb is
end Control_tb;

architecture Control_tb_arch of Control_tb is

    component OutputControl
        port (
            CLK       : in  std_logic;
            OC_in     : in  std_logic_vector(5 downto 0);
            RegWrite  : out std_logic;
            ALUSrc    : out std_logic;
            ALUOp     : out std_logic_vector(2 downto 0);
            MemWrite  : out std_logic;
            MemRead   : out std_logic;
            MemToReg  : out std_logic;
            RegDst    : out std_logic;
            Jump      : out std_logic;
            Branch    : out std_logic
        );
    end component;

    -- Signal 
    signal CLK_tb       : std_logic := '0';
    signal OC_in_tb     : std_logic_vector(5 downto 0);
    signal RegWrite_tb  : std_logic;
    signal ALUSrc_tb    : std_logic;
    signal ALUOp_tb     : std_logic_vector(2 downto 0);
    signal MemWrite_tb  : std_logic;
    signal MemRead_tb   : std_logic;
    signal MemToReg_tb  : std_logic;
    signal RegDst_tb    : std_logic;
    signal Jump_tb      : std_logic;
    signal Branch_tb    : std_logic;

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

begin

    uut: OutputControl
        port map (
            CLK       => CLK_tb,
            OC_in     => OC_in_tb,
            RegWrite  => RegWrite_tb,
            ALUSrc    => ALUSrc_tb,
            ALUOp     => ALUOp_tb,
            MemWrite  => MemWrite_tb,
            MemRead   => MemRead_tb,
            MemToReg  => MemToReg_tb,
            RegDst    => RegDst_tb,
            Jump      => Jump_tb,
            Branch    => Branch_tb
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
        -- Wait for initial setup
        wait for 20 ns;
        
        -- Test 1: addi $1, $0, 4 (opcode = 001000)
        OC_in_tb <= "001000";
        wait for 30 ns;
        
        -- Test 2: sw $6, 0($4) (opcode = 101011)
        OC_in_tb <= "101011";
        wait for 30 ns;
        
        -- Test 3: bne $5,$0,L1 (opcode = 000101)
        OC_in_tb <= "000101";
        wait for 30 ns;
        
        -- Additional tests for completeness
        -- Test lw instruction (opcode = 100011)
        OC_in_tb <= "100011";
        wait for 30 ns;
        
        -- Test R-type instruction (opcode = 000000)
        OC_in_tb <= "000000";
        wait for 30 ns;

        wait;
    end process;

end Control_tb_arch;