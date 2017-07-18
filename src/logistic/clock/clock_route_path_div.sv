module clock_route_path_div(
	output wire clock_route_path_out,
	input  wire clock_route_path_in,
	input  wire control_path_data0_or_gate,
	input  wire control_path_data1_and_gate
);

clock_cell_mux mux(
	.ina(control_path_data0_or_gate),
	.inb(control_path_data1_and_gate),
	.sel(clock_route_path_in),
	.out(clock_route_path_out)
);

endmodule

