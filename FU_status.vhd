library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.NUMERIC_STD_UNSIGNED.all; 

entity FU_status is
    port(
        clock         :  in  STD_LOGIC;
        reset         :  in  STD_LOGIC;
        write_enable  :  in  STD_LOGIC;
        FU_sel        :  in  STD_LOGIC_VECTOR(1 downto 0);
        write_status  :  out STD_LOGIC_VECTOR(26 downto 0);
        status        :  out STD_LOGIC_VECTOR(26 downto 0)
    );
end;
-- FU_sel
-- A : 00
-- B : 01
-- C : 10
-- dont care : 11
architecture behavioral of FU_status is
begin
    process is
        type fu_table is array (1 downto 0) of STD_LOGIC_VECTOR(26 downto 0);
        variable table : fu_table;
    begin
        loop
            if reset = '1' then
                table := (others => (others => '0'));
            elsif clock'event and clock = '1' then 
                if write_enable = '1' then 
                    table(to_integer(FU_sel)) := write_status;
                end if;
            end if;
            status  <= table(to_integer(FU_sel));
            wait on clock;
        end loop;
    end process;
end;