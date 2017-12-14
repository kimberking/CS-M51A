module interlayer(clk, new, in1, ready1, in2, ready2, in3, ready3, in4, ready4, out1, out2, out3, out4, ready_out);
  input clk;
  input new;
  input [7:0] in1, in2, in3, in4;
  input ready1, ready2, ready3, ready4;
  output [7:0] out1, out2, out3, out4;
  output ready_out;

  wire ar, re1, re2;
  assign ar = ready1 & ready2 & ready3 & ready4;

  dreg	#(8)	reg1(ar, in1, out1);
  dreg	#(8)	reg2(ar, in2, out2);
  dreg	#(8)	reg3(ar, in3, out3);
  dreg	#(8)	reg4(ar, in4, out4);
  dreg  #(1)  lastone(clk, ar, re1);

  assign readygate = (!re1 && ar) ? 1'b1 : 1'b0;

  wire readygate;

  dreg  #(1)  readygated(clk, readygate, ready_out);

endmodule
