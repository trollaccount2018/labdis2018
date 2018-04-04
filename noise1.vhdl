-- NOISE holds N ring oscillators. The ROs' outputs are XORed
-- and sample to generate a CLK synchronized bitstream.

---------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

---------------------------------------------------------------

entity NOISE is
	generic (N: integer:=733);
	port (
		NOISE_clk : in std_logic;
		NOISE_enRO : in std_logic;
		NOISE_out : out std_logic);
end NOISE;

---------------------------------------------------------------

architecture DATAFLOW of NOISE is

	component RO is
		port(	RO_enable : in std_logic;
			RO_out : out std_logic);
	end component;

	signal INTERCON: std_logic_vector(N downto 0);
	signal XORSIG: std_logic;
	signal DFF_OUT: std_logic;
begin
	-- Instantiate ring oscillators
	-- NOISE_enRO is passed to individual ROs as an enable
	NBIT: for I in 0 to N generate
		RO_0: RO port map(NOISE_enRO,INTERCON(I));
	end generate NBIT;

	-- XOR outputs
	XORSIG <= xor_reduce(INTERCON);

	-- D-FF
	DFF: process (NOISE_clk)
	begin
		if NOISE_clk'event and NOISE_clk = '1' then
			DFF_OUT <= XORSIG;
		end if;
	end process DFF;

	NOISE_out <= DFF_OUT;

end DATAFLOW;
