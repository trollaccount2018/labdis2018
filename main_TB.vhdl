library ieee;
use ieee.std_logic_1164.all;

entity main_TB is
end main_TB;

architecture TESTBENCH of main_TB is
	component main is
		generic (m : natural :=128);
		port ( 	CLK		: in std_logic;
			UART_TX_PIN	: out std_logic;
			LED		: out std_logic_vector(7 downto 0);
			RST		: in std_logic
		);
	end component;

	signal CLK : std_logic := '0';
	signal UART_TX_PIN : std_logic;
	signal LED : std_logic_vector(7 downto 0);
	signal RST : std_logic := '0';

begin
	CLK <= not CLK after 5 ns;
	RST <= '1', '0' after 5 ns;

	DUT: main generic map (128) port map (CLK,UART_TX_PIN,LED,RST);
	
end TESTBENCH;

