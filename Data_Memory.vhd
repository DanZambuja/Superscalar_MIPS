library IEEE; 
use IEEE.STD_LOGIC_1164.all; use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all; 

entity Data_Memory is -- data memory
  port(
    CLK, WE_A, WE_B, WE_C  :  in STD_LOGIC;
    WA_A, WA_B, WA_C       :  in STD_LOGIC_VECTOR(31 downto 0);
    WD_A, WD_B, WD_C       :  in STD_LOGIC_VECTOR(31 downto 0);
    RD_A, RD_B, RD_C       :  out STD_LOGIC_VECTOR(31 downto 0)
  );
end;

architecture behave of Data_Memory is
begin
  process is
    type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    variable mem: ramtype;
  begin
    -- read or write memory
    loop
      if clk'event and clk = '1' then
          if (WE_A = '1') then mem(to_integer(WA_A)) := WD_A;
          end if;
          if (WE_B = '1') then mem(to_integer(WA_B)) := WD_B;
          end if;
          if (WE_C = '1') then mem(to_integer(WA_C)) := WD_C;
          end if;
      end if;
      RD_A <= mem(to_integer(WA_A));
      RD_B <= mem(to_integer(WA_B)); 
      RD_C <= mem(to_integer(WA_C)); 
      wait on CLK, WA_A;
    end loop;

  end process;
end;