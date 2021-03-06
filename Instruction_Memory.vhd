library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;  

entity Instruction_Memory is -- instruction memory
  port(
    limited_PC:  in  STD_LOGIC_VECTOR(5 downto 0);
    instruction_A, instruction_B, instruction_C: out STD_LOGIC_VECTOR(31 downto 0)
  );
end;

architecture behave of Instruction_Memory is
begin
  process is
    file mem_file: TEXT;
    variable L: line;
    variable ch: character;
    variable i, index, result: integer;
    type ramtype is array (65 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    variable mem: ramtype;
  begin
    -- initialize memory from file
    for i in 0 to 65 loop -- set all contents low
      mem(i) := (others => '0'); 
    end loop;
    index := 0; 
    FILE_OPEN(mem_file, "C:/Users/danie/Desktop/Arq/Superscalar/src/memfile.dat", READ_MODE);
    while not endfile(mem_file) loop
      readline(mem_file, L);
      result := 0;
      for i in 1 to 8 loop
        read(L, ch);
        if '0' <= ch and ch <= '9' then 
            result := character'pos(ch) - character'pos('0');
        elsif 'a' <= ch and ch <= 'f' then
            result := character'pos(ch) - character'pos('a')+10;
        else report "Format error on line " & integer'image(index)
              severity error;
        end if;
        mem(index)(35-i*4 downto 32-i*4) :=to_std_logic_vector(result,4);
      end loop;
      index := index + 1;
    end loop;

    -- read memory
    loop
      instruction_A <= mem(to_integer(limited_PC));
      instruction_B <= mem(to_integer(limited_PC) + 1);
      instruction_C <= mem(to_integer(limited_PC) + 2);
      wait on limited_PC;
    end loop;
  end process;
end;