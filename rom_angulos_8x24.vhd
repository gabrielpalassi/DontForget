LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY rom_angulos_8x24 IS
    PORT (
        endereco : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        saida : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rom_arch OF rom_angulos_8x24 IS
    TYPE memoria_8x24 IS ARRAY (INTEGER RANGE 0 TO 7) OF STD_LOGIC_VECTOR(23 DOWNTO 0);
    CONSTANT tabela_angulos : memoria_8x24 := (
        x"303230", --  0 = 020  -- conteudo da ROM
        x"303430", --  1 = 040  -- angulos para o sonar
        x"303630", --  2 = 060  -- (valores em hexadecimal)
        x"303830", --  3 = 080
        x"313030", --  4 = 100
        x"313230", --  5 = 120
        x"313430", --  6 = 140
        x"313630" --  7 = 160
    );
BEGIN

    saida <= tabela_angulos(to_integer(unsigned(endereco)));

END ARCHITECTURE rom_arch;