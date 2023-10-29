LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY interface_hcsr04 IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        medir : IN STD_LOGIC;
        echo : IN STD_LOGIC;
        trigger : OUT STD_LOGIC;
        medida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        pronto : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END interface_hcsr04;

ARCHITECTURE comportamental OF interface_hcsr04 IS

    COMPONENT interface_hcsr04_uc IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            medir : IN STD_LOGIC;
            echo : IN STD_LOGIC;
            fim_medida : IN STD_LOGIC;
            zera : OUT STD_LOGIC;
            gera : OUT STD_LOGIC;
            limpa : OUT STD_LOGIC;
            registra : OUT STD_LOGIC;
            pronto : OUT STD_LOGIC;
            db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT interface_hcsr04_fd IS
        PORT (
            clock : IN STD_LOGIC;
            echo : IN STD_LOGIC;
            zera : IN STD_LOGIC;
            gera : IN STD_LOGIC;
            limpa : IN STD_LOGIC;
            registra : IN STD_LOGIC;
            fim_medida : OUT STD_LOGIC;
            medida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            trigger : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL s_fim_medida, s_zera, s_gera, s_registra, s_limpa : STD_LOGIC;

BEGIN
    UC : interface_hcsr04_uc
    PORT MAP(
        clock => clock,
        reset => reset,
        medir => medir,
        echo => echo,
        fim_medida => s_fim_medida,
        zera => s_zera,
        gera => s_gera,
        limpa => s_limpa,
        registra => s_registra,
        pronto => pronto,
        db_estado => db_estado
    );

    FD : interface_hcsr04_fd
    PORT MAP(
        clock => clock,
        echo => echo,
        zera => s_zera,
        gera => s_gera,
        limpa => s_limpa,
        registra => s_registra,
        fim_medida => s_fim_medida,
        medida => medida,
        trigger => trigger
    );
END ARCHITECTURE;