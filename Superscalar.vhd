library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Superscalar is
    port(
        CLK     :       in STD_LOGIC
    );
end;

architecture hierarchical of Superscalar is
    component Register_File
        port(
            CLK:           in  STD_LOGIC;
            WE_A, WE_B, WE_C: in  STD_LOGIC; --write enable
            RA1_A, RA2_A: in STD_LOGIC_VECTOR(4 downto 0); -- register selector for ULA 1
            RA1_B, RA2_B: in STD_LOGIC_VECTOR(4 downto 0); -- register selector for ULA 2
            RA1_C, RA2_C: in STD_LOGIC_VECTOR(4 downto 0); -- register selector for ULA 3
            WA_A, WA_B, WA_C: in  STD_LOGIC_VECTOR(4 downto 0); -- register selector for write operation
            WD_A, WD_B, WD_C: in  STD_LOGIC_VECTOR(31 downto 0); -- data to be writen
            RD1_A, RD2_A: out STD_LOGIC_VECTOR(31 downto 0); -- output data for ULA 1
            RD1_B, RD2_B: out STD_LOGIC_VECTOR(31 downto 0); -- output data for ULA 2
            RD1_C, RD2_C: out STD_LOGIC_VECTOR(31 downto 0) -- output data for ULA 3
        );
    end component;

    component instruction_memory
        port(
            a:  in  STD_LOGIC_VECTOR(5 downto 0);
            instruction_A, instruction_B, instruction_C: out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component Data_Memory
        port(
            CLK, WE_A, WE_B, WE_C  :  in STD_LOGIC;
            WA_A, WA_B, WA_C       :  in STD_LOGIC_VECTOR(4 downto 0);
            WD_A, WD_B, WD_C       :  in STD_LOGIC_VECTOR(31 downto 0);
            RD_A, RD_B, RD_C       :  out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component mux2 
        generic(width: integer);
        port(
            d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
            s:      in  STD_LOGIC;
            y:      out STD_LOGIC_VECTOR(width-1 downto 0)
        );
    end component;

    signal instr_A, instr_B, instr_C             : STD_LOGIC_VECTOR(31 downto 0);
    signal data_A, data_B, data_C                : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_data1_A, reg_data1_B, reg_data1_C : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_data2_A, reg_data2_B, reg_data2_C : STD_LOGIC_VECTOR(31 downto 0);
    signal w_en_A, w_en_B, w_en_C                : STD_LOGIC;
    signal PC                                    : STD_LOGIC_VECTOR(31 downto 0);

begin

    reg_file    : Register_File port map(CLK, w_en_A, w_en_B, w_en_C,
                                        instr_A(24 downto 19), instr_A(18 downto 13), 
                                        instr_B(24 downto 19), instr_B(18 downto 13), 
                                        instr_C(24 downto 19), instr_C(18 downto 13),
                                        instr_A(12 downto 8), instr_B(12 downto 8), instr_C(12 downto 8),
                                        data_A, data_B, data_C,
                                        reg_data1_A, reg_data2_A,
                                        reg_data1_B, reg_data2_B,
                                        reg_data1_C, reg_data2_C
                                        );

    instr_mem   : instruction_memory port map(PC(7 downto 2), instr_A, instr_B, instr_C);

    

end;