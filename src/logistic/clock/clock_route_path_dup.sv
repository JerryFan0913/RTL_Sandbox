module clock_route_path_dup(
	output wire clock_route_path_out0,
	output wire clock_route_path_out1,
	input  wire clock_route_path_in
);

assign clock_route_path_out0 = clock_route_path_in;
assign clock_route_path_out1 = clock_route_path_in;

endmodule

