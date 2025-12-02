library ieee;  
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all; 

ENTITY TestBench is 
END TestBench; 

ARCHITECTURE TestBench_MIPS of TestBench is 

component MIPS 
    port ( 
        CLK : in std_logic; 
        Rst : in std_logic; 
        outMIPS : out std_logic_vector(31 downto 0);
        -- Debug outputs
        debug_PC : out std_logic_vector(31 downto 0);
        debug_instruction : out std_logic_vector(31 downto 0);
        debug_reg_data1 : out std_logic_vector(31 downto 0);
        debug_reg_data2 : out std_logic_vector(31 downto 0);
        debug_alu_result : out std_logic_vector(31 downto 0);
        debug_mem_data : out std_logic_vector(31 downto 0);
        debug_write_reg : out std_logic_vector(4 downto 0);
        debug_write_data : out std_logic_vector(31 downto 0);
        debug_mem_addr : out std_logic_vector(31 downto 0);
        debug_controls : out std_logic_vector(7 downto 0)
    ); 
end component; 

-- signals
signal CLK : std_logic := '0';  
signal Rst : std_logic := '1';  
signal outMIPS : std_logic_vector(31 downto 0); 

-- Debug signals waveform viewing
signal debug_PC : std_logic_vector(31 downto 0);
signal debug_instruction : std_logic_vector(31 downto 0);
signal debug_reg_data1 : std_logic_vector(31 downto 0);
signal debug_reg_data2 : std_logic_vector(31 downto 0);
signal debug_alu_result : std_logic_vector(31 downto 0);
signal debug_mem_data : std_logic_vector(31 downto 0);
signal debug_write_reg : std_logic_vector(4 downto 0);
signal debug_write_data : std_logic_vector(31 downto 0);
signal debug_mem_addr : std_logic_vector(31 downto 0);
signal debug_controls : std_logic_vector(7 downto 0);

--  control signals 
signal RegWrite : std_logic;
signal ALUSrc : std_logic;
signal MemWrite : std_logic;
signal MemRead : std_logic;
signal RegDst : std_logic;
signal MemToReg : std_logic;
signal Jump : std_logic;
signal Branch : std_logic;

-- Instruction decoding signals 
signal opcode : std_logic_vector(5 downto 0);
signal rs : std_logic_vector(4 downto 0);
signal rt : std_logic_vector(4 downto 0);
signal rd : std_logic_vector(4 downto 0);
signal immediate : std_logic_vector(15 downto 0);
signal jump_addr : std_logic_vector(25 downto 0);


signal reg_write_occurred : std_logic := '0';
signal prev_write_reg : std_logic_vector(4 downto 0) := (others => '0');
signal prev_write_data : std_logic_vector(31 downto 0) := (others => '0');


signal mem_write_occurred : std_logic := '0';
signal mem_read_occurred : std_logic := '0';
signal prev_mem_addr : std_logic_vector(31 downto 0) := (others => '0');
signal prev_mem_data : std_logic_vector(31 downto 0) := (others => '0');

BEGIN 

UUT: MIPS 
    port map ( 
        CLK => CLK,  
        Rst => Rst, 
        outMIPS => outMIPS,
        debug_PC => debug_PC,
        debug_instruction => debug_instruction,
        debug_reg_data1 => debug_reg_data1,
        debug_reg_data2 => debug_reg_data2,
        debug_alu_result => debug_alu_result,
        debug_mem_data => debug_mem_data,
        debug_write_reg => debug_write_reg,
        debug_write_data => debug_write_data,
        debug_mem_addr => debug_mem_addr,
        debug_controls => debug_controls
    ); 


RegWrite <= debug_controls(7);
ALUSrc <= debug_controls(6);
MemWrite <= debug_controls(5);
MemRead <= debug_controls(4);
RegDst <= debug_controls(3);
MemToReg <= debug_controls(2);
Jump <= debug_controls(1);
Branch <= debug_controls(0);


opcode <= debug_instruction(31 downto 26);
rs <= debug_instruction(25 downto 21);
rt <= debug_instruction(20 downto 16);
rd <= debug_instruction(15 downto 11);
immediate <= debug_instruction(15 downto 0);
jump_addr <= debug_instruction(25 downto 0);

-- Clock generation: 200 MHz, period = 5 ns  
clk_process: process 
begin 
    while true loop 
        CLK <= '1'; 
        wait for 2.5 ns; 
        CLK <= '0'; 
        wait for 2.5 ns; 
    end loop; 
end process;

-- Reset  
rst_process: process 
begin 
    Rst <= '1'; 
    wait for 12.5 ns; 
    Rst <= '0'; 
    wait; 
end process; 

-- Process 
reg_monitor: process(CLK)
begin
    if rising_edge(CLK) then
        if RegWrite = '1' and Rst = '0' then
            reg_write_occurred <= '1';
            prev_write_reg <= debug_write_reg;
            prev_write_data <= debug_write_data;
        else
            reg_write_occurred <= '0';
        end if;
    end if;
end process;

-- Process 
mem_monitor: process(CLK)
begin
    if rising_edge(CLK) then
        if Rst = '0' then
            if MemWrite = '1' then
                mem_write_occurred <= '1';
                prev_mem_addr <= debug_mem_addr;
                prev_mem_data <= debug_reg_data2;
            else
                mem_write_occurred <= '0';
            end if;
            
            if MemRead = '1' then
                mem_read_occurred <= '1';
                prev_mem_addr <= debug_mem_addr;
                prev_mem_data <= debug_mem_data; 
            else
                mem_read_occurred <= '0';
            end if;
        else
            mem_write_occurred <= '0';
            mem_read_occurred <= '0';
        end if;
    end if;
end process;

END TestBench_MIPS;
