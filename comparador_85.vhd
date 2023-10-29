LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY comparador_85 IS
    PORT (
        i_A3 : IN STD_LOGIC;
        i_B3 : IN STD_LOGIC;
        i_A2 : IN STD_LOGIC;
        i_B2 : IN STD_LOGIC;
        i_A1 : IN STD_LOGIC;
        i_B1 : IN STD_LOGIC;
        i_A0 : IN STD_LOGIC;
        i_B0 : IN STD_LOGIC;
        i_AGTB : IN STD_LOGIC;
        i_ALTB : IN STD_LOGIC;
        i_AEQB : IN STD_LOGIC;
        o_AGTB : OUT STD_LOGIC;
        o_ALTB : OUT STD_LOGIC;
        o_AEQB : OUT STD_LOGIC
    );
END ENTITY comparador_85;

ARCHITECTURE dataflow OF comparador_85 IS
    SIGNAL agtb : STD_LOGIC;
    SIGNAL aeqb : STD_LOGIC;
    SIGNAL altb : STD_LOGIC;
BEGIN

    -- equacoes dos sinais: pagina 462, capitulo 6 do livro-texto
    -- Wakerly, J.F. Digital Design - Principles and Practice, 4th Edition
    -- veja tambem datasheet do CI SN7485 (Function Table) 
    agtb <= (i_A3 AND NOT(i_B3)) OR
        (NOT(i_A3 XOR i_B3) AND i_A2 AND NOT(i_B2)) OR
        (NOT(i_A3 XOR i_B3) AND NOT(i_A2 XOR i_B2) AND i_A1 AND NOT(i_B1)) OR
        (NOT(i_A3 XOR i_B3) AND NOT(i_A2 XOR i_B2) AND NOT(i_A1 XOR i_B1) AND i_A0 AND NOT(i_B0));
    aeqb <= NOT((i_A3 XOR i_B3) OR (i_A2 XOR i_B2) OR (i_A1 XOR i_B1) OR (i_A0 XOR i_B0));
    altb <= NOT(agtb OR aeqb);
    
    -- saidas
    o_AGTB <= agtb OR (aeqb AND (NOT(i_AEQB) AND NOT(i_ALTB)));
    o_ALTB <= altb OR (aeqb AND (NOT(i_AEQB) AND NOT(i_AGTB)));
    o_AEQB <= aeqb AND i_AEQB;

END ARCHITECTURE dataflow;