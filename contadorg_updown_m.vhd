LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY contadorg_updown_m IS
    GENERIC (
        CONSTANT M : INTEGER := 50 -- modulo do contador
    );
    PORT (
        clock : IN STD_LOGIC;
        zera_as : IN STD_LOGIC;
        zera_s : IN STD_LOGIC;
        conta : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR (NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
        inicio : OUT STD_LOGIC;
        fim : OUT STD_LOGIC;
        meio : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE comportamental OF contadorg_updown_m IS
    SIGNAL IQ : INTEGER RANGE 0 TO M - 1;
    SIGNAL dir : BIT;
BEGIN

    PROCESS (clock, zera_as, zera_s, conta, IQ)
    BEGIN
        IF zera_as = '1' THEN
            IQ <= 0;
        ELSIF rising_edge(clock) THEN
            IF zera_s = '1' THEN
                IQ <= 0;
            ELSIF conta = '1' THEN

                IF dir = '0' THEN
                    IF IQ = M - 1 THEN
                        IQ <= M - 2;
                        dir <= '1';
                    ELSE
                        IQ <= IQ + 1;
                    END IF;
                ELSE
                    IF IQ = 0 THEN
                        IQ <= 1;
                        dir <= '0';
                    ELSE
                        IQ <= IQ - 1;
                    END IF;
                END IF;

            ELSE
                IQ <= IQ;
            END IF;
        END IF;

        -- inicio de contagem    
        IF IQ = 0 THEN
            inicio <= '1';
        ELSE
            inicio <= '0';
        END IF;

        -- fim de contagem    
        IF IQ = M - 1 THEN
            fim <= '1';
        ELSE
            fim <= '0';
        END IF;

        -- meio da contagem
        IF IQ = M/2 - 1 THEN
            meio <= '1';
        ELSE
            meio <= '0';
        END IF;

        Q <= STD_LOGIC_VECTOR(to_unsigned(IQ, Q'length));

    END PROCESS;

END ARCHITECTURE comportamental;