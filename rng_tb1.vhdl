library ieee;
use ieee.std_logic_1164.all;

entity RO_TB is
end RO_TB;

architecture TESTBENCH of RO_TB is
	component RO is
		port(RO_enable : in bit; RO_out : out bit);
	end component;
	for DUT: RO use entity work.RO;
	signal RO_enable,RO_out:bit;

begin
		DUT: RO port map(RO_enable=>RO_enable,RO_out=>RO_out);

		stim_proc:process
		begin
			RO_enable <= '1';
			wait for 4 ns;
		end process stim_proc;
end TESTBENCH;	
