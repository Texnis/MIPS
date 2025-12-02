library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
    port (
        CLK       : in  std_logic;
        inRAM     : in  std_logic_vector(31 downto 0);
        WriteData : in  std_logic_vector(31 downto 0);
        MemWrite  : in  std_logic;
        MemRead   : in  std_logic;
        outRAM    : out std_logic_vector(31 downto 0);
        reset     : in  std_logic
    );
end Memory;

architecture Memory_1 of Memory is
    -- RAM: 1024 words of 32-bit memory
    type ram_type is array (0 to 1023) of std_logic_vector(31 downto 0);
    signal ram : ram_type := (others => (others => '0'));
    signal Address : integer := 0;
    
    --  Function to check if a vector has only defined bits
    function is_defined(vec : std_logic_vector) return boolean is
    begin
        for i in vec'range loop
            if vec(i) = 'U' or vec(i) = 'X' then
                return false;
            end if;
        end loop;
        return true;
    end function;
    
begin
    -- Address decoding with proper bounds checking
    process(inRAM)
        variable temp_addr : integer;
    begin
        if is_defined(inRAM) then
           
            temp_addr := to_integer(signed(inRAM));
            
            -- Bounds checking: ensure address is within valid range
            if temp_addr >= 0 and temp_addr < 1024 then
                Address <= temp_addr;
            else
                -- For negative or out-of-bounds addresses, use address 0
                Address <= 0;
            end if;
        else
            Address <= 0;
        end if;
    end process;
    
    --  Clocked write to memory
    process(CLK)
    begin
        if rising_edge(CLK) then
            if (MemWrite = '1' and reset = '0') then
                ram(Address) <= WriteData;
            end if;
        end if;
    end process;
    
    --  Read from memory
    with reset select
        outRAM <= ram(Address) when '0',
                  (others => '0') when others;
                  
end Memory_1;