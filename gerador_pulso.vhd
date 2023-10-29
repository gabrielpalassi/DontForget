LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY gerador_pulso IS
   GENERIC (
      largura : INTEGER := 25
   );
   PORT (
      clock : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      gera : IN STD_LOGIC;
      para : IN STD_LOGIC;
      pulso : OUT STD_LOGIC;
      pronto : OUT STD_LOGIC
   );
END ENTITY gerador_pulso;

ARCHITECTURE fsm_arch OF gerador_pulso IS

   TYPE tipo_estado IS (parado, contagem, final);
   SIGNAL reg_estado, prox_estado : tipo_estado;
   SIGNAL reg_cont, prox_cont : INTEGER RANGE 0 TO largura - 1;

BEGIN

   -- logica de estado e contagem
   PROCESS (clock, reset)
   BEGIN
      IF (reset = '1') THEN
         reg_estado <= parado;
         reg_cont <= 0;
      ELSIF (clock'event AND clock = '1') THEN
         reg_estado <= prox_estado;
         reg_cont <= prox_cont;
      END IF;
   END PROCESS;

   -- logica de proximo estado e contagem
   PROCESS (reg_estado, gera, para, reg_cont)
   BEGIN
      pulso <= '0';
      pronto <= '0';
      prox_cont <= reg_cont;

      CASE reg_estado IS

         WHEN parado =>
            IF gera = '1' THEN
               prox_estado <= contagem;
            ELSE
               prox_estado <= parado;
            END IF;
            prox_cont <= 0;

         WHEN contagem =>
            IF para = '1' THEN
               prox_estado <= parado;
            ELSE
               IF (reg_cont = largura - 1) THEN
                  prox_estado <= final;
               ELSE
                  prox_estado <= contagem;
                  prox_cont <= reg_cont + 1;
               END IF;
            END IF;
            pulso <= '1';

         WHEN final =>
            prox_estado <= parado;
            pronto <= '1';
      END CASE;
   END PROCESS;

END ARCHITECTURE fsm_arch;