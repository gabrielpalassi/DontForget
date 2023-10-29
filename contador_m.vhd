LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY contador_m IS
    GENERIC (
        CONSTANT M : INTEGER := 50;
        CONSTANT N : INTEGER := 6
    );
    PORT (
        clock : IN STD_LOGIC;
        zera : IN STD_LOGIC;
        conta : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
        fim : OUT STD_LOGIC;
        meio : OUT STD_LOGIC
    );
END ENTITY contador_m;

ARCHITECTURE contador_m_arch OF contador_m IS
    SIGNAL IQ : INTEGER RANGE 0 TO M - 1;
BEGIN

    PROCESS (clock, zera, conta, IQ)
    BEGIN
        IF zera = '1' THEN
            IQ <= 0;
        ELSIF clock'event AND clock = '1' THEN
            IF conta = '1' THEN
                IF IQ = M - 1 THEN
                    IQ <= 0;
                ELSE
                    IQ <= IQ + 1;
                END IF;
            END IF;
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
END ARCHITECTURE;