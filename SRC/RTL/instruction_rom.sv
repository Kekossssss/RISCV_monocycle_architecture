//Author : Kevin GUILLOUX
//Last modified : 12/05/2024
//Comment : Instruction ROM, memory with preregistered instructions in 32 bits format
//          Data is stored at adresses espaced by a value of 4

`timescale 1ns / 1ps

module instruction_rom(
    input logic [7:0] addr_i,
    output logic [31:0] data_o
    );
    //Internal connection declaration
    logic [255:0][31:0] data_s;
    //Memory data assignement
    assign data_s[0] = 32'h00000000;
    assign data_s[1] = 32'h00108093;
    assign data_s[2] = 32'h001080B3;
    assign data_s[3] = 32'h001080B3;
    assign data_s[4] = 32'h55555555;
    assign data_s[5] = 32'h66666666;
    assign data_s[6] = 32'h77777777;
    //Data output logic
    assign data_o = data_s[addr_i[7:2]];
endmodule : instruction_rom
