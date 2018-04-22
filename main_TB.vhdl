library ieee;
use ieee.std_logic_1164.all;

entity main_TB is
end main_TB;

architecture TESTBENCH of main_TB is
	component main is
		generic (
			m : natural :=128; --word width
			p : natural := 733 --number of rings
		);
		port (
			CLK		: in std_logic;
			UART_TX_PIN	: out std_logic;
			RST		: in std_logic;
			BTNR		: in std_logic;
			SW0		: in std_logic;
			AN		: out std_logic_vector(7 downto 0);
			CA		: out std_logic_vector(7 downto 0)
		);
	end component;

	signal CLK 		: std_logic := '0';
	signal UART_TX_PIN 	: std_logic;
	signal RST 		: std_logic := '0';
	signal BTNR		: std_logic := '0';
	signal SW0		: std_logic := '0';
	signal AN		: std_logic_vector(7 downto 0);
	signal CA		: std_logic_vector(7 downto 0);

begin
	CLK <= not CLK after 5 ns;
	RST <= '1', '0' after 5 ns;

	-- productive mode activated after 25ns, test mode activated after 1ms
	BTNR <= '1' after 20 ns, '0' after 25 ns, '1' after 1 ms, '0' after 1001 us;
	SW0 <= '1' after 1 ms;

	DUT: main generic map (128,733) port map (CLK,UART_TX_PIN,RST,BTNR,SW0,AN,CA);
	
end TESTBENCH;

