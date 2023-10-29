LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY sonar_uc IS
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
END ENTITY;

ARCHITECTURE fsm OF sonar_uc IS
    TYPE tipo_estado IS (inicial, preparacao, posiciona_servo, espera_2seg, medida, espera_medida, prox_transmissao, transmite, espera_transmissao, final);
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
    PROCESS (ligar, medida_pronto, fim_transmissao, ultima_transmissao, fim_2seg, Eatual)
    BEGIN
        CASE Eatual IS
            WHEN inicial => IF ligar = '1' THEN
                Eprox <= preparacao;
            ELSE
                Eprox <= inicial;
        END IF;
        WHEN preparacao => Eprox <= posiciona_servo;
        WHEN posiciona_servo => Eprox <= medida;
        WHEN medida => Eprox <= espera_medida;
        WHEN espera_medida => IF medida_pronto = '1' THEN
        Eprox <= transmite;
    ELSE
        Eprox <= espera_medida;
    END IF;
    WHEN transmite => Eprox <= espera_transmissao;
    WHEN espera_transmissao => IF fim_transmissao = '1' AND ultima_transmissao = '1' THEN
    Eprox <= espera_2seg;
ELSIF fim_transmissao = '1' THEN
    Eprox <= prox_transmissao;
ELSE
    Eprox <= espera_transmissao;
END IF;
WHEN prox_transmissao => Eprox <= transmite;
WHEN espera_2seg => IF fim_2seg = '1' THEN
Eprox <= final;
ELSE
Eprox <= espera_2seg;
END IF;
WHEN final => Eprox <= posiciona_servo;
WHEN OTHERS => Eprox <= inicial;
END CASE;
END PROCESS;

-- saidas de controle
WITH Eatual SELECT
    medir <= '1' WHEN medida, '0' WHEN OTHERS;
WITH Eatual SELECT
    transmitir <= '1' WHEN transmite, '0' WHEN OTHERS;
WITH Eatual SELECT
    conta_mux <= '1' WHEN prox_transmissao, '0' WHEN OTHERS;
WITH Eatual SELECT
    zera_mux <= '1' WHEN medida, '0' WHEN OTHERS;
WITH Eatual SELECT
    pronto <= '1' WHEN final, '0' WHEN OTHERS;
WITH Eatual SELECT
    conta_2seg <= '1' WHEN espera_2seg, '0' WHEN OTHERS;
WITH Eatual SELECT
    zera_2seg <= '1' WHEN posiciona_servo, '0' WHEN OTHERS;
WITH Eatual SELECT
    conta_servo <= '1' WHEN final, '0' WHEN OTHERS;
WITH Eatual SELECT
    zera_servo <= '1' WHEN preparacao, '0' WHEN OTHERS;
WITH Eatual SELECT
    db_estado <= "0000" WHEN inicial,
    "0001" WHEN preparacao,
    "0010" WHEN posiciona_servo,
    "0100" WHEN medida,
    "0101" WHEN espera_medida,
    "1000" WHEN transmite,
    "1001" WHEN espera_transmissao,
    "1110" WHEN espera_2seg,
    "1111" WHEN final,
    "1110" WHEN OTHERS;
END ARCHITECTURE;