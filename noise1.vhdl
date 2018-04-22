-- NOISE holds N ring oscillators. The ROs' outputs are XORed
-- and sample to generate a CLK synchronized bitstream.

---------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------

entity NOISE is
	generic (N: integer:=30);	
	port (
		NOISE_clk : in std_logic;
		NOISE_enRO : in std_logic;
		NOISE_out : out std_logic
	);
end NOISE;

---------------------------------------------------------------

architecture DATAFLOW of NOISE is

	component RO is
		generic (N: integer:=101);
		port(	RO_enable : in std_logic;
			RO_out : out std_logic);
	end component;

	signal INTERCON: std_logic_vector(N downto 0);
	-- The following attributes ensure, that vivado toolchain
	-- doesn't drop oscillator rings during synthesis.
	attribute DONT_TOUCH : string;
	attribute DONT_TOUCH of INTERCON : signal is "TRUE";
	attribute ALLOW_COMBINATORIAL_LOOPS : string;
	attribute ALLOW_COMBINATORIAL_LOOPS of INTERCON : signal is "TRUE";
	
	signal XORSIG: std_logic;
	signal DFF_OUT: std_logic;

begin
	-- Instantiate ring oscillators
	-- NOISE_enRO is passed to individual ROs as an enable
	NBIT: for I in 0 to N generate
		RO_0: RO port map(NOISE_enRO,INTERCON(I));
	end generate NBIT;

	-- XOR individual oscillator rings
	XORSIG <= xor INTERCON;
	
	-- D-FF samples oscillator output
	DFF: process (NOISE_clk)
	begin
		if NOISE_clk'event and NOISE_clk = '1' then
			DFF_OUT <= XORSIG;
		end if;
	end process DFF;

	NOISE_out <= DFF_OUT;

end DATAFLOW;
