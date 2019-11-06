# slot-machine
VHDL model for implementation on a Digilent Basys 3 Artix-7 development board. The three left-most display segments will represent three reels of a slot machine. After some predetermined time, the displays will start scrolling through digits 0-9 (0 to 9 up-counter) at different speeds and the fourth segment will be set as '0'. The reels will stop scrolling once the user has pressed BTNC and the fourth segment will either display 'V' for victory or remain at '0' if there is no victory. The conditions for 'V' are as follows:
'V' if Three of Kind (000, 111, etc..) or if Two Pair (121, 334, etch..)
The reels will be reset if BTNU is pressed.
