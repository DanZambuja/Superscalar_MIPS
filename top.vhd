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
    mips1: mips port map(clk, reset, pc, instr_A, instr_B, instr_C, memwrite, dataadr, writedata, ula_source_1, ula_source_2, readdata);

    imem1: Instruction_Memory port map(pc(7 downto 2), instr_A, instr_B, instr_C); -- pc(7 downto 2) is a way of limiting the number of instructions read from the instruction memory

    dmem1: Data_Memory port map(clk, memwrite, dataadr, writedata, readdata);

  end;
  