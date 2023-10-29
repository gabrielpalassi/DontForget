LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY contador_cm_uc IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        inicio : IN STD_LOGIC;
        fim : IN STD_LOGIC;
        tick : IN STD_LOGIC;
        conta_bcd : OUT STD_LOGIC;
        zera_bcd : OUT STD_LOGIC;
        conta_tick : OUT STD_LOGIC;
        zera_tick : OUT STD_LOGIC;
        pronto : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE fsm_contador_cm OF contador_cm_uc IS
    TYPE tipo_estado IS (inicial, preparacao, espera, conta, final);
    SIGNAL Eatual, Eprox : tipo_estado;

BEGIN

    -- estado
    PROCESS (reset, clock)
    BEGIN
        IF reset = '1' THEN
            Eatual <= inicial;
        ELSIF clock'event AND clock = '1' THEN
            Eatual <= Eprox;
        END IF;
    END PROCESS;

    -- logica de proximo estado
    PROCESS (tick, inicio, fim, Eatual)
    BEGIN
        CASE Eatual IS
            WHEN inicial => IF inicio = '1' THEN
                Eprox <= preparacao;
            ELSE
                Eprox <= inicial;
        END IF;
        WHEN preparacao => Eprox <= espera;
        WHEN espera => IF tick = '1' THEN
        Eprox <= conta;
    ELSIF fim = '1' THEN
        Eprox <= final;
    ELSE
        Eprox <= espera;
    END IF;
    WHEN conta => IF fim = '1' THEN
    Eprox <= final;
ELSE
    Eprox <= espera;
END IF;
WHEN final => Eprox <= inicial;
WHEN OTHERS => Eprox <= inicial;
END CASE;
END PROCESS;

-- saidas de controle
WITH Eatual SELECT
    zera_bcd <= '1' WHEN preparacao, '0' WHEN OTHERS;
WITH Eatual SELECT
    zera_tick <= '1' WHEN preparacao, '0' WHEN OTHERS;
WITH Eatual SELECT
    conta_bcd <= '1' WHEN conta, '0' WHEN OTHERS;
WITH Eatual SELECT
    conta_tick <= '1' WHEN espera, '1' WHEN conta, '0' WHEN OTHERS;
WITH Eatual SELECT
    pronto <= '1' WHEN final, '0' WHEN OTHERS;
END ARCHITECTURE;