// EEM16 - Logic Design
// Design Assignment #1 - Problem #1.2
// dassign1_2.v
// Verilog template

// You may define any additional modules as necessary
// Do not change the module or port names of these stubs

// Max/argmax (declarative verilog)
// IMPORTANT: Do not change module or port names
module mam (in1_value, in1_label, in2_value, in2_label, out_value, out_label);
    input   [7:0] in1_value, in2_value;
    input   [4:0] in1_label, in2_label;
    output  [7:0] out_value;
    output  [4:0] out_label;
	wire [7:0] e;
	assign e[0] = ( (in1_value[0] >= in2_value[0]) ? ( (in1_value[0] == in2_value[0]) ? 1 : 0 ) : 1 );
	assign e[1] = ( (in1_value[1] >= in2_value[1]) ? ( (in1_value[1] == in2_value[1]) ? e[0] : 0 ) : 1 );
	assign e[2] = ( (in1_value[2] >= in2_value[2]) ? ( (in1_value[2] == in2_value[2]) ? e[1] : 0 ) : 1 );
	assign e[3] = ( (in1_value[3] >= in2_value[3]) ? ( (in1_value[3] == in2_value[3]) ? e[2] : 0 ) : 1 );
	assign e[4] = ( (in1_value[4] >= in2_value[4]) ? ( (in1_value[4] == in2_value[4]) ? e[3] : 0 ) : 1 );
	assign e[5] = ( (in1_value[5] >= in2_value[5]) ? ( (in1_value[5] == in2_value[5]) ? e[4] : 0 ) : 1 );
	assign e[6] = ( (in1_value[6] >= in2_value[6]) ? ( (in1_value[6] == in2_value[6]) ? e[5] : 0 ) : 1 );
	assign e[7] = ( (in1_value[7] >= in2_value[7]) ? ( (in1_value[7] == in2_value[7]) ? e[6] : 0 ) : 1 );
	assign out_value = ( ( e[7] == 1) ? in2_value : in1_value);
	assign out_label = ( ( e[7] == 1) ? in2_label : in1_label);
endmodule


// Maximum index (structural verilog)
// IMPORTANT: Do not change module or port names
module maxindex(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,out);
    input [7:0] a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z;
    output [4:0] out;
    
	wire [4:0] la,lb,lc,ld,le,lf,lg,lh,li,lj,lk,ll,lm,ln,lo,lp,lq,lr,ls,lt,lu,lv,lw,lx,ly,lz;
	wire [7:0] v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14,v15,v16,v17,v18,v19,v20,v21,v22,v23,v24;
	wire [4:0] o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15,o16,o17,o18,o19,o20,o21,o22,o23,o24;
	wire [7:0] value;
	
	assign la[4]=0, la[3]=0,la[2]=0,la[1]=0,la[0]=0;
	assign lb[4]=0, lb[3]=0,lb[2]=0,lb[1]=0,lb[0]=1;
	assign lc[4]=0, lc[3]=0,lc[2]=0,lc[1]=1,lc[0]=0;
	assign ld[4]=0, ld[3]=0,ld[2]=0,ld[1]=1,ld[0]=1;
	assign le[4]=0, le[3]=0,le[2]=1,le[1]=0,le[0]=0;
	assign lf[4]=0, lf[3]=0,lf[2]=1,lf[1]=0,lf[0]=1;
	assign lg[4]=0, lg[3]=0,lg[2]=1,lg[1]=1,lg[0]=0;
	assign lh[4]=0, lh[3]=0,lh[2]=1,lh[1]=1,lh[0]=1;
	assign li[4]=0, li[3]=1,li[2]=0,li[1]=0,li[0]=0;
	assign lj[4]=0, lj[3]=1,lj[2]=0,lj[1]=0,lj[0]=1;
	assign lk[4]=0, lk[3]=1,lk[2]=0,lk[1]=1,lk[0]=0;
	assign ll[4]=0, ll[3]=1,ll[2]=0,ll[1]=1,ll[0]=1;
	assign lm[4]=0, lm[3]=1,lm[2]=1,lm[1]=0,lm[0]=0;
	assign ln[4]=0, ln[3]=1,ln[2]=1,ln[1]=0,ln[0]=1;
	assign lo[4]=0, lo[3]=1,lo[2]=1,lo[1]=1,lo[0]=0;
	assign lp[4]=0, lp[3]=1,lp[2]=1,lp[1]=1,lp[0]=1;
	assign lq[4]=1, lq[3]=0,lq[2]=0,lq[1]=0,lq[0]=0;
	assign lr[4]=1, lr[3]=0,lr[2]=0,lr[1]=0,lr[0]=1;
	assign ls[4]=1, ls[3]=0,ls[2]=0,ls[1]=1,ls[0]=0;
	assign lt[4]=1, lt[3]=0,lt[2]=0,lt[1]=1,lt[0]=1;
	assign lu[4]=1, lu[3]=0,lu[2]=1,lu[1]=0,lu[0]=0;
	assign lv[4]=1, lv[3]=0,lv[2]=1,lv[1]=0,lv[0]=1;
	assign lw[4]=1, lw[3]=0,lw[2]=1,lw[1]=1,lw[0]=0;
	assign lx[4]=1, lx[3]=0,lx[2]=1,lx[1]=1,lx[0]=1;
	assign ly[4]=1, ly[3]=1,ly[2]=0,ly[1]=0,ly[0]=0;
	assign lz[4]=1, lz[3]=1,lz[2]=0,lz[1]=0,lz[0]=1;
	
	mam one(a,la,b,lb,v1,o1); //layer1
	mam two(c,lc,d,ld,v2,o2);
	mam three(e,le,f,lf,v3,o3);
	mam four(g,lg,h,lh,v4,o4);
	mam five(i,li,j,lj,v5,o5);
	mam six(k,lk,l,ll,v6,o6);
	mam seven(m,lm,n,ln,v7,o7);
	mam eight(o,lo,p,lp,v8,o8);
	mam nine(q,lq,r,lr,v9,o9);
	mam ten(s,ls,t,lt,v10,o10);
	mam eleven(u,lu,v,lv,v11,o11);
	mam tweleve(w,lw,x,lx,v12,o12);
	mam thirteenth(y,ly,z,lz,v13,o13);
	
	mam fourt(v1,o1,v2,o2,v14,o14); //layer2
	mam fift(v3,o3,v4,o4,v15,o15);
	mam sixt(v5,o5,v6,o6,v16,o16);
	mam sevent(v7,o7,v8,o8,v17,o17);
	mam eightt(v9,o9,v10,o10,v18,o18);
	mam ninet(v11,o11,v12,o12,v19,o19);
	
	mam twote(v14,o14,v15,o15,v20,o20); //layer3 and 4
	mam twoone(v16,o16,v17,o17,v21,o21);
	mam twotwo(v19,o19,v13,o13,v22,o22);
	mam twothree(v20,o20,v21,o21,v23,o23);
	mam twofour(v18,o18,v22,o22,v24,o24);
	mam twofive(v23,o23,v24,o24,value,out);
	
endmodule
