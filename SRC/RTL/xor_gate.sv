//Author : Kevin GUILLOUX
//Last modified : 10/05/2024
//Comment : Configurable XOR gate configurable, on single bit mode in basic mode

`timescale 1ns/1ps

module xor_gate #(
	parameter delay = 0,
	parameter nb_bits = 1
) (

	input logic [nb_bits - 1 : 0] a_i, b_i,
	output logic [nb_bits - 1 : 0] s_o
);
	assign #delay s_o = (a_i ^ b_i);
endmodule : xor_gate
