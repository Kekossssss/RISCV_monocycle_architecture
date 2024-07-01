//Author : Kevin GUILLOUX
//Last modified : 15/05/2024
//Comment : Module rassembling all the operations on the instructions in the RISCV-RV32i monocycle architecture

`timescale 1ns / 1ps

import RISCV32i_Pack::*;

module data_path_monocycle(
    input logic clk_i, rst_i,
    input logic reg_write_enable_i,
    input logic alu_src_1_i, alu_src_2_i,
    input logic [2:0] imm_gen_sel_i,
    input logic [3:0] alu_function_i,
    output logic zero_o, lt_o,
    output data_bus instruction_o
    );
    //Internal connections declaration
    data_bus rs1_data_to_mux_alu_src1_s, rs2_data_to_mux_alu_src2_s;
    data_bus mux_alu_src1_to_alu_op1_s, mux_alu_src2_to_alu_op2_s;
    data_bus alu_to_rd_data_s;
    data_bus instruction_memory_output_s;
    data_bus imm_gen_to_mux_alu_s;
    logic [7:0] address_adder_to_reg_s;
    logic [7:0] address_reg_to_adder_and_instruction_memory_s;
    //Module declaration
    ALU ALU (
        .op1_i(mux_alu_src1_to_alu_op1_s),
        .op2_i(mux_alu_src2_to_alu_op2_s),
        .func_i(alu_function_i),
        .d_o(alu_to_rd_data_s),
        .zero_o(zero_o),
        .lt_o(lt_o)
    );
    register_bank #(32,5,32) REG_BANK (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .write_enable_i(reg_write_enable_i),
        .rs1_add_i(instruction_memory_output_s[19:15]),
        .rs2_add_i(instruction_memory_output_s[24:20]),
        .rd_add_i(instruction_memory_output_s[11:7]),
        .rd_data_i(alu_to_rd_data_s),
        .rs1_data_o(rs1_data_to_mux_alu_src1_s),
        .rs2_data_o(rs2_data_to_mux_alu_src2_s)
    );
    instruction_rom INSTR_MEM (
        .addr_i(address_reg_to_adder_and_instruction_memory_s),
        .data_o(instruction_memory_output_s)
    );
    register_n_bits #(8) ADDR_REG (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .write_enable_i(1),
        .D_i(address_adder_to_reg_s),
        .Q_o(address_reg_to_adder_and_instruction_memory_s)
    );
    adder_n_bits #(8) DUT (
		.A_i(address_reg_to_adder_and_instruction_memory_s),
		.B_i(8'h04),
		.Cin_i(0),
		.S_o(address_adder_to_reg_s)
	);
	imm_gen_v1 IMM_GEN (
        .instruction_i(instruction_memory_output_s),
        .imm_gen_sel_i(imm_gen_sel_i),
        .imm_extend_o(imm_gen_to_mux_alu_s)
    );
    configurable_mux #(1,32) MUX_ALU_SRC1 (
		.data_i({imm_gen_to_mux_alu_s,
		        rs1_data_to_mux_alu_src1_s}),
		.sel_i(alu_src_1_i),
		.data_o(mux_alu_src1_to_alu_op1_s)
	);
	configurable_mux #(1,32) MUX_ALU_SRC2 (
		.data_i({imm_gen_to_mux_alu_s,
		        rs2_data_to_mux_alu_src2_s}),
		.sel_i(alu_src_2_i),
		.data_o(mux_alu_src2_to_alu_op2_s)
	);
	//Instruction output to control path
	assign instruction_o = instruction_memory_output_s;
endmodule : data_path_monocycle
