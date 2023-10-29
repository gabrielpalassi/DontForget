LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY interface_hcsr04_uc IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        medir : IN STD_LOGIC;
        echo : IN STD_LOGIC;
        fim_medida : IN STD_LOGIC;
        zera : OUT STD_LOGIC;
        gera : OUT STD_LOGIC;
        limpa : OUT STD_LOGIC;
        registra : OUT STD_LOGIC;
        pronto : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END interface_hcsr04_uc;

ARCHITECTURE fsm_arch OF interface_hcsr04_uc IS
    TYPE tipo_estado IS (inicial, preparacao, envia_trigger,
        espera_echo, medida, armazenamento, final);
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
    PROCESS (medir, echo, fim_medida, Eatual)
    BEGIN
        CASE Eatual IS
            WHEN inicial => IF medir = '1' THEN
                Eprox <= preparacao;
            ELSE
                Eprox <= inicial;
        END IF;
        WHEN preparacao => Eprox <= envia_trigger;
        WHEN envia_trigger => Eprox <= espera_echo;
        WHEN espera_echo => IF echo = '0' THEN
        Eprox <= espera_echo;
    ELSE
        Eprox <= medida;
    END IF;
    WHEN medida => IF fim_medida = '1' THEN
    Eprox <= armazenamento;
ELSE
    Eprox <= medida;
END IF;
WHEN armazenamento => Eprox <= final;
WHEN final => IF medir = '1' THEN
Eprox <= preparacao;
ELSE
Eprox <= final;
END IF;
WHEN OTHERS => Eprox <= inicial;
END CASE;
END PROCESS;

-- saidas de controle
WITH Eatual SELECT
    --      zera <= '1' when inicial | preparacao, '0' when others;
    zera <= '1' WHEN preparacao, '0' WHEN OTHERS;
WITH Eatual SELECT
    gera <= '1' WHEN envia_trigger, '0' WHEN OTHERS;
WITH Eatual SELECT
    limpa <= '1' WHEN inicial, '0' WHEN OTHERS;
WITH Eatual SELECT
    registra <= '1' WHEN armazenamento, '0' WHEN OTHERS;
WITH Eatual SELECT
    pronto <= '1' WHEN final, '0' WHEN OTHERS;

WITH Eatual SELECT
    db_estado <= "0000" WHEN inicial,
    "0001" WHEN preparacao,
    "0010" WHEN envia_trigger,
    "0011" WHEN espera_echo,
    "0100" WHEN medida,
    "0101" WHEN armazenamento,
    "1111" WHEN final,
    "1110" WHEN OTHERS;

END ARCHITECTURE fsm_arch;