library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_ARITH.all;

entity datapath is  -- MIPS datapath
  port(
    clk, reset:        in  STD_LOGIC;
    memtoreg, pcsrc:   in  STD_LOGIC;
    alusrc, regdst:    in  STD_LOGIC;
    jump:              in  STD_LOGIC;
    alucontrol:        in  STD_LOGIC_VECTOR(2 downto 0);
    zero:              out STD_LOGIC;
    pc:                buffer STD_LOGIC_VECTOR(31 downto 0);
    instr:             in  STD_LOGIC_VECTOR(31 downto 0);
    aluout: buffer STD_LOGIC_VECTOR(31 downto 0);
    ula_source_1:         in STD_LOGIC_VECTOR(31 downto 0);
    ula_source_2:         in STD_LOGIC_VECTOR(31 downto 0)
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
  signal signimm, signimmsh: STD_LOGIC_VECTOR(31 downto 0);
  signal src1, src2, result: STD_LOGIC_VECTOR(31 downto 0);
  
begin
  -- next PC logic
  pcjump <= pcplus4(31 downto 28) & instr(25 downto 0) & "00";
  pcreg: flopr generic map(32) port map(clk, reset, pcnext, pc);
  pcadd1: adder port map(pc, X"00000004", pcplus4);
  immsh: sl2 port map(signimm, signimmsh);
  pcadd2: adder port map(pcplus4, signimmsh, pcbranch);
  pcbrmux: mux2 generic map(32) port map(pcplus4, pcbranch, 
                                         pcsrc, pcnextbr);
  pcmux: mux2 generic map(32) port map(pcnextbr, pcjump, jump, pcnext);


  se: signext port map(instr(15 downto 0), signimm);

  -- ALU logic A
  srcbmux_A: mux2 generic map(32) port map(ula_source_2, signimm, alusrc, 
                                         src2);
  mainalu_A: alu port map(src1, src2, alucontrol, aluout, zero);

  -- ALU logic B
  srcbmux_B: mux2 generic map(32) port map(ula_source_2, signimm, alusrc, 
                                         src2);
  mainalu_B: alu port map(src1, src2, alucontrol, aluout, zero);

  -- ALU logic C
  srcbmux_C: mux2 generic map(32) port map(ula_source_2, signimm, alusrc, 
                                         src2);
  mainalu_C: alu port map(src1, src2, alucontrol, aluout, zero);

end;
