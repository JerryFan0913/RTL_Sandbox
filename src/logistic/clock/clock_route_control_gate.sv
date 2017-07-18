module clock_route_control_gate(
	input  wire clock,
	input  wire async_enable,
	input  wire async_resetn,
	output wire async_enable_ack,
	input  wire async_test_en,
	output wire control_path_enable
);

wire clock_inv = ~clock;

clock_logic_cross_sync_0  enable_sync(
	.clock(clock_inv),
	.resetn(async_resetn),
	.data_in(async_enable),
	.data_out(control_path_enable)
);

assign async_enable_ack = control_path_enable;

endmodule

