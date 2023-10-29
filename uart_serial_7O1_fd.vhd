LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY uart_serial_7O1_fd IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        zera : IN STD_LOGIC;
        conta : IN STD_LOGIC;
        carrega : IN STD_LOGIC;
        desloca : IN STD_LOGIC;
        limpa : IN STD_LOGIC;
        registra : IN STD_LOGIC;
        dado_serial : IN STD_LOGIC;
        dados_ascii : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        saida_serial : OUT STD_LOGIC;
        dado_recebido : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        paridade_recebida : OUT STD_LOGIC;
        fim : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE uart_serial_7O1_fd_arch OF uart_serial_7O1_fd IS

    COMPONENT deslocador_n
        GENERIC (
            CONSTANT N : INTEGER
        );
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            carrega : IN STD_LOGIC;
            desloca : IN STD_LOGIC;
            entrada_serial : IN STD_LOGIC;
            dados : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            saida : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT contador_m
        GENERIC (
            CONSTANT M : INTEGER;
            CONSTANT N : INTEGER
        );
        PORT (
            clock : IN STD_LOGIC;
            zera : IN STD_LOGIC;
            conta : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            fim : OUT STD_LOGIC;
            meio : OUT STD_LOGIC
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

    SIGNAL s_dados : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL s_dados_entrada : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL s_dados_registrado : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    s_dados_entrada(0) <= '0'; -- start bit
    s_dados_entrada(7 DOWNTO 1) <= dados_ascii;
    -- bit de paridade da transmissao impar (dados + paridade)
    s_dados_entrada(8) <= NOT (dados_ascii(0) XOR dados_ascii(1)
    XOR dados_ascii(2) XOR dados_ascii(3)
    XOR dados_ascii(4) XOR dados_ascii(5)
    XOR dados_ascii(6));
    s_dados_entrada(9) <= '1'; -- stop bit

    U1 : deslocador_n
    GENERIC MAP(
        N => 10
    )
    PORT MAP(
        clock => clock,
        reset => reset,
        carrega => carrega,
        desloca => desloca,
        entrada_serial => dado_serial,
        dados => s_dados_entrada,
        saida => s_dados
    );

    U2 : contador_m
    GENERIC MAP(
        M => 11,
        N => 4
    )
    PORT MAP(
        clock => clock,
        zera => zera,
        conta => conta,
        Q => OPEN,
        fim => fim,
        meio => OPEN
    );

    U3 : registrador_n
    GENERIC MAP(N => 8)
    PORT MAP(
        clock => clock,
        clear => limpa,
        enable => registra,
        D => s_dados(8 DOWNTO 1),
        Q => s_dados_registrado
    );

    dado_recebido <= s_dados_registrado(6 DOWNTO 0);
    paridade_recebida <= s_dados_registrado(7);
    saida_serial <= s_dados(0);

END ARCHITECTURE;