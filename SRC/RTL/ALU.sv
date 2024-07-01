//Author : Kevin GUILLOUX
//Last modified : 10/05/2024
//Comment : ALU module, allowing a RISCV-rv32i type processor to do every arithmetic operations available to him

`timescale 1ns/1ps

import RISCV32i_Pack::*;

module ALU (
	input data_bus op1_i, op2_i,
	input logic [3:0] func_i,
	output data_bus d_o,
	output logic zero_o,
	output logic lt_o
);
	//Internal connections declaration
	////Input to operations
	logic [4:0] op2_to_dec_s;
	////Operations to mux
	data_bus add_to_mux_s;
	data_bus sub_to_mux_s;
	data_bus decL_left_to_mux_s;
	data_bus decL_right_to_mux_s;
	data_bus decA_right_to_mux_s;
	data_bus and_to_mux_s;
	data_bus or_to_mux_s;
	data_bus xor_to_mux_s;
	data_bus comp_signed_to_mux_s;
	data_bus comp_unsigned_to_mux_s;
	data_bus zero_to_mux_s;
	////Mux to comparator for logical outputs
	data_bus mux_to_comp_fin_s;
	data_bus zero_to_comp_fin_s;
	//Operation modules declarations
	adder_n_bits #(32) ADDER (
		.A_i(op1_i),
		.B_i(op2_i),
		.Cin_i(0),
		.S_o(add_to_mux_s)
	);
	substract #(32) SUB (
		.A_i(op1_i),
		.B_i(op2_i),
		.Bin_i(0),
		.S_o(sub_to_mux_s)
	);
	shifter_left_logical #(32,5) SHIFT_L_L (
		.data_i(op1_i),
		.shift_value_i(op2_to_dec_s),
		.data_o(decL_left_to_mux_s)
	);
	shifter_right_logical #(32,5) SHIFT_R_L (
		.data_i(op1_i),
		.shift_value_i(op2_to_dec_s),
		.data_o(decL_right_to_mux_s)
	);
	shifter_right_arithmetic #(32,5) SHIFT_R_A (
		.data_i(op1_i),
		.shift_value_i(op2_to_dec_s),
		.data_o(decA_right_to_mux_s)
	);
	and_gate #(0,32) AND (
		.a_i(op1_i),
		.b_i(op2_i),
		.s_o(and_to_mux_s)
	);
	or_gate #(0,32) OR (
		.a_i(op1_i),
		.b_i(op2_i),
		.s_o(or_to_mux_s)
	);
	xor_gate #(0,32) XOR (
		.a_i(op1_i),
		.b_i(op2_i),
		.s_o(xor_to_mux_s)
	);
	comparator_signed #(32) COMP_S1 (
		.A_i(op1_i),
		.B_i(op2_i),
		.lesser_o(comp_signed_to_mux_s[0])
	);
	comparator_unsigned #(32) COMP_U (
		.A_i(op1_i),
		.B_i(op2_i),
		.lesser_o(comp_unsigned_to_mux_s[0])
	);
	//MUX declaration
	configurable_mux #(4,32) MUX (
		.data_i({zero_to_mux_s,
			zero_to_mux_s,
			zero_to_mux_s,
			zero_to_mux_s,
			op1_i,
			comp_unsigned_to_mux_s,
			comp_signed_to_mux_s,
			xor_to_mux_s,
			or_to_mux_s,
			and_to_mux_s,
			decA_right_to_mux_s,
			decL_right_to_mux_s,
			decL_left_to_mux_s,
			sub_to_mux_s,
			add_to_mux_s,
			zero_to_mux_s}),
		.sel_i(func_i),
		.data_o(mux_to_comp_fin_s)
	);
	//Logical output comparator declaration
	comparator_signed #(32) COMP_S2 (
		.A_i(mux_to_comp_fin_s),
		.B_i(zero_to_comp_fin_s),
		.equal_o(zero_o),
		.lesser_o(lt_o)
	);
	//Values assignations
	assign op2_to_dec_s = op2_i[4:0];
	assign zero_to_mux_s = 32'h00000000;
	assign zero_to_comp_fin_s = 32'h00000000;
	assign comp_signed_to_mux_s[31:1] = 31'b0000000000000000000000000000000;
	assign comp_unsigned_to_mux_s[31:1] = 31'b0000000000000000000000000000000;
	assign d_o = mux_to_comp_fin_s;
endmodule : ALU