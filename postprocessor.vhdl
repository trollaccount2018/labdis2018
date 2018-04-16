-- crypto postprocessor

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------

entity postprocessor is
	
	generic ( m : integer := 128 );

	port (
		clk	: in std_logic;
		s	: in std_logic_vector(m-1 downto 0);
		r	: out std_logic_vector(m-1 downto 0)
	);

end postprocessor;

-------------------------------------------------------------------------

architecture behaviour of postprocessor is

begin

	process (clk)
    		variable h : std_logic;
		type array_type is array (m-1 downto 0 , m-1 downto 0) of std_logic;
		variable G : array_type;
	begin
		for i in 0 to m-1 loop
            		for j in 0 to m-1 loop
				--h := h XOR ( s(j) AND G(i,j) );
				if (i=j) then
					h := s(j);
				end if;
            		end loop;
            		r(i) <= h;
        	end loop;
	end process;

end behaviour;

