library ieee;
use ieee.std_logic_1164.all;

entity sevendisp is
	port(
		INPUT	: in std_logic_vector(31 downto 0);
		CLK	: in std_logic;
		ENABLE	: in std_logic;
	 	AN	: out std_logic_vector(7 downto 0); --common anodes
		CA	: out std_logic_vector(7 downto 0) --sim segments
	);
end sevendisp;

architecture dataflow of sevendisp is

component sevenseg is
	port(
		CLK 	: in std_logic;
		BCD	: in std_logic_vector(3 downto 0);
		CA	: out std_logic_vector(7 downto 0)
	);
end component;

	signal BCD_BUFF : std_logic_vector(3 downto 0);

begin
	sevs:sevenseg port map(CLK,BCD_BUFF,CA);

	process(CLK)
	
		variable div : integer := 0;
		variable phase : integer := 0;

	begin
		if(CLK'event and CLK = '1') then
			div := div + 1;
			if(div = 1000) then -- clock division
				BCD_BUFF <= INPUT(3+phase*4 downto phase*4);
				AN <= (others => '1');
				if(ENABLE = '1') then
					AN(phase) <= '0';
				end if;
				phase := phase + 1;
				if(phase = 8) then
					phase := 0;
				end if;
				div := 0;
			end if;
		end if;
	end process;
end dataflow;
