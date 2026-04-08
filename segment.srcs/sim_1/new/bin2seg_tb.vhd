-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 04 Mar 2026 07:40:37 GMT
-- Request id : cfwk-fed377c2-69a7e1f580c32

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  -- Required for "to_unsigned"

entity tb_bin2seg is
end tb_bin2seg;

architecture tb of tb_bin2seg is

    component bin2seg
        port (bin : in std_logic_vector (3 downto 0);
              seg : out std_logic_vector (6 downto 0));
    end component;

    signal bin : std_logic_vector (3 downto 0);
    signal seg : std_logic_vector (6 downto 0);

begin

    dut : bin2seg
    port map (bin => bin,
              seg => seg);

    stimuli : process
    begin
        -- Loop through all hexadecimal values (0 to 15)
    for i in 0 to 15 loop

        -- Convert integer i to 4-bit std_logic_vector
        bin <= std_logic_vector(to_unsigned(i, 4));
        wait for 10 ns;

    end loop;

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_bin2seg of tb_bin2seg is
    for tb
    end for;
end cfg_tb_bin2seg;
