--------------------------------------------------------------------------------
-- Title		: Registrador de Deslocamento
-- Project		: CPU Multi-ciclo
--------------------------------------------------------------------------------
-- File			: RegDesloc.vhd
-- Author		: Emannuel Gomes Mac�do <egm@cin.ufpe.br>
--				  Fernando Raposo Camara da Silva <frcs@cin.ufpe.br>
--				  Pedro Machado Manh�es de Castro <pmmc@cin.ufpe.br>
--				  Rodrigo Alves Costa <rac2@cin.ufpe.br>
-- Organization : Universidade Federal de Pernambuco
-- Created		: 10/07/2002
-- Last update	: 26/11/2002
-- Plataform	: Flex10K
-- Simulators	: Altera Max+plus II
-- Synthesizers	: 
-- Targets		: 
-- Dependency	: 
--------------------------------------------------------------------------------
-- Description	: Entidade respons�vel pelo deslocamento de um vetor de 32 
--                bits para a direita e para a esquerda. 
--				  Entradas:
--				  	* N: vetor de 5 bits que indica a quantidade de 
--					deslocamentos   
--				  	* Shift: vetor de 3 bits que indica a fun��o a ser 
--					realizada pelo registrador   
--				  Abaixo seguem os valores referentes � entrada shift e as 
--                respectivas fun��es do registrador: 
--				  
--				  Shift					FUN��O DO REGISTRADOR
--				  000					faz nada
--				  001					carrega vetor (sem deslocamentos)
--				  010					deslocamento � esquerda n vezes
--				  011					deslocamento � direita l�gico n vezes
--				  100					deslocamento � direita aritm�tico n vezes
--				  101					rota��o � direita n vezes
--				  110					rota��o � esquerda n vezes
--------------------------------------------------------------------------------
-- Copyright (c) notice
--		Universidade Federal de Pernambuco (UFPE).
--		CIn - Centro de Informatica.
--		Developed by computer science undergraduate students.
--		This code may be used for educational and non-educational purposes as 
--		long as its copyright notice remains unchanged. 
--------------------------------------------------------------------------------
-- Revisions		: 2
-- Revision Number	: 2.0
-- Version			: 1.2
-- Date				: 26/11/2002
-- Modifier			: Marcus Vinicius Lima e Machado <mvlm@cin.ufpe.br>
--				  	  Paulo Roberto Santana Oliveira Filho <prsof@cin.ufpe.br>
--					  Viviane Cristina Oliveira Aureliano <vcoa@cin.ufpe.br>
-- Description		:
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Revisions		: 3
-- Revision Number	: 1.2
-- Version			: 1.3
-- Date				: 08/08/2008
-- Modifier			: Jo�o Paulo Fernandes Barbosa (jpfb@cin.ufpe.br)
-- Description		: Os sinais de entrada e sa�da passam a ser do tipo std_logic.
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Short name: desl
ENTITY RegDesloc IS
		PORT(
			Clk		: IN	STD_LOGIC;	-- Clock do sistema
		 	Reset	: IN	STD_LOGIC;	-- Reset
			Shift 	: IN	STD_LOGIC_vector (2 downto 0);	-- Fun��o a ser realizada pelo registrador 
			N		: IN	STD_LOGIC_vector (4 downto 0);	-- Quantidade de deslocamentos
			Entrada : IN	STD_LOGIC_vector (31 downto 0);	-- Vetor a ser deslocado
			Saida	: OUT	STD_LOGIC_vector (31 downto 0)	-- Vetor deslocado
		);
END RegDesloc;

-- Arquitetura que define o comportamento do registrador de deslocamento
-- Simulation
ARCHITECTURE behavioral_arch OF RegDesloc IS
	
	signal temp		: STD_LOGIC_vector (31 downto 0);	-- Vetor tempor�rio
	
	begin

	-- Clocked process
	process (Clk, Reset)
		begin
			if(Reset = '1') then
				temp <= "00000000000000000000000000000000";

			elsif (Clk = '1' and Clk'event) then
				case Shift is
					when "000" => 						-- Faz nada
						temp <= temp;
					when "001" => 						-- Carrega vetor de entrada, n�o faz deslocamentos
						temp <= Entrada;
					when "010" =>						-- Deslocamento � esquerda N vezes
						case N is
							when "00000" =>				-- Deslocamento � esquerda nenhuma vez
								temp <= temp;
							when "00001" =>				-- Deslocamento � esquerda 1 vez
								temp(0) <= '0';
								temp(31 downto 1) <= temp(30 downto 0);
							when "00010" =>				-- Deslocamento � esquerda 2 vezes
								temp(1 downto 0) <= "00";
								temp(31 downto 2) <= temp(29 downto 0);
							when "00011" =>				-- Deslocamento � esquerda 3 vezes
								temp(2 downto 0) <= "000";
								temp(31 downto 3) <= temp(28 downto 0);
							when "00100" =>				-- Deslocamento � esquerda 4 vezes
								temp(3 downto 0) <= "0000";
								temp(31 downto 4) <= temp(27 downto 0);
							when "00101" =>				-- Deslocamento � esquerda 5 vezes
								temp(4 downto 0) <= "00000";
								temp(31 downto 5) <= temp(26 downto 0);
							when "00110" =>				-- Deslocamento � esquerda 6 vezes
								temp(5 downto 0) <= "000000";
								temp(31 downto 6) <= temp(25 downto 0);
							when "00111" =>				-- Deslocamento � esquerda 7 vezes
								temp(6 downto 0) <= "0000000";
								temp(31 downto 7) <= temp(24 downto 0);
                            when "01000" =>                         -- e assim sucessivamente...
								temp(7 downto 0) <= "00000000";
								temp(31 downto 8) <= temp(23 downto 0);
							when "01001" =>
								temp(8 downto 0) <= "000000000";
								temp(31 downto 9) <= temp(22 downto 0);
							when "01010" =>
								temp(9 downto 0) <= "0000000000";
								temp(31 downto 10) <= temp(21 downto 0);
							when "01011" =>
								temp(10 downto 0) <= "00000000000";
								temp(31 downto 11) <= temp(20 downto 0);
							when "01100" =>
								temp(11 downto 0) <= "000000000000";
								temp(31 downto 12) <= temp(19 downto 0);
							when "01101" =>
								temp(12 downto 0) <= "0000000000000";
								temp(31 downto 13) <= temp(18 downto 0);
							when "01110" =>
								temp(13 downto 0) <= "00000000000000";
								temp(31 downto 14) <= temp(17 downto 0);
							when "01111" =>
								temp(14 downto 0) <= "000000000000000";
								temp(31 downto 15) <= temp(16 downto 0);
							when "10000" =>
								temp(15 downto 0) <= "0000000000000000";
								temp(31 downto 16) <= temp(15 downto 0);
							when "10001" =>
								temp(16 downto 0) <= "00000000000000000";
								temp(31 downto 17) <= temp(14 downto 0);
							when "10010" =>
								temp(17 downto 0) <= "000000000000000000";
								temp(31 downto 18) <= temp(13 downto 0);
							when "10011" =>
								temp(18 downto 0) <= "0000000000000000000";
								temp(31 downto 19) <= temp(12 downto 0);
							when "10100" =>
								temp(19 downto 0) <= "00000000000000000000";
								temp(31 downto 20) <= temp(11 downto 0);
							when "10101" =>
								temp(20 downto 0) <= "000000000000000000000";
								temp(31 downto 21) <= temp(10 downto 0);
							when "10110" =>
								temp(21 downto 0) <= "0000000000000000000000";
								temp(31 downto 22) <= temp(9 downto 0);
							when "10111" =>
								temp(22 downto 0) <= "00000000000000000000000";
								temp(31 downto 23) <= temp(8 downto 0);
							when "11000" =>
								temp(23 downto 0) <= "000000000000000000000000";
								temp(31 downto 24) <= temp(7 downto 0);
							when "11001" =>
								temp(24 downto 0) <= "0000000000000000000000000";
								temp(31 downto 25) <= temp(6 downto 0);
							when "11010" =>
								temp(25 downto 0) <= "00000000000000000000000000";
								temp(31 downto 26) <= temp(5 downto 0);
							when "11011" =>
								temp(26 downto 0) <= "000000000000000000000000000";
								temp(31 downto 27) <= temp(4 downto 0);
							when "11100" =>
								temp(27 downto 0) <= "0000000000000000000000000000";
								temp(31 downto 28) <= temp(3 downto 0);
							when "11101" =>
								temp(28 downto 0) <= "00000000000000000000000000000";
								temp(31 downto 29) <= temp(2 downto 0);
							when "11110" =>
								temp(29 downto 0) <= "000000000000000000000000000000";
								temp(31 downto 30) <= temp(1 downto 0);
							when "11111" =>
								temp(30 downto 0) <= "0000000000000000000000000000000";
								temp(31) <= temp(0);
							
							end case;

					-- Deslocamento � direita l�gico N vezes
					when "011" =>						
						case n is
							when "00000" =>				-- Deslocamento � direita l�gico nenhuma vez
								temp <= temp;
							when "00001" =>				-- Deslocamento � direita l�gico 1 vez
								temp(30 downto 0) <= temp(31 downto 1);
								temp(31) <= '0';
							when "00010" =>				-- Deslocamento � direita l�gico 2 vezes
								temp(29 downto 0) <= temp(31 downto 2);
								temp(31 downto 30) <= "00";
							when "00011" =>				-- Deslocamento � direita l�gico 3 vezes
								temp(28 downto 0) <= temp(31 downto 3);
								temp(31 downto 29) <= "000";
							when "00100" =>				-- Deslocamento � direita l�gico 4 vezes
								temp(27 downto 0) <= temp(31 downto 4);
								temp(31 downto 28) <= "0000";
							when "00101" =>				-- Deslocamento � direita l�gico 5 vezes
								temp(26 downto 0) <= temp(31 downto 5);
								temp(31 downto 27) <= "00000";
							when "00110" =>				-- Deslocamento � direita l�gico 6 vezes
								temp(25 downto 0) <= temp(31 downto 6);
								temp(31 downto 26) <= "000000";
							when "00111" =>				-- Deslocamento � direita l�gico 7 vezes
								temp(24 downto 0) <= temp(31 downto 7);
								temp(31 downto 25) <= "0000000";
							when "01000" =>				-- Deslocamento � direita l�gico 8 vezes
								temp(23 downto 0) <= temp(31 downto 8);
								temp(31 downto 24) <= "00000000";
							when "01001" =>				-- Deslocamento � direita l�gico 9 vezes
								temp(22 downto 0) <= temp(31 downto 9);
								temp(31 downto 23) <= "000000000";
							when "01010" =>				-- Deslocamento � direita l�gico 10 vezes
								temp(21 downto 0) <= temp(31 downto 10);
								temp(31 downto 22) <= "0000000000";
							when "01011" =>				-- Deslocamento � direita l�gico 11 vezes
								temp(20 downto 0) <= temp(31 downto 11);
								temp(31 downto 21) <= "00000000000";
							when "01100" =>				-- Deslocamento � direita l�gico 12 vezes
								temp(19 downto 0) <= temp(31 downto 12);
								temp(31 downto 20) <= "000000000000";
							when "01101" =>				-- Deslocamento � direita l�gico 13 vezes
								temp(18 downto 0) <= temp(31 downto 13);
								temp(31 downto 19) <= "0000000000000";
							when "01110" =>				-- Deslocamento � direita l�gico 14 vezes
								temp(17 downto 0) <= temp(31 downto 14);
								temp(31 downto 18) <= "00000000000000";
							when "01111" =>				-- Deslocamento � direita l�gico 15 vezes
								temp(16 downto 0) <= temp(31 downto 15);
								temp(31 downto 17) <= "000000000000000";
							when "10000" =>				-- Deslocamento � direita l�gico 16 vezes
								temp(15 downto 0) <= temp(31 downto 16);
								temp(31 downto 16) <= "0000000000000000";
							when "10001" =>				-- Deslocamento � direita l�gico 17 vezes
								temp(14 downto 0) <= temp(31 downto 17);
								temp(31 downto 15) <= "00000000000000000";
							when "10010" =>				-- Deslocamento � direita l�gico 18 vezes
								temp(13 downto 0) <= temp(31 downto 18);
								temp(31 downto 14) <= "000000000000000000";
							when "10011" =>				-- Deslocamento � direita l�gico 19 vezes
								temp(12 downto 0) <= temp(31 downto 19);
								temp(31 downto 13) <= "0000000000000000000";
							when "10100" =>				-- Deslocamento � direita l�gico 20 vezes
								temp(11 downto 0) <= temp(31 downto 20);
								temp(31 downto 12) <= "00000000000000000000";
							when "10101" =>				-- Deslocamento � direita l�gico 21 vezes
								temp(10 downto 0) <= temp(31 downto 21);
								temp(31 downto 11) <= "000000000000000000000";
							when "10110" =>				-- Deslocamento � direita l�gico 22 vezes
								temp(9 downto 0) <= temp(31 downto 22);
								temp(31 downto 10) <= "0000000000000000000000";
							when "10111" =>				-- Deslocamento � direita l�gico 23 vezes
								temp(8 downto 0) <= temp(31 downto 23);
								temp(31 downto 9) <= "00000000000000000000000";
							when "11000" =>				-- Deslocamento � direita l�gico 24 vezes
								temp(7 downto 0) <= temp(31 downto 24);
								temp(31 downto 8) <= "000000000000000000000000";
							when "11001" =>				-- Deslocamento � direita l�gico 25 vezes
								temp(6 downto 0) <= temp(31 downto 25);
								temp(31 downto 7) <= "0000000000000000000000000";
							when "11010" =>				-- Deslocamento � direita l�gico 26 vezes
								temp(5 downto 0) <= temp(31 downto 26);
								temp(31 downto 6) <= "00000000000000000000000000";
							when "11011" =>				-- Deslocamento � direita l�gico 27 vezes
								temp(4 downto 0) <= temp(31 downto 27);
								temp(31 downto 5) <= "000000000000000000000000000";
							when "11100" =>				-- Deslocamento � direita l�gico 28 vezes
								temp(3 downto 0) <= temp(31 downto 28);
								temp(31 downto 4) <= "0000000000000000000000000000";
							when "11101" =>				-- Deslocamento � direita l�gico 29 vezes
								temp(2 downto 0) <= temp(31 downto 29);
								temp(31 downto 3) <= "00000000000000000000000000000";
							when "11110" =>				-- Deslocamento � direita l�gico 30 vezes
								temp(1 downto 0) <= temp(31 downto 30);
								temp(31 downto 2) <= "000000000000000000000000000000";
							when "11111" =>				-- Deslocamento � direita l�gico 31 vezes
								temp(0) <= temp(31);
								temp(31 downto 1) <= "0000000000000000000000000000000";
						end case;

					-- Deslocamento � direita aritm�tico N vezes
					when "100" =>						
						case n is
							when "00000" =>				-- Deslocamento � direita aritm�tico nenhuma vez
								temp <= temp;
							when "00001" =>				-- Deslocamento � direita aritm�tico 1 vezes
								temp(30 downto 0) <= temp(31 downto 1);
								temp(31) <= temp(31);
							when "00010" =>				-- Deslocamento � direita aritm�tico 2 vezes
								temp(29 downto 0) <= temp(31 downto 2);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "00011" =>				-- Deslocamento � direita aritm�tico 3 vezes
								temp(28 downto 0) <= temp(31 downto 3);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "00100" =>				-- Deslocamento � direita aritm�tico 4 vezes
								temp(27 downto 0) <= temp(31 downto 4);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "00101" =>				-- Deslocamento � direita aritm�tico 5 vezes
								temp(26 downto 0) <= temp(31 downto 5);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "00110" =>				-- Deslocamento � direita aritm�tico 6 vezes
								temp(25 downto 0) <= temp(31 downto 6);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "00111" =>				-- Deslocamento � direita aritm�tico 7 vezes
								temp(24 downto 0) <= temp(31 downto 7);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01000" =>				-- Deslocamento � direita aritm�tico 8 vezes
								temp(23 downto 0) <= temp(31 downto 8);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01001" =>				-- Deslocamento � direita aritm�tico 9 vezes
								temp(22 downto 0) <= temp(31 downto 9);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01010" =>				-- Deslocamento � direita aritm�tico 10 vezes
								temp(21 downto 0) <= temp(31 downto 10);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01011" =>				-- Deslocamento � direita aritm�tico 11 vezes
								temp(20 downto 0) <= temp(31 downto 11);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01100" =>				-- Deslocamento � direita aritm�tico 12 vezes
								temp(19 downto 0) <= temp(31 downto 12);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01101" =>				-- Deslocamento � direita aritm�tico 13 vezes
								temp(18 downto 0) <= temp(31 downto 13);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01110" =>				-- Deslocamento � direita aritm�tico 14 vezes
								temp(17 downto 0) <= temp(31 downto 14);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "01111" =>				-- Deslocamento � direita aritm�tico 15 vezes
								temp(16 downto 0) <= temp(31 downto 15);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);

							when "10000" =>				-- Deslocamento � direita aritm�tico 16 vezes
								temp(15 downto 0) <= temp(31 downto 16);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10001" =>				-- Deslocamento � direita aritm�tico 17 vezes
								temp(14 downto 0) <= temp(31 downto 17);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10010" =>				-- Deslocamento � direita aritm�tico 18 vezes
								temp(13 downto 0) <= temp(31 downto 18);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10011" =>				-- Deslocamento � direita aritm�tico 19 vezes
								temp(12 downto 0) <= temp(31 downto 19);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10100" =>				-- Deslocamento � direita aritm�tico 20 vezes
								temp(11 downto 0) <= temp(31 downto 20);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10101" =>				-- Deslocamento � direita aritm�tico 21 vezes
								temp(10 downto 0) <= temp(31 downto 21);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10110" =>				-- Deslocamento � direita aritm�tico 22 vezes
								temp(9 downto 0) <= temp(31 downto 22);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "10111" =>				-- Deslocamento � direita aritm�tico 23 vezes
								temp(8 downto 0) <= temp(31 downto 23);
								temp(9) <= temp(31);
								temp(10) <= temp(31);				
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11000" =>				-- Deslocamento � direita aritm�tico 24 vezes
								temp(7 downto 0) <= temp(31 downto 24);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11001" =>				-- Deslocamento � direita aritm�tico 25 vezes
								temp(6 downto 0) <= temp(31 downto 25);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11010" =>				-- Deslocamento � direita aritm�tico 26 vezes
								temp(5 downto 0) <= temp(31 downto 26);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11011" =>				-- Deslocamento � direita aritm�tico 27 vezes
								temp(4 downto 0) <= temp(31 downto 27);
								temp(5) <= temp(31);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11100" =>				-- Deslocamento � direita aritm�tico 28 vezes
								temp(3 downto 0) <= temp(31 downto 28);
								temp(4) <= temp(31);
								temp(5) <= temp(31);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11101" =>				-- Deslocamento � direita aritm�tico 29 vezes
								temp(2 downto 0) <= temp(31 downto 29);
								temp(3) <= temp(31);
								temp(4) <= temp(31);
								temp(5) <= temp(31);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11110" =>				-- Deslocamento � direita aritm�tico 30 vezes
								temp(1 downto 0) <= temp(31 downto 30);
								temp(2) <= temp(31);
								temp(3) <= temp(31);
								temp(4) <= temp(31);
								temp(5) <= temp(31);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
							when "11111" =>				-- Deslocamento � direita aritm�tico 31 vezes
								temp(0) <= temp(31);
								temp(1) <= temp(31);
								temp(2) <= temp(31);
								temp(3) <= temp(31);
								temp(4) <= temp(31);
								temp(5) <= temp(31);
								temp(6) <= temp(31);
								temp(7) <= temp(31);
								temp(8) <= temp(31);
								temp(9) <= temp(31);
								temp(10) <= temp(31);
								temp(11) <= temp(31);
								temp(12) <= temp(31);
								temp(13) <= temp(31);
								temp(14) <= temp(31);
								temp(15) <= temp(31);
								temp(16) <= temp(31);
								temp(17) <= temp(31);
								temp(18) <= temp(31);
								temp(19) <= temp(31);
								temp(20) <= temp(31);
								temp(21) <= temp(31);
								temp(22) <= temp(31);
								temp(23) <= temp(31);
								temp(24) <= temp(31);
								temp(25) <= temp(31);
								temp(26) <= temp(31);
								temp(27) <= temp(31);
								temp(28) <= temp(31);
								temp(29) <= temp(31);
								temp(30) <= temp(31);
								temp(31) <= temp(31);
						end case;

					-- Rota��o � direita N vezes
					when "101" =>						
						case n is
							when "00000" =>				-- Rota��o � direita nenhuma vez
								temp <= temp;
							when "00001" =>				-- Rota��o � direita 1 vez
								temp(30 downto 0) <= temp(31 downto 1);
								temp(31) <= temp(0);
							when "00010" =>				-- Rota��o � direita 2 vezes
								temp(29 downto 0) <= temp(31 downto 2);
								temp(31 downto 30) <= temp(1 downto 0);
							when "00011" =>				-- Rota��o � direita 3 vezes
								temp(28 downto 0) <= temp(31 downto 3);
								temp(31 downto 29) <= temp(2 downto 0);
							when "00100" =>				-- Rota��o � direita 4 vezes
								temp(27 downto 0) <= temp(31 downto 4);
								temp(31 downto 28) <= temp(3 downto 0);
							when "00101" =>				-- Rota��o � direita 5 vezes
								temp(26 downto 0) <= temp(31 downto 5);
								temp(31 downto 27) <= temp(4 downto 0);
							when "00110" =>				-- Rota��o � direita 6 vezes
								temp(25 downto 0) <= temp(31 downto 6);
								temp(31 downto 26) <= temp(5 downto 0);
							when "00111" =>				-- Rota��o � direita 7 vezes
								temp(24 downto 0) <= temp(31 downto 7);
								temp(31 downto 25) <= temp(6 downto 0);
							when "01000" =>				-- Rota��o � direita 8 vezes
								temp(23 downto 0) <= temp(31 downto 8);
								temp(31 downto 24) <= temp(7 downto 0);
							when "01001" =>				-- Rota��o � direita 9 vezes
								temp(22 downto 0) <= temp(31 downto 9);
								temp(31 downto 23) <= temp(8 downto 0);
							when "01010" =>				-- Rota��o � direita 10 vezes
								temp(21 downto 0) <= temp(31 downto 10);
								temp(31 downto 22) <= temp(9 downto 0);
							when "01011" =>				-- Rota��o � direita 11 vezes
								temp(20 downto 0) <= temp(31 downto 11);
								temp(31 downto 21) <= temp(10 downto 0);
							when "01100" =>				-- Rota��o � direita 12 vezes
								temp(19 downto 0) <= temp(31 downto 12);
								temp(31 downto 20) <= temp(11 downto 0);
							when "01101" =>				-- Rota��o � direita 13 vezes
								temp(18 downto 0) <= temp(31 downto 13);
								temp(31 downto 19) <= temp(12 downto 0);
							when "01110" =>				-- Rota��o � direita 14 vezes
								temp(17 downto 0) <= temp(31 downto 14);
								temp(31 downto 18) <= temp(13 downto 0);
							when "01111" =>				-- Rota��o � direita 15 vezes
								temp(16 downto 0) <= temp(31 downto 15);
								temp(31 downto 17) <= temp(14 downto 0);
							when "10000" =>				-- Rota��o � direita 16 vezes
								temp(15 downto 0) <= temp(31 downto 16);
								temp(31 downto 16) <= temp(15 downto 0);
							when "10001" =>				-- Rota��o � direita 17 vezes
								temp(14 downto 0) <= temp(31 downto 17);
								temp(31 downto 15) <= temp(16 downto 0);
							when "10010" =>				-- Rota��o � direita 18 vezes
								temp(13 downto 0) <= temp(31 downto 18);
								temp(31 downto 14) <= temp(17 downto 0);
							when "10011" =>				-- Rota��o � direita 19 vezes
								temp(12 downto 0) <= temp(31 downto 19);
								temp(31 downto 13) <= temp(18 downto 0);
							when "10100" =>				-- Rota��o � direita 20 vezes
								temp(11 downto 0) <= temp(31 downto 20);
								temp(31 downto 12) <= temp(19 downto 0);
							when "10101" =>				-- Rota��o � direita 21 vezes
								temp(10 downto 0) <= temp(31 downto 21);
								temp(31 downto 11) <= temp(20 downto 0);
							when "10110" =>				-- Rota��o � direita 22 vezes
								temp(9 downto 0) <= temp(31 downto 22);
								temp(31 downto 10) <= temp(21 downto 0);
							when "10111" =>				-- Rota��o � direita 23 vezes
								temp(8 downto 0) <= temp(31 downto 23);
								temp(31 downto 9) <= temp(22 downto 0);
							when "11000" =>				-- Rota��o � direita 24 vezes
								temp(7 downto 0) <= temp(31 downto 24);
								temp(31 downto 8) <= temp(23 downto 0);
							when "11001" =>				-- Rota��o � direita 25 vezes
								temp(6 downto 0) <= temp(31 downto 25);
								temp(31 downto 7) <= temp(24 downto 0);
							when "11010" =>				-- Rota��o � direita 26 vezes
								temp(5 downto 0) <= temp(31 downto 26);
								temp(31 downto 6) <= temp(25 downto 0);
							when "11011" =>				-- Rota��o � direita 27 vezes
								temp(4 downto 0) <= temp(31 downto 27);
								temp(31 downto 5) <= temp(26 downto 0);
							when "11100" =>				-- Rota��o � direita 28 vezes
								temp(3 downto 0) <= temp(31 downto 28);
								temp(31 downto 4) <= temp(27 downto 0);
							when "11101" =>				-- Rota��o � direita 29 vezes
								temp(2 downto 0) <= temp(31 downto 29);
								temp(31 downto 3) <= temp(28 downto 0);
							when "11110" =>				-- Rota��o � direita 30 vezes
								temp(1 downto 0) <= temp(31 downto 30);
								temp(31 downto 2) <= temp(29 downto 0);
							when "11111" =>				-- Rota��o � direita 31 vezes
								temp(0) <= temp(31);
								temp(31 downto 1) <= temp(30 downto 0);
						end case;

					-- Rota��o � esquerda N vezes
					when "110" =>						
						case n is
							when "00000" =>				-- Rota��o � esquerda nenhuma vez
								temp <= temp;
							when "00001" =>				-- Rota��o � esquerda 1 vez
								temp(0) <= temp(31);
								temp(31 downto 1) <= temp(30 downto 0);
							when "00010" =>				-- Rota��o � esquerda 2 vezes
								temp(1 downto 0) <= temp(31 downto 30);
								temp(31 downto 2) <= temp(29 downto 0);
							when "00011" =>				-- Rota��o � esquerda 3 vezes
								temp(2 downto 0) <= temp(31 downto 29);
								temp(31 downto 3) <= temp(28 downto 0);
							when "00100" =>				-- Rota��o � esquerda 4 vezes
								temp(3 downto 0) <= temp(31 downto 28);
								temp(31 downto 4) <= temp(27 downto 0);
							when "00101" =>				-- Rota��o � esquerda 5 vezes
								temp(4 downto 0) <= temp(31 downto 27);
								temp(31 downto 5) <= temp(26 downto 0);
							when "00110" =>				-- Rota��o � esquerda 6 vezes
								temp(5 downto 0) <= temp(31 downto 26);
								temp(31 downto 6) <= temp(25 downto 0);
							when "00111" =>				-- Rota��o � esquerda 7 vezes
								temp(6 downto 0) <= temp(31 downto 25);
								temp(31 downto 7) <= temp(24 downto 0);
							when "01000" =>				-- Rota��o � esquerda 8 vezes
								temp(7 downto 0) <= temp(31 downto 24);
								temp(31 downto 8) <= temp(23 downto 0);
							when "01001" =>				-- Rota��o � esquerda 9 vezes
								temp(8 downto 0) <= temp(31 downto 23);
								temp(31 downto 9) <= temp(22 downto 0);
							when "01010" =>				-- Rota��o � esquerda 10 vezes
								temp(9 downto 0) <= temp(31 downto 22);
								temp(31 downto 10) <= temp(21 downto 0);
							when "01011" =>				-- Rota��o � esquerda 11 vezes
								temp(10 downto 0) <= temp(31 downto 21);
								temp(31 downto 11) <= temp(20 downto 0);
							when "01100" =>				-- Rota��o � esquerda 12 vezes
								temp(11 downto 0) <= temp(31 downto 20);
								temp(31 downto 12) <= temp(19 downto 0);
							when "01101" =>				-- Rota��o � esquerda 13 vezes
								temp(12 downto 0) <= temp(31 downto 19);
								temp(31 downto 13) <= temp(18 downto 0);
							when "01110" =>				-- Rota��o � esquerda 14 vezes
								temp(13 downto 0) <= temp(31 downto 18);
								temp(31 downto 14) <= temp(17 downto 0);
							when "01111" =>				-- Rota��o � esquerda 15 vezes
								temp(14 downto 0) <= temp(31 downto 17);
								temp(31 downto 15) <= temp(16 downto 0);
							when "10000" =>				-- Rota��o � esquerda 16 vezes
								temp(15 downto 0) <= temp(31 downto 16);
								temp(31 downto 16) <= temp(15 downto 0);
							when "10001" =>				-- Rota��o � esquerda 17 vezes
								temp(16 downto 0) <= temp(31 downto 15);
								temp(31 downto 17) <= temp(14 downto 0);
							when "10010" =>				-- Rota��o � esquerda 18 vezes
								temp(17 downto 0) <= temp(31 downto 14);
								temp(31 downto 18) <= temp(13 downto 0);
							when "10011" =>				-- Rota��o � esquerda 19 vezes
								temp(18 downto 0) <= temp(31 downto 13);
								temp(31 downto 19) <= temp(12 downto 0);
							when "10100" =>				-- Rota��o � esquerda 20 vezes
								temp(19 downto 0) <= temp(31 downto 12);
								temp(31 downto 20) <= temp(11 downto 0);
							when "10101" =>				-- Rota��o � esquerda 21 vezes
								temp(20 downto 0) <= temp(31 downto 11);
								temp(31 downto 21) <= temp(10 downto 0);
							when "10110" =>				-- Rota��o � esquerda 22 vezes
								temp(21 downto 0) <= temp(31 downto 10);
								temp(31 downto 22) <= temp(9 downto 0);
							when "10111" =>				-- Rota��o � esquerda 23 vezes
								temp(22 downto 0) <= temp(31 downto 9);
								temp(31 downto 23) <= temp(8 downto 0);
							when "11000" =>				-- Rota��o � esquerda 24 vezes
								temp(23 downto 0) <= temp(31 downto 8);
								temp(31 downto 24) <= temp(7 downto 0);
							when "11001" =>				-- Rota��o � esquerda 25 vezes
								temp(24 downto 0) <= temp(31 downto 7);
								temp(31 downto 25) <= temp(6 downto 0);
							when "11010" =>				-- Rota��o � esquerda 26 vezes
								temp(25 downto 0) <= temp(31 downto 6);
								temp(31 downto 26) <= temp(5 downto 0);
							when "11011" =>				-- Rota��o � esquerda 27 vezes
								temp(26 downto 0) <= temp(31 downto 5);
								temp(31 downto 27) <= temp(4 downto 0);
							when "11100" =>				-- Rota��o � esquerda 28 vezes
								temp(27 downto 0) <= temp(31 downto 4);
								temp(31 downto 28) <= temp(3 downto 0);
							when "11101" =>				-- Rota��o � esquerda 29 vezes
								temp(28 downto 0) <= temp(31 downto 3);
								temp(31 downto 29) <= temp(2 downto 0);
							when "11110" =>				-- Rota��o � esquerda 30 vezes
								temp(29 downto 0) <= temp(31 downto 2);
								temp(31 downto 30) <= temp(1 downto 0);
							when "11111" =>				-- Rota��o � esquerda 31 vezes
								temp(30 downto 0) <= temp(31 downto 1);
								temp(31) <= temp(0);
						end case;

					-- Funcionalidade n�o definida
					when others =>
					-- Faz nada					
				end case;
			end if;
			Saida <= temp;	
	end process;
END behavioral_arch;

