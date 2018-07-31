library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.NUMERIC_STD_UNSIGNED.all; 
-- Table that signals which FUs are writing to which registers
entity reg_res_status is
    port(
        clock         :  in  STD_LOGIC;
        reset         :  in  STD_LOGIC;
        write_enable  :  in  STD_LOGIC;
        reg_sel       :  in  STD_LOGIC_VECTOR(4 downto 0);
        write_status  :  out STD_LOGIC_VECTOR(1 downto 0);
        status        :  out STD_LOGIC_VECTOR(1 downto 0)
    );
end;
-- reg_sel : 5 bits 
-- mapeia registradores de 0 a 31
architecture behavioral of reg_res_status is
begin
    process is
        type reg_table is array (4 downto 0) of STD_LOGIC_VECTOR(1 downto 0);
        variable table : reg_table;
    begin
        loop
            if reset = '1' then
                table := (others => (others => '1'));
            elsif clock'event and clock = '1' then 
                if write_enable = '1' then 
                    table(to_integer(reg_sel)) := write_status;
                end if;
            end if;
            status  <= table(to_integer(reg_sel));
            wait on clock;
        end loop;
    end process;
end;