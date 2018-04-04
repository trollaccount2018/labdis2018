library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture tb of top_tb is

	component top is
		port(	RST : in std_logic;
			BTNR : in std_logic;
			CLK : in std_logic;
			UART_TX_PIN : out std_logic;
			LED : out std_logic_vector(7 downto 0)
		);
	end component;

	signal RST : std_logic;
	signal BTNR : std_logic;
	signal CLK : std_logic := '0';
	signal UART_TX_PIN : std_logic;
	signal LED : std_logic_vector(7 downto 0);

begin
	CLK <= not CLK after 10 ns;
	RST <= '0','1' after 20 ns;
	BTNR <= '0','1' after 100 ns;


	DUT: top port map(RST,BTNR,CLK,UART_TX_PIN,LED);
end tb;
