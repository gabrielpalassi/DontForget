LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY interface_hcsr04_fd IS
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
END interface_hcsr04_fd;

ARCHITECTURE comportamental OF interface_hcsr04_fd IS

    COMPONENT contador_cm IS
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
    END COMPONENT;

    COMPONENT gerador_pulso IS
        GENERIC (
            largura : INTEGER := 25
        );
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            gera : IN STD_LOGIC;
            para : IN STD_LOGIC;
            pulso : OUT STD_LOGIC;
            pronto : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT registrador_n IS
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
    END COMPONENT;

    SIGNAL s_medida : STD_LOGIC_VECTOR(11 DOWNTO 0);

BEGIN

    CM : contador_cm
    GENERIC MAP(R => 2941, N => 12)
    PORT MAP(
        clock => clock,
        reset => zera,
        pulso => echo,
        digito0 => s_medida(3 DOWNTO 0),
        digito1 => s_medida(7 DOWNTO 4),
        digito2 => s_medida(11 DOWNTO 8),
        fim => OPEN,
        pronto => fim_medida
    );

    GTRG : gerador_pulso
    GENERIC MAP(largura => 500)
    PORT MAP(
        clock => clock,
        reset => zera,
        gera => gera,
        para => zera,
        pulso => trigger,
        pronto => OPEN
    );

    REG1 : registrador_n
    GENERIC MAP(N => 12)
    PORT MAP(
        clock => clock,
        clear => limpa,
        enable => registra,
        D => s_medida,
        Q => medida
    );

END ARCHITECTURE;