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
				if free_fu /= "11" then 
					if write_status(to_integer(destination_register)) /= '0' then
                        state <= read_op;
                    end if;
				end if;

            when stall_c =>	
				if dependencies = "00" then
					state <= done;
                elsif dependencies = "01" then
                    state <= done;
                elsif dependencies = "10" then
                    state <= stall_a_b;
                elsif dependencies = "11" then
                    state <= done;
				end if;

            when stall_a_b =>	
				if dependencies = "00" then
					state <= done;
                elsif dependencies = "01" then
                    state <= done;
                elsif dependencies = "10" then
                    state <= done;
                elsif dependencies = "11" then
                    state <= done;
				end if;

            when stall_a_c =>	
				if dependencies = "00" then
					state <= done;
                elsif dependencies = "01" then
                    state <= done;
                elsif dependencies = "10" then
                    state <= done;
                elsif dependencies = "11" then
                    state <= stall_a_b;
				end if;

            when stall_b_c =>	
				if dependencies = "00" then
					state <= dont_stall;
                elsif dependencies = "01" then
                    state <= stall_a_c;
                elsif dependencies = "10" then
                    state <= stall_c;
                elsif dependencies = "11" then
                    state <= stall_a_c;
				end if;

            when dont_stall =>	
				state <= init;

            when done =>	
				state <= init;
		end case;
	end if;
    end process;
   
	process (state)
	begin
		case state is
            when init =>
                saida <= "0111";
			when stall_b =>
				saida <= "0010";
			when stall_c =>
				saida <= "0001";
			when stall_a_b =>
				saida <= "0110";
			when stall_a_c =>
				saida <= "0101";
            when stall_b_c =>
				saida <= "0011";
            when dont_stall =>
				saida <= "1000";
            when done =>
				saida <= "1111";
		end case;
   end process;
end struct;