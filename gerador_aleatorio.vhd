LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY gerador_aleatorio IS
    PORT (
        clock : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamental OF gerador_aleatorio IS
    SIGNAL saida : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
BEGIN
    PROCESS (clock, rst)
    BEGIN
        -- reset
        IF rst = '1' THEN
            saida <= "0001";
        ELSIF rising_edge(clock) THEN
            saida <= saida(2 DOWNTO 0) & saida(3);
        END IF;
    END PROCESS;

    -- saida Q
    Q <= saida;

END ARCHITECTURE;