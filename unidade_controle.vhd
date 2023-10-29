LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY unidade_controle IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        iniciar : IN STD_LOGIC;
        fimE : IN STD_LOGIC;
        fimT : IN STD_LOGIC;
        fimL : IN STD_LOGIC;
        fimLED : IN STD_LOGIC;
        fimEntre : IN STD_LOGIC;
        fimEntre2 : IN STD_LOGIC;
        jogada_feita : IN STD_LOGIC;
        jogada_correta : IN STD_LOGIC;
        enderecoIgualRodada : IN STD_LOGIC;
        modoJogo : IN STD_LOGIC;
        zeroVidas1 : IN STD_LOGIC;
        zeroVidas2 : IN STD_LOGIC;

        mudaJogador : OUT STD_LOGIC;
        contaVidas : OUT STD_LOGIC;
        resetVidas : OUT STD_LOGIC;
        zeraCR : OUT STD_LOGIC;
        zeraE : OUT STD_LOGIC;
        zeraT : OUT STD_LOGIC;
        zeraLED : OUT STD_LOGIC;
        zeraEntre : OUT STD_LOGIC;
        zeraEntre2 : OUT STD_LOGIC;
        resetG : OUT STD_LOGIC;
        contaCR : OUT STD_LOGIC;
        contaE : OUT STD_LOGIC;
        contaT : OUT STD_LOGIC;
        contaLED : OUT STD_LOGIC;
        contaEntre : OUT STD_LOGIC;
        contaEntre2 : OUT STD_LOGIC;
        limpaRC : OUT STD_LOGIC;
        registraRC : OUT STD_LOGIC;
        acertou : OUT STD_LOGIC;
        errou : OUT STD_LOGIC;
        pronto : OUT STD_LOGIC;
        led_mux : OUT STD_LOGIC;
        escreve_ram : OUT STD_LOGIC;
        apagahex : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE fsm OF unidade_controle IS
    TYPE t_estado IS (inicial, preparacao, inicioRodada, espera, esperaEscrita, registraEscrita, escreve, registra, comparacao, proximo,
        fimRodada, proxRodada, certo, errado, timeout, ledInicial, inicioRodadaM0, mostraJogadaM0, contaLedM0, fimLedM0, esperaM0, registraM0,
        comparacaoM0, proximoM0, fimRodadaM0, proxRodadaM0, erradoM0, zeraContLedM0, escreveM0, fimErrado, comparaVidas, aguardaBotao, aguardaBotaoM0,
        aguardaBotaoE);
    SIGNAL Eatual, Eprox : t_estado;
    SIGNAL s_jogador : STD_LOGIC;

BEGIN

    -- memoria de estado
    PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            Eatual <= inicial;
        ELSIF clock'event AND clock = '1' THEN
            Eatual <= Eprox;
        END IF;
    END PROCESS;

    -- logica de proximo estado
    Eprox <=
        inicial WHEN Eatual = inicial AND iniciar = '0' ELSE
        preparacao WHEN Eatual = inicial AND iniciar = '1' ELSE
        escreveM0 WHEN Eatual = preparacao AND modoJogo = '0' ELSE
        ledInicial WHEN Eatual = preparacao AND modoJogo = '1' ELSE
        ledInicial WHEN Eatual = ledInicial AND fimLED = '0' ELSE
        inicioRodada WHEN Eatual = ledInicial AND fimLED = '1' ELSE
        inicioRodadaM0 WHEN Eatual = inicioRodadaM0 AND fimEntre2 = '0' ELSE
        mostraJogadaM0 WHEN Eatual = inicioRodadaM0 AND fimEntre2 = '1' ELSE
        mostraJogadaM0 WHEN Eatual = mostraJogadaM0 AND fimLED = '0' ELSE
        contaLedM0 WHEN Eatual = mostraJogadaM0 AND fimLED = '1' AND enderecoIgualRodada = '0' ELSE
        fimLedM0 WHEN Eatual = contaLedM0 ELSE
        fimLedM0 WHEN Eatual = fimLedM0 AND fimEntre = '0' ELSE
        mostraJogadaM0 WHEN Eatual = fimLedM0 AND fimEntre = '1' ELSE
        zeraContLedM0 WHEN Eatual = mostraJogadaM0 AND fimLED = '1' AND enderecoIgualRodada = '1' ELSE
        esperaM0 WHEN Eatual = zeraContLedM0 ELSE
        esperaM0 WHEN Eatual = esperaM0 AND jogada_feita = '0' AND fimT = '0' ELSE
        registraM0 WHEN Eatual = esperaM0 AND jogada_feita = '1' AND fimT = '0' ELSE
        aguardaBotaoM0 WHEN Eatual = registraM0 ELSE
        aguardaBotaoM0 WHEN Eatual = aguardaBotaoM0 AND fimEntre = '0' ELSE
        comparacaoM0 WHEN Eatual = aguardaBotaoM0 AND fimEntre = '1' ELSE
        timeout WHEN Eatual = esperaM0 AND fimT = '1' ELSE
        espera WHEN Eatual = inicioRodada ELSE
        espera WHEN Eatual = espera AND jogada_feita = '0' AND fimT = '0' ELSE
        registra WHEN Eatual = espera AND jogada_feita = '1' AND fimT = '0' ELSE
        aguardaBotao WHEN Eatual = registra ELSE
        aguardaBotao WHEN Eatual = aguardaBotao AND fimEntre = '0' ELSE
        comparacao WHEN Eatual = aguardaBotao AND fimEntre = '1' ELSE
        timeout WHEN Eatual = espera AND fimT = '1' ELSE
        proximoM0 WHEN Eatual = comparacaoM0 AND jogada_correta = '1' AND enderecoIgualRodada = '0' ELSE
        fimRodadaM0 WHEN Eatual = comparacaoM0 AND jogada_correta = '1' AND enderecoIgualRodada = '1' ELSE
        erradoM0 WHEN Eatual = comparacaoM0 AND jogada_correta = '0' ELSE
        proximo WHEN Eatual = comparacao AND jogada_correta = '1' AND enderecoIgualRodada = '0' ELSE
        fimRodada WHEN Eatual = comparacao AND jogada_correta = '1' AND enderecoIgualRodada = '1' ELSE
        errado WHEN Eatual = comparacao AND jogada_correta = '0' ELSE
        comparaVidas WHEN Eatual = errado ELSE
        proximo WHEN Eatual = comparaVidas AND enderecoIgualRodada = '0' AND zeroVidas1 = '0' AND zeroVidas2 = '0' ELSE
        fimRodada WHEN Eatual = comparaVidas AND enderecoIgualRodada = '1' AND zeroVidas1 = '0' AND zeroVidas2 = '0' ELSE
        fimErrado WHEN Eatual = comparaVidas AND (zeroVidas1 = '1' OR zeroVidas2 = '1') ELSE
        fimErrado WHEN Eatual = fimErrado AND iniciar = '0' ELSE
        preparacao WHEN Eatual = fimErrado AND iniciar = '1' ELSE
        esperaM0 WHEN Eatual = proximoM0 ELSE
        espera WHEN Eatual = proximo ELSE
        esperaEscrita WHEN Eatual = fimRodada AND fimL = '0' ELSE
        esperaEscrita WHEN Eatual = esperaEscrita AND jogada_feita = '0' AND fimT = '0' ELSE
        registraEscrita WHEN Eatual = esperaEscrita AND jogada_feita = '1' AND fimT = '0' ELSE
        aguardaBotaoE WHEN Eatual = registraEscrita ELSE
        aguardaBotaoE WHEN Eatual = aguardaBotaoE AND fimEntre = '0' ELSE
        escreve WHEN Eatual = aguardaBotaoE AND fimEntre = '1' ELSE
        timeout WHEN Eatual = esperaEscrita AND fimT = '1' ELSE
        proxRodadaM0 WHEN Eatual = fimRodadaM0 AND fimL = '0' ELSE
        escreveM0 WHEN Eatual = proxRodadaM0 ELSE
        inicioRodadaM0 WHEN Eatual = escreveM0 ELSE
        certo WHEN Eatual = fimRodadaM0 AND fimL = '1' ELSE
        proxRodada WHEN Eatual = escreve ELSE
        inicioRodada WHEN Eatual = proxRodada ELSE
        certo WHEN Eatual = fimRodada AND fimL = '1' ELSE
        certo WHEN Eatual = certo AND iniciar = '0' ELSE
        preparacao WHEN Eatual = certo AND iniciar = '1' ELSE
        erradoM0 WHEN Eatual = erradoM0 AND iniciar = '0' ELSE
        preparacao WHEN Eatual = erradoM0 AND iniciar = '1' ELSE
        timeout WHEN Eatual = timeout AND iniciar = '0' ELSE
        preparacao WHEN Eatual = timeout AND iniciar = '1' ELSE
        inicial;

    -- logica de saída (maquina de Moore)
    WITH Eatual SELECT
        zeraCR <= '1' WHEN preparacao,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        escreve_ram <= '1' WHEN escreve | escreveM0,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        zeraE <= '1' WHEN inicioRodada | preparacao | inicioRodadaM0 | zeraContLedM0,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        zeraT <= '1' WHEN inicioRodada | proximo | fimRodada | zeraContLedM0 | proximoM0,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        limpaRC <= '1' WHEN inicial | preparacao,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        registraRC <= '1' WHEN registra | registraEscrita | registraM0,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        contaCR <= '1' WHEN proxRodada | proxRodadaM0,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        contaE <= '1' WHEN proximo | contaLedM0 | proximoM0 | proxRodadaM0 | fimRodada,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        contaT <= '1' WHEN espera | esperaEscrita | esperaM0,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        pronto <= '1' WHEN certo | erradoM0 | timeout | fimErrado,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        acertou <= '1' WHEN certo,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        errou <= '1' WHEN errado | timeout | erradoM0 | fimErrado,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        led_mux <= '0' WHEN ledInicial | mostraJogadaM0 | fimErrado | erradoM0 | timeout,
        '1' WHEN OTHERS;

    WITH Eatual SELECT
        zeraLED <= '1' WHEN preparacao | fimLedM0 | zeraContLedM0 | inicioRodadaM0,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        contaLED <= '1' WHEN ledInicial | mostraJogadaM0,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        zeraEntre <= '1' WHEN preparacao | contaLedM0 | proxRodadaM0 | registra | registraM0 | registraEscrita,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        zeraEntre2 <= '1' WHEN preparacao | contaLedM0 | proxRodadaM0,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        contaEntre <= '1' WHEN inicioRodadaM0 | fimLedM0 | aguardaBotaoM0 | aguardaBotao | aguardaBotaoE,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        contaEntre2 <= '1' WHEN inicioRodadaM0 | fimLedM0,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        contaVidas <= '1' WHEN errado,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        resetVidas <= '1' WHEN preparacao,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        mudaJogador <= '1' WHEN inicioRodada,
        '0' WHEN OTHERS;

    WITH Eatual SELECT
        apagahex <= '1' WHEN preparacao | inicial,
        '0' WHEN OTHERS;

    -- saida de depuracao (db_estado)
    WITH Eatual SELECT
        db_estado <= "0000" WHEN inicial, -- 0
        "0001" WHEN preparacao, -- 1
        "0010" WHEN ledInicial, -- 2
        "0011" WHEN espera | esperaM0, -- 3
        "0100" WHEN registra | registraM0, -- 4
        "0101" WHEN comparacao | comparacaoM0, -- 5
        "0110" WHEN proximo | proximoM0, -- 6
        "0111" WHEN fimRodada | fimRodadaM0, -- 7
        "1000" WHEN proxRodada | proxRodadaM0, -- 8
        "1001" WHEN inicioRodada | inicioRodadaM0, -- 9
        "1010" WHEN esperaEscrita, -- A
        "1011" WHEN escreve, -- B
        "1100" WHEN certo, -- C
        "1101" WHEN timeout, -- D
        "1110" WHEN errado, -- E
        "1111" WHEN OTHERS; -- F

END ARCHITECTURE fsm;