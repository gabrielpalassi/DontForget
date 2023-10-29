library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controle_servo is
  port (
    clock      : in  std_logic;
    reset      : in  std_logic;
    posicao    : in  std_logic_vector(2 downto 0);  
    pwm        : out std_logic;
    db_reset   : out std_logic;
    db_pwm     : out std_logic;
    db_posicao : out std_logic_vector(2 downto 0)
  );
end entity controle_servo;

architecture rtl of controle_servo is

  signal contagem     : integer range 0 to 999999; -- confirmar range
  signal posicao_pwm  : integer range 0 to 999999;
  signal s_posicao    : integer range 0 to 999999;
  
begin

  process(clock, reset, s_posicao)
  begin
    -- inicia contagem e posicao
    if(reset='1') then
      contagem     <= 0;
      pwm     <= '0';
      posicao_pwm  <= s_posicao;
    elsif(rising_edge(clock)) then
        -- saida
        if(contagem < posicao_pwm) then
          pwm  <= '1';
        else
          pwm  <= '0';
        end if;
        -- atualiza contagem e posicao
        if(contagem = 999999) then
          contagem    <= 0;
          posicao_pwm <= s_posicao;
        else
          contagem    <= contagem + 1;
        end if;
    end if;
  end process;

  -- define posicao do pulso em ciclos de clock
  with posicao select 
    s_posicao <=  35500 when "000",
                  45700 when "001",
                  56450 when "010",
                  67150 when "011",
                  77850 when "100",
                  88550 when "101",
                  99300 when "110",
                  110000 when "111",
                  35500 when others;

end architecture rtl;