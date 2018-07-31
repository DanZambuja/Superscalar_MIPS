library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all; 

entity SB_Controller is
  port(
    clk, reset: in STD_LOGIC;
    dependencies: in STD_LOGIC_VECTOR(1 downto 0);
    free_fu: in STD_LOGIC_VECTOR(1 downto 0);
    destination_register: in STD_LOGIC_VECTOR(4 downto 0);
    source_register1, source_register2: in STD_LOGIC_VECTOR(4 downto 0);
    write_status: in STD_LOGIC_VECTOR(26 downto 0);
    saida: out STD_LOGIC_VECTOR(3 downto 0)
  );
end;


architecture struct of SB_Controller is
type type_state is (init, issue, read_op, exec, write_back);
signal state   : type_state;
   
begin
	process (clk, dependencies, state, reset)
	begin
   
	if reset = '1' then
		state <= init;
         
	elsif (clk'event and clk = '1') then
		case state is
			when init =>
				state <= issue;

			when issue =>	
				if free_fu /= "11" then -- need to have at least 1 of them available
					if write_status(to_integer(destination_register)) /= '0' then
                        state <= read_op;
                    end if;
				end if;

            when read_op =>	
				if write_status(to_integer(destination_register)) /= '0' then
                        state <= exec;
                end if;

            when exec =>	
				if done_exec = '1' then
                    state <= write_back;
                end if;

            when write_back =>	
				if done_wb then
                    state <= issue;
                end if;
		end case;
	end if;
    end process;
   
	process (state)
	begin
		case state is
            when init =>
                saida <= "0111";
			when issue =>
				saida <= "0010";
			when read_op =>
				saida <= "0001";
			when exec =>
				saida <= "0110";
			when write_back =>
				saida <= "0101";
		end case;
   end process;
end struct;