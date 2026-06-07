----------------------------------------------------------------------------------
-- Company:         FH Wiener Neustadt
-- Engineer:        HFK
--
-- Create Date:     2020
-- Design Name:
-- Module Name:     MCP4821_Model
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
-- Revision 1.00 - MCP4821_Model tested
-- Revision 1.10 - MCP4821_Model with command
-- Revision 1.20 - MCP4821_Model Vdd and Vout in real format
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

entity MCP4821_Model is
  generic (
    Vdd   : real := 3.3
  );
  port (
    CS    : in  std_logic;
    SCK   : in  std_logic;
    SDI   : in  std_logic;
    Vout  : out real := 0.0
  );
end MCP4821_Model;

architecture Behavioral of MCP4821_Model is
  signal   shift_reg    : std_logic_vector(15 downto 0) := (others =>'0');
  constant output_delay : time := 220 ns;

begin

  Shift: process(SCK)
  begin
    if rising_edge(SCK) then
      shift_reg <= shift_reg(14 downto 0) & SDI;
    end if;
  end process;

  Out_Reg: process(CS)
    variable Vdig : real;
  begin
    Vdig := real(conv_integer(unsigned(shift_reg(11 downto 0))))/1000.0;
    if rising_edge(CS) then
      if shift_reg(15) = '0' then             -- accept command
        if shift_reg(12) = '1' and Vdd >= 2.7 and Vdd <= 5.5 then
                                              -- no shut down and valid power supply

          if shift_reg(13) = '0' then         -- Gain = 2x
            if Vdig <= Vdd then
              Vout <= Vdig after output_delay;
            else                              -- output OPA saturate on Vdd
              Vout <= Vdd after output_delay;
            end if;

          else                                -- Gain = 1x
              Vout <= Vdig/2.0  after output_delay;
          end if;

        else                                  -- shut down
          vout <= 0.0;
        end if;

      end if;
    end if;
  end process;

end Behavioral;


