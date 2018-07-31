library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.NUMERIC_STD_UNSIGNED.all; 

entity instruction_status is
    port(
        clock         :  in  STD_LOGIC;
        reset         :  in  STD_LOGIC;
        write_enable  :  in  STD_LOGIC;
        instr_address :  in  STD_LOGIC_VECTOR(5 downto 0);
        write_status  :  in  STD_LOGIC_VECTOR(26 downto 0);
        status        :  out STD_LOGIC_VECTOR(26 downto 0)
    );
end;

architecture behavioral of instruction_status is
begin
    process is
        type instruction_table is array (63 downto 0) of STD_LOGIC_VECTOR(26 downto 0);
        variable table : instruction_table;
    begin
        loop
            if reset = '1' then
                table := (others => (others => '0'));
            elsif clock'event and clock = '1' then 
                if write_enable = '1' then 
                    table(to_integer(instr_address)) := write_status;
                end if;
            end if;
            status <= table(to_integer(instr_address));
            wait on clock;
        end loop;
    end process;
end;