// EEM16 - Logic Design
// Design Assignment #1 - Problem #1.3
// dassign1_3.v
// Verilog template

// You may define any additional modules as necessary
// Do not change the module or port names of the given stubs

/* Arrays for convenience

  | abcdefghijklmnopqrstuvwxyz  <-- letter
__|___________________________
G | 11111111001001111111000111
F | 11001111001100011010101010
E | 11111101011111110100110001
D | 01111010011100100010111111
C | 11010011110011101011110010
B | 10010011110000011001101011
A | 10001110000010011010000101
^-- display segment
~~~

  |  GFEDCBA <-- display segment
__|________
a | b1110111
b | b1111100
c | b1011000
d | b1011110
e | b1111001
f | b1110001
g | b1101111
h | b1110110
i | b0000110
j | b0011110
k | b1111000
l | b0111000
m | b0010101
n | b1010100
o | b1011100
p | b1110011
q | b1100111
r | b1010000
s | b1101101
t | b1000110
u | b0111110
v | b0011100
w | b0101010
x | b1001001
y | b1101110
z | b1011011
^-- letter
*/

// Display driver (procedural verilog)
// IMPORTANT: Do not change module or port names
module display_rom (letter, display);
    input   [4:0] letter;
    reg  [6:0] displays;
	output [6:0] display;
	always @ (letter)
	case (letter)
	5'b00000 :  displays = 7'b1110111; //a
	5'b00001 :  displays = 7'b1111100; //b
	5'b00010 :  displays = 7'b1011000; //c
	5'b00011 :  displays = 7'b1011110; //d
	5'b00100 :  displays = 7'b1111001; //e
	5'b00101 :  displays = 7'b1110001; //f
	5'b00110 :  displays = 7'b1101111; //g
	5'b00111 :  displays = 7'b1110110; //h
	5'b01000 :  displays = 7'b0000110; //i
	5'b01001 :  displays = 7'b0011110; //j
	5'b01010 :  displays = 7'b1111000; //k
	5'b01011 :  displays = 7'b0111000; //l
	5'b01100 :  displays = 7'b0010101; //m
	5'b01101 :  displays = 7'b1010100; //n
	5'b01110 :  displays = 7'b1011100; //o
	5'b01111 :  displays = 7'b1110011; //p
	5'b10000 :  displays = 7'b1100111; //q
	5'b10001 :  displays = 7'b1010000; //r
	5'b10010 :  displays = 7'b1101101; //s
	5'b10011 :  displays = 7'b1000110; //t
	5'b10100 :  displays = 7'b0111110; //u
	5'b10101 :  displays = 7'b0011100; //v
	5'b10110 :  displays = 7'b0101010; //w
	5'b10111 :  displays = 7'b1001001; //x
	5'b11000 :  displays = 7'b1101110; //y
	5'b11001 :  displays = 7'b1011011; //z
	default : displays = 7'b1000000;
	endcase
	assign display = displays;
endmodule


// Display driver (declarative verilog)
// IMPORTANT: Do not change module or port names
module display_mux (letter, g,f,e,d,c,b,a);
    input   [4:0] letter;
    output  g,f,e,d,c,b,a;
	wire out1, out2, out3, out4;
	
	wire [7:0] muxA = {1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b1}; //a
	wire [7:0] muxB = {1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0};
	wire [7:0] muxC = {1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1};
	wire [7:0] muxD = {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0};
	wire [4:0] muxE = {out4,out3,out2,out1};
	wire [2:0] select1 = letter[2:0];
	wire [4:3] select2 = letter[4:3];
	assign out1 = muxA[select1];
	assign out2 = muxB[select1];
	assign out3 = muxC[select1];
	assign out4 = muxD[select1];
	assign a = muxE[select2];
	
	wire out6, out7, out8, out9;
	wire [7:0] mux1 = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}; //g
	wire [7:0] mux2 = {1'b1,1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0};
	wire [7:0] mux3 = {1'b1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b1};
	wire [7:0] mux4 = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1};
	wire [4:0] mux5 = {out9,out8,out7,out6};
	wire [2:0] select3 = letter[2:0];
	wire [4:3] select4 = letter[4:3];
	assign out6 = mux1[select3];
	assign out7 = mux2[select3];
	assign out8 = mux3[select3];
	assign out9 = mux4[select3];
	assign g = mux5[select4];
	
	
	wire [0:31] muxdaddy1 = { 1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
	wire [0:31] muxdaddy2 = { 1'b1,1'b1,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
	wire [0:31] muxdaddy3 = { 1'b0,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
	wire [0:31] muxdaddy4 = { 1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
	wire [0:31] muxdaddy5 = { 1'b1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
	
	
	assign b = muxdaddy1[letter];
	assign c = muxdaddy2[letter];
	assign d = muxdaddy3[letter];
	assign e = muxdaddy4[letter];
	assign f = muxdaddy5[letter];
	
endmodule
