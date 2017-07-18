module clock_hard_macro_div(
	output wire clock_route_path_out,
	input  wire clock_route_path_in,
	input  wire async_resetn,
	input  wire async_enable,
	output wire async_enable_ack,
	input  wire async_update,
	input  wire [7:0] mfi,
	input  wire [7:0] mfn,
	input  wire [7:0] mfd,
	output wire async_update_ack,
	input  wire async_test_en
);


wire clock = clock_route_path_in;

clock_route_control_div div_control(
	.clock(clock),
	.async_resetn(async_resetn),
	.async_enable(async_enable),
	.async_enable_ack(async_enable_ack),
	.async_update(async_update),
	.async_update_ack(async_update_ack),
	.mfi(mfi),
	.mfn(mfn),
	.mfd(mfd),
	.control_path_data0_or_gate(control_path_data0_or_gate),
	.control_path_data1_and_gate(control_path_data1_and_gate)
);


clock_route_path_div div_path(
	.clock_route_path_out(clock_route_path_out),
	.clock_route_path_in(clock_route_path_in),
	.control_path_data0_or_gate(control_path_data0_or_gate),
	.control_path_data1_and_gate(control_path_data1_and_gate)
);

endmodule

