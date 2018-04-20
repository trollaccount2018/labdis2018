-------------------------------------------------------------------------------
--
-- 7-segment display
-- Source: http://vhdlguru.blogspot.co.at/2010/03/vhdl-code-for-bcd-to-7-segment-display.html
--
-------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
--
-------------------------------------------------------------------------------
--
entity sevenseg is

	port (
		clk	: in std_logic;
		bcd	: in std_logic_vector(3 downto 0);  -- BCD input
		CA	: out std_logic_vector(7 downto 0)  -- 7 bit decoded output.
	);

end sevenseg;
--
-------------------------------------------------------------------------------
--
-- NOTE: 'a' corresponds to MSB of segment7 and 'g' corresponds to LSB of
--	segment7:
--
architecture behavioral of sevenseg is
begin

	process (clk,bcd)
	begin

		if (clk'event and clk='1') then
			case  bcd is

				--------------------------abcdefg.----------
				when "0000"=> CA <="11000000";  -- '0'
				when "0001"=> CA <="11111001";  -- '1'
				when "0010"=> CA <="10100100";  -- '2'
				when "0011"=> CA <="10110000";  -- '3'
				when "0100"=> CA <="10011001";  -- '4'
				when "0101"=> CA <="10010010";  -- '5'
				when "0110"=> CA <="10000010";  -- '6'
				when "0111"=> CA <="11111000";  -- '7'
				when "1000"=> CA <="10000000";  -- '8'
				when "1001"=> CA <="10010000";  -- '9'
				when "1010"=> CA <="10001000";  -- 'A'
				when "1011"=> CA <="10000011";  -- 'B'
				when "1100"=> CA <="11000110";  -- 'C'
				when "1101"=> CA <="10100001";  -- 'D'
				when "1110"=> CA <="10000110";  -- 'E'
				when "1111"=> CA <="10001110";  -- 'F'

				--nothing is displayed when a number more than 9 is given as input.
				when others=> CA <="11111111";

			end case;

		end if;

	end process;

end behavioral;
--
-------------------------------------------------------------------------------
