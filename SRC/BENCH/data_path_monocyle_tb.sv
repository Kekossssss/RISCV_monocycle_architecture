//Author : Kevin GUILLOUX
//Last modified : 15/05/2024
//Comment : Testbench of the data path module, for the monocycle architecture

`timescale 1ns / 1ps

import RISCV32i_Pack::*;

module data_path_monocyle_tb();
    logic clk_s = 1'b0;
    logic rst_s = 1'b0;
    logic reg_write_enable_s;
    logic alu_src_1_s, alu_src_2_s;
    logic [2:0] imm_gen_sel_s;
    logic [3:0] alu_function_s;
    logic zero_s, lt_s;
    data_bus instruction_s;
    //Tested module declaration
    data_path_monocycle DUT (
        .clk_i(clk_s),
        .rst_i(rst_s),
        .reg_write_enable_i(reg_write_enable_s),
        .alu_src_1_i(alu_src_1_s),
        .alu_src_2_i(alu_src_2_s),
        .imm_gen_sel_i(imm_gen_sel_s),
        .alu_function_i(alu_function_s),
        .zero_o(zero_s),
        .lt_o(lt_s),
        .instruction_o(instruction_s)
    );
    //Clock generation
    always begin
		assign clk_s = ~clk_s;
     	#10;
   	end
   	//Test
   	initial begin
   	    reg_write_enable_s = 1'b0;
   	    alu_src_1_s = 1'b0;
   	    alu_src_2_s = 1'b0;
   	    imm_gen_sel_s = 3'h0;
   	    alu_function_s = 4'h0;
   	    #2;
   	    rst_s = 1'b1;
   	    #20;
   	    reg_write_enable_s = 1'b1;
   	    alu_function_s = 4'h1;
   	    alu_src_2_s = 1'b1;
   	    imm_gen_sel_s = 3'h1;
   	    #20;
   	    alu_src_2_s = 1'b0;
   	end
endmodule : data_path_monocyle_tb
