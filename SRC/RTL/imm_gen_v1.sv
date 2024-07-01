//Author : Kevin GUILLOUX
//Last modified : 15/05/2024
//Comment : Module allowing to extract the values included in the instructions and to give them out in a 32 bit format

`timescale 1ns / 1ps

import RISCV32i_Pack::*;

module imm_gen_v1(
    input data_bus instruction_i,
    input logic [2:0] imm_gen_sel_i,
    output data_bus imm_extend_o
    );
    //Internal connection declaration
    data_bus zero_to_mux_s;
    data_bus zero_extend_Itype_to_mux_s;
    data_bus zero_extend_Utype_to_mux_s;
    data_bus zero_extend_Stype_to_mux_s;
    //Module declaration
    configurable_mux #(3,32) MUX (
		.data_i({zero_extend_Stype_to_mux_s,
		         zero_extend_Utype_to_mux_s,
		         zero_extend_Itype_to_mux_s,
		         zero_to_mux_s}),
		.sel_i(imm_gen_sel_i),
		.data_o(imm_extend_o)
	);
	//Signals assignation
	assign zero_to_mux_s = 32'h00000000;
	////I type instruction
	assign zero_extend_Itype_to_mux_s[11:0] = instruction_i[31:20];
	assign zero_extend_Itype_to_mux_s[31:12] = 20'h00000;
	////U type instruction
	assign zero_extend_Utype_to_mux_s[31:12] = instruction_i[31:12];
	assign zero_extend_Utype_to_mux_s[11:0] = 12'h000;
	////S type instruction
	assign zero_extend_Stype_to_mux_s[11:5] = instruction_i[31:25];
	assign zero_extend_Stype_to_mux_s[4:0] = instruction_i[11:7];
	assign zero_extend_Stype_to_mux_s[31:12] = 20'h00000;
endmodule : imm_gen_v1
