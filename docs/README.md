# 🔵🔴🟢🟡 Don't Forget

O Don't Forget é um jogo eletrônico implementado em VHDL (VHSIC Hardware Description Language). Ele oferece uma experiência de jogo desafiadora e divertida, combinando elementos de memória e reflexos.

[Assista ao vídeo da implementação final aqui!](https://dms.licdn.com/playlist/vid/D4D05AQEEY0ItrWKh5g/mp4-720p-30fp-crf28/0/1681317428386?e=1699171200&v=beta&t=8_TksRSx_4gIdA5OXBqZZKRiwHGpEQR3G2NKqKGgigY)

Esse projeto fez parte da disciplina de Laboratório Digital 1 da Universdade de São Paulo e consistiu na implementação do jogo Genius completamente em hardware, utilizando uma placa FPGA para criar os circuitos lógicos necessários. O trabalho envolveu desde a criação da interface do jogo, da implementação dos diferentes modos e dificuldades até a lógica para a geração das sequências aleatórias de luzes e sons e a comparação com as jogadas do usuário.

Divirta-se jogando e explorando a implementação!

## Sobre o Jogo

O Genius é uma versão eletrônica da brincadeira "Simon says" que se tornou popular nos anos 80. O objetivo do jogo é reproduzir uma sequência de luzes e sons, sem cometer erros.

### Modo 1 de Jogo - Siga a Sequência

Neste modo, o Genius inicia piscando uma luz, e o jogador deve repetir essa sequência. A cada rodada, o jogo adiciona mais uma luz à sequência, e o jogador deve repetir a sequência corretamente. Se o jogador cometer um erro ou demorar mais de 5 segundos para selecionar a próxima luz, o jogo termina.

### Modo 2 de Jogo - Crie a sua Sequência

No modo 2, o Genius dá o primeiro sinal, e os jogadores devem criar sua própria sequência. O primeiro jogador repete o sinal dado e adiciona um novo. O segundo jogador repete a sequência do primeiro jogador e adiciona mais um sinal, e assim por diante. O objetivo é criar a sequência mais longa possível.

## Seletor de Dificuldade

O projeto inclui um seletor de dificuldade com 3 níveis: fácil (1), médio (2) e difícil (3).

### Modo 1 de Jogo - Siga a Sequência

No modo 1, o seletor de dificuldade controla a quantidade de rodadas necessárias para vencer o jogo. No nível 1 de dificuldade, são necessárias 8 rodadas para a vitória, no nível 2, 12 rodadas, e no nível 3, 16 rodadas.

### Modo 2 de Jogo - Crie a sua Sequência

No modo 2, cada jogador começa com uma quantidade definida de vidas. Cada vez que um jogador comete um erro, ele perde uma vida e passa a vez. Os níveis de dificuldade afetam a quantidade de vidas no início do jogo: no nível 1, cada jogador começa com 4 vidas, no nível 2 com 2 vidas e no nível 3 com 1 vida.

## Recursos Externos

Neste projeto, utilizamos displays de 7 segmentos, buzzers, botões e LEDs externos. Certifique-se de configurar e pinar esses recursos adequadamente caso venha a implantar o projeto.
