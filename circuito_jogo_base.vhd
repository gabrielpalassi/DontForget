LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY circuito_jogo_base IS
	PORT (
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		iniciar : IN STD_LOGIC;
		modoJogo : IN STD_LOGIC;
		dificuldade : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		botoes : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

		db_iniciar : OUT STD_LOGIC;
		db_reset : OUT STD_LOGIC;
		leds : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		buzzer : OUT STD_LOGIC;
		pronto : OUT STD_LOGIC;
		ganhou : OUT STD_LOGIC;
		perdeu : OUT STD_LOGIC;
		hex5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END ENTITY;
ARCHITECTURE circuito_arch OF circuito_jogo_base IS

	SIGNAL s_zeraCR, s_contaCR, s_zeraE, s_contaE, s_zeraT, s_contaT, s_limpaRC, s_registraRC, s_resetG : STD_LOGIC;
	SIGNAL s_fimL, s_fimE, s_fimT, s_enderecoIgualRodada, s_jogada, s_jogadaCorreta, s_fimLED, s_contaLED : STD_LOGIC;
	SIGNAL s_led_mux, s_zeraLED, s_escreve, s_contaEntre, s_zeraEntre, s_fimEntre, s_jogador, s_apagahex : STD_LOGIC;
	SIGNAL s_mudaJogador, s_resetVidas, s_contaVidas, s_zeroVidas1, s_zeroVidas2, s_ganhou, s_perdeu : STD_LOGIC;
	SIGNAL s_contaEntre2, s_zeraEntre2, s_fimEntre2 : STD_LOGIC;
	SIGNAL s_contagem, s_memoria, s_jogadafeita, s_rodada, s_chave_acionada, s_hexa_vidas1, s_hexa_vidas2, s_estado : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL s_vidas1, s_vidas2 : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL s_vidas2_7seg, s_vidas1_7seg, s_rod_aux, s_rod_unid, s_rod_dez : STD_LOGIC_VECTOR (6 DOWNTO 0);

	COMPONENT fluxo_dados IS
		PORT (
			clock : IN STD_LOGIC;
			zeraCR : IN STD_LOGIC;
			contaCR : IN STD_LOGIC;
			zeraE : IN STD_LOGIC;
			contaE : IN STD_LOGIC;
			zeraT : IN STD_LOGIC;
			contaT : IN STD_LOGIC;
			zeraLED : IN STD_LOGIC;
			contaLED : IN STD_LOGIC;
			zeraEntre : IN STD_LOGIC;
			contaEntre : IN STD_LOGIC;
			zeraEntre2 : IN STD_LOGIC;
			contaEntre2 : IN STD_LOGIC;
			escreve : IN STD_LOGIC;
			limpaRC : IN STD_LOGIC;
			registraRC : IN STD_LOGIC;
			led_mux : IN STD_LOGIC;
			chaves : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			modoJogo : IN STD_LOGIC;
			resetG : IN STD_LOGIC;
			dificuldade : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			mudaJogador : IN STD_LOGIC;
			resetVidas : IN STD_LOGIC;
			contaVidas : IN STD_LOGIC;
			errou : IN STD_LOGIC;

			zeroVidas1 : OUT STD_LOGIC;
			zeroVidas2 : OUT STD_LOGIC;
			fimL : OUT STD_LOGIC;
			fimE : OUT STD_LOGIC;
			fimT : OUT STD_LOGIC;
			fimLED : OUT STD_LOGIC;
			fimEntre : OUT STD_LOGIC;
			fimEntre2 : OUT STD_LOGIC;
			enderecoIgualRodada : OUT STD_LOGIC;
			jogada_correta : OUT STD_LOGIC;
			jogada_feita : OUT STD_LOGIC;
			jogador_out : OUT STD_LOGIC;
			buzzer : OUT STD_LOGIC;
			rodada : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			leds : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			vidas1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			vidas2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT unidade_controle IS
		PORT (
			clock : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			iniciar : IN STD_LOGIC;
			fimE : IN STD_LOGIC;
			fimT : IN STD_LOGIC;
			fimL : IN STD_LOGIC;
			fimLED : IN STD_LOGIC;
			fimEntre : IN STD_LOGIC;
			fimEntre2 : IN STD_LOGIC;
			jogada_feita : IN STD_LOGIC;
			jogada_correta : IN STD_LOGIC;
			enderecoIgualRodada : IN STD_LOGIC;
			modoJogo : IN STD_LOGIC;
			zeroVidas1 : IN STD_LOGIC;
			zeroVidas2 : IN STD_LOGIC;

			mudaJogador : OUT STD_LOGIC;
			contaVidas : OUT STD_LOGIC;
			resetVidas : OUT STD_LOGIC;
			zeraCR : OUT STD_LOGIC;
			zeraE : OUT STD_LOGIC;
			zeraT : OUT STD_LOGIC;
			zeraLED : OUT STD_LOGIC;
			zeraEntre : OUT STD_LOGIC;
			zeraEntre2 : OUT STD_LOGIC;
			resetG : OUT STD_LOGIC;
			contaCR : OUT STD_LOGIC;
			contaE : OUT STD_LOGIC;
			contaT : OUT STD_LOGIC;
			contaLED : OUT STD_LOGIC;
			contaEntre : OUT STD_LOGIC;
			contaEntre2 : OUT STD_LOGIC;
			limpaRC : OUT STD_LOGIC;
			registraRC : OUT STD_LOGIC;
			acertou : OUT STD_LOGIC;
			errou : OUT STD_LOGIC;
			pronto : OUT STD_LOGIC;
			led_mux : OUT STD_LOGIC;
			escreve_ram : OUT STD_LOGIC;
			apagahex : OUT STD_LOGIC;
			db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT hexa7seg IS
		PORT (
			hexa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;

BEGIN

	fd : fluxo_dados
	PORT MAP(
		clock => clock,
		zeraCR => s_zeraCR,
		contaCR => s_contaCR,
		zeraE => s_zeraE,
		contaE => s_contaE,
		zeraT => s_zeraT,
		contaT => s_contaT,
		escreve => s_escreve,
		limpaRC => s_limpaRC,
		registraRC => s_registraRC,
		led_mux => s_led_mux,
		chaves => NOT botoes,
		dificuldade => dificuldade,
		mudaJogador => s_mudaJogador,
		resetVidas => s_resetVidas,
		contaVidas => s_contaVidas,
		errou => s_perdeu,
		zeroVidas1 => s_zeroVidas1,
		zeroVidas2 => s_zeroVidas2,
		fimL => s_fimL,
		fimE => s_fimE,
		fimT => s_fimT,
		fimLED => s_fimLED,
		zeraLED => s_zeraLED,
		contaLED => s_contaLED,
		zeraEntre => s_zeraEntre,
		contaEntre => s_contaEntre,
		fimEntre => s_fimEntre,
		zeraEntre2 => s_zeraEntre2,
		contaEntre2 => s_contaEntre2,
		fimEntre2 => s_fimEntre2,
		enderecoIgualRodada => s_enderecoIgualRodada,
		jogada_correta => s_jogadaCorreta,
		jogada_feita => s_jogada,
		leds => leds,
		buzzer => buzzer,
		modoJogo => modoJogo,
		resetG => s_resetG,
		vidas1 => s_vidas1,
		vidas2 => s_vidas2,
		jogador_out => s_jogador,
		rodada => s_rodada
	);

	uc : unidade_controle
	PORT MAP(
		clock => clock,
		reset => reset,
		iniciar => iniciar,
		fimE => s_fimE,
		fimT => s_fimT,
		fimL => s_fimL,
		fimLED => s_fimLED,
		zeraLED => s_zeraLED,
		contaLED => s_contaLED,
		zeraEntre => s_zeraEntre,
		contaEntre => s_contaEntre,
		fimEntre => s_fimEntre,
		zeraEntre2 => s_zeraEntre2,
		contaEntre2 => s_contaEntre2,
		fimEntre2 => s_fimEntre2,
		jogada_feita => s_jogada,
		jogada_correta => s_jogadaCorreta,
		enderecoIgualRodada => s_enderecoIgualRodada,
		modoJogo => modoJogo,
		zeroVidas1 => s_zeroVidas1,
		zeroVidas2 => s_zeroVidas2,
		mudaJogador => s_mudaJogador,
		contaVidas => s_contaVidas,
		resetVidas => s_resetVidas,
		zeraCR => s_zeraCR,
		zeraE => s_zeraE,
		zeraT => s_zeraT,
		contaCR => s_contaCR,
		contaE => s_contaE,
		contaT => s_contaT,
		limpaRC => s_limpaRC,
		registraRC => s_registraRC,
		acertou => s_ganhou,
		errou => s_perdeu,
		pronto => pronto,
		led_mux => s_led_mux,
		escreve_ram => s_escreve,
		resetG => s_resetG,
		apagahex => s_apagahex,
		db_estado => s_estado
	);

	hex0 <= "1000001" WHEN s_ganhou = '1' ELSE --u
		"1000001" WHEN s_perdeu = '1' ELSE --u
		s_rod_unid WHEN (modoJogo = '0' AND s_ganhou = '0' AND s_perdeu = '0' AND s_apagahex = '0') ELSE
		s_vidas1_7seg WHEN (modoJogo = '1' AND s_ganhou = '0' AND s_perdeu = '0' AND s_apagahex = '0') ELSE
		"1111001" WHEN (s_apagahex = '1' AND s_ganhou = '0' AND s_perdeu = '0' AND modoJogo = '0') ELSE --1
		"0100100" WHEN (s_apagahex = '1' AND s_ganhou = '0' AND s_perdeu = '0' AND modoJogo = '1') ELSE --2
		"1111111";

	s_hexa_vidas1 <= '0' & s_vidas1;

	hex_vidas1 : hexa7seg
	PORT MAP(
		hexa => s_hexa_vidas1,
		sseg => s_vidas1_7seg
	);

	s_rod_unid <= "1111001" WHEN s_rodada = "0000" ELSE
		"0100100" WHEN s_rodada = "0001" ELSE
		"0110000" WHEN s_rodada = "0010" ELSE
		"0011001" WHEN s_rodada = "0011" ELSE
		"0010010" WHEN s_rodada = "0100" ELSE
		"0000010" WHEN s_rodada = "0101" ELSE
		"1111000" WHEN s_rodada = "0110" ELSE
		"0000000" WHEN s_rodada = "0111" ELSE
		"0010000" WHEN s_rodada = "1000" ELSE
		"1000000" WHEN s_rodada = "1001" ELSE
		"1111001" WHEN s_rodada = "1010" ELSE
		"0100100" WHEN s_rodada = "1011" ELSE
		"0110000" WHEN s_rodada = "1100" ELSE
		"0011001" WHEN s_rodada = "1101" ELSE
		"0010010" WHEN s_rodada = "1110" ELSE
		"0000010" WHEN s_rodada = "1111" ELSE
		"1111111";

	s_rod_dez <= "1111111" WHEN NOT(s_rodada(3) = '1' AND (s_rodada(2) = '1' OR s_rodada(1) = '1' OR s_rodada(0) = '1')) ELSE
		"1111001";

	hex1 <= "1000000" WHEN s_ganhou = '1' ELSE --o
		"0000110" WHEN s_perdeu = '1' ELSE --e
		s_rod_dez WHEN (modoJogo = '0' AND s_ganhou = '0' AND s_perdeu = '0' AND s_apagahex = '0') ELSE
		"1000000" WHEN (s_apagahex = '1' AND s_ganhou = '0' AND s_perdeu = '0') ELSE --o
		"1111111";

	hex2 <= "0001011" WHEN s_ganhou = '1' ELSE --h
		"0100001" WHEN s_perdeu = '1' ELSE --d
		"1111001" WHEN (modoJogo = '1' AND s_ganhou = '0' AND s_perdeu = '0' AND s_jogador = '0' AND s_apagahex = '0') ELSE --1
		"0100100" WHEN (modoJogo = '1' AND s_ganhou = '0' AND s_perdeu = '0' AND s_jogador = '1' AND s_apagahex = '0') ELSE --2
		"0001000" WHEN (s_apagahex = '1' AND s_ganhou = '0' AND s_perdeu = '0') ELSE --a
		"1111111";

	hex3 <= "0101011" WHEN s_ganhou = '1' ELSE --n
		"0101111" WHEN s_perdeu = '1' ELSE --r
		"0100001" WHEN (modoJogo = '0' AND s_ganhou = '0' AND s_perdeu = '0' AND s_apagahex = '0') ELSE --d
		"1100001" WHEN (modoJogo = '1' AND s_ganhou = '0' AND s_perdeu = '0' AND s_apagahex = '0') ELSE --j
		"1000110" WHEN (s_apagahex = '1' AND s_ganhou = '0' AND s_perdeu = '0') ELSE --c
		"1111111";

	hex4 <= "0001000" WHEN s_ganhou = '1' ELSE --a
		"0000110" WHEN s_perdeu = '1' ELSE --e
		"0100011" WHEN (modoJogo = '0' AND s_ganhou = '0' AND s_perdeu = '0' AND s_apagahex = '0') ELSE --o
		"0001100" WHEN (s_apagahex = '1' AND s_ganhou = '0' AND s_perdeu = '0') ELSE --p
		"1111111";

	s_hexa_vidas2 <= '0' & s_vidas2;

	hex_vidas2 : hexa7seg
	PORT MAP(
		hexa => s_hexa_vidas2,
		sseg => s_vidas2_7seg
	);

	hex5 <= "1000010" WHEN s_ganhou = '1' ELSE --g
		"0001100" WHEN s_perdeu = '1' ELSE --p
		"0101111" WHEN (modoJogo = '0' AND s_ganhou = '0' AND s_perdeu = '0' AND s_apagahex = '0') ELSE --r
		s_vidas2_7seg WHEN (modoJogo = '1' AND s_ganhou = '0' AND s_perdeu = '0' AND s_apagahex = '0') ELSE
		"1000000" WHEN (s_apagahex = '1' AND s_ganhou = '0' AND s_perdeu = '0') ELSE --o
		"1111111";

	ganhou <= s_ganhou;
	perdeu <= s_perdeu;
	db_iniciar <= iniciar;
	db_reset <= reset;
END ARCHITECTURE;