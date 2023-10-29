LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY contador_bcd_3digitos IS
    PORT (
        clock : IN STD_LOGIC;
        zera : IN STD_LOGIC;
        conta : IN STD_LOGIC;
        digito0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        digito1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        digito2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        fim : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE comportamental OF contador_bcd_3digitos IS

    SIGNAL s_dig2, s_dig1, s_dig0 : unsigned(3 DOWNTO 0);

BEGIN

    PROCESS (clock)
    BEGIN
        IF (clock'event AND clock = '1') THEN
            IF (zera = '1') THEN -- reset sincrono
                s_dig0 <= "0000";
                s_dig1 <= "0000";
                s_dig2 <= "0000";
            ELSIF (conta = '1') THEN
                IF (s_dig0 = "1001") THEN
                    s_dig0 <= "0000";
                    IF (s_dig1 = "1001") THEN
                        s_dig1 <= "0000";
                        IF (s_dig2 = "1001") THEN
                            s_dig2 <= "0000";
                        ELSE
                            s_dig2 <= s_dig2 + 1;
                        END IF;
                    ELSE
                        s_dig1 <= s_dig1 + 1;
                    END IF;
                ELSE
                    s_dig0 <= s_dig0 + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- fim de contagem (comando VHDL when else)
    fim <= '1' WHEN s_dig2 = "1001" AND s_dig1 = "1001" AND s_dig0 = "1001" ELSE
        '0';

    -- saidas
    digito2 <= STD_LOGIC_VECTOR(s_dig2);
    digito1 <= STD_LOGIC_VECTOR(s_dig1);
    digito0 <= STD_LOGIC_VECTOR(s_dig0);

END ARCHITECTURE comportamental;