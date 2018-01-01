module inverter(a,y);
    input a;
    output y;

    assign #1 y = ~a;
endmodule

module fa_gate_1(a,b,c,y);
    input a,b,c;
    output y;

    assign #1 y = ~((a&b) | (c&(b|a)));
endmodule

module fa_gate_2(a,b,c,m,y);
    input a,b,c,m;
    output y;

    assign #1 y = ~((a&b&c) | ((a|b|c)&m));
endmodule

// Full adder (structural Verilog)
module fa(a,b,ci,co,s);
    input a,b,ci;
    output s,co;

    wire nco, ns;

    fa_gate_1   fa_gate_1_1(a,b,ci, nco);
    fa_gate_2   fa_gate_2_1(a,b,ci,nco, ns);
    inverter    inverter_1(nco, co); 
    inverter    inverter_2(ns, s);
endmodule

// 5+2 input full adder (structural Verilog)
// IMPORTANT: Do not change module or port names
module fa5 (a,b,c,d,e,ci0,ci1, 
            co1,co0,s);

    input a,b,c,d,e,ci0,ci1;
    output co1, co0, s;

	wire fa1C0ToCOUT;
	wire fa1SToFA2;
	wire fa2C0ToCOUT;
	wire fa2SToSUM;
	wire SUMC0ToCOUT;
	
	fa fa1(a, b, c, fa1C0ToCOUT,  fa1SToFA2);
	fa fa2(fa1SToFA2, d, e, fa2C0ToCOUT, fa2SToSUM);
	fa SUM(fa2SToSUM, ci0, ci1, SUMC0ToCOUT, s);
	fa COUT(SUMC0ToCOUT, fa2C0ToCOUT, fa1C0ToCOUT, co1, co0);
endmodule


module adder5 (a,b,c,d,e,sum);
    input [3:0] a,b,c,d,e;
	output [6:0] sum;
	
	wire c1,c2,c3,c4,c5,sk1,sk2,sk3,sk4;
	
	fa5 one(a[0],b[0],c[0],d[0],e[0],0,0,sk1,c1,sum[0]);
	
	fa5 two(a[1],b[1],c[1],d[1],e[1],c1,0,sk2,c2,sum[1]);
	
	fa5 three(a[2],b[2],c[2],d[2],e[2],sk1,c2,sk3,c3,sum[2]);
	
	fa5 four(a[3],b[3],c[3],d[3],e[3],sk2,c3,sk4,c4,sum[3]);
	
	fa five(0,sk3,c4,c5,sum[4]);
	
	fa six(0,c5,sk4,sum[6],sum[5]);
	
endmodule
