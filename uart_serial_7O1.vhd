LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uart_serial_7O1 IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        partida : IN STD_LOGIC;
        dados_ascii : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        dado_serial : IN STD_LOGIC;
        saida_serial : OUT STD_LOGIC;
        pronto_tx : OUT STD_LOGIC;
        dado_recebido0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        dado_recebido1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        paridade_recebida : OUT STD_LOGIC;
        pronto_rx : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE uart_serial_7O1_arch OF uart_serial_7O1 IS

    COMPONENT uart_serial_uc
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            partida : IN STD_LOGIC;
            dado_serial : IN STD_LOGIC;
            tick_rx : IN STD_LOGIC;
            tick_tx : IN STD_LOGIC;
            fim : IN STD_LOGIC;
            zera : OUT STD_LOGIC;
            conta : OUT STD_LOGIC;
            carrega : OUT STD_LOGIC;
            desloca : OUT STD_LOGIC;
            limpa : OUT STD_LOGIC;
            registra : OUT STD_LOGIC;
            pronto : OUT STD_LOGIC;
            db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT uart_serial_7O1_fd
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

    COMPONENT hexa7seg
        PORT (
            hexa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT edge_detector
        PORT (
            clock : IN STD_LOGIC;
            signal_in : IN STD_LOGIC;
            output : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL s_reset, s_pronto : STD_LOGIC;
    SIGNAL s_zera, s_conta, s_carrega, s_desloca, s_tick_rx, s_tick_tx, s_fim, s_limpa, s_registra, s_partida_ed, s_partida : STD_LOGIC;
    SIGNAL s_dado_recebido : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL s_estado : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    -- sinais reset e partida mapeados na GPIO (ativos em alto)
    s_reset <= reset;
    s_partida <= partida;

    -- unidade de controle
    U1_UC : uart_serial_uc
    PORT MAP(
        clock => clock,
        reset => s_reset,
        partida => s_partida_ed,
        dado_serial => dado_serial,
        tick_rx => s_tick_rx,
        tick_tx => s_tick_tx,
        fim => s_fim,
        zera => s_zera,
        conta => s_conta,
        carrega => s_carrega,
        desloca => s_desloca,
        limpa => s_limpa,
        registra => s_registra,
        pronto => s_pronto,
        db_estado => s_estado
    );

    -- fluxo de dados
    U2_FD : uart_serial_7O1_fd
    PORT MAP(
        clock => clock,
        reset => s_reset,
        zera => s_zera,
        conta => s_conta,
        carrega => s_carrega,
        desloca => s_desloca,
        limpa => s_limpa,
        registra => s_registra,
        dado_serial => dado_serial,
        dados_ascii => dados_ascii,
        saida_serial => saida_serial,
        dado_recebido => s_dado_recebido,
        paridade_recebida => paridade_recebida,
        fim => s_fim
    );
    -- gerador de tick
    -- fator de divisao para 9600 bauds (5208=50M/9600)
    -- fator de divisao para 115.200 bauds (434=50M/115200)
    U3_TICK : contador_m
    GENERIC MAP(
        M => 434, -- 115200 bauds
        N => 13
    )
    PORT MAP(
        clock => clock,
        zera => s_zera,
        conta => '1',
        Q => OPEN,
        fim => s_tick_tx,
        meio => s_tick_rx
    );

    -- detetor de borda para tratar pulsos largos
    U4_ED : edge_detector
    PORT MAP(
        clock => clock,
        signal_in => s_partida,
        output => s_partida_ed
    );

    -- saida
    db_estado <= s_estado;
    dado_recebido0 <= s_dado_recebido(3 DOWNTO 0);
    dado_recebido1 <= '0' & s_dado_recebido(6 DOWNTO 4);
    pronto_rx <= s_pronto;
    pronto_tx <= s_pronto;
    -- HEX0: hexa7seg
    --       port map (
    --           hexa => s_estado,
    --           sseg => db_estado
    --       );

    -- HEX1: hexa7seg
    --       port map (
    --           hexa => s_dado_recebido(3 downto 0),
    --           sseg => dado_recebido0
    --       );

    -- HEX2: hexa7seg
    --       port map (
    --           hexa => '0' & s_dado_recebido(6 downto 4),
    --           sseg => dado_recebido1
    --       );

END ARCHITECTURE;