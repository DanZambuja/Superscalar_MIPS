library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_ARITH.all;

entity datapath is  -- MIPS datapath
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
end;

architecture struct of datapath is
  component alu
    port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
         alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
         result:     buffer STD_LOGIC_VECTOR(31 downto 0);
         zero:       out STD_LOGIC);
  end component;

  component adder
    port(a, b: in  STD_LOGIC_VECTOR(31 downto 0);
         y:    out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  component sl2
    port(a: in  STD_LOGIC_VECTOR(31 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  component signext
    port(a: in  STD_LOGIC_VECTOR(15 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  component flopr generic(width: integer);
    port(clk, reset: in  STD_LOGIC;
         d:          in  STD_LOGIC_VECTOR(width-1 downto 0);
         q:          out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;

  component mux2 generic(width: integer);
    port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
         s:      in  STD_LOGIC;
         y:      out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;

  signal pcjump, pcnext, 
         pcnextbr, pcplus4, 
         pcbranch:           STD_LOGIC_VECTOR(31 downto 0);
  signal signimm_A, signimmsh_A: STD_LOGIC_VECTOR(31 downto 0);
  signal signimm_B, signimmsh_B: STD_LOGIC_VECTOR(31 downto 0);
  signal signimm_C, signimmsh_C: STD_LOGIC_VECTOR(31 downto 0);
  signal src1_A, src2_A, result_A: STD_LOGIC_VECTOR(31 downto 0);
  signal src1_B, src2_B, result_B: STD_LOGIC_VECTOR(31 downto 0);
  signal src1_C, src2_C, result_C: STD_LOGIC_VECTOR(31 downto 0);
  
begin
  -- next PC logic
  pcjump <= pcplus4(31 downto 28) & instr_A(25 downto 0) & "00";

  pcreg: flopr generic map(32) port map(clk, reset, pcnext, pc);

  pcadd1: adder port map(pc, X"00000004", pcplus4);

  immsh: sl2 port map(signimm_A, signimmsh_A);

  pcadd2: adder port map(pcplus4, signimmsh_A, pcbranch);

  pcbrmux: mux2 generic map(32) port map(pcplus4, pcbranch, pcsrc_A, pcnextbr);

  pcmux: mux2 generic map(32) port map(pcnextbr, pcjump, jump_A, pcnext);

  se_A: signext port map(instr_A(15 downto 0), signimm_A);

  se_B: signext port map(instr_B(15 downto 0), signimm_B);

  se_C: signext port map(instr_C(15 downto 0), signimm_C);

  -- ALU logic A
  srcbmux_A: mux2 generic map(32) port map(ula_source_A, signimm_A, alusrc_A, src2_A);

  mainalu_A: alu port map(src1_A, src2_A, alucontrol_A, aluout_A, zero_A);

  -- ALU logic B
  srcbmux_B: mux2 generic map(32) port map(ula_source_B, signimm_B, alusrc_B, src2_B);

  mainalu_B: alu port map(src1_B, src2_B, alucontrol_B, aluout_B, zero_B);

  -- ALU logic C
  srcbmux_C: mux2 generic map(32) port map(ula_source_C, signimm_C, alusrc_C, src2_C);

  mainalu_C: alu port map(src1_C, src2_C, alucontrol_C, aluout_C, zero_C);

end;
