----------------------------------------------------------------------------------
-- Company:         FH Wiener Neustadt
-- Engineer:        HFK
--
-- Create Date:     2020
-- Design Name:
-- Module Name:     Read_from_File_real
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.00 - Read_from_File_real tested
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
--use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_SIGNED.all;
--use IEEE.STD_LOGIC_TEXTIO.all;

--library STD;
use STD.TEXTIO.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Read_from_File_real is
  generic (
    FileName  : string  := "src/input_file.dat"
  );
  port (
    clk       : in  std_logic;
    FileOpen  : in  std_logic;
    RD        : in  std_logic;
    EOF       : out std_logic;
    Data      : out real := 0.0
  );
end Read_from_File_real;

architecture Behavioral of Read_from_File_real is
  file   InFile    : TEXT;
  signal EndOfFile : std_logic := '0';

begin

  EOF <= EndOfFile;

  Read_from_file: process(FileOpen,clk)
    variable current_line : line;
    variable value : real;

  begin

    if rising_edge(FileOpen) then
      file_open(InFile, FileName, READ_MODE);
      EndOfFile <= '0';
    end if;

    if falling_edge(FileOpen) then
      file_close(InFile);
      EndOfFile <= '0';
    end if;

    if rising_edge(clk) then
      if RD = '1' and FileOpen = '1' and EndOfFile = '0' then
        if endfile(InFile) = true then
          EndOfFile <= '1';
        else
          readline(InFile,current_line);
          read(current_line,value);

          Data <= real(value);

        end if;
      end if;
    end if;

  end process;

end Behavioral;


