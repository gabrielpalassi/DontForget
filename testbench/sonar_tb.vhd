LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sonar_tb IS
END ENTITY;

ARCHITECTURE tb OF sonar_tb IS

    -- componente a ser testado (Device Under Test - DUT)
    COMPONENT sonar
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            ligar : IN STD_LOGIC;
            echo : IN STD_LOGIC;
            trigger : OUT STD_LOGIC;
            pwm : OUT STD_LOGIC;
            saida_serial : OUT STD_LOGIC;
            fim_posicao : OUT STD_LOGIC;
            db_estado : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    -- declaração de sinais para conectar o componente a ser testado (DUT)
    -- valores iniciais para fins de simulacao (GHDL ou ModelSim)
    SIGNAL clock_in : STD_LOGIC := '0';
    SIGNAL reset_in : STD_LOGIC := '0';
    SIGNAL ligar_in : STD_LOGIC := '0';
    SIGNAL echo_in : STD_LOGIC := '0';
    SIGNAL trigger_out : STD_LOGIC := '0';
    SIGNAL pwm_out : STD_LOGIC := '0';
    SIGNAL saida_serial_out : STD_LOGIC := '1';
    SIGNAL fim_posicao_out : STD_LOGIC := '0';
    SIGNAL db_estado_out : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0000000";
    -- configurações do clock
    CONSTANT clockPeriod : TIME := 20 ns; -- clock de 50MHz
    SIGNAL keep_simulating : STD_LOGIC := '0'; -- delimita o tempo de geração do clock

    -- array de posicoes de teste
    TYPE posicoes_teste_type IS RECORD
        id : NATURAL;
        tempo : INTEGER;
    END RECORD;

    -- fornecida tabela com 2 posicoes (comentadas 6 posicoes)
    TYPE posicoes_teste_array IS ARRAY (NATURAL RANGE <>) OF posicoes_teste_type;
    CONSTANT posicoes_teste : posicoes_teste_array :=
    (
    (1, 294), --   5cm ( 294us)
    (2, 353) --   6cm ( 353us)
    -- ( 2,  353),  --   6cm ( 353us)
    -- ( 3, 5882),  -- 100cm (5882us)
    -- ( 4, 5882),  -- 100cm (5882us)
    -- ( 5,  882),  --  15cm ( 882us)
    -- ( 6,  882),  --  15cm ( 882us)
    -- ( 7, 5882),  -- 100cm (5882us)
    -- ( 8,  588)   --  10cm ( 588us)
    -- inserir aqui outros posicoes de teste (inserir "," na linha anterior)
    );

    SIGNAL larguraPulso : TIME := 1 ns;

BEGIN
    -- gerador de clock: executa enquanto 'keep_simulating = 1', com o período
    -- especificado. Quando keep_simulating=0, clock é interrompido, bem como a 
    -- simulação de eventos
    clock_in <= (NOT clock_in) AND keep_simulating AFTER clockPeriod/2;

    -- conecta DUT (Device Under Test)
    dut : sonar
    PORT MAP(
        clock => clock_in,
        reset => reset_in,
        ligar => ligar_in,
        echo => echo_in,
        trigger => trigger_out,
        pwm => pwm_out,
        saida_serial => saida_serial_out,
        fim_posicao => fim_posicao_out,
        db_estado => db_estado_out
    );

    -- geracao dos sinais de entrada (estimulos)
    stimulus : PROCESS IS
    BEGIN

        ASSERT false REPORT "Inicio das simulacoes" SEVERITY note;
        keep_simulating <= '1';

        ---- valores iniciais
        ligar_in <= '0';
        echo_in <= '0';

        ---- inicio: reset
        reset_in <= '1';
        WAIT FOR 2 us;
        reset_in <= '0';
        WAIT UNTIL falling_edge(clock_in);

        ---- ligar sonar
        WAIT FOR 20 us;
        ligar_in <= '1';

        ---- espera de 20us
        WAIT FOR 20 us;

        ---- loop pelas posicoes de teste
        FOR i IN posicoes_teste'RANGE LOOP
            -- 1) determina largura do pulso echo para a posicao i
            ASSERT false REPORT "Posicao " & INTEGER'image(posicoes_teste(i).id) & ": " &
            INTEGER'image(posicoes_teste(i).tempo) & "us" SEVERITY note;
            larguraPulso <= posicoes_teste(i).tempo * 1 us; -- posicao de teste "i"

            -- 2) espera pelo pulso trigger
            WAIT UNTIL falling_edge(trigger_out);

            -- 3) espera por 400us (simula tempo entre trigger e echo)
            WAIT FOR 400 us;

            -- 4) gera pulso de echo (largura = larguraPulso)
            echo_in <= '1';
            WAIT FOR larguraPulso;
            echo_in <= '0';

            -- 5) espera sinal fim (indica final da medida de uma posicao do sonar)
            WAIT UNTIL fim_posicao_out = '1';
        END LOOP;

        WAIT FOR 400 us;

        ---- final dos casos de teste da simulacao
        ASSERT false REPORT "Fim das simulacoes" SEVERITY note;
        keep_simulating <= '0';

        WAIT; -- fim da simulação: aguarda indefinidamente (não retirar esta linha)
    END PROCESS;

END ARCHITECTURE;