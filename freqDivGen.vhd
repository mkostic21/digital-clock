library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity freqDivGen is
	generic(nfclk: natural:=24000000);
	port (clk: in std_logic:='0';
			clk_o: buffer std_logic:='0');
end freqDivGen;

architecture Behavioral of freqDivGen is
begin
	process(clk)
		variable temp: integer range 0 to nfclk/2:=0;
	begin
		if rising_edge(clk) then
			temp:=temp+1;
			if(temp>=nfclk/2) then
				clk_o<= not clk_o;
				temp:=0;
			end if;
		end if;
	end process;
end Behavioral;
