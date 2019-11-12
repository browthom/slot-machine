library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top_level is
port (clk, btnu, btnc: in std_logic;
      seg_out : out std_logic_vector (7 downto 0);
	  anode_out : out std_logic_vector (3 downto 0));
end top_level;

architecture Behavioral of top_level is

component multiplexer_seven_segment_display is
port ( clk : in std_logic;
	   input_1, input_2, input_3, input_4 : in std_logic_vector (7 downto 0);
       seg_out : out std_logic_vector (7 downto 0);
	   anode_out : out std_logic_vector (3 downto 0));
end component;

component bcd_seven_segment_decoder is
port (input : in std_logic_vector (3 downto 0);
	  enable : in std_logic;
      seg_out : out std_logic_vector (7 downto 0));
end component;

component seven_segment_decoder is
port (input : in std_logic_vector (5 downto 0);
	  enable : in std_logic;
      seg_out : out std_logic_vector (7 downto 0));
end component;

component count_to_nine is
port (clk, reset, enable, enable_auto_reset : in std_logic;
	  output : out std_logic_vector (3 downto 0));
end component;

component var_clock_divider_2 is
port (clk : in std_logic;
	  divider : in natural range 0 to 25;
      clk_out : out std_logic);
end component;

component flip_flop is
port (clk, D, R, enable : in std_logic;
      Q : out std_logic);
end component;

component press_debouncer is
Port (clk : in std_logic;
      button_press : in std_logic;
      output : out std_logic);
end component;

component victory_logic is
port (input_1, input_2, input_3 : in std_logic_vector(3 downto 0);
      enable : in std_logic;
      decoded_output : out std_logic_vector(5 downto 0));
end component;

component delay_enable is
port (clk, reset, invert : in std_logic;
      delay_value : in natural range 0 to 1000000000;
	  enable : out std_logic);
end component;

signal seg_a, seg_b, seg_c, seg_d : std_logic_vector (7 downto 0);
signal count_a, count_b, count_c, count_d : std_logic_vector (3 downto 0);
signal clk_div_out_a, clk_div_out_b, clk_div_out_c : std_logic;
signal not_counter_enable, counter_enable, enable_out : std_logic;
signal reset_db_signal, stop_db_signal : std_logic;
signal decoded_output : std_logic_vector(5 downto 0);

begin

counter_enable <= not not_counter_enable and enable_out;

U1: delay_enable port map (clk => clk, 
                           reset => reset_db_signal,
                           invert => '0',
                           delay_value => 200000000,
                           enable => enable_out);

V1: victory_logic port map (input_1 => count_a,
                            input_2 => count_b,
                            input_3 => count_c,
                            enable => not_counter_enable,
                            decoded_output => decoded_output);
      
clk_div_c: var_clock_divider_2 port map (clk => clk,
                                         divider => 22,
                                         clk_out => clk_div_out_c);
clk_div_b: var_clock_divider_2 port map (clk => clk,
                                         divider => 20,
                                         clk_out => clk_div_out_b);
clk_div_a: var_clock_divider_2 port map (clk => clk,
                                         divider => 24,
                                         clk_out => clk_div_out_a);
                                         
stop_pb: press_debouncer port map (clk => clk,
                                   button_press => btnc,
                                   output => stop_db_signal);                                       
reset_pb: press_debouncer port map (clk => clk,
                                    button_press => btnu,
                                    output => reset_db_signal);
                                    
COUNT_ENABLE: flip_flop port map (clk => clk,
                                  D => '1', 
                                  R => reset_db_signal,
                                  enable => stop_db_signal,
                                  Q => not_counter_enable);

COUNTER_C: count_to_nine port map (clk => clk_div_out_c,
                                   reset => reset_db_signal,
                                   enable => counter_enable,
                                   enable_auto_reset => '1',
                                   output => count_c);
COUNTER_B: count_to_nine port map (clk => clk_div_out_b,
                                   reset => reset_db_signal,
                                   enable => counter_enable,
                                   enable_auto_reset => '1',
                                   output => count_b);
COUNTER_A: count_to_nine port map (clk => clk_div_out_a,
                                   reset => reset_db_signal,
                                   enable => counter_enable,
                                   enable_auto_reset => '1',
                                   output => count_a);

SEG_DEC_D: seven_segment_decoder port map (input => decoded_output,
                                           enable => '1',
                                           seg_out => seg_d);
SEG_DEC_C: bcd_seven_segment_decoder port map (input => count_c,
                                               enable => '1',
                                               seg_out => seg_c);
SEG_DEC_B: bcd_seven_segment_decoder port map (input => count_b,
                                               enable => '1',
                                               seg_out => seg_b);
SEG_DEC_A: bcd_seven_segment_decoder port map (input => count_a,
                                               enable => '1',
                                               seg_out => seg_a);    
                                                                                                                                         
M1: multiplexer_seven_segment_display port map (clk => clk,
                                                input_1 => seg_d,
                                                input_2 => seg_c,
                                                input_3 => seg_b, 
                                                input_4 => seg_a,
                                                seg_out => seg_out,
                                                anode_out => anode_out);

end Behavioral;
