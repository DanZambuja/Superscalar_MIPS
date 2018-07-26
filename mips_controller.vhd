library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity Controller is -- single cycle control decoder
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
end;


architecture struct of Controller is

  component Main_Decoder
    port(
      op                  :  in  STD_LOGIC_VECTOR(5 downto 0);
      memtoreg, memwrite  :  out STD_LOGIC;
      branch, alusrc      :  out STD_LOGIC;
      regdst, regwrite    :  out STD_LOGIC;
      jump                :  out STD_LOGIC;
      aluop               :  out STD_LOGIC_VECTOR(1 downto 0);
      bneq                :  out STD_LOGIC
    );
  end component;

  component ALU_Decoder
    port(
      funct       :      in  STD_LOGIC_VECTOR(5 downto 0);
      aluop       :      in  STD_LOGIC_VECTOR(1 downto 0);
      alucontrol  : out STD_LOGIC_VECTOR(2 downto 0)
    );
  end component;

  signal aluop_A, aluop_B, aluop_C:  STD_LOGIC_VECTOR(1 downto 0);
  signal branch_A, branch_B, branch_C: STD_LOGIC;
  signal bneq_A, bneq_B, bneq_C: STD_LOGIC;

begin
  -- Controller A
  md_A: Main_Decoder port map(op_A, memtoreg_A, memwrite_A, branch_A,
                              alusrc_A, regdst_A, regwrite_A, jump_A, aluop_A, bneq_A);
  ad_A: ALU_Decoder port map(funct_A, aluop_A, alucontrol_A);

  pcsrc_A <= (branch_A and zero_A) or (bneq_A and not zero_A);

  -- Controller B
  md_B: Main_Decoder port map(op_B, memtoreg_B, memwrite_B, branch_B,
                              alusrc_B, regdst_B, regwrite_B, jump_B, aluop_B, bneq_B);
  ad_B: ALU_Decoder port map(funct_B, aluop_B, alucontrol_B);

  pcsrc_B <= (branch_B and zero_B) or (bneq_B and not zero_B);

  -- Controller C
  md_C: Main_Decoder port map(op_C, memtoreg_C, memwrite_C, branch_C,
                              alusrc_C, regdst_C, regwrite_C, jump_C, aluop_C, bneq_C);
  ad_C: ALU_Decoder port map(funct_C, aluop_C, alucontrol_C);

  pcsrc_C <= (branch_C and zero_C) or (bneq_C and not zero_C);

end;