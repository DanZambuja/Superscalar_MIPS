 library IEEE; use IEEE.STD_LOGIC_1164.all; 
    use IEEE.NUMERIC_STD_UNSIGNED.all;
    
    entity regfile is -- three-port register file
      port(clk:           in  STD_LOGIC;
           we3, we6, we9: in  STD_LOGIC; --write enable
           ra1, ra2: in STD_LOGIC_VECTOR(4 downto 0); -- register selector for ULA 1
           ra3, ra4: in STD_LOGIC_VECTOR(4 downto 0);-- register selector for ULA 2
           ra5, ra6: in STD_LOGIC_VECTOR(4 downto 0);-- register selector for ULA 3
           wa3, wa6, wa9: in  STD_LOGIC_VECTOR(4 downto 0); -- register selector for write operation
           wd3, wd6, wd9: in  STD_LOGIC_VECTOR(31 downto 0); -- data to be writen
           rd1, rd2: out STD_LOGIC_VECTOR(31 downto 0)); -- output data for ULA 1
           rd3, rd4: out STD_LOGIC_VECTOR(31 downto 0)); -- output data for ULA 2
           rd5, rd6: out STD_LOGIC_VECTOR(31 downto 0)); -- output data for ULA 3
    end;
    
    architecture behave of regfile is
      type ramtype is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
      signal mem: ramtype;
    begin
      -- three-ported register file
      -- read two ports combinationally
      -- write third port on rising edge of clock
      -- register 0 hardwired to 0
      -- note: for pipelined processor, write third port
      -- on falling edge of clk
      process(clk) begin
        if rising_edge(clk) then
           if we3 = '1' then mem(to_integer(wa3)) <= wd3;
           end if;
           if we6 = '1' then mem(to_integer(wa3)) <= wd6;
           end if;
           if we9 = '1' then mem(to_integer(wa3)) <= wd9;
           end if;
        end if;
      end process;
      process(all) begin
        if (to_integer(ra1) = 0) then rd1 <= X"00000000"; -- register 0 holds 0
           else rd1 <= mem(to_integer(ra1));
        end if;
        if (to_integer(ra2) = 0) then rd2 <= X"00000000"; 
           else rd2 <= mem(to_integer(ra2));
        end if;
        if (to_integer(ra3) = 0) then rd3 <= X"00000000";
           else rd3 <= mem(to_integer(ra3));
        end if;
        if (to_integer(ra4) = 0) then rd4 <= X"00000000"; 
           else rd4 <= mem(to_integer(ra4));
        end if;
        if (to_integer(ra5) = 0) then rd5 <= X"00000000";
           else rd5 <= mem(to_integer(ra5));
        end if;
        if (to_integer(ra6) = 0) then rd6 <= X"00000000"; 
           else rd6 <= mem(to_integer(ra6));
        end if;
      end process;
    end;