library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity mips is -- single cycle MIPS processor
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
        alu_data_A1, alu_data_A2     :   in STD_LOGIC_VECTOR(31 downto 0);
        alu_data_B1, alu_data_B2     :   in STD_LOGIC_VECTOR(31 downto 0);
        alu_data_C1, alu_data_C2     :   in STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  component Register_File is -- The register file need to be shared among the ALUs
    port(
        CLK:           in  STD_LOGIC;
        WE_A, WE_B, WE_C: in  STD_LOGIC; --write enable
        RA1_A, RA2_A: in STD_LOGIC_VECTOR(4 downto 0); -- register selector for ULA 1
        RA1_B, RA2_B: in STD_LOGIC_VECTOR(4 downto 0); -- register selector for ULA 2
        RA1_C, RA2_C: in STD_LOGIC_VECTOR(4 downto 0); -- register selector for ULA 3
        WA_A, WA_B, WA_C: in  STD_LOGIC_VECTOR(4 downto 0); -- register selector for write operation
        WD_A, WD_B, WD_C: in  STD_LOGIC_VECTOR(31 downto 0); -- data to be writen
        RD1_A, RD2_A: out STD_LOGIC_VECTOR(31 downto 0); -- output data for ULA 1
        RD1_B, RD2_B: out STD_LOGIC_VECTOR(31 downto 0); -- output data for ULA 2
        RD1_C, RD2_C: out STD_LOGIC_VECTOR(31 downto 0) -- output data for ULA 3
    ); 
end component;

component mux2
    generic(width: integer);
        port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
             s:      in  STD_LOGIC;
             y:      out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;

  component flopr_en
    generic(width: integer);
      port(
        clk, reset: in  STD_LOGIC;
        enable    : in  STD_LOGIC;
        d         : in  STD_LOGIC_VECTOR(width-1 downto 0);
        q         : out STD_LOGIC_VECTOR(width-1 downto 0)
      );
    end component;

  signal memtoreg_A, alusrc_A, regdst_A, regwrite_A, jump_A, pcsrc_A: STD_LOGIC;
  signal memtoreg_B, alusrc_B, regdst_B, regwrite_B, jump_B, pcsrc_B: STD_LOGIC;
  signal memtoreg_C, alusrc_C, regdst_C, regwrite_C, jump_C, pcsrc_C: STD_LOGIC;
  signal zero_A, zero_B, zero_C: STD_LOGIC;
  signal alucontrol_A, alucontrol_B, alucontrol_C: STD_LOGIC_VECTOR(2 downto 0);
  signal writeReg_A, writeReg_B, writeReg_C: STD_LOGIC_VECTOR (4 downto 0);
  signal alu_data_a1, alu_data_a2: STD_LOGIC_VECTOR (31 downto 0);
  signal alu_data_b1, alu_data_b2: STD_LOGIC_VECTOR (31 downto 0);
  signal alu_data_c1, alu_data_c2: STD_LOGIC_VECTOR (31 downto 0);
  signal s_aluout_A, s_aluout_B,s_aluout_C: STD_LOGIC_VECTOR (31 downto 0);
  signal flopr_alu_data_a1, flopr_alu_data_a2: STD_LOGIC_VECTOR(31 downto 0);
  signal flopr_alu_data_b1, flopr_alu_data_b2: STD_LOGIC_VECTOR(31 downto 0);
  signal flopr_alu_data_c1, flopr_alu_data_c2: STD_LOGIC_VECTOR(31 downto 0);

begin

    cont: controller port map(
        instr_A(31 downto 26), instr_B(31 downto 26), instr_C(31 downto 26),
        instr_A(5 downto 0), instr_B(5 downto 0), instr_C(5 downto 0),
        zero_A, zero_B, zero_C, 
        memtoreg_A, memwrite_A, 
        memtoreg_B, memwrite_B, 
        memtoreg_C, memwrite_C,
        pcsrc_A, alusrc_A, 
        pcsrc_B, alusrc_B, 
        pcsrc_C, alusrc_C,
        regdst_A, regwrite_A, 
        regdst_B, regwrite_B, 
        regdst_C, regwrite_C,
        jump_A, jump_B, jump_C, 
        alucontrol_A, alucontrol_B,  alucontrol_C
    );

    dp: datapath port map(
        clk, reset, 
        memtoreg_A, pcsrc_A, 
        memtoreg_B, pcsrc_B,
        memtoreg_C, pcsrc_C,
        alusrc_A, regdst_A,
        alusrc_B, regdst_B,
        alusrc_C, regdst_C,
        jump_A, jump_B, jump_C, 
        alucontrol_A, alucontrol_B, alucontrol_C, 
        zero_A, zero_B, zero_C, 
        pc, 
        instr_A, instr_B, instr_C,
        s_aluout_A, s_aluout_B, s_aluout_C, 
        flopr_alu_data_a1, flopr_alu_data_a2,
        flopr_alu_data_b1, flopr_alu_data_b2,
        flopr_alu_data_c1, flopr_alu_data_c2
    );

    rf: Register_File port map(
        clk,
        regwrite_A, regwrite_B, regwrite_C,
        instr_A(25 downto 21), instr_A(20 downto 16),
        instr_B(25 downto 21), instr_B(20 downto 16),
        instr_C(25 downto 21), instr_C(20 downto 16),
        writeReg_A, writeReg_B, writeReg_C,
        writedata_A, writedata_B, writedata_C,
        alu_data_a1, alu_data_a2,
        alu_data_b1, alu_data_b2, 
        alu_data_c1, alu_data_c2
    );

    resmux_A: mux2 generic map(32) port map(s_aluout_A, readdata_A, memtoreg_A, writedata_A);

    resmux_B: mux2 generic map(32) port map(s_aluout_B, readdata_B, memtoreg_B, writedata_B);

    resmux_C: mux2 generic map(32) port map(s_aluout_C, readdata_C, memtoreg_C, writedata_C);
    
    wrmux_A: mux2 generic map(5) port map(instr_A(20 downto 16), instr_A(15 downto 11), regdst_A, writeReg_A);

    wrmux_B: mux2 generic map(5) port map(instr_B(20 downto 16), instr_B(15 downto 11), regdst_B, writeReg_B);

    wrmux_C: mux2 generic map(5) port map(instr_C(20 downto 16), instr_C(15 downto 11), regdst_C, writeReg_C);

    floper_en_in_mipsA1: flopr_en generic map(32) port map (clk, reset, '1', alu_data_a1, flopr_alu_data_a1);
    floper_en_in_mipsA2: flopr_en generic map(32) port map (clk, reset, '1', alu_data_a2, flopr_alu_data_a2);

    floper_en_in_mipsB1: flopr_en generic map(32) port map (clk, reset, '1', alu_data_b1, flopr_alu_data_b1);
    floper_en_in_mipsB2: flopr_en generic map(32) port map (clk, reset, '1', alu_data_b2, flopr_alu_data_b2);

    floper_en_in_mipsC1: flopr_en generic map(32) port map (clk, reset, '1', alu_data_c1, flopr_alu_data_c1);
    floper_en_in_mipsC2: flopr_en generic map(32) port map (clk, reset, '1', alu_data_c2, flopr_alu_data_c2);

    
    --floper_en_out_mipsA1: flopr_en generic map(1) port map (clk, reset, '1', '1', '1');
    --floper_en_out_mipsA2: flopr_en generic map(1) port map (clk, reset, '1', '1', '1');

    --floper_en_out_mipsB2: flopr_en generic map(1) port map (clk, reset, '1', '1', '1');
    --floper_en_out_mipsB1: flopr_en generic map(1) port map (clk, reset, '1', '1', '1');
    
    --floper_en_out_mipsC1: flopr_en generic map(1) port map (clk, reset, '1', '1', '1');
    --floper_en_out_mipsC2: flopr_en generic map(1) port map (clk, reset, '1', '1', '1');
    
    writeDM_A <= alu_data_a2;
    writeDM_B <= alu_data_b2;
    writeDM_C <= alu_data_c2;

    aluout_A <= s_aluout_A;
    aluout_B <= s_aluout_B;
    aluout_C <= s_aluout_C;
    
end;