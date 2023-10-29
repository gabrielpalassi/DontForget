LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ram_16x4 IS
  PORT (
    clk : IN STD_LOGIC;
    endereco : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    dado_entrada : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    we : IN STD_LOGIC;
    ce : IN STD_LOGIC;
    dado_saida : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END ENTITY ram_16x4;

-- dados iniciais em arquivo MIF (para sintese com Intel Quartus Prime) 
ARCHITECTURE ram_mif OF ram_16x4 IS
  TYPE arranjo_memoria IS ARRAY(0 TO 15) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL memoria : arranjo_memoria;

  -- configuracao do Arquivo MIF
  ATTRIBUTE ram_init_file : STRING;
  ATTRIBUTE ram_init_file OF memoria : SIGNAL IS "ram_conteudo_jogadas.mif";

BEGIN

  PROCESS (clk)
  BEGIN
    IF (clk = '1' AND clk'event) THEN
      IF ce = '0' THEN -- dado armazenado na subida de "we" com "ce=0"

        -- detecta ativacao de we (ativo baixo)
        IF (we = '0')
          THEN
          memoria(to_integer(unsigned(endereco))) <= dado_entrada;
        END IF;

      END IF;
    END IF;
  END PROCESS;

  -- saida da memoria
  dado_saida <= memoria(to_integer(unsigned(endereco)));

END ARCHITECTURE ram_mif;

-- dados iniciais (para simulacao com Modelsim) 
ARCHITECTURE ram_modelsim OF ram_16x4 IS
  TYPE arranjo_memoria IS ARRAY(0 TO 15) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL memoria : arranjo_memoria := (
    "0001",
    "0010",
    "0100",
    "1000",
    "0100",
    "0010",
    "0001",
    "0001",
    "0010",
    "0010",
    "0100",
    "0100",
    "1000",
    "1000",
    "0001",
    "0100");

BEGIN

  PROCESS (clk)
  BEGIN
    IF (clk = '1' AND clk'event) THEN
      IF ce = '0' THEN -- dado armazenado na subida de "we" com "ce=0"

        -- detecta ativacao de we (ativo baixo)
        IF (we = '0')
          THEN
          memoria(to_integer(unsigned(endereco))) <= dado_entrada;
        END IF;

      END IF;
    END IF;
  END PROCESS;

  -- saida da memoria
  dado_saida <= memoria(to_integer(unsigned(endereco)));

END ARCHITECTURE ram_modelsim;