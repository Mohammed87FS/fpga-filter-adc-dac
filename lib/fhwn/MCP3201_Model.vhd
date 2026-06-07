----------------------------------------------------------------------------------
-- Company:         FH Wiener Neustadt
-- Engineer:        HFK
--
-- Create Date:     2020
-- Design Name:
-- Module Name:     MCP3201_Model
-- Project Name:
-- Target Devices:
-- Tool versions:
--
-- Description:
--
-- Dependencies:    none
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.00 - MCP3201_Model tested
-- Revision 1.10 - MCP3201_Model Vref and Vin in real format
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

entity MCP3201_Model is
  generic (
    Vref  : real := 3.3
  );
  port (
    Vin   : in  real;
    CS    : in  std_logic;
    CLK   : in  std_logic;
    Dout  : out std_logic
  );
end MCP3201_Model;

architecture Behavioral of MCP3201_Model is
  signal Vinb      : std_logic_vector(11 downto 0);
  signal shift_reg : std_logic_vector(25 downto 0);

begin

  Dout <= shift_reg(25) after 70 ns when CS='0' else 'Z' after 15 ns;

  Limiter: process(Vin)
    variable Vlim : real;
  begin
    Vlim := 4096.0*Vin/Vref;
    if Vlim < 0.0 then
      Vlim := 0.0;
    end if;
    if Vlim > 4095.0 then
      Vlim := 4095.0;
    end if;
    Vinb <= conv_std_logic_vector(natural(Vlim),12);
  end process;

  Load_Shift: process(CLK,CS)
  begin

    if falling_edge(CS) then
      -- LSB first out after 14 clocks, see datasheet, ISIM ERROR if Vin(1 to 11) used
      shift_reg <= "ZZ0" & Vinb & Vinb(1)&Vinb(2)&Vinb(3)&Vinb(4)&Vinb(5)&Vinb(6)&Vinb(7)&Vinb(8)&Vinb(9)&Vinb(10)&Vinb(11);
    end if;

    if falling_edge(CLK) then
      shift_reg <= shift_reg(24 downto 0) & '0';      -- '0's out for more clk's
    end if;

  end process;

end Behavioral;


