module clock_hard_macro_out(
	input  wire async_resetn,
	output wire clock_route_path_out,
	input  wire clock_route_path_in0,
	input  wire clock_route_path_in1,
	input  wire async_enable0,
	input  wire async_enable1,
	output wire async_enable0_ack,
	output wire async_enable1_ack,
	input  wire async_test_en
);

wire clock0 = clock_route_path_in0;
wire clock1 = clock_route_path_in1;

clock_route_control_out out_control(
	.async_resetn(async_resetn),
	.clock0(clock0),
	.clock1(clock1),
	.async_enable0_ack(async_enable0_ack),
	.control_path_enable0(control_path_enable0),
	.control_path_enable1(control_path_enable1),
	.async_test_en(async_test_en)
);

clock_route_path_out out_path(
	.clock_route_path_out(clock_route_path_out),
	.clock_route_path_in0(clock_route_path_in0),
	.clock_route_path_in1(clock_route_path_in1),
	.control_path_enable0(control_path_enable0),
	.control_path_enable1(control_path_enable1),
	.async_test_en(async_test_en)
);

endmodule

