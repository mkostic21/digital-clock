library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity dek_sed is --decimal numbers converted to hex for 7-segment display
	port (hex: in std_logic_vector(3 downto 0);
			led: out std_logic_vector(6 downto 0));
end dek_sed;

architecture Behavioral of dek_sed is
begin
	with hex select
		led<= "1111110" when "0000", --0
				"0110000" when "0001", --1
				"1101101" when "0010", --2
				"1111001" when "0011", --3
				"0110011" when "0100", --4
				"1011011" when "0101", --5
				"1011111" when "0110", --6
				"1110000" when "0111", --7
				"1111111" when "1000", --8
				"1111011" when "1001", --9
				"0000000" when others; --OFF
end Behavioral;

