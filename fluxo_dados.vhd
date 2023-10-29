LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY fluxo_dados IS
    PORT (
        clock : IN STD_LOGIC;
        zeraCR : IN STD_LOGIC;
        contaCR : IN STD_LOGIC;
        zeraE : IN STD_LOGIC;
        contaE : IN STD_LOGIC;
        zeraT : IN STD_LOGIC;
        contaT : IN STD_LOGIC;
        zeraLED : IN STD_LOGIC;
        contaLED : IN STD_LOGIC;
        zeraEntre : IN STD_LOGIC;
        contaEntre2 : IN STD_LOGIC;
        zeraEntre2 : IN STD_LOGIC;
        contaEntre : IN STD_LOGIC;
        escreve : IN STD_LOGIC;
        limpaRC : IN STD_LOGIC;
        registraRC : IN STD_LOGIC;
        led_mux : IN STD_LOGIC;
        chaves : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        modoJogo : IN STD_LOGIC;
        resetG : IN STD_LOGIC;
        dificuldade : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        mudaJogador : IN STD_LOGIC;
        resetVidas : IN STD_LOGIC;
        contaVidas : IN STD_LOGIC;
        errou : IN STD_LOGIC;

        zeroVidas1 : OUT STD_LOGIC;
        zeroVidas2 : OUT STD_LOGIC;
        fimL : OUT STD_LOGIC;
        fimE : OUT STD_LOGIC;
        fimT : OUT STD_LOGIC;
        fimLED : OUT STD_LOGIC;
        fimEntre : OUT STD_LOGIC;
        fimEntre2 : OUT STD_LOGIC;
        enderecoIgualRodada : OUT STD_LOGIC;
        jogada_correta : OUT STD_LOGIC;
        jogada_feita : OUT STD_LOGIC;
        jogador_out : OUT STD_LOGIC;
        buzzer : OUT STD_LOGIC;
        rodada : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        leds : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        vidas1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vidas2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE estrutural OF fluxo_dados IS

    SIGNAL s_endereco : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_dado : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_jogada : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_rodada : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_rodada_1_3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_rodada_2 : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_escrita : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_not_zeraCR : STD_LOGIC;
    SIGNAL s_not_zeraE : STD_LOGIC;
    SIGNAL s_not_escreve : STD_LOGIC;
    SIGNAL s_chaveAcionada : STD_LOGIC;
    SIGNAL s_gerador : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL jogador : STD_LOGIC := '1';
    SIGNAL s_not_jogador : STD_LOGIC;
    SIGNAL totalVidas : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL fim1 : STD_LOGIC;
    SIGNAL fim2 : STD_LOGIC;
    SIGNAL fim3 : STD_LOGIC;
    SIGNAL s_som_azul, s_som_vermelho, s_som_verde, s_som_amarelo : STD_LOGIC;
    SIGNAL s_zera_buzzer : STD_LOGIC;
    SIGNAL s_leds : STD_LOGIC_VECTOR (3 DOWNTO 0);

    COMPONENT contador_163
        PORT (
            clock : IN STD_LOGIC;
            clr : IN STD_LOGIC;
            ld : IN STD_LOGIC;
            enp : IN STD_LOGIC;
            ent : IN STD_LOGIC;
            D : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            rco : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT comparador_85
        PORT (
            i_A3 : IN STD_LOGIC;
            i_B3 : IN STD_LOGIC;
            i_A2 : IN STD_LOGIC;
            i_B2 : IN STD_LOGIC;
            i_A1 : IN STD_LOGIC;
            i_B1 : IN STD_LOGIC;
            i_A0 : IN STD_LOGIC;
            i_B0 : IN STD_LOGIC;
            i_AGTB : IN STD_LOGIC;
            i_ALTB : IN STD_LOGIC;
            i_AEQB : IN STD_LOGIC;
            o_AGTB : OUT STD_LOGIC;
            o_ALTB : OUT STD_LOGIC;
            o_AEQB : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT ram_16x4 IS
        PORT (
            clk : IN STD_LOGIC;
            endereco : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            dado_entrada : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            we : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            dado_saida : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
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

    COMPONENT edge_detector IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            sinal : IN STD_LOGIC;
            pulso : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT contador_m IS
        GENERIC (
            CONSTANT M : INTEGER := 100
        );
        PORT (
            clock : IN STD_LOGIC;
            zera_as : IN STD_LOGIC;
            zera_s : IN STD_LOGIC;
            conta : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
            fim : OUT STD_LOGIC;
            meio : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT gerador_aleatorio IS
        PORT (
            clock : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT contador_dec IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            conta : IN STD_LOGIC;
            D : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            fim : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT contador_buzzer IS
        GENERIC (
            CONSTANT M : INTEGER := 100 -- 50MHz / f 
        );
        PORT (
            clock : IN STD_LOGIC;
            zera_as : IN STD_LOGIC;
            zera_s : IN STD_LOGIC;
            conta : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
            fim : OUT STD_LOGIC;
            meio : OUT STD_LOGIC
        );
    END COMPONENT;
BEGIN

    -- sinais de controle ativos em alto
    -- sinais dos componentes ativos em baixo
    s_not_zeraE <= NOT zeraE;
    s_not_escreve <= NOT escreve;
    s_not_jogador <= NOT jogador;

    Gerador : gerador_aleatorio
    PORT MAP(
        clock => clock,
        rst => resetG,
        Q => s_gerador
    );

    ContRod1e3 : contador_m
    GENERIC MAP(M => 16)
    PORT MAP(
        clock => clock,
        zera_as => zeraCR,
        zera_s => '0',
        conta => contaCR,
        Q => s_rodada_1_3,
        fim => fim3,
        meio => fim1
    );

    ContRod2 : contador_m
    GENERIC MAP(M => 12)
    PORT MAP(
        clock => clock,
        zera_as => zeraCR,
        zera_s => '0',
        conta => contaCR,
        Q => s_rodada_2,
        fim => fim2,
        meio => OPEN
    );

    s_rodada <= s_rodada_1_3 WHEN ((dificuldade = "01" OR dificuldade = "10") AND modoJogo = '0') OR modoJogo = '1' ELSE
        s_rodada_2 WHEN (dificuldade = "00" AND modoJogo = '0') ELSE
        "0000";

    fimL <= fim1 WHEN (dificuldade = "01" AND modoJogo = '0') ELSE
        fim2 WHEN (dificuldade = "00" AND modoJogo = '0') ELSE
        fim3 WHEN (dificuldade = "10" AND modoJogo = '0') OR modoJogo = '1' ELSE
        '1';

    ContEnd : contador_163
    PORT MAP(
        clock => clock,
        clr => s_not_zeraE, -- clr ativo em baixo
        ld => '1',
        enp => contaE,
        ent => '1',
        D => "0000",
        Q => s_endereco,
        rco => fimE
    );

    Timer : contador_m
    GENERIC MAP(M => 250000000)
    PORT MAP(
        clock => clock,
        zera_as => '0',
        zera_s => zeraT,
        conta => contaT,
        Q => OPEN,
        fim => fimT,
        meio => OPEN
    );

    TimerLED : contador_m
    GENERIC MAP(M => 25000000)
    PORT MAP(
        clock => clock,
        zera_as => '0',
        zera_s => zeraLED,
        conta => contaLED,
        Q => OPEN,
        fim => fimLED,
        meio => OPEN
    );

    TimerEntre : contador_m
    GENERIC MAP(M => 12500000)
    PORT MAP(
        clock => clock,
        zera_as => '0',
        zera_s => zeraEntre,
        conta => contaEntre,
        Q => OPEN,
        fim => fimEntre,
        meio => OPEN
    );

    TimerEntre2 : contador_m
    GENERIC MAP(M => 25000000)
    PORT MAP(
        clock => clock,
        zera_as => '0',
        zera_s => zeraEntre2,
        conta => contaEntre2,
        Q => OPEN,
        fim => fimEntre2,
        meio => OPEN
    );

    CompEnd : comparador_85
    PORT MAP(
        i_A3 => s_rodada(3),
        i_B3 => s_endereco(3),
        i_A2 => s_rodada(2),
        i_B2 => s_endereco(2),
        i_A1 => s_rodada(1),
        i_B1 => s_endereco(1),
        i_A0 => s_rodada(0),
        i_B0 => s_endereco(0),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => OPEN, -- saidas nao usadas
        o_ALTB => OPEN,
        o_AEQB => enderecoIgualRodada
    );

    CompJog : comparador_85
    PORT MAP(
        i_A3 => s_dado(3),
        i_B3 => s_jogada(3),
        i_A2 => s_dado(2),
        i_B2 => s_jogada(2),
        i_A1 => s_dado(1),
        i_B1 => s_jogada(1),
        i_A0 => s_dado(0),
        i_B0 => s_jogada(0),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => OPEN, -- saidas nao usadas
        o_ALTB => OPEN,
        o_AEQB => jogada_correta
    );

    MemJog : ENTITY work.ram_16x4 (ram_mif) -- usar esta linha para Intel Quartus
        PORT MAP(
            clk => clock,
            endereco => s_endereco,
            dado_entrada => s_escrita,
            we => s_not_escreve,
            ce => '0',
            dado_saida => s_dado
        );

    RegChv : registrador_n
    GENERIC MAP(N => 4)
    PORT MAP(
        clock => clock,
        clear => zeraCR,
        enable => registraRC,
        D => chaves,
        Q => s_jogada
    );

    detector : edge_detector
    PORT MAP(
        clock => clock,
        reset => zeraCR,
        sinal => s_chaveAcionada,
        pulso => jogada_feita
    );

    cont_vidas1 : contador_dec
    PORT MAP(
        clock => clock,
        reset => resetVidas,
        enable => s_not_jogador,
        conta => contaVidas,
        D => totalVidas,
        Q => vidas1,
        fim => zeroVidas1
    );

    cont_vidas2 : contador_dec
    PORT MAP(
        clock => clock,
        reset => resetVidas,
        enable => jogador,
        conta => contaVidas,
        D => totalVidas,
        Q => vidas2,
        fim => zeroVidas2
    );

    buzzer_azul : contador_buzzer
    GENERIC MAP(M => 240788) -- 50MHz / 207,652Hz
    PORT MAP(
        clock => clock,
        zera_as => '0',
        zera_s => s_zera_buzzer,
        conta => s_leds(3),
        Q => OPEN,
        fim => OPEN,
        meio => s_som_azul
    );

    buzzer_vermelho : contador_buzzer
    GENERIC MAP(M => 160707) -- 50MHz / 311,127Hz
    PORT MAP(
        clock => clock,
        zera_as => '0',
        zera_s => s_zera_buzzer,
        conta => s_leds(2),
        Q => OPEN,
        fim => OPEN,
        meio => s_som_vermelho
    );

    buzzer_verde : contador_buzzer
    GENERIC MAP(M => 120394) -- 50MHz / 415,305Hz
    PORT MAP(
        clock => clock,
        zera_as => '0',
        zera_s => s_zera_buzzer,
        conta => s_leds(1),
        Q => OPEN,
        fim => OPEN,
        meio => s_som_verde
    );

    buzzer_amarelo : contador_buzzer
    GENERIC MAP(M => 201652) -- 50MHz / 247,942Hz
    PORT MAP(
        clock => clock,
        zera_as => '0',
        zera_s => s_zera_buzzer,
        conta => s_leds(0),
        Q => OPEN,
        fim => OPEN,
        meio => s_som_amarelo
    );

    PROCESS (clock)
    BEGIN
        IF rising_edge(clock) THEN
            IF jogador = '0' THEN
                IF mudaJogador = '1' THEN
                    jogador <= '1';
                ELSIF mudaJogador = '0' THEN
                    jogador <= '0';
                END IF;
            ELSIF jogador = '1' THEN
                IF mudaJogador = '1' THEN
                    jogador <= '0';
                ELSIF mudaJogador = '0' THEN
                    jogador <= '1';
                END IF;
            END IF;
        END IF;
    END PROCESS;
    totalVidas <= "100" WHEN (dificuldade = "01") ELSE
        "010" WHEN (dificuldade = "00") ELSE
        "001" WHEN (dificuldade = "10") ELSE
        "000";

    s_chaveAcionada <= chaves(0) OR chaves(1) OR chaves(2) OR chaves(3);

    s_leds <= s_dado WHEN (led_mux = '0') ELSE
        chaves;

    s_zera_buzzer <= NOT(s_leds(3) OR s_leds(2) OR s_leds(1) OR s_leds(0)) OR errou;

    buzzer <= s_som_azul OR s_som_vermelho OR s_som_verde OR s_som_amarelo;

    s_escrita <= s_jogada WHEN (modoJogo = '1') ELSE
        s_gerador;

    leds <= s_leds;

    jogador_out <= jogador;

    rodada <= s_rodada;

END ARCHITECTURE estrutural;