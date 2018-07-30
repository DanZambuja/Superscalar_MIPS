library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all; 

entity Hazard_Unit is
  port(
    clk, reset: in STD_LOGIC;
    dependencies: in STD_LOGIC_VECTOR(1 downto 0);
    saida: out STD_LOGIC_VECTOR(3 downto 0)
  );
end;


architecture struct of Hazard_Unit is
type type_state is (init, stall_b, stall_c, stall_a_b, stall_a_c, stall_b_c, dont_stall, done);
signal state   : type_state;
   
begin
	process (clk, dependencies, state, reset)
	begin
   
	if reset = '1' then
		state <= init;
         
	elsif (clk'event and clk = '1') then
		case state is
			when init =>
				if dependencies = "00" then
					state <= dont_stall;
                elsif dependencies = "01" then
                    state <= stall_b;
                elsif dependencies = "10" then
                    state <= stall_c;
                elsif dependencies = "11" then
                    state <= stall_b_c;
				end if;

			when stall_b =>	
				if dependencies = "00" then -- should not land here
					state <= done;
                elsif dependencies = "01" then
                    state <= stall_a_c;
                elsif dependencies = "10" then --  should not land here
                    state <= done;
                elsif dependencies = "11" then
                    state <= done;
				end if;

            when stall_c =>	
				if dependencies = "00" then -- should not land here
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