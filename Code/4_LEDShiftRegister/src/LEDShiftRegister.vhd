library ieee;
use ieee.std_logic_1164.all;

entity LEDShiftRegister is 
port
(
	rst : in std_logic;	-- Reset push button, asserted low.
	clk : in std_logic;	-- 50 MHz
	sw1 : in std_logic;	-- Asserted low
	
	led : out std_logic_vector(1 to 4)
);
end entity;


architecture rtl of LEDShiftRegister is 

constant DebouncePeriod : integer:= 2500000; 

signal ButtonPressed		: std_logic;
signal ShiftReg 			: std_logic_vector(1 to 4);
signal sync					: std_logic_vector(1 downto 0);	-- Used to Sync sw1 pressing
signal delayedSwitch 	: std_logic;
signal Counter 			: integer;
signal DebouncedSW1		: std_logic;

begin

	led <= ShiftReg;

	SyncProcess: process(rst, clk) 	-- Sync Button Press to avoid glitches caused to Async operations
	begin
		if rst = '0' then
			sync <= "11";
		elsif rising_edge(clk) then
				sync(0) <= sw1;
				sync(1) <= sync(0);
		end if;
	end process;
	
	DebouceProcess:process(rst, clk)
	begin
		if rst = '0' then
			Counter <= 0;
			DebouncedSW1 <= '1';
		elsif rising_edge(clk) then
			if sync(1) = '0' then
				-- If the switch is in the active state
			   if Counter < DebouncePeriod then
					Counter <= Counter + 1;
				end if;
			else
				-- If the switch is in the inactive state			
				if Counter > 0 then
					Counter <= Counter - 1;
				end if;
			end if;
			
			if Counter = DebouncePeriod then
				DebouncedSW1 <= '0';
			elsif Counter = 0 then
				DebouncedSW1 <= '1';
			end if;
			
		end if;
	end process;
	
	ButtonPressDetect: process(rst, clk)
	begin
		if rst = '0' then
			delayedSwitch <= '1';
		elsif rising_edge(clk) then
		
			delayedSwitch <= DebouncedSW1;
		
			if DebouncedSW1 = '0' and delayedSwitch = '1' then
				ButtonPressed <= '1';
			else 
				ButtonPressed <= '0';
			end if;
			
		end if;
	end process;
	
	ShiftProcess: process(rst, clk)
	begin
		if rst = '0' then
			ShiftReg <= "0111";
			
		elsif rising_edge(clk) then
			if ButtonPressed = '1' then
				ShiftReg <= ShiftReg(4) & ShiftReg(1 to 3);			
			end if;
		end if;
	end process;

end rtl;