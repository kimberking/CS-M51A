// EEM16 - Logic Design
// Design Assignment #2 - Problem #2.1
// dassign2_1.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// ***************
// Building blocks
// ***************

// D-register (flipflop).  Width set via parameter.
// Includes propagation delay t_PD = 3
module dreg(clk, d, q);
    parameter width = 1;
    input clk;
    input [width-1:0] d;
    output [width-1:0] q;
    reg [width-1:0] q;

    always @(posedge clk) begin
        q <= #3 d;
    end
endmodule

// 2-1 Mux.  Width set via parameter.
// Includes propagation delay t_PD = 3
module mux2(a, b, sel, y);
    parameter width = 1;
    input [width-1:0] a, b;
    input sel;
    output [width-1:0] y;

    assign #3 y = sel ? b : a;
endmodule

// Left-shifter
// No propagation delay, it's just wires really
module shl(a, y);
    parameter width = 1;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {a[width-2:0], 1'b0};
endmodule

// Right-shifter
// more wires
module shr(a, y);
    parameter width = 1;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {1'b0, a[width-1:1]};
endmodule

// 16-bit adder (declarative Verilog)
// Includes propagation delay t_PD = 3n = 48
module adder16(a, b, sum);
    input [15:0] a, b;
    output [15:0] sum;

    assign #48 sum = a+b;
endmodule

// ****************
// Blocks to design
// ****************

// Lowest order partial product of two inputs
// Use declarative verilog only
// IMPORTANT: Do not change module or port names
module partial_product (a, b, pp);
    input [15:0] a;
    input [7:0]  b;
    output [15:0] pp;

    assign #1 pp = ( b[0] ) ? a : {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};

endmodule

// Determine if multiplication is complete
// Use declarative verilog only
// IMPORTANT: Do not change module or port names
module is_done (a, b, done);
  input [7:0] b;
  input [15:0] a;

  output done;

  assign #4 done = (b == 8'b0) ? 1 : 0;

endmodule

// 8 bit unsigned multiply
// Use structural verilog only
// IMPORTANT: Do not change module or port names
module multiply (clk, ain, bin, reset, prod, ready);
    input clk,reset;
    input [7:0] ain, bin;
    output [15:0] prod;
    output ready;

    wire [15:0] aout, newa, a1, a2;
    wire [7:0]  bout, newb, b1, b2;

    dreg #(16) A (clk, a2, aout);
    dreg #(8)  B (clk, b2, bout);

    shl #(16) shiftleft (aout, a1);
    shr #(8) shiftright (bout, b1);

    mux2 #(16) resetA(a1, ain, reset, a2);
    mux2 #(8)  resetB(b1, bin, reset, b2);

    wire [15:0] pptoadd;
    partial_product sum(aout, bout, pptoadd);

    wire [15:0] out1, out2;
    adder16 add(pptoadd, prod, out1);
    mux2 #(16)  resetAdder(out1, 16'b0, reset, out2);
    dreg #(16) accum (clk, out2, prod);

    is_done isitdone(newa, bout, ready);

endmodule

// Clock generation.  Period set via parameter:
//   clock changes every half_period ticks
//   full clock period = 2*half_period
// Replace half_period parameter with desired value
module clock_gen(clk);
    parameter half_period = 30; // REPLACE half_period HERE
    output clk;
    reg    clk;
    initial clk = 0;
    always #half_period clk = ~clk;
endmodule
