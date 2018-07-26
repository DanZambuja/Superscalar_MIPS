-- superscalar mips.vhd
library IEEE; 
use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD_UNSIGNED.all;

entity testbench is
end;

architecture test of testbench is
  component top
    port(
      clk, reset                                :   in     STD_LOGIC;
      writedata_A, writedata_B, writedata_C     :   buffer STD_LOGIC_VECTOR(31 downto 0);
      dataadr_A, dataaddr_B, dataaddr_C         :   buffer STD_LOGIC_VECTOR(31 downto 0);
      ula_source_A, ula_source_B, ula_source_C  :   in     STD_LOGIC_VECTOR(31 downto 0);
      memwrite_A, memwrite_B, memwrite_C        :   buffer STD_LOGIC
    );
  end component;
  signal writedata_A, dataadr_A                              : STD_LOGIC_VECTOR(31 downto 0);
  signal writedata_B, dataadr_B                              : STD_LOGIC_VECTOR(31 downto 0);
  signal writedata_C, dataadr_C                              : STD_LOGIC_VECTOR(31 downto 0);
  signal ula_source_A, ula_source_B, ula_source_C            : STD_LOGIC_VECTOR(31 downto 0);
  signal clk, reset, memwrite_A, memwrite_B, memwrite_C      : STD_LOGIC;
  
  begin
  
    -- instantiate device to be tested
    dut: top port map(clk, reset, writedata, dataadr, ula_source_1, ula_source_2, memwrite);
  
    -- Generate clock with 10 ns period
    process begin
      clk <= '1';
      wait for 5 ns; 
      clk <= '0';
      wait for 5 ns;
    end process;
  
    -- Generate reset for first two clock cycles
    process begin
      reset <= '1';
      wait for 22 ns;
      reset <= '0';
      wait;
    end process;
  
  
  --  -- check that 7 gets written to address 84 at end of program
  --  process (clk) begin
  --    if (clk'event and clk = '0' and memwrite = '1') then
  --      if (to_integer(dataadr) = 84 and to_integer(writedata) = 7) then 
  --        report "NO ERRORS: Simulation succeeded" severity failure;
  --      elsif (dataadr /= 80) then 
  --        report "Simulation failed" severity failure;
  --      end if;
  --    end if;
  --  end process;
  end;
  
  
