----------------------------------------------------------------------------------
-- Company:         FH Wiener Neustadt
-- Engineer:        HFK
--
-- Create Date:     2025
-- Design Name:
-- Module Name:     pre_scaler
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:    none
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.00 - pre_scaler tested
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pre_scaler is
  generic (Divider: integer := 5);
  port (
    clk   : in  std_logic;
    res   : in  std_logic;
    CE    : in  std_logic;
    TC    : out std_logic
  );
end pre_scaler;

architecture Behavioral of pre_scaler is
  signal cnt: integer range 0 to (Divider-1) := 0;
  signal TC_latch: std_logic;

begin

  TC <= TC_latch and CE;

  Prescaler: process(clk)
  begin
    if rising_edge(clk) then
      if res = '1' then
        cnt <= 0;
        TC_latch <= '0';
      elsif CE = '1' then
        if cnt = (Divider-1) then
          cnt <= 0;
          TC_latch <= '1';
        else
          cnt <= cnt+1;
          TC_latch <= '0';
        end if; -- cnt
      end if; -- res
    end if; -- rising_edge
  end process;

end Behavioral;


