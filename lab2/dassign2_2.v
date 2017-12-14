// EEM16 - Logic Design
// Design Assignment #2 - Problem #2.2
// dassign2_2.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// Include constants file defining THRESHOLD, CMDs, STATEs

`include "constants2_2.vh"

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

// 4-1 Mux.  Width set via parameter.
// Includes propagation delay t_PD = 3
module mux4(a, b, c, d, sel, y);
    parameter width = 1;
    input [width-1:0] a, b, c, d;
    input [1:0] sel;
    output [width-1:0] y;
    reg [width-1:0] y;

    always @(*) begin
        case (sel)
            2'b00:    y <= #3 a;
            2'b01:    y <= #3 b;
            2'b10:    y <= #3 c;
            default:  y <= #3 d;
        endcase
    end
endmodule

// ****************
// Blocks to design
// ****************
module counter (a, sum, new);
parameter width = 8;
  input [width-1:0] a;
  input new;
  output [width-1:0] sum;

  wire [width-1:0] y;

  assign y = a + 1;

  mux2 #(width) money (y, 1, new, sum);

endmodule
// Evaluates incoming pulses/gaps
// Use any combination of declarative or structural verilog
// IMPORTANT: Do not change module or port names
module pulse_width(clk, in, pwidth, long, type, new);
    parameter width = 8;
    input clk, in;
    output [width-1:0] pwidth;
    output long, type, new;
	wire [width-1:0] curr_pwidth;
    wire long_out, prev;

    dreg in_reg(clk, in, prev);

    assign new = in ^ prev;
    assign type = prev & new;

  	dreg #(width) pwidth_reg(clk, curr_pwidth, pwidth);

  	counter #(width) counter(pwidth, curr_pwidth, new);

    assign long_out = pwidth > `THRESHOLD ? 1 : 0;
  	assign long = long_out & new;
endmodule

// Four valued shift-register
// Use any combination of declarative or structural verilog
//    or procedural verilog, provided it obeys rules for combinational logic
// IMPORTANT: Do not change module or port names
module shift4(clk, in, cmd, out3, out2, out1, out0);
    parameter width = 1;
    input clk;
    input [width-1:0] in;
    input [`CMD_WIDTH-1:0] cmd;
    output [width-1:0] out3, out2, out1, out0;

    wire [width-1:0] dummy = 8'b0;
    wire [width-1:0] toreg3, toreg2, toreg1, toreg0, mout3, mout2, mout1, mout0;

    //                 CLR  LOAD, HOLD
    mux4 #(width) mux1(8'b0, in,    mout3, dummy, cmd, toreg3);
    mux4 #(width) mux2(8'b0, mout3, mout2, dummy, cmd, toreg2);
    mux4 #(width) mux3(8'b0, mout2, mout1, dummy, cmd, toreg1);
    mux4 #(width) mux4(8'b0, mout1, mout0, dummy, cmd, toreg0);

    dreg #(width) sum0(clk, toreg3, mout3);
    dreg #(width) sum1(clk, toreg2, mout2);
    dreg #(width) sum2(clk, toreg1, mout1);
    dreg #(width) sum3(clk, toreg0, mout0);

    assign out3 = mout0;
    assign out2 = mout1;
    assign out1 = mout2;
    assign out0 = mout3;

endmodule

// Control FSM for shift register
// Use any combination of declarative or structural verilog
//    or procedural verilog, provided it obeys rules for combinational logic
// IMPORTANT: Do not change module or port names
module control_fsm(clk, long, type, cmd, done);
	input clk, long, type;
    output [`CMD_WIDTH-1:0] cmd;
    output done;

  	wire [`CMD_WIDTH-1:0] cmd_out;
  	wire [1:0] select;
  	wire current_done, prev_done;

  	assign select = { type, long };
  	mux4 #(`CMD_WIDTH) cmd_mux(`CMD_HOLD, `CMD_CLEAR, `CMD_LOAD, `CMD_LOAD, select, cmd);

  	dreg #(1) done_reg(clk, current_done, prev_done);
  	assign current_done = ~type & long;
  	mux2 #(1) done_mux(current_done, 1'b0, prev_done, done);

endmodule

// Input de-serializer
// Use structural verilog only
// IMPORTANT: Do not change module or port names
module deserializer(clk, in, out3, out2, out1, out0, done);
	parameter width = 8;
    input clk, in;
    output [width-1:0] out3, out2, out1, out0;
    output done;

  	wire [width-1:0] pwidth;
  	wire [`CMD_WIDTH-1:0] cmd;
  	wire type, long, new;

  	pulse_width #(width) pulse(clk, in, pwidth, long, type, new);
  	control_fsm control(clk, long, type, cmd, done);
  	shift4 #(width) shift(clk, pwidth, cmd, out3, out2, out1, out0);

endmodule
