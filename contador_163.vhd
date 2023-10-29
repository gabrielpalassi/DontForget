LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY contador_163 IS
    PORT (
        clock : IN STD_LOGIC;
        clr : IN STD_LOGIC;
        ld : IN STD_LOGIC;
        ent : IN STD_LOGIC;
        enp : IN STD_LOGIC;
        D : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        rco : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE comportamental OF contador_163 IS
    SIGNAL IQ : INTEGER RANGE 0 TO 15;
BEGIN

    -- contagem
    PROCESS (clock)
    BEGIN
        IF clock'event AND clock = '1' THEN
            IF clr = '0' THEN
                IQ <= 0;
            ELSIF ld = '0' THEN
                IQ <= to_integer(unsigned(D));
            ELSIF ent = '1' AND enp = '1' THEN
                IF IQ = 15 THEN
                    IQ <= 0;
                ELSE
                    IQ <= IQ + 1;
                END IF;
            ELSE
                IQ <= IQ;
            END IF;
        END IF;
    END PROCESS;

    -- saida rco
    rco <= '1' WHEN IQ = 15 AND ent = '1' ELSE
        '0';

    -- saida Q
    Q <= STD_LOGIC_VECTOR(to_unsigned(IQ, Q'length));

END ARCHITECTURE;