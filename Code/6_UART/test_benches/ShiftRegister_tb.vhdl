library ieee;
use ieee.std_logic_1164.all;

entity ShiftRegister_tb is
    generic (
        CHAIN_LENGTH : integer;
        SHIFT_DIRECTION :character -- indicates the direction of shift: 'L' for left, 'R' for right
    );

end entity;

architecture rtl of ShiftRegister_tb is
   component ShiftRegister is
    generic (
        CHAIN_LENGTH : integer;
        SHIFT_DIRECTION :character -- indicates the direction of shift: 'L' for left, 'R' for right
    );

    port (
        Clk     : in  std_logic;
        Rst     : in  std_logic;
        
        ShiftEn : in  std_logic;
        Din     : in  std_logic;
        Dout    : out std_logic_vector(CHAIN_LENGTH - 1 downto 0)
    );
    end component;
   
    signal Clk     : std_logic := '0';
    signal Rst     : std_logic;

    signal ShiftEn : std_logic;
    signal Din     : std_logic;
    signal Dout    : std_logic_vector(CHAIN_LENGTH - 1 downto 0);
begin

    Clk <= not Clk after 10 ns;

    UUT : ShiftRegister
    generic map (
        CHAIN_LENGTH => 8,
        SHIFT_DIRECTION => 'R'
    );

    port map (
        Clk     => Clk,
        Rst     => Rst,

        ShiftEn => ShiftEn,
        Din     => Din,
        Dout    => Dout
    );

    TestProcess : process
    begin
        Rst <= '1';
        ShiftEn <= '1';
        Din <= '0';
        wait for 100 ns;
        
        Rst <= '0';
        wait for 100 ns;

        -- RS232 transmitted here is 0x51 -> 0101 0001

        Din <= '1';
        wait for 4.3us;
        wait until rising_edge(Clk);
        ShiftEn <= '1';
        wait until rising_edge(Clk);
        ShiftEn <= '0';
        wait for 4.3us;

        for i in 0 to 2 loop
            Din <= '0';
            wait for 4.3us;
            wait until rising_edge(Clk);
            ShiftEn <= '1';
            wait until rising_edge(Clk);
            ShiftEn <= '0';
            wait for 4.3us;
        end loop;
        
        for i in 0 to 1 loop
            Din <= '1';
            wait for 4.3us;
            wait until rising_edge(Clk);
            ShiftEn <= '1';
            wait until rising_edge(Clk);
            ShiftEn <= '0';
            wait for 4.3us;


            Din <= '0';
            wait for 4.3us;
            wait until rising_edge(Clk);
            ShiftEn <= '1';
            wait until rising_edge(Clk);
            ShiftEn <= '0';
            wait for 4.3us;
        end loop;

        wait;
    end process;

end rtl;