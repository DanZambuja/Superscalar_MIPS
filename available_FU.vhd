library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.STD_LOGIC_ARITH.all;

entity available_FU is
    port(
        selector        : in  STD_LOGIC_VECTOR(2 downto 0);
        available       : out STD_LOGIC_VECTOR(1 downto 0)     
    );
end;

architecture behavioral of available_FU is

begin
    process(all) begin
        case selector is
            when "000" => available <= "00";
            when "100" => available <= "01";
            when "110" => available <= "10";
            when "011" => available <= "00";
            when "101" => available <= "01";
            when "010" => available <= "00";
            when "111" => available <= "11";
            when others => available <= "11";
        end case;
    end process;

end;