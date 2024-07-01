//Author : Kevin GUILLOUX
//Last modified : 12/05/2024
//Comment : Testbench for the instruction ROM memory module

`timescale 1ns / 1ps

module instruction_rom_tb();
    logic [7:0] addr_s;
    logic [31:0] data_s;
    //Tested module declaration
    instruction_rom DUT (
        .addr_i(addr_s),
        .data_o(data_s)
    );
    //Test
    initial begin
        addr_s = 8'h00;
        #20;
        addr_s = 8'h04;
        #20;
        addr_s = 8'h08;
        #20;
        addr_s = 8'h0c;
        #20;
        addr_s = 8'h10;
        #20;
        addr_s = 8'h14;
        #20;
        addr_s = 8'h18;
        #20;
        addr_s = 8'h1c;
        #20;
        addr_s = 8'h20;
    end
endmodule : instruction_rom_tb
