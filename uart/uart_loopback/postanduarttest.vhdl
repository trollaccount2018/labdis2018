library ieee;
use ieee.std_logic_1164.all;

-----------------------------------------------------------------------

entity top is
	port ( 	RST : in std_logic; -- button N17
		BTNR : in std_logic; -- button M17
		CLK : in std_logic;
		UART_TX_PIN : out std_logic;
		LED : out std_logic_vector(7 downto 0)
		);
end top;

-----------------------------------------------------------------------

architecture beh of top is

	constant CLK_FREQ : integer := 100E6;
	constant BAUDRATE : integer := 9600;

	signal send_trans : std_logic;
	signal data_trans : std_logic_vector(7 downto 0);
	signal rdy_trans : std_logic;

	signal transmit : std_logic;
		
	component uart_tx is
		generic (
			CLK_FREQ : integer;
			BAUDRATE : integer
		);

		port(
			clk   : in std_logic;
			rst   : in std_logic;
			send  : in std_logic;
			data  : in std_logic_vector(7 downto 0);
			rdy   : out std_logic;
			tx    : out std_logic
		);
	end component;

begin
	UART_0: uart_tx generic map(CLK_FREQ, BAUDRATE) 
			port map (CLK,RST,send_trans,data_trans,rdy_trans,UART_TX_PIN);

	process(CLK)
	begin
		if (CLK'event and CLK='1') then
			if (rdy_trans = '1' and transmit <= '1') then
				send_trans <= '0';
				transmit <= '0';
			elsif (send_trans='1') then
				send_trans <= '0';
			end if;
		end if;
		
	end process;

	process(BTNR)
	begin
		if (BTNR'event and BTNR='1') then
			if (transmit='0') then
				transmit <= '1';
			end if;
		end if;
	end process;
	
	data_trans <= "01000100";
	LED(0) <= rdy_trans;
	LED(1) <= transmit;
	LED(2) <= '1';

end beh;
