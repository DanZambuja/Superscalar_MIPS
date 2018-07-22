  library IEEE; use IEEE.STD_LOGIC_1164.all;
  
  entity maindec is -- main control decoder
    port(op:                 in  STD_LOGIC_VECTOR(5 downto 0);
         memtoreg, memwrite: out STD_LOGIC;
         branch, alusrc:     out STD_LOGIC;
         regdst, regwrite:   out STD_LOGIC;
         jump:               out STD_LOGIC;
         aluop:              out STD_LOGIC_VECTOR(1 downto 0);
         bneq:               out STD_LOGIC);
  end;
  
  architecture behave of maindec is
    signal controls: STD_LOGIC_VECTOR(9 downto 0);
  begin
    process(all) begin
      case op is
        when "000000" => controls <= "0110000010"; -- RTYPE
        when "100011" => controls <= "0101001000"; -- LW
        when "101011" => controls <= "0001010000"; -- SW
        when "000100" => controls <= "0000100001"; -- BEQ
        when "000101" => controls <= "1000100001"; -- BNE
        when "001000" => controls <= "0101000000"; -- ADDI
        when "001101" => controls <= "0101000011"; -- ORI
        when "000010" => controls <= "0000000100"; -- J
        when others   => controls <= "----------"; -- illegal op
      end case;
    end process;
  
    (bneq, regwrite, regdst, alusrc, branch, memwrite,
     memtoreg, jump, aluop(1 downto 0)) <= controls;
  end;