//Author : Kevin GUILLOUX
//Last modified : 10/05/2024
//Comment : Shifter for right arithmetic shifts, fixed in shifting value(passed in parameter), configurable for data lenght, default : 32 bits for data and 1 for shifting value

`timescale 1ns/1ps

module fixed_shifter_right_arithmetic #(
	parameter nb_bits_data = 32,
	parameter shift_value = 1
)(
	input logic [nb_bits_data-1:0] data_i,
	input logic enable_i,
	output logic [nb_bits_data-1:0] data_o
);
	//Internal connections declaration
	logic [nb_bits_data-1:0] data_s;
	genvar i;
	//Mux declaration
	configurable_mux #(1,32) MUX (
		.data_i({data_i,
			data_s}),
		.sel_i(enable_i),
		.data_o(data_o)
	);
	//Shift of the bits by the fixed value
	generate
		for (i=nb_bits_data-1;i>=0;i--) begin : shift
			if (i >= nb_bits_data - shift_value) begin 
				assign data_s[i] = data_i[nb_bits_data-1];
			end
			else begin
				assign data_s[i] = data_i[i+shift_value];
			end
		end : shift
	endgenerate				
endmodule : fixed_shifter_right_arithmetic
