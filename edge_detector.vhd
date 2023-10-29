LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY edge_detector IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        sinal : IN STD_LOGIC;
        pulso : OUT STD_LOGIC
    );
END ENTITY edge_detector;

ARCHITECTURE rtl OF edge_detector IS

    SIGNAL reg0 : STD_LOGIC;
    SIGNAL reg1 : STD_LOGIC;

BEGIN

    detector : PROCESS (clock, reset)
    BEGIN
        IF (reset = '1') THEN
            reg0 <= '0';
            reg1 <= '0';
        ELSIF (rising_edge(clock)) THEN
            reg0 <= sinal;
            reg1 <= reg0;
        END IF;
    END PROCESS;

    pulso <= NOT reg1 AND reg0;

END ARCHITECTURE rtl;