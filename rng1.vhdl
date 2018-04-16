library ieee;
use ieee.std_logic_1164.all;

-- Ring Oscillator of N inverters
entity RO is
	generic (N: integer:=101);
	port (RO_enable: in std_logic; RO_out : out std_logic);
end RO;

architecture DATAFLOW of RO is

	signal INTERCON: std_logic_vector(N downto 0);
	attribute DONT_TOUCH : string;
	attribute DONT_TOUCH of INTERCON : signal is "TRUE";
	attribute ALLOW_COMBINATORIAL_LOOPS : string;
	attribute ALLOW_COMBINATORIAL_LOOPS of INTERCON : signal is "TRUE";

begin	
	NBIT: for I in 1 to N generate
		INTERCON(I) <= not INTERCON(I-1);
	end generate NBIT;
	
	--gated
	--INTERCON(0) <= (not INTERCON(N)) and RO_enable;
	
	-- not gated
	INTERCON(0) <= not INTERCON(N);
	
	RO_out <= INTERCON(0);
	
	--debugging:
	--RO_out <= '1';
end DATAFLOW;

	
