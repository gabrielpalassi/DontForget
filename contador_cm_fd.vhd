LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY contador_cm_fd IS
    GENERIC (
        CONSTANT R : INTEGER;
        CONSTANT N : INTEGER
    );
    PORT (
        clock : IN STD_LOGIC;
        conta_bcd : IN STD_LOGIC;
        zera_bcd : IN STD_LOGIC;
        conta_tick : IN STD_LOGIC;
        zera_tick : IN STD_LOGIC;
        digito0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        digito1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        digito2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        fim : OUT STD_LOGIC;
        tick : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE comportamental OF contador_cm_fd IS

    COMPONENT contador_m IS
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
    END COMPONENT;

    COMPONENT contador_bcd_3digitos IS
        PORT (
            clock : IN STD_LOGIC;
            zera : IN STD_LOGIC;
            conta : IN STD_LOGIC;
            digito0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            digito1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            digito2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            fim : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    TIK : contador_m
    GENERIC MAP(M => R, N => N)
    PORT MAP(
        clock => clock,
        zera => zera_tick,
        conta => conta_tick,
        Q => OPEN,
        fim => OPEN,
        meio => tick
    );

    CBCD : contador_bcd_3digitos
    PORT MAP(
        clock => clock,
        zera => zera_bcd,
        conta => conta_bcd,
        digito0 => digito0,
        digito1 => digito1,
        digito2 => digito2,
        fim => fim
    );
END ARCHITECTURE;