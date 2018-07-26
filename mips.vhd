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