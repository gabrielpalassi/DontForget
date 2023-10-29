LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY sonar_fd IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        echo : IN STD_LOGIC;
        medir : IN STD_LOGIC;
        transmitir : IN STD_LOGIC;
        conta_2seg : IN STD_LOGIC;
        zera_2seg : IN STD_LOGIC;
        conta_servo : IN STD_LOGIC;
        zera_servo : IN STD_LOGIC;
        conta_mux : IN STD_LOGIC;
        zera_mux : IN STD_LOGIC;
        medida_pronto : OUT STD_LOGIC;
        fim_transmissao : OUT STD_LOGIC;
        ultima_transmissao : OUT STD_LOGIC;
        fim_2seg : OUT STD_LOGIC;
        trigger : OUT STD_LOGIC;
        saida_serial : OUT STD_LOGIC;
        pwm : OUT STD_LOGIC;
        medida : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE comportamental OF sonar_fd IS

    COMPONENT interface_hcsr04 IS
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
    END COMPONENT;

    COMPONENT uart_serial_7O1 IS
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
    END COMPONENT;

    COMPONENT controle_servo IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            posicao : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            pwm : OUT STD_LOGIC;
            db_reset : OUT STD_LOGIC;
            db_pwm : OUT STD_LOGIC;
            db_posicao : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT contadorg_updown_m IS
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
    END COMPONENT;

    COMPONENT mux_8x1_n IS
        GENERIC (
            CONSTANT BITS : INTEGER := 4
        );
        PORT (
            D0 : IN STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);
            D1 : IN STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);
            D2 : IN STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);
            D3 : IN STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);
            D4 : IN STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);
            D5 : IN STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);
            D6 : IN STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);
            D7 : IN STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0);
            SEL : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            MUX_OUT : OUT STD_LOGIC_VECTOR (BITS - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT rom_angulos_8x24 IS
        PORT (
            endereco : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            saida : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
        );
    END COMPONENT;

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

    SIGNAL s_dados_ascii : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL s_medida : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL s_D2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL s_D1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL s_D0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL s_posicao_servo, s_sel : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL s_angulo : STD_LOGIC_VECTOR(23 DOWNTO 0);
    SIGNAL s_reset_uart : STD_LOGIC;
    SIGNAL s_reset_med : STD_LOGIC;

BEGIN

    s_reset_uart <= medir OR reset;
    s_reset_med <= conta_servo OR reset;

    MED : interface_hcsr04
    PORT MAP(
        clock => clock,
        reset => s_reset_med,
        medir => medir,
        echo => echo,
        trigger => trigger,
        medida => s_medida,
        pronto => medida_pronto,
        db_estado => OPEN
    );

    UART : uart_serial_7O1
    PORT MAP(
        clock => clock,
        reset => s_reset_uart,
        partida => transmitir,
        dados_ascii => s_dados_ascii,
        dado_serial => '1',
        saida_serial => saida_serial,
        pronto_tx => fim_transmissao,
        dado_recebido0 => OPEN,
        dado_recebido1 => OPEN,
        paridade_recebida => OPEN,
        pronto_rx => OPEN,
        db_estado => OPEN
    );

    SERVO : controle_servo
    PORT MAP(
        clock => clock,
        reset => reset,
        posicao => s_posicao_servo,
        pwm => pwm,
        db_reset => OPEN,
        db_pwm => OPEN,
        db_posicao => OPEN
    );

    UPDW : contadorg_updown_m
    GENERIC MAP(M => 8)
    PORT MAP(
        clock => clock,
        zera_as => '0',
        zera_s => zera_servo,
        conta => conta_servo,
        Q => s_posicao_servo,
        inicio => OPEN,
        fim => OPEN,
        meio => OPEN
    );

    s_D2 <= "011" & s_medida(3 DOWNTO 0);
    s_D1 <= "011" & s_medida(7 DOWNTO 4);
    s_D0 <= "011" & s_medida(11 DOWNTO 8);

    MEM : rom_angulos_8x24
    PORT MAP(
        endereco => s_posicao_servo,
        saida => s_angulo
    );

    MUX : mux_8x1_n
    GENERIC MAP(BITS => 7)
    PORT MAP(
        D7 => "0100011",
        D6 => s_D2,
        D5 => s_D1,
        D4 => s_D0,
        D3 => "0101100",
        D2 => s_angulo(6 DOWNTO 0),
        D1 => s_angulo(14 DOWNTO 8),
        D0 => s_angulo(22 DOWNTO 16),
        SEL => s_sel,
        MUX_OUT => s_dados_ascii
    );

    CMUX : contador_m
    GENERIC MAP(M => 8, N => 3)
    PORT MAP(
        clock => clock,
        zera => zera_mux,
        conta => conta_mux,
        Q => s_sel,
        fim => ultima_transmissao,
        meio => OPEN
    );

    SEG2 : contador_m
    GENERIC MAP(M => 100000000, N => 27)
    PORT MAP(
        clock => clock,
        zera => zera_2seg,
        conta => conta_2seg,
        Q => OPEN,
        fim => fim_2seg,
        meio => OPEN
    );

    medida <= s_medida;
END ARCHITECTURE;