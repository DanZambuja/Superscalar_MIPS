library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all; 

entity Hazard_Unit is
  port(
    write_register_A, write_register_B, write_register_C:  in  STD_LOGIC_VECTOR(4 downto 0);
    PC_enable: out STD_LOGIC
  );
end;

architecture struct of Hazard_Unit is

component Comparator is
  port(
    A, B, C:  in  STD_LOGIC_VECTOR(4 downto 0);
    result: out STD_LOGIC_VECTOR (1 downto 0)
  );
end component;

signal dependencies: STD_LOGIC_VECTOR(1 downto 0);

begin
    comp: Comparator port map(write_register_A, write_register_B, write_register_C, dependencies);
    process(all) begin
        case dependencies is
            when "00" => PC_enable <= '1'; -- no dependencies
            when "10" => PC_enable <= '0'; -- stall B
            when "01" => PC_enable <= '0'; -- stall C ( if either  A = C or B = C )
            when "11" => PC_enable <= '0'; -- stall B and C
            when others => PC_enable <= '-';
        end case;
    end process;
end;