LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY uart_serial_uc IS
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
END ENTITY;

ARCHITECTURE uart_serial_uc_arch OF uart_serial_uc IS

    TYPE tipo_estado IS (inicial, preparacao_rx, espera_rx, preparacao_tx, espera_tx, transmissao, recepcao, armazena, final);
    SIGNAL Eatual : tipo_estado; -- estado atual
    SIGNAL Eprox : tipo_estado; -- proximo estado

BEGIN

    -- memoria de estado
    PROCESS (reset, clock)
    BEGIN
        IF reset = '1' THEN
            Eatual <= inicial;
        ELSIF clock'event AND clock = '1' THEN
            Eatual <= Eprox;
        END IF;
    END PROCESS;

    -- logica de proximo estado
    PROCESS (dado_serial, tick_rx, tick_tx, fim, Eatual, partida)
    BEGIN

        CASE Eatual IS

            WHEN inicial => IF dado_serial = '0' THEN
                Eprox <= preparacao_rx;
            ELSIF partida = '1' THEN
                Eprox <= preparacao_tx;
            ELSE
                Eprox <= inicial;
        END IF;

        WHEN preparacao_rx => Eprox <= espera_rx;

        WHEN espera_rx => IF tick_rx = '1' THEN
        Eprox <= recepcao;
    ELSIF fim = '0' THEN
        Eprox <= espera_rx;
    ELSE
        Eprox <= armazena;
    END IF;

    WHEN preparacao_tx => Eprox <= espera_tx;

    WHEN espera_tx => IF tick_tx = '1' THEN
    Eprox <= transmissao;
ELSIF fim = '0' THEN
    Eprox <= espera_tx;
ELSE
    Eprox <= final;
END IF;

WHEN recepcao => IF fim = '0' THEN
Eprox <= espera_rx;
ELSE
Eprox <= armazena;
END IF;

WHEN transmissao => IF fim = '0' THEN
Eprox <= espera_tx;
ELSE
Eprox <= final;
END IF;

WHEN armazena => Eprox <= final;

WHEN final => Eprox <= inicial;

WHEN OTHERS => Eprox <= inicial;

END CASE;

END PROCESS;

-- logica de saida (Moore)
WITH Eatual SELECT
    carrega <= '1' WHEN preparacao_rx,
    '1' WHEN preparacao_tx,
    '0' WHEN OTHERS;

WITH Eatual SELECT
    limpa <= '1' WHEN preparacao_rx, '0' WHEN OTHERS;

WITH Eatual SELECT
    zera <= '1' WHEN preparacao_rx,
    '1' WHEN preparacao_tx,
    '0' WHEN OTHERS;

WITH Eatual SELECT
    desloca <= '1' WHEN recepcao,
    '1' WHEN transmissao,
    '0' WHEN OTHERS;

WITH Eatual SELECT
    conta <= '1' WHEN recepcao,
    '1' WHEN transmissao,
    '0' WHEN OTHERS;

WITH Eatual SELECT
    registra <= '1' WHEN armazena, '0' WHEN OTHERS;

WITH Eatual SELECT
    pronto <= '1' WHEN final, '0' WHEN OTHERS;

WITH Eatual SELECT
    db_estado <= "0000" WHEN inicial,
    "0010" WHEN preparacao_rx,
    "0011" WHEN espera_rx,
    "0100" WHEN preparacao_tx,
    "0101" WHEN espera_tx,
    "1000" WHEN recepcao,
    "1001" WHEN transmissao,
    "1100" WHEN armazena,
    "1111" WHEN final, -- Final
    "1110" WHEN OTHERS; -- Erro

END ARCHITECTURE uart_serial_uc_arch;