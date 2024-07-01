//Author : Kevin GUILLOUX
//Last modified : 11/05/2024
//Comment : Configurable data register, updating on rising edge clock, and using a Write enable input

`timescale 1ns / 1ps

module register_n_bits #(
    parameter nb_bits = 1
)(
    input logic clk_i,
    input logic rst_i,
    input logic write_enable_i,
    input logic [nb_bits-1:0] D_i,
    output logic [nb_bits-1:0] Q_o
    );
    //Process
    always_ff @(posedge clk_i or negedge rst_i) begin : seq_0
        if (rst_i == 1'b0) Q_o <= 0;
        else if (write_enable_i == 1'b1) Q_o <= D_i;
    end : seq_0
endmodule : register_n_bits
