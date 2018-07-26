-- superscalar mips.vhd
library IEEE; 
use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD_UNSIGNED.all;

entity testbench is
end;

architecture test of testbench is
  component top
    port(clk, reset:           in  STD_LOGIC;
         writedata, dataadr:   out STD_LOGIC_VECTOR(31 downto 0);
         ula_source_1, ula_source_2:   in STD_LOGIC_VECTOR(31 downto 0);
         memwrite:             out STD_LOGIC);
  end component;
  signal writedata, dataadr:         STD_LOGIC_VECTOR(31 downto 0);
  signal ula_source_1, ula_source_2: STD_LOGIC_VECTOR(31 downto 0);
  signal clk, reset,  memwrite:      STD_LOGIC;
  
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
  
  library IEEE; 
  use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD_UNSIGNED.all;
  
  entity top is -- top-level design for testing
    port(clk, reset:           in     STD_LOGIC;
         writedata, dataadr:   buffer STD_LOGIC_VECTOR(31 downto 0);
         ula_source_1, ula_source_2:   in STD_LOGIC_VECTOR(31 downto 0);
         memwrite:             buffer STD_LOGIC);
  end;
  
  architecture test of top is
    component MIPS 
      port(clk, reset:                in  STD_LOGIC;
           pc:                        out STD_LOGIC_VECTOR(31 downto 0);
           instr_A, instr_B, instr_C: in  STD_LOGIC_VECTOR(31 downto 0);
           memwrite:                  out STD_LOGIC;
           aluout, writedata:         out STD_LOGIC_VECTOR(31 downto 0);
           ula_source_1, ula_source_2: in STD_LOGIC_VECTOR(31 downto 0);
           readdata:                  in  STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component Instruction_Memory
      port(a:  in  STD_LOGIC_VECTOR(5 downto 0);
           instruction_A, instruction_B, instruction_C: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component Data_Memory
      port(clk, we:  in STD_LOGIC;
           a, wd:    in STD_LOGIC_VECTOR(31 downto 0);
           rd:       out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    signal pc, instr_A, instr_B, instr_C,
           readdata: STD_LOGIC_VECTOR(31 downto 0);

  begin
    -- instantiate processor and memories
    mips1: mips port map(clk, reset, pc, instr_A, instr_B, instr_C, memwrite, dataadr, 
                         writedata, ula_source_1, ula_source_2, readdata);
    imem1: Instruction_Memory port map(pc(7 downto 2), instr_A, instr_B, instr_C); -- pc(7 downto 2) is a way of limiting the number of instructions read from the instruction memory
    dmem1: Data_Memory port map(clk, memwrite, dataadr, writedata, readdata);
  end;
  
  library IEEE; use IEEE.STD_LOGIC_1164.all;
  
  entity mips is -- single cycle MIPS processor
    port(clk, reset:                 in  STD_LOGIC;
         pc:                         out STD_LOGIC_VECTOR(31 downto 0);
         instr_A, instr_B, instr_C:  in  STD_LOGIC_VECTOR(31 downto 0);
         memwrite:                   out STD_LOGIC;
         aluout, writedata:          out STD_LOGIC_VECTOR(31 downto 0);
         ula_source_1, ula_source_2: in STD_LOGIC_VECTOR(31 downto 0);
         readdata:                   in  STD_LOGIC_VECTOR(31 downto 0));
  end;
  
  architecture struct of mips is
    component controller
      port(op_A, funct_A:      in  STD_LOGIC_VECTOR(5 downto 0);
           op_B, funct_B:      in  STD_LOGIC_VECTOR(5 downto 0);
           op_C, funct_C:      in  STD_LOGIC_VECTOR(5 downto 0);
           zero:               in  STD_LOGIC;
           memtoreg, memwrite: out STD_LOGIC;
           pcsrc, alusrc:      out STD_LOGIC;
           regdst, regwrite:   out STD_LOGIC;
           jump:               out STD_LOGIC;
           alucontrol:         out STD_LOGIC_VECTOR(2 downto 0));
    end component;
    component datapath
      port(clk, reset:        in  STD_LOGIC;
           memtoreg, pcsrc:   in  STD_LOGIC;
           alusrc, regdst:    in  STD_LOGIC;
           jump:    in  STD_LOGIC;
           alucontrol:        in  STD_LOGIC_VECTOR(2 downto 0);
           zero:              out STD_LOGIC;
           pc:                buffer STD_LOGIC_VECTOR(31 downto 0);
           instr_A, instr_B, instr_C:             in STD_LOGIC_VECTOR(31 downto 0);
           aluout: buffer STD_LOGIC_VECTOR(31 downto 0);
           ula_source_1:          in  STD_LOGIC_VECTOR(31 downto 0);
           ula_source_2:          in  STD_LOGIC_VECTOR(31 downto 0));
    end component;
    signal memtoreg, alusrc, regdst, regwrite, jump, pcsrc: STD_LOGIC;
    signal zero: STD_LOGIC;
    signal alucontrol: STD_LOGIC_VECTOR(2 downto 0);
  begin
    cont: controller port map(instr_A(31 downto 26), instr_A(5 downto 0),
                              instr_B(31 downto 26), instr_B(5 downto 0),
                              instr_C(31 downto 26), instr_C(5 downto 0),
                              zero, memtoreg, memwrite, pcsrc, alusrc,
                              regdst, regwrite, jump, alucontrol);
    dp: datapath port map(clk, reset, memtoreg, pcsrc, alusrc, regdst,
                          jump, alucontrol, zero, pc, instr_A, instr_B, instr_C,
                          aluout, ula_source_1, ula_source_2);
  end;