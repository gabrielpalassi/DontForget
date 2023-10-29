LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY sonar IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        ligar : IN STD_LOGIC;
        echo : IN STD_LOGIC;
        trigger : OUT STD_LOGIC;
        pwm : OUT STD_LOGIC;
        saida_serial : OUT STD_LOGIC;
        fim_posicao : OUT STD_LOGIC;
        db_medida0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- digitos da medida
        db_medida1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        db_medida2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        db_saida_serial : OUT STD_LOGIC;
        db_trigger : OUT STD_LOGIC;
        db_echo : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- estado da UC
    );
END ENTITY;

ARCHITECTURE comportamental OF sonar IS

    COMPONENT sonar_uc IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            ligar : IN STD_LOGIC;
            medida_pronto : IN STD_LOGIC;
            fim_transmissao : IN STD_LOGIC;
            ultima_transmissao : IN STD_LOGIC;
            fim_2seg : IN STD_LOGIC;
            conta_2seg : OUT STD_LOGIC;
            zera_2seg : OUT STD_LOGIC;
            conta_servo : OUT STD_LOGIC;
            zera_servo : OUT STD_LOGIC;
            medir : OUT STD_LOGIC;
            transmitir : OUT STD_LOGIC;
            conta_mux : OUT STD_LOGIC;
            zera_mux : OUT STD_LOGIC;
            pronto : OUT STD_LOGIC;
            db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- estado da UC
        );
    END COMPONENT;

    COMPONENT sonar_fd IS
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
    END COMPONENT;

    COMPONENT hexa7seg IS
        PORT (
            hexa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT edge_detector IS
        PORT (
            clock : IN STD_LOGIC;
            signal_in : IN STD_LOGIC;
            output : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL s_medir, s_trigger, s_medida_pronto, s_fim_transmissao, s_transmitir, s_saida_serial, s_ultima_transmissao : STD_LOGIC;
    SIGNAL s_fim_2seg, s_conta_2seg, s_zera_2seg, s_conta_servo, s_zera_servo, s_conta_mux, s_zera_mux : STD_LOGIC;
    SIGNAL s_estado : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_medida : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL s_reset : STD_LOGIC;

BEGIN

    s_reset <= reset OR NOT ligar;

    UC : sonar_uc
    PORT MAP(
        clock => clock,
        reset => s_reset,
        ligar => ligar,
        medida_pronto => s_medida_pronto,
        fim_transmissao => s_fim_transmissao,
        ultima_transmissao => s_ultima_transmissao,
        fim_2seg => s_fim_2seg,
        conta_2seg => s_conta_2seg,
        zera_2seg => s_zera_2seg,
        conta_servo => s_conta_servo,
        zera_servo => s_zera_servo,
        medir => s_medir,
        transmitir => s_transmitir,
        conta_mux => s_conta_mux,
        zera_mux => s_zera_mux,
        pronto => fim_posicao,
        db_estado => s_estado
    );

    FD : sonar_fd
    PORT MAP(
        clock => clock,
        reset => s_reset,
        echo => echo,
        medir => s_medir,
        transmitir => s_transmitir,
        conta_2seg => s_conta_2seg,
        zera_2seg => s_zera_2seg,
        conta_servo => s_conta_servo,
        zera_servo => s_zera_servo,
        conta_mux => s_conta_mux,
        zera_mux => s_zera_mux,
        medida_pronto => s_medida_pronto,
        fim_transmissao => s_fim_transmissao,
        ultima_transmissao => s_ultima_transmissao,
        fim_2seg => s_fim_2seg,
        trigger => s_trigger,
        saida_serial => s_saida_serial,
        pwm => pwm,
        medida => s_medida
    );

    HEX0 : hexa7seg
    PORT MAP(
        hexa => s_medida(3 DOWNTO 0),
        sseg => db_medida0
    );

    HEX1 : hexa7seg
    PORT MAP(
        hexa => s_medida(7 DOWNTO 4),
        sseg => db_medida1
    );

    HEX2 : hexa7seg
    PORT MAP(
        hexa => s_medida(11 DOWNTO 8),
        sseg => db_medida2
    );

    -- Saídas
    trigger <= s_trigger;
    saida_serial <= s_saida_serial;

    -- Sinais de depuração
    HEX3 : hexa7seg
    PORT MAP(
        hexa => s_estado,
        sseg => db_estado
    );

    db_saida_serial <= s_saida_serial;
    db_trigger <= s_trigger;
    db_echo <= echo;

END ARCHITECTURE;