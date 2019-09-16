library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity d_clock is
	port (clk:in std_logic;
			anode: out std_logic_vector(3 downto 0);
			led_segments: out std_logic_vector(6 downto 0);
			dp: out std_logic:='0');
end d_clock;

architecture Behavioral of d_clock is
	signal min1: std_logic_vector(3 downto 0):="0000";
	signal min10: std_logic_vector(3 downto 0):="0000";
	signal hour1: std_logic_vector(3 downto 0):="0000";
	signal hour10: std_logic_vector(3 downto 0):="0000";
	signal sec: integer range 0 to 59:=0;
	signal min1_temp: integer range 0 to 9:=0;
	signal min10_temp: integer range 0 to 5:=0;
	signal hour1_temp: integer range 0 to 9:=0;
	signal hour10_temp: integer range 0 to 2:=0;
	signal clk_o: std_logic; 
	signal anode_clk: std_logic; 
	signal hex: std_logic_vector(15 downto 0); 
	signal digit: std_logic_vector(3 downto 0);
	signal anode_counter: std_logic_vector(1 downto 0);
begin
	fr: entity work.freqDivGen generic map(24000000) port map(clk,clk_o);
	an_fr: entity work.freqDivGen generic map(120000) port map(clk, anode_clk);
	dek: entity work.dek_sed port map(digit,led_segments);
	
	process(clk_o)
	begin
		if rising_edge(clk_o) then
			sec <= sec+1;
			if(sec>=59) then
				min1_temp<=min1_temp+1;
				sec<=0;
			end if;
			if(min1_temp=10) then
				min1_temp<=0;
				min10_temp<=min10_temp+1;
			end if;
			if(min10_temp=6) then
				min10_temp<=0;
				hour1_temp<=hour1_temp+1;
			end if;
			if(hour1_temp=10) then
				hour1_temp<=0;
				hour10_temp<=hour10_temp+1;
			end if;
			if(hour10_temp=2 and hour1_temp=3 and min10_temp=5 and min1_temp=9 and sec=59) then
				hour10_temp<=0;
				hour1_temp<=0;
				min10_temp<=0;
				min1_temp<=0;
				sec<=0;
			end if;
		end if;
		min1 <= conv_std_logic_vector(min1_temp,4);
		min10 <= conv_std_logic_vector(min10_temp,4);
		hour1 <= conv_std_logic_vector(hour1_temp,4);
		hour10 <= conv_std_logic_vector(hour10_temp,4);
		hex <= min1 & min10 & hour1 & hour10;
	end process;
	
	process(anode_clk)
	begin
		if rising_edge(anode_clk) then
			anode_counter<=anode_counter+1;
		end if;
		case anode_counter is
			when "00" => 
				anode <= "1000";
				digit <= hex(15 downto 12);
			when "01" =>
				anode <= "0100";
				digit <= hex(11 downto 8);
			when "10" =>
				anode <= "0010";
				digit <= hex(7 downto 4);
			when others =>
				anode <= "0001";
				digit <= hex(3 downto 0);
		end case;
	end process;
end Behavioral;