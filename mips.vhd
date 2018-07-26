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