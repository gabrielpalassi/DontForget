LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY contador_dec IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        conta : IN STD_LOGIC;
        D : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        fim : OUT STD_LOGIC
    );
END ENTITY contador_dec;

ARCHITECTURE comportamental OF contador_dec IS
    SIGNAL IQ : INTEGER RANGE 0 TO 7;
BEGIN

    PROCESS (clock, reset, conta, IQ)
    BEGIN
        IF reset = '1' THEN
            IQ <= to_integer(unsigned(D));
        ELSIF rising_edge(clock) THEN
            IF conta = '1' AND enable = '1' THEN
                IF IQ = 0 THEN
                    IQ <= 7;
                ELSE
                    IQ <= IQ - 1;
                END IF;
            ELSE
                IQ <= IQ;
            END IF;
        END IF;
    END PROCESS;

    -- saida fim
    fim <= '1' WHEN IQ = 0 ELSE
        '0';

    -- saida Q
    Q <= STD_LOGIC_VECTOR(to_unsigned(IQ, Q'length));

END ARCHITECTURE comportamental;