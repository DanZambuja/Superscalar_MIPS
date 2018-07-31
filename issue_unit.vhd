library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.STD_LOGIC_ARITH.all;

entity issue_unit is
    port(
        instr           : in  STD_LOGIC_VECTOR(31 downto 0);
        instr_status    : out STD_LOGIC_VECTOR();
        FU_sel          : out STD_LOGIC_VECTOR(1 downto 0);
        FU_status       : out STD_LOGIC_VECTOR();
        reg_sel         : out STD_LOGIC_VECTOR(4 downto 0);
        reg_res_status  : out STD_LOGIC_VECTOR()
    );
end issue_unit;

architecture combinatorial of issue_unit is

    

    
begin



    process(all) begin
        case instr(31 downto 26) is
            when "000000" =>
                instr_status    <= "";
                FU_status       <= "";
                reg_sel         <= instr(15 downto 11);
                reg_res_status  <= "";
            when "100011" =>
                instr_status    <= "";
                FU_status       <= "";
                reg_res_status  <= "";
            when "101011" =>
                instr_status    <= "";
                FU_status       <= "";
                reg_res_status  <= "";
            when "000100" =>
                instr_status    <= "";
                FU_status       <= "";
                reg_res_status  <= "";
            when "000101" =>
                instr_status    <= "";
                FU_status       <= "";
                reg_res_status  <= "";
            when "001000" =>
                instr_status    <= "";
                FU_status       <= "";
                reg_res_status  <= "";
            when "001101" =>
                instr_status    <= "";
                FU_status       <= "";
                reg_res_status  <= "";
            when "000010" =>
                instr_status    <= "";
                FU_status       <= "";
                reg_res_status  <= "";
            when others   =>
                instr_status    <= "";
                FU_status       <= "";
                reg_res_status  <= "";
        end case;
    end process;
end;