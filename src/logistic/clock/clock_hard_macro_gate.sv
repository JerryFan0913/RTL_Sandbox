module clock_hard_macro_gate(
	output wire clock_route_path_out,
	input  wire clock_route_path_in,
	input  wire async_resetn,
	input  wire async_enable,
	output wire async_enable_ack,
	input  wire async_test_en
);

wire clock = clock_route_path_in;

clock_route_control_gate gate_control(
	.clock(clock),
	.async_enable(async_enable),
	.async_resetn(async_resetn),
	.async_enable_ack(async_enable_ack),
	.control_path_enable(control_path_enable)
);

clock_route_path_gate gate_path(
	.clock_route_path_out(clock_route_path_out),
	.clock_route_path_in(clock_route_path_in),
	.control_path_enable(control_path_enable),
	.test_en(async_test_en)
);

endmodule

