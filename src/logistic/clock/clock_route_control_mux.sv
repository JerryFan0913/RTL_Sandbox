module clock_route_control_mux(
	input  wire async_resetn,
	input  wire clock0,
	input  wire clock1,
	input  wire async_enable0,
	input  wire async_enable1,
	output wire async_enable0_ack,
	output wire async_enable1_ack,
	output wire control_path_enable0,
	output wire control_path_enable1,
	input  wire async_test_en
);

wire clock0_inv = ~clock0;
wire async_combine_enable0 = async_enable0 & ~control_path_enable1;

clock_logic_cross_sync_0  enable0_sync(
	.clock(clock0_inv),
	.resetn(async_resetn),
	.data_in(async_combine_enable0),
	.data_out(control_path_enable0)
);

wire clock1_inv = ~clock1;
wire async_combine_enable1 = async_enable1 & ~control_path_enable0;

clock_logic_cross_sync_0  enable1_sync(
	.clock(clock1_inv),
	.resetn(async_resetn),
	.data_in(async_combine_enable1),
	.data_out(control_path_enable1)
);

assign async_enable0_ack = control_path_enable0;
assign async_enable1_ack = control_path_enable1;

endmodule

