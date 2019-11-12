library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity victory_logic is
port (input_1, input_2, input_3 : in std_logic_vector(3 downto 0);
      enable : in std_logic;
      decoded_output : out std_logic_vector(5 downto 0));
end victory_logic;

architecture DataFlow of victory_logic is

begin

decoded_output <= "011111" when (input_1 = input_2 or input_2 = input_3 or input_1 = input_3) and enable = '1' else
                  "000000";

end DataFlow;
