module clock_route_path_gate(
	output wire clock_route_path_out,
	input  wire clock_route_path_in,
	input  wire control_path_enable,
	input  wire test_en
);

clock_cell_gate gate(
	.ck(clock_route_path_in),
	.en(control_path_enable),
	.out(clock_route_path_out)
);

endmodule

