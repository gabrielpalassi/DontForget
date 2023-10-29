LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY edge_detector IS
    PORT (
        clock : IN STD_LOGIC;
        signal_in : IN STD_LOGIC;
        output : OUT STD_LOGIC
    );
END ENTITY edge_detector;

ARCHITECTURE Behavioral OF edge_detector IS
    SIGNAL signal_d : STD_LOGIC;
BEGIN
    PROCESS (clock)
    BEGIN
        IF clock = '1' AND clock'event THEN
            signal_d <= signal_in;
        END IF;
    END PROCESS;

    output <= (NOT signal_d) AND signal_in;

END ARCHITECTURE Behavioral;