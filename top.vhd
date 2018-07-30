library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD_UNSIGNED.all;
  
entity top is -- top-level design for testing
  port(
    clk, reset                                :   in     STD_LOGIC;
    writedata_A, writedata_B, writedata_C     :   buffer STD_LOGIC_VECTOR(31 downto 0);
    dataaddr_A, dataaddr_B, dataaddr_C        :   buffer STD_LOGIC_VECTOR(31 downto 0);
    memwrite_A, memwrite_B, memwrite_C        :   buffer STD_LOGIC;
    instruction_A, instruction_B, instruction_C : out STD_LOGIC_VECTOR(31 downto 0)
  );
end;
  
  architecture test of top is
    component MIPS 
      port(
        clk, reset                                   :  in  STD_LOGIC;
        pc                                           :  out STD_LOGIC_VECTOR(31 downto 0);
        instr_A, instr_B, instr_C                    :  in  STD_LOGIC_VECTOR(31 downto 0);
        memwrite_A, memwrite_B, memwrite_C           :  out STD_LOGIC;
        aluout_A, aluout_B, aluout_C                 :  out STD_LOGIC_VECTOR(31 downto 0);
        writedata_A, writedata_B, writedata_C        :  out STD_LOGIC_VECTOR(31 downto 0);
        readdata_A, readdata_B, readdata_C           :  in  STD_LOGIC_VECTOR(31 downto 0);
        writeDM_A, writeDM_B, writeDM_C              :  out STD_LOGIC_VECTOR(31 downto 0)
      );
    end component;

    component Instruction_Memory
      port(
        limited_PC:  in  STD_LOGIC_VECTOR(5 downto 0);
        instruction_A, instruction_B, instruction_C: out STD_LOGIC_VECTOR(31 downto 0)
      );
    end component;

    component Data_Memory
      port(
        CLK                    :  in STD_LOGIC;
        WE_A, WE_B, WE_C       :  in STD_LOGIC;
        WA_A, WA_B, WA_C       :  in STD_LOGIC_VECTOR(31 downto 0);
        WD_A, WD_B, WD_C       :  in STD_LOGIC_VECTOR(31 downto 0);
        RD_A, RD_B, RD_C       :  out STD_LOGIC_VECTOR(31 downto 0)
      );
    end component;

    signal pc, instr_A, instr_B, instr_C, readdata_A, readdata_B, readdata_C: STD_LOGIC_VECTOR(31 downto 0);
    signal s_memwrite_A, s_memwrite_B, s_memwrite_C : STD_LOGIC;
    signal s_dataaddr_A, s_dataaddr_B, s_dataaddr_C : STD_LOGIC_VECTOR(31 downto 0);
    signal s_writedata_A, s_writedata_B, s_writedata_C : STD_LOGIC_VECTOR(31 downto 0);
    signal s_writeDM_A, s_writeDM_B, s_writeDM_C : STD_LOGIC_VECTOR(31 downto 0);

  begin
    
    -- instantiate processor and memories
    mips1: MIPS port map(
      clk, reset, pc, 
      instr_A, instr_B, instr_C, 
      s_memwrite_A, s_memwrite_B, s_memwrite_C, 
      s_dataaddr_A, s_dataaddr_B, s_dataaddr_C, 
      s_writedata_A, s_writedata_B, s_writedata_C, 
      readdata_A, readdata_B, readdata_C,
      s_writeDM_A, s_writeDM_B, s_writeDM_C
    );

    -- pc(7 downto 2) is a way of limiting the number of instructions read from the instruction memory
    imem1: Instruction_Memory port map( 
      pc(7 downto 2), instr_A, instr_B, instr_C
    ); 

    dmem1: Data_Memory port map(
      clk, 
      s_memwrite_A, s_memwrite_B, s_memwrite_C, 
      s_dataaddr_A, s_dataaddr_B, s_dataaddr_C, 
      s_writeDM_A, s_writeDM_B, s_writeDM_C, 
      readdata_A, readdata_B, readdata_C
    );

    memwrite_A <= s_memwrite_A;
    memwrite_B <= s_memwrite_B;
    memwrite_C <= s_memwrite_C;

    dataaddr_A <= s_dataaddr_A;
    dataaddr_B <= s_dataaddr_B;
    dataaddr_C <= s_dataaddr_C;

    writedata_A <= s_writedata_A;
    writedata_B <= s_writedata_B;
    writedata_C <= s_writedata_C;

    instruction_A <= instr_A;
    instruction_B <= instr_B;
    instruction_C <= instr_C;

  end;
  