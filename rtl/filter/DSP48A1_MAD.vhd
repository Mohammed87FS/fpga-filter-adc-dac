----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:53:33 04/12/2026 
-- Design Name: 
-- Module Name:    DSP48A1_MAD - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.all;
use UNISIM.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DSP48A1_MAD is
    Port ( clk  : in  std_logic;
           res  : in  std_logic;
           EN   : in  std_logic;
           A    : in  STD_LOGIC_VECTOR (17 downto 0);
           B    : in  STD_LOGIC_VECTOR (17 downto 0);
           C    : in  STD_LOGIC_VECTOR (47 downto 0);
           P    : out STD_LOGIC_VECTOR (47 downto 0));
end DSP48A1_MAD;

architecture Behavioral of DSP48A1_MAD is
    signal OPMODE : std_logic_vector(7 downto 0);
begin

   -- X Multiplexer
   OPMODE (1 downto 0) <= "01";   -- Use Multiplier product
   
   -- Z Multiplexer
   OPMODE (3 downto 2) <= "11";   -- C Port
   
   OPMODE (4) <= '0';   -- Bypass pre-adder
   OPMODE (5) <= '0';   -- Use Cin
   OPMODE (6) <= '0';   -- Add
   OPMODE (7) <= '0';   -- Add
   
   DSP48A1_inst : DSP48A1
   generic map (
      A0REG         => 0,              -- First stage A input pipeline register (0/1)
      A1REG         => 0,              -- Second stage A input pipeline register (0/1)
      B0REG         => 0,              -- First stage B input pipeline register (0/1)
      B1REG         => 0,              -- Second stage B input pipeline register (0/1)
      CARRYINREG    => 0,              -- CARRYIN input pipeline register (0/1)
      CARRYINSEL    => "OPMODE5",      -- Specify carry-in source, "CARRYIN" or "OPMODE5" 
      CARRYOUTREG   => 0,              -- CARRYOUT output pipeline register (0/1)
      CREG          => 0,              -- C input pipeline register (0/1)
      DREG          => 0,              -- D pre-adder input pipeline register (0/1)
      MREG          => 0,              -- M pipeline register (0/1)
      OPMODEREG     => 0,              -- Enable=1/disable=0 OPMODE input pipeline registers
      PREG          => 1,              -- P output pipeline register (0/1)
      RSTTYPE       => "SYNC"          -- Specify reset type, "SYNC" or "ASYNC" 
   )
   port map (
      -- Cascade Ports: 18-bit (each) output: Ports to cascade from one DSP48 to another
      BCOUT         => open,           -- 18-bit output: B port cascade output
      PCOUT         => open,           -- 48-bit output: P cascade output (if used, connect to PCIN of another DSP48A1)
      -- Data Ports: 1-bit (each) output: Data input and output ports
      CARRYOUT      => open,     -- 1-bit output: carry output (if used, connect to CARRYIN pin of another
                                -- DSP48A1)

      CARRYOUTF     => open,   -- 1-bit output: fabric carry output
      M             => open,                   -- 36-bit output: fabric multiplier data output
      P             => P,                   -- 48-bit output: data output
      -- Cascade Ports: 48-bit (each) input: Ports to cascade from one DSP48 to another
      PCIN          => (others => '0'),             -- 48-bit input: P cascade input (if used, connect to PCOUT of another DSP48A1)
      -- Control Input Ports: 1-bit (each) input: Clocking and operation mode
      CLK           => clk,               -- 1-bit input: clock input
      OPMODE        => OPMODE,         -- 8-bit input: operation mode input
      -- Data Ports: 18-bit (each) input: Data input and output ports
      A             => A,                   -- 18-bit input: A data input
      B             => B,                   -- 18-bit input: B data input (connected to fabric or BCOUT of adjacent DSP48A1)
      C             => C,                   -- 48-bit input: C data input
      CARRYIN       => '0',       -- 1-bit input: carry input signal (if used, connect to CARRYOUT pin of another
                                -- DSP48A1)

      D             => (others => '0'),                   -- 18-bit input: B pre-adder data input
      -- Reset/Clock Enable Input Ports: 1-bit (each) input: Reset and enable input ports
      CEA           => '0',               -- 1-bit input: active high clock enable input for A registers
      CEB           => '0',               -- 1-bit input: active high clock enable input for B registers
      CEC           => '0',               -- 1-bit input: active high clock enable input for C registers
      CECARRYIN     => '0',   -- 1-bit input: active high clock enable input for CARRYIN registers
      CED           => '0',               -- 1-bit input: active high clock enable input for D registers
      CEM           => '0',               -- 1-bit input: active high clock enable input for multiplier registers
      CEOPMODE      => '0',     -- 1-bit input: active high clock enable input for OPMODE registers
      CEP           => EN,               -- 1-bit input: active high clock enable input for P registers
      RSTA          => '0',             -- 1-bit input: reset input for A pipeline registers
      RSTB          => '0',             -- 1-bit input: reset input for B pipeline registers
      RSTC          => '0',             -- 1-bit input: reset input for C pipeline registers
      RSTCARRYIN    => '0', -- 1-bit input: reset input for CARRYIN pipeline registers
      RSTD          => '0',             -- 1-bit input: reset input for D pipeline registers
      RSTM          => '0',             -- 1-bit input: reset input for M pipeline registers
      RSTOPMODE     => '0',   -- 1-bit input: reset input for OPMODE pipeline registers
      RSTP          => res              -- 1-bit input: reset input for P pipeline registers
   ); -- End of DSP48A1_inst instantiation
end Behavioral;

