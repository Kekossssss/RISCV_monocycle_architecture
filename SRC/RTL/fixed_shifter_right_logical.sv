//Author : Kevin GUILLOUX
//Last modified : 10/05/2024
//Comment : Shifter for right logical shifts, fixed in shifting value(passed in parameter), configurable for data lenght, default : 32 bits for data and 1 for shifting value

`timescale 1ns/1ps

module fixed_shifter_right_logical #(
	parameter nb_bits_data = 32,
	parameter shift_value = 1
)(
	input logic [nb_bits_data-1:0] data_i,
	input logic enable_i,
	output logic [nb_bits_data-1:0] data_o
);
	//Internal connections declaration
	logic [nb_bits_data-1:0] data_s;
	//Mux declaration
	configurable_mux #(1,32) MUX (
		.data_i({data_i,
			data_s}),
		.sel_i(enable_i),
		.data_o(data_o)
	);
	//Shift of the bits by the fixed value
	assign data_s[nb_bits_data - shift_value-1:0] = data_i[nb_bits_data-1:shift_value];
	assign data_s[nb_bits_data-1:nb_bits_data - shift_value] = 0;
endmodule : fixed_shifter_right_logical
