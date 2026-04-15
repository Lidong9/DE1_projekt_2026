
-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 11 Mar 2026 07:37:52 GMT
-- Request id : cfwk-fed377c2-69b11bd03bdea

library ieee;
use ieee.std_logic_1164.all;

entity tb_clk_en is
end tb_clk_en;

architecture tb of tb_clk_en is

    component clk_en
        generic(G_MAX: positive := 5);
        port (clk : in std_logic;
              rst : in std_logic;
              ce  : out std_logic);
    end component;

    signal clk : std_logic;
    signal rst : std_logic;
    signal ce  : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin
    
    dut : clk_en
    generic map (G_MAX => 32)
    port map (clk => clk,
              rst => rst,
              ce  => ce);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_clk_en of tb_clk_en is
    for tb
    end for;
end cfg_tb_clk_en;