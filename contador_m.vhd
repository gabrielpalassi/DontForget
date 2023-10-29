LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY contador_m IS
    GENERIC (
        CONSTANT M : INTEGER := 100 -- modulo do contador
    );
    PORT (
        clock : IN STD_LOGIC;
        zera_as : IN STD_LOGIC;
        zera_s : IN STD_LOGIC;
        conta : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
        fim : OUT STD_LOGIC;
        meio : OUT STD_LOGIC
    );
END ENTITY contador_m;

ARCHITECTURE comportamental OF contador_m IS
    SIGNAL IQ : INTEGER RANGE 0 TO M - 1;
BEGIN

    PROCESS (clock, zera_as, zera_s, conta, IQ)
    BEGIN
        IF zera_as = '1' THEN
            IQ <= 0;
        ELSIF rising_edge(clock) THEN
            IF zera_s = '1' THEN
                IQ <= 0;
            ELSIF conta = '1' THEN
                IF IQ = M - 1 THEN
                    IQ <= 0;
                ELSE
                    IQ <= IQ + 1;
                END IF;
            ELSE
                IQ <= IQ;
            END IF;
        END IF;
    END PROCESS;

    -- saida fim
    fim <= '1' WHEN IQ = M - 1 ELSE
        '0';

    -- saida meio
    meio <= '1' WHEN IQ = M/2 - 1 ELSE
        '0';

    -- saida Q
    Q <= STD_LOGIC_VECTOR(to_unsigned(IQ, Q'length));

END ARCHITECTURE comportamental;