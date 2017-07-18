
module clock_hard_macro_sync(
	input  wire clock_route_path_syncer,
	input  wire clock_route_path_syncee,
	input  wire async_resetn,
	input  wire async_test_en,
	input  wire async_enable,
	output wire async_enable_ack,
	output wire clock_route_path_out
);

wire clock = clock_route_path_syncer;
wire control_path_clock;

clock_route_control_sync sync_control(
	.async_resetn(async_resetn),
	.clock(clock),
	.control_path_clock(control_path_clock),
	.async_enable(async_enable),
	.async_enable_ack(async_enable_ack),
	.control_path_data0_or_gate(control_path_data0_or_gate),
	.control_path_data1_and_gate(control_path_data1_and_gate),
	.control_path_enable(control_path_enable)
);


clock_route_path_sync sync_path(
	.clock_route_path_out(clock_route_path_out),
	.clock_route_path_syncer(clock_route_path_syncer),
	.clock_route_path_syncee(clock_route_path_syncee),
	.control_path_clock(control_path_clock),
	.control_path_data0_or_gate(control_path_data0_or_gate),
	.control_path_data1_and_gate(control_path_data1_and_gate),
	.control_path_enable(control_path_enable)
);

endmodule

