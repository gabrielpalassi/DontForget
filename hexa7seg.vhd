LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY hexa7seg IS
    PORT (
        hexa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY hexa7seg;

ARCHITECTURE comportamental OF hexa7seg IS
BEGIN

    sseg <= "1000000" WHEN hexa = "0000" ELSE
        "1111001" WHEN hexa = "0001" ELSE
        "0100100" WHEN hexa = "0010" ELSE
        "0110000" WHEN hexa = "0011" ELSE
        "0011001" WHEN hexa = "0100" ELSE
        "0010010" WHEN hexa = "0101" ELSE
        "0000010" WHEN hexa = "0110" ELSE
        "1111000" WHEN hexa = "0111" ELSE
        "0000000" WHEN hexa = "1000" ELSE
        "0010000" WHEN hexa = "1001" ELSE
        "0001000" WHEN hexa = "1010" ELSE
        "0000011" WHEN hexa = "1011" ELSE
        "1000110" WHEN hexa = "1100" ELSE
        "0100001" WHEN hexa = "1101" ELSE
        "0000110" WHEN hexa = "1110" ELSE
        "0001110" WHEN hexa = "1111" ELSE
        "1111111";

END ARCHITECTURE comportamental;