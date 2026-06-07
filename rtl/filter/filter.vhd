----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:22:29 04/15/2026 
-- Design Name: 
-- Module Name:    filter - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.my_package.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filter is
    Port ( clk          : in  STD_LOGIC;
           res          : in  STD_LOGIC;
           EN           : in  STD_LOGIC;
           DataIn       : in  STD_LOGIC_VECTOR (15 downto 0);
           DataOut      : out  STD_LOGIC_VECTOR (15 downto 0));
end filter;

architecture Behavioral of filter is
    constant nkb : integer := 15;
    constant kb  : integer := 2**nkb;
    constant nka : integer := 14;
    constant ka  : integer := 2**nka;
    constant a1  : real :=-1.86475780206283;
    constant a2  : real := 0.870723124304353;
    constant b0  : real := 0.00149133056038031;
    constant b1  : real := 0.00298266112075996;
    constant b2  : real := 0.00149133056038098;
    
    signal X     : STD_LOGIC_VECTOR (17 downto 0) := (others => '0');
    signal Y     : STD_LOGIC_VECTOR (17 downto 0) := (others => '0');
    signal Ya    : STD_LOGIC_VECTOR (17 downto 0) := (others => '0');
    signal Z     : STD_LOGIC_VECTOR (47 downto 0) := (others => '0');
    
    signal P1    : STD_LOGIC_VECTOR (47 downto 0);
    signal P2    : STD_LOGIC_VECTOR (47 downto 0);
    signal P3    : STD_LOGIC_VECTOR (47 downto 0);
    signal P4    : STD_LOGIC_VECTOR (47 downto 0);
    signal P5    : STD_LOGIC_VECTOR (47 downto 0);
    
    signal B_b0  : STD_LOGIC_VECTOR (17 downto 0);
    signal B_b1  : STD_LOGIC_VECTOR (17 downto 0);
    signal B_b2  : STD_LOGIC_VECTOR (17 downto 0);
    signal B_a1  : STD_LOGIC_VECTOR (17 downto 0);
    signal B_a2  : STD_LOGIC_VECTOR (17 downto 0);
    
begin
    -- Input alignment
    X(15 downto  0) <= DataIn;
    X(17 downto 16) <= DataIn(15) & DataIn(15);
    
    -- IIR forward push
    Z <= P3;
    
    -- Output divider
    Y <= P5(17+nkb downto nkb);
    
    -- IIR feedback divider
    Ya <= P5(17+nka downto nka);
    
    -- Output divider
    DataOut <= Y(17) & Y(14 downto 0);
    -- DataOut <= Y(17 downto 2);
    
    -- Filter Coefficients
    B_b2 <= CONV_STD_LOGIC_VECTOR(integer(b2*real(kb)),18);
    B_b1 <= CONV_STD_LOGIC_VECTOR(integer(b1*real(kb)),18);
    B_b0 <= CONV_STD_LOGIC_VECTOR(integer(b0*real(kb)),18);
    B_a2 <= CONV_STD_LOGIC_VECTOR(integer(-a2*real(ka)),18);
    B_a1 <= CONV_STD_LOGIC_VECTOR(integer(-a1*real(ka)),18);
    
    -- Filter section
    --U1 : entity work.DSP48A1_MAD
    U1 : DSP48A1_MAD
    port map(
        clk => clk,
        res => res,
        EN  => EN,
        A   => X,
        B   => B_b2,
        C   => (others => '0'),
        P   => P1
    );
    
    U2 : DSP48A1_MAD
    port map(
        clk => clk,
        res => res,
        EN  => EN,
        A   => X,
        B   => B_b1,
        C   => P1,
        P   => P2
    );
    
    U3 : DSP48A1_MAD
    port map(
        clk => clk,
        res => res,
        EN  => EN,
        A   => X,
        B   => B_b0,
        C   => P2,
        P   => P3
    );
    
    U4 : DSP48A1_MAD
    port map(
        clk => clk,
        res => res,
        EN  => EN,
        A   => Ya,
        B   => B_a2,
        C   => P3,
        P   => P4
    );
    
    U5 : DSP48A1_MAD
    port map(
        clk => clk,
        res => res,
        EN  => EN,
        A   => Ya,
        B   => B_a1,
        C   => P4,
        P   => P5
    );

end Behavioral;

