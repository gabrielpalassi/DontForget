LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY deslocador_n IS
    GENERIC (
        CONSTANT N : INTEGER := 4
    );
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        carrega : IN STD_LOGIC;
        desloca : IN STD_LOGIC;
        entrada_serial : IN STD_LOGIC;
        dados : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
        saida : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0)
    );
END ENTITY deslocador_n;

ARCHITECTURE deslocador_n_arch OF deslocador_n IS

    SIGNAL IQ : STD_LOGIC_VECTOR (N - 1 DOWNTO 0);

BEGIN

    PROCESS (clock, reset, IQ)
    BEGIN
        IF reset = '1' THEN
            IQ <= (OTHERS => '1');
        ELSIF (clock'event AND clock = '1') THEN
            IF carrega = '1' THEN
                IQ <= dados;
            ELSIF desloca = '1' THEN
                IQ <= entrada_serial & IQ(N - 1 DOWNTO 1);
            ELSE
                IQ <= IQ;
            END IF;
        END IF;
    END PROCESS;

    saida <= IQ;
END ARCHITECTURE deslocador_n_arch;