library ieee;
use ieee.std_logic_1164.all;

entity BaudClkGenerator is
    generic (
        NUMBER_OF_CLOCKS    : INTEGER;
        SYS_CLK_FREQ        : INTEGER;
        BAUD_RATE           : INTEGER
            
    );
    port (
        Clk     : in std_logic;   -- 50MHz
        Rst     : in std_logic;
        
        Start   : in std_logic;
        BaudClk : out std_logic;
        Ready   : out std_logic 
    );
end entity;

architecture rtl of BaudClkGenerator is
    
    constant BIT_PERIOD : INTEGER := SYS_CLK_FREQ / BAUD_RATE;

    -- Signals
    signal BitPeriodCounter : integer range 0 to BIT_PERIOD;
    signal ClocksLeft       : integer range 0 to NUMBER_OF_CLOCKS;

begin

    BitPeriodProcess:process (Rst, Clk)
    begin
        if Rst = '1' then
            BaudClk <= '0';
            BitPeriodCounter <= 0;
        elsif rising_edge(Clk) then
            if ClocksLeft > 0 then
                if BitPeriodCounter = BIT_PERIOD then
                    BaudClk <= '1';
                    BitPeriodCounter <= 0;
                else
                    BaudClk <= '0';
                    BitPeriodCounter <= BitPeriodCounter + 1;
                end if;
            else
                -- if ClocksLeft = 0 then:
                BaudClk <= '0';
                BitPeriodCounter<= 0;
            end if;
        end if;
    end process;

    BeginOrEndBaudClk:process (Rst, Clk)
    begin
        if Rst = '1' then
         ClocksLeft <= 0;
        elsif rising_edge(Clk) then
            if Start = '1' then
                ClocksLeft <= NUMBER_OF_CLOCKS;
            elsif BaudClk = '1' then
                ClocksLeft <= ClocksLeft - 1;
            end if;    
        end if;
    end process;

    GenerateReady:process (Rst, Clk)
    begin
        if Rst = '1' then
            Ready <= '0';
        elsif rising_edge(Clk) then
            if Start = '1' then
                Ready <= '0';
            elsif ClocksLeft = 0 then
                Ready <= '1';
            end if;
        end if;
    end process;

end rtl;