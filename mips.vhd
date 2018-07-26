library IEEE; 
use IEEE.STD_LOGIC_1164.all;

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
    port(
        op_A, op_B, op_C            :   in  STD_LOGIC_VECTOR(5 downto 0);
        funct_A, funct_B, funct_C   :   in  STD_LOGIC_VECTOR(5 downto 0);
        zero_A, zero_B, zero_C      :   in  STD_LOGIC;
        memtoreg_A, memwrite_A      :   out STD_LOGIC;
        memtoreg_B, memwrite_B      :   out STD_LOGIC;
        memtoreg_C, memwrite_C      :   out STD_LOGIC;
        pcsrc_A, alusrc_A           :   out STD_LOGIC;
        pcsrc_B, alusrc_B           :   out STD_LOGIC;
        pcsrc_C, alusrc_C           :   out STD_LOGIC;
        regdst_A, regwrite_A        :   out STD_LOGIC;
        regdst_B, regwrite_B        :   out STD_LOGIC;
        regdst_C, regwrite_C        :   out STD_LOGIC;
        jump_A, jump_B, jump_C      :   out STD_LOGIC;
        alucontrol_A                :   out STD_LOGIC_VECTOR(2 downto 0);
        alucontrol_B                :   out STD_LOGIC_VECTOR(2 downto 0);
        alucontrol_C                :   out STD_LOGIC_VECTOR(2 downto 0)
    );
  end component;

  component datapath
    port(
        clk, reset                   :   in  STD_LOGIC;
        memtoreg_A, pcsrc_A          :   in  STD_LOGIC;
        memtoreg_B, pcsrc_B          :   in  STD_LOGIC;
        memtoreg_C, pcsrc_C          :   in  STD_LOGIC;
        alusrc_A, regdst_A           :   in  STD_LOGIC;
        alusrc_B, regdst_B           :   in  STD_LOGIC;
        alusrc_C, regdst_C           :   in  STD_LOGIC;
        jump_A, jump_B, jump_C       :   in  STD_LOGIC;
        alucontrol_A                 :   in  STD_LOGIC_VECTOR(2 downto 0);
        alucontrol_B                 :   in  STD_LOGIC_VECTOR(2 downto 0);
        alucontrol_C                 :   in  STD_LOGIC_VECTOR(2 downto 0);
        zero_A, zero_B, zero_C       :   out STD_LOGIC;
        pc                           :   buffer STD_LOGIC_VECTOR(31 downto 0);
        instr_A, instr_B, instr_C    :   in  STD_LOGIC_VECTOR(31 downto 0);
        aluout_A, aluout_B, aluout_C :   buffer STD_LOGIC_VECTOR(31 downto 0);
        ula_source_A                 :   in STD_LOGIC_VECTOR(31 downto 0);
        ula_source_B                 :   in STD_LOGIC_VECTOR(31 downto 0);
        ula_source_C                 :   in STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  signal memtoreg_A, alusrc_A, regdst_A, regwrite_A, jump_A, pcsrc_A: STD_LOGIC;
  signal memtoreg_B, alusrc_B, regdst_B, regwrite_B, jump_B, pcsrc_B: STD_LOGIC;
  signal memtoreg_C, alusrc_C, regdst_C, regwrite_C, jump_C, pcsrc_C: STD_LOGIC;
  signal zero_A, zero_B, zero_C: STD_LOGIC;
  signal alucontrol_A, alucontrol_B, alucontrol_C: STD_LOGIC_VECTOR(2 downto 0);

begin

    cont: controller port map(
        instr_A(31 downto 26), instr_A(5 downto 0),
        instr_B(31 downto 26), instr_B(5 downto 0),
        instr_C(31 downto 26), instr_C(5 downto 0),
        zero_A, zero_B, zero_C, 
        memtoreg_A, memwrite_A, memtoreg_B, memwrite_B, memtoreg_C, memwrite_C,
        pcsrc_A, alusrc_A, pcsrc_B, alusrc_B, pcsrc_C, alusrc_C,
        regdst_A, regwrite_A, regdst_B, regwrite_B, regdst_C, regwrite_C,
        jump_A, alucontrol_A, jump_B, alucontrol_B, jump_C, alucontrol_C
    );

    dp: datapath port map(
        clk, reset, 
        memtoreg_A, pcsrc_A, 
        memtoreg_B, pcsrc_B,
        memtoreg_C, pcsrc_C,
        alusrc_A, regdst_A,
        alusrc_B, regdst_B,
        alusrc_C, regdst_C,
        jump_A, jump_B, jump_C 
        alucontrol_A, alucontrol_B, alucontrol_C, 
        zero_A, zero_B, zero_C, 
        pc, instr_A, instr_B, instr_C,
        aluout_A, aluout_B, aluout_C, 
        ula_source_A, ula_source_B, ula_source_C
    );
end;