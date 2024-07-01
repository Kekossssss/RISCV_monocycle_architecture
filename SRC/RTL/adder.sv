//Author : Kevin GUILLOUX
//Last modified : 10/05/2024
//Comment : Single bit complete adder, with carry flag on input and output

`timescale 1ns/1ps

module adder (
	input logic A_i, B_i, Cin_i,
	output logic S_o, Cout_o
);
	//Internal connections declaration
	logic n1_s, n2_s, n3_s;
	//Modules declaration
	half_adder half1 (
		.a_i(n2_s),
		.b_i(B_i),
		.s_o(S_o),
		.c_o(n3_s)
	);
	half_adder half2 (
		.a_i(Cin_i),
		.b_i(A_i),
		.s_o(n2_s),
		.c_o(n1_s)
	);
	or_gate #(0,1) OR1 (
		.a_i(n1_s),
		.b_i(n3_s),
		.s_o(Cout_o)
	);
endmodule : adder	
