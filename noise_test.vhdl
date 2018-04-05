-- NOISE holds N ring oscillators. The ROs' outputs are XORed
-- and sample to generate a CLK synchronized bitstream.

---------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_misc.all;

---------------------------------------------------------------

entity NOISE is
	generic (N: integer:=10);
	port (
		NOISE_clk : in std_logic;
		NOISE_enRO : in std_logic;
		NOISE_out : out std_logic);
end NOISE;

---------------------------------------------------------------

architecture DATAFLOW of NOISE is

--	component RO is
--		port(	RO_enable : in std_logic;
--			RO_out : out std_logic);
--	end component;

--	signal INTERCON: std_logic_vector(9 downto 0);
	signal XORSIG: std_logic;
	signal DFF_OUT: std_logic;

	signal CON1: std_logic_vector(9 downto 0) := "1011101001";
	signal CON2: std_logic_vector(9 downto 0) := "1011101001";
	signal CON3: std_logic_vector(9 downto 0) := "1011101001";
	signal CON4: std_logic_vector(9 downto 0) := "1011101001";
	signal CON5: std_logic_vector(9 downto 0) := "1011101001";
	signal CON6: std_logic_vector(9 downto 0) := "1011101001";
	signal CON7: std_logic_vector(9 downto 0) := "1011101001";
	signal CON8: std_logic_vector(9 downto 0) := "1011101001";
	signal CON9: std_logic_vector(9 downto 0) := "1011101001";
	signal CON10: std_logic_vector(9 downto 0) := "1011101001";

begin
	-- Instantiate ring oscillators
	-- NOISE_enRO is passed to individual ROs as an enable
--	NBIT: for I in 0 to N generate
--		RO_0: RO port map(NOISE_enRO,INTERCON(I));
--	end generate NBIT;

--	-- XOR outputs
--	XORSIG <= xor_reduce(INTERCON);

	CON1(0) <=   inertial (not CON1(1)) after 3 ns;
	CON1(1) <=   inertial (not CON1(2)) after 5 ns;
	CON1(2) <=   inertial (not CON1(3)) after 8 ns;
	CON1(3) <=   inertial (not CON1(4)) after 4 ns;
	CON1(4) <=   inertial (not CON1(5)) after 2 ns;
	CON1(5) <=   inertial (not CON1(6)) after 5 ns;
	CON1(6) <=   inertial (not CON1(7)) after 3 ns;
	CON1(7) <=   inertial (not CON1(8)) after 9 ns;
	CON1(8) <=   inertial (not CON1(9)) after 7 ns;
	CON1(9) <=   inertial (not CON1(0)) after 1 ns;

	CON2(0) <=   inertial (not CON2(1)) after 3 ns;
	CON2(1) <=   inertial (not CON2(2)) after 5 ns;
	CON2(2) <=   inertial (not CON2(3)) after 8 ns;
	CON2(3) <=   inertial (not CON2(4)) after 4 ns;
	CON2(4) <=   inertial (not CON2(5)) after 2 ns;
	CON2(5) <=   inertial (not CON2(6)) after 5 ns;
	CON2(6) <=   inertial (not CON2(7)) after 3 ns;
	CON2(7) <=   inertial (not CON2(8)) after 9 ns;
	CON2(8) <=   inertial (not CON2(9)) after 7 ns;
	CON2(9) <=   inertial (not CON2(0)) after 1 ns;

	CON3(0) <=   inertial (not CON3(1)) after 4 ns;
	CON3(1) <=   inertial (not CON3(2)) after 5 ns;
	CON3(2) <=   inertial (not CON3(3)) after 7 ns;
	CON3(3) <=   inertial (not CON3(4)) after 3 ns;
	CON3(4) <=   inertial (not CON3(5)) after 4 ns;
	CON3(5) <=   inertial (not CON3(6)) after 5 ns;
	CON3(6) <=   inertial (not CON3(7)) after 3 ns;
	CON3(7) <=   inertial (not CON3(8)) after 4 ns;
	CON3(8) <=   inertial (not CON3(9)) after 5 ns;
	CON3(9) <=   inertial (not CON3(0)) after 3 ns;

	CON4(0) <=   inertial (not CON4(1)) after 3 ns;
	CON4(1) <=   inertial (not CON4(2)) after 4 ns;
	CON4(2) <=   inertial (not CON4(3)) after 7 ns;
	CON4(3) <=   inertial (not CON4(4)) after 2 ns;
	CON4(4) <=   inertial (not CON4(5)) after 3 ns;
	CON4(5) <=   inertial (not CON4(6)) after 3 ns;
	CON4(6) <=   inertial (not CON4(7)) after 3 ns;
	CON4(7) <=   inertial (not CON4(8)) after 2 ns;
	CON4(8) <=   inertial (not CON4(9)) after 3 ns;
	CON4(9) <=   inertial (not CON4(0)) after 4 ns;

	CON5(0) <=   inertial (not CON5(1)) after 3 ns;
	CON5(1) <=   inertial (not CON5(2)) after 3 ns;
	CON5(2) <=   inertial (not CON5(3)) after 8 ns;
	CON5(3) <=   inertial (not CON5(4)) after 4 ns;
	CON5(4) <=   inertial (not CON5(5)) after 3 ns;
	CON5(5) <=   inertial (not CON5(6)) after 3 ns;
	CON5(6) <=   inertial (not CON5(7)) after 4 ns;
	CON5(7) <=   inertial (not CON5(8)) after 5 ns;
	CON5(8) <=   inertial (not CON5(9)) after 6 ns;
	CON5(9) <=   inertial (not CON5(0)) after 4 ns;

	CON6(0) <=   inertial (not CON6(1)) after 2 ns;
	CON6(1) <=   inertial (not CON6(2)) after 3 ns;
	CON6(2) <=   inertial (not CON6(3)) after 6 ns;
	CON6(3) <=   inertial (not CON6(4)) after 5 ns;
	CON6(4) <=   inertial (not CON6(5)) after 4 ns;
	CON6(5) <=   inertial (not CON6(6)) after 5 ns;
	CON6(6) <=   inertial (not CON6(7)) after 4 ns;
	CON6(7) <=   inertial (not CON6(8)) after 3 ns;
	CON6(8) <=   inertial (not CON6(9)) after 4 ns;
	CON6(9) <=   inertial (not CON6(0)) after 2 ns;

	CON7(0) <=   inertial (not CON7(1)) after 3 ns;
	CON7(1) <=   inertial (not CON7(2)) after 4 ns;
	CON7(2) <=   inertial (not CON7(3)) after 6 ns;
	CON7(3) <=   inertial (not CON7(4)) after 3 ns;
	CON7(4) <=   inertial (not CON7(5)) after 2 ns;
	CON7(5) <=   inertial (not CON7(6)) after 3 ns;
	CON7(6) <=   inertial (not CON7(7)) after 4 ns;
	CON7(7) <=   inertial (not CON7(8)) after 2 ns;
	CON7(8) <=   inertial (not CON7(9)) after 3 ns;
	CON7(9) <=   inertial (not CON7(0)) after 2 ns;

	CON8(0) <=   inertial (not CON8(1)) after 4 ns;
	CON8(1) <=   inertial (not CON8(2)) after 2 ns;
	CON8(2) <=   inertial (not CON8(3)) after 3 ns;
	CON8(3) <=   inertial (not CON8(4)) after 7 ns;
	CON8(4) <=   inertial (not CON8(5)) after 6 ns;
	CON8(5) <=   inertial (not CON8(6)) after 3 ns;
	CON8(6) <=   inertial (not CON8(7)) after 3 ns;
	CON8(7) <=   inertial (not CON8(8)) after 9 ns;
	CON8(8) <=   inertial (not CON8(9)) after 3 ns;
	CON8(9) <=   inertial (not CON8(0)) after 4 ns;

	CON9(0) <=   inertial (not CON9(1)) after 7 ns;
	CON9(1) <=   inertial (not CON9(2)) after 6 ns;
	CON9(2) <=   inertial (not CON9(3)) after 5 ns;
	CON9(3) <=   inertial (not CON9(4)) after 2 ns;
	CON9(4) <=   inertial (not CON9(5)) after 3 ns;
	CON9(5) <=   inertial (not CON9(6)) after 6 ns;
	CON9(6) <=   inertial (not CON9(7)) after 5 ns;
	CON9(7) <=   inertial (not CON9(8)) after 4 ns;
	CON9(8) <=   inertial (not CON9(9)) after 7 ns;
	CON9(9) <=   inertial (not CON9(0)) after 2 ns;

	CON10(0) <=   inertial (not CON10(1)) after 6 ns;
	CON10(1) <=   inertial (not CON10(2)) after 5 ns;
	CON10(2) <=   inertial (not CON10(3)) after 3 ns;
	CON10(3) <=   inertial (not CON10(4)) after 8 ns;
	CON10(4) <=   inertial (not CON10(5)) after 7 ns;
	CON10(5) <=   inertial (not CON10(6)) after 5 ns;
	CON10(6) <=   inertial (not CON10(7)) after 3 ns;
	CON10(7) <=   inertial (not CON10(8)) after 8 ns;
	CON10(8) <=   inertial (not CON10(9)) after 4 ns;
	CON10(9) <=   inertial (not CON10(0)) after 6 ns;

	XORSIG <= CON1(0) XOR CON2(0) XOR CON3(0) XOR CON4(0) 
		  	  XOR CON5(0) XOR CON6(0) XOR CON7(0)
			  XOR CON8(0) XOR CON9(0) XOR CON10(0); 

	-- D-FF
	DFF: process (NOISE_clk)
	begin
		if NOISE_clk'event and NOISE_clk = '1' then
			DFF_OUT <= XORSIG;
		end if;
	end process DFF;

	NOISE_out <= DFF_OUT;

end DATAFLOW;
