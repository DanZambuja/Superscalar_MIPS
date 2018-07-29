library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all; 

entity Comparator is
  port(
    A, B, C:  in  STD_LOGIC_VECTOR(4 downto 0);
    result: out STD_LOGIC_VECTOR (1 downto 0)
  );
end;

architecture struct of Comparator is
begin
    process(A, B, C) begin
        result <= '000';
        if(A = B AND B = C) then
            result <= '11'
        elsif(A = B) then
            result <= '10'
        elsif(A = C) then
            result <= '01'
        elsif(B = C) then
            result <= '01'
        others
            result <= '00';
        end if;
    end process;
end struct;