module clock_route_path_out(
	output wire clock_route_path_out,
	input  wire clock_route_path_in0,
	input  wire clock_route_path_in1,
	input  wire control_path_enable0,
	input  wire control_path_enable1,
	input  wire async_test_en
);

wire clock_route_path_out0;
wire clock_route_path_out1;

clock_route_path_gate gate_path0(
	.clock_route_path_out(clock_route_path_out0),
	.clock_route_path_in(clock_route_path_in0),
	.control_path_enable(control_path_enable0),
	.test_en(async_test_en)
);

clock_route_path_gate gate_path1(
	.clock_route_path_out(clock_route_path_out1),
	.clock_route_path_in(clock_route_path_in1),
	.control_path_enable(control_path_enable1),
	.test_en(async_test_en)
);

clock_cell_or log_or(
	.ina(clock_route_path_out0),
	.inb(clock_route_path_out1),
	.out(clock_route_path_out)
);

endmodule

