LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY contador_cm IS
    GENERIC (
        CONSTANT R : INTEGER;
        CONSTANT N : INTEGER
    );
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        pulso : IN STD_LOGIC;
        digito0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        digito1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        digito2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        fim : OUT STD_LOGIC;
        pronto : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE comportamental OF contador_cm IS

    COMPONENT contador_cm_uc IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            inicio : IN STD_LOGIC;
            fim : IN STD_LOGIC;
            tick : IN STD_LOGIC;
            conta_bcd : OUT STD_LOGIC;
            zera_bcd : OUT STD_LOGIC;
            conta_tick : OUT STD_LOGIC;
            zera_tick : OUT STD_LOGIC;
            pronto : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT contador_cm_fd IS
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
    END COMPONENT;

    SIGNAL s_conta_bcd, s_zera_bcd, s_conta_tick, s_zera_tick, s_tick, not_pulso : STD_LOGIC;

BEGIN

    not_pulso <= NOT pulso;

    UC : contador_cm_uc
    PORT MAP(
        clock => clock,
        reset => reset,
        inicio => pulso,
        fim => not_pulso,
        tick => s_tick,
        conta_bcd => s_conta_bcd,
        zera_bcd => s_zera_bcd,
        conta_tick => s_conta_tick,
        zera_tick => s_zera_tick,
        pronto => pronto
    );

    FD : contador_cm_fd
    GENERIC MAP(R => R, N => N)
    PORT MAP(
        clock => clock,
        conta_bcd => s_conta_bcd,
        zera_bcd => s_zera_bcd,
        conta_tick => s_conta_tick,
        zera_tick => s_zera_tick,
        digito0 => digito0,
        digito1 => digito1,
        digito2 => digito2,
        fim => fim,
        tick => s_tick
    );
END ARCHITECTURE;