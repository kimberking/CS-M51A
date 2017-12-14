module relu(in, out);
    input [15:0] in;
  	output [7:0] out;

  	wire [15:0] temp1, temp2;

  	shr #(16) shift1(in, temp1); //divide by 4
  	shr #(16) shift2(temp1, temp2);

  	assign out = (!in[15]) ? temp2 : 8'b0; //check case

endmodule

module piped_adder(clk, a, b, c, d, e, valid, sum, ready);
    input clk, valid;
    input [15:0] a, b, c, d, e;
    output [15:0] sum;
    output ready;
    wire [19:0] in2, in3, in4;

    assign in2 [19:16] = a [7:4];
    assign in2 [15:12] = b [7:4];
    assign in2 [11:8] = c [7:4];
    assign in2 [7:4] = d [7:4];
    assign in2 [3:0] = e [7:4];

    assign in3 [19:16] = a [11:8];
    assign in3 [15:12] = b [11:8];
    assign in3 [11:8] = c [11:8];
    assign in3 [7:4] = d [11:8];
    assign in3 [3:0] = e [11:8];

    assign in4 [19:16] = a [15:12];
    assign in4 [15:12] = b [15:12];
    assign in4 [11:8] = c [15:12];
    assign in4 [7:4] = d [15:12];
    assign in4 [3:0] = e [15:12];

    wire [2:0] outone, outtwo, outthree, intwo, inthree, infour;
    wire [3:0] sum1, sum2, sum3, sum4;

    //first adder second
    adder5carry one (a[3:0],b[3:0],c[3:0],d[3:0],e[3:0], 1'b0, 1'b0, 1'b0, outone[2], outone[1], outone[0], sum1);

    wire [3:0] sum11, sum12, sum13;
    dreg #(4) one1(clk, sum1, sum11);
    dreg #(4) one2(clk, sum11, sum12);
    dreg #(4) one3(clk, sum12, sum13);
    dreg #(4) one4(clk, sum13, sum[3:0]);

    //connect the first adder to the second adder
    dreg #(3) goingout1(clk, outone, intwo);

    wire [19:0] in22, in33, in44;

    //second adder section
    dreg #(20) gointo2(clk, in2, in22);

    adder5carry two (in22[19:16],in22[15:12],in22[11:8],in22[7:4],in22[3:0], intwo[2], intwo[1], intwo[0], outtwo[2], outtwo[1], outtwo[0], sum2);

    wire [3:0] sum21,sum22,sum23;
    dreg #(4) two1(clk, sum2, sum21);
    dreg #(4) two2(clk, sum21, sum22);
    dreg #(4) two3(clk, sum22, sum[7:4]);

    //connect adder two to three
    dreg #(3) goingout2(clk, outtwo, inthree);

    //adder3
    wire [19:0] in31,in32;
    dreg #(20) gointo31(clk, in3, in31);
    dreg #(20) gointo32(clk, in31, in32);

    adder5carry three (in32[19:16],in32[15:12],in32[11:8],in32[7:4],in32[3:0], inthree[2], inthree[1], inthree[0], outthree[2], outthree[1], outthree[0], sum3);

    wire [3:0] sum31;
    dreg #(4) three1(clk, sum3, sum31);
    dreg #(4) three2(clk, sum31, sum[11:8]);

    dreg #(3) goingout3(clk, outthree, infour);

    //adder 4 section
    wire [19:0] in41,in42,in43;
    dreg #(20) gointo41(clk, in4, in41);
    dreg #(20) gointo42(clk, in41, in42);
    dreg #(20) gointo43(clk, in42, in43);

    wire co14, co0a4, co0b4;
    adder5carry four (in43[19:16],in43[15:12],in43[11:8],in43[7:4],in43[3:0], infour[2], infour[1], infour[0], co14, co0a4, co0b4, sum4);

    dreg #(4) final(clk, sum4, sum[15:12]);
    wire r1,r2,r3,r4;

    dreg #(1) reg1(clk, valid, r1);
    dreg #(1) reg2(clk, r1, r2);
    dreg #(1) reg3(clk, r2, r3);
    dreg #(1) reg4(clk, r3, ready);

endmodule

module neuron(clk, w1, w2, w3, w4, b, x1, x2, x3, x4, new, y, ready);
  input clk;
  input [7:0] w1, w2, w3, w4, b;  // signed 2s complement
  input [7:0] x1, x2, x3, x4;     // unsigned
  input new;
  output [7:0] y;                 // unsigned
  output ready;

  wire [15:0] w1x1, w2x2, w3x3, w4x4;
  wire mr1, mr2, mr3, mr4, andedMR, readygate;
  wire [15:0] bextended, sum;
  wire [7:0] gatey;

  multiply multiply1(clk, w1, x1, new, w1x1, mr1);
  multiply multiply2(clk, w2, x2, new, w2x2, mr2);
  multiply multiply3(clk, w3, x3, new, w3x3, mr3);
  multiply multiply4(clk, w4, x4, new, w4x4, mr4);

  assign andedMR = mr1 & mr2 & mr3 & mr4;
  assign bextended = { {8{b[7]}}, b };

  piped_adder piped_adder(clk, w1x1, w2x2, w3x3, w4x4, bextended, andedMR, sum, readygate);

  relu relu(sum, gatey);

  dreg #(8) gatedy(clk, gatey, y);
  dreg #(1) readyreg(clk, readygate, ready);

endmodule
