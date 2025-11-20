library ieee;
use ieee.std_logic_1164.all;

entity Synchronizer is
    generic (
        IDLE_STATE : std_logic := '0'
    );
    port (
        clk     : in  std_logic;
        Rst     : in  std_logic;

        Async   : in  std_logic;
        Sync    : out std_logic
    );
end entity;

architecture rtl of Synchronizer is
    signal SR: std_logic_vector(1 downto 0);
begin
    Sync <= SR(1);

    SynchronizationProcess : process (clk, Rst)
    begin
        if Rst = '1' then
            SR <= (others => IDLE_STATE);
        elsif rising_edge(clk) then
            SR(0) <= Async;
            SR(1) <= SR(0);
        end if;
    end process;

end architecture;