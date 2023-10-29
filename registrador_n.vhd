LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registrador_n IS
    GENERIC (
        CONSTANT N : INTEGER := 8
    );
    PORT (
        clock : IN STD_LOGIC;
        clear : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        D : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0)
    );
END ENTITY registrador_n;

ARCHITECTURE comportamental OF registrador_n IS
    SIGNAL IQ : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
BEGIN

    PROCESS (clock, clear, enable, IQ)
    BEGIN
        IF (clear = '1') THEN
            IQ <= (OTHERS => '0');
        ELSIF (clock'event AND clock = '1') THEN
            IF (enable = '1') THEN
                IQ <= D;
            ELSE
                IQ <= IQ;
            END IF;
        END IF;
        Q <= IQ;
    END PROCESS;

END ARCHITECTURE comportamental;