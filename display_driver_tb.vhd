-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 18 Mar 2026 07:44:38 GMT
-- Request id : cfwk-fed377c2-69ba57e632876

library ieee;
use ieee.std_logic_1164.all;

entity tb_display_driver is
end tb_display_driver;

architecture tb of tb_display_driver is

    component display_driver
        port (clk   : in std_logic;
              rst   : in std_logic;
              data  : in std_logic_vector (15 downto 0);
              seg   : out std_logic_vector (6 downto 0);
              anode : out std_logic_vector (3 downto 0));
    end component;

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal data  : std_logic_vector (15 downto 0);
    signal seg   : std_logic_vector (6 downto 0);
    signal anode : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 4 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : display_driver
    port map (clk   => clk,
              rst   => rst,
              data  => data,
              seg   => seg,
              anode => anode);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

  stimuli : process
begin
    data <= (others => '0');

    -- Reset generation
    rst <= '1';
    wait for 50 ns;
    rst <= '0';

    data <= x"0018";
    wait for 50 * TbPeriod;

    data <= x"0019";
    wait for 50 * TbPeriod;

    data <= x"0020";
    wait for 50 * TbPeriod;
    
    data <= x"1234";
    wait for 50 * TbPeriod;

    -- Stop the clock and hence terminate the simulation
    TbSimEnded <= '1';
    wait;
end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_display_driver of tb_display_driver is
    for tb
    end for;
end cfg_tb_display_driver;
