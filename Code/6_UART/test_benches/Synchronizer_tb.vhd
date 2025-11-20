library ieee;
use ieee.std_logic_1164.all;

entity Synchronizer_tb is
end entity;

architecture rtl of Synchronizer_tb is
   component Synchronizer is
        generic 
        (
            IDLE_STATE : std_logic
        );
        port
        (
            Clk     : in  std_logic;
            Rst     : in  std_logic;
            Async   : in  std_logic;
            Sync    : out std_logic
        );
    end component;

    signal Clk     : std_logic;
    signal Rst     : std_logic;
    signal Async   : std_logic;
    signal Sync    : std_logic;
begin
    Clk <= not Clk after 10 ns;

    UUT: Synchronizer
        generic map 
        (
            IDLE_STATE => '1'
        );
        port map 
        (
            Clk     => Clk,
            Rst     => Rst,
            Async   => Async,
            Sync    => Sync
        );

    TestProcess : process
    begin
        Rst   <= '1';]
        Async <= '1';
        wait for 100 ns;
        Rst   <= '0';
        wait for 100 ns;
        wait for 3 ns;
        Async <= '0';

        wait;
    end process;

end rtl;