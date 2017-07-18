module clock_module_div(
	input  wire clock,
	input  wire async_resetn,

	output wire parent_request,
	input  wire parent_ready,
	input  wire parent_silent,
	input  wire parent_starting,
	input  wire parent_stopping,
	
	input  wire child_request,
	output wire child_ready,
	output wire child_silent,
	output wire child_starting,
	output wire child_stopping,

	output wire clock_route_path_out,
	input  wire clock_route_path_in
);

wire async_update;
wire [7:0] mfi;
wire [7:0] mfn;
wire [7:0] mfd;
wire async_update_ack;


clock_control_logic_div control(
	.clock(clock),
	.async_resetn(async_resetn),

	.parent_request(parent_request),
	.parent_ready(parent_ready),
	.parent_silent(parent_silent),
	.parent_starting(parent_starting),
	.parent_stopping(parent_stopping),
	
	.child_request(child_request),
	.child_ready(child_ready),
	.child_silent(child_silent),
	.child_starting(child_starting),
	.child_stopping(child_stopping),

	.async_update(async_update),
	.async_update_ack(async_update_ack),
	.mfi(mfi),
	.mfn(mfn),
	.mfd(mfd),

	.async_enable(async_enable),
	.async_enable_ack(async_enable_ack)
);

clock_hard_macro_div slice(
	.clock_route_path_out(clock_route_path_out),
	.clock_route_path_in(clock_route_path_in),
	.async_enable(async_enable),
	.async_resetn(async_resetn),
	.async_enable_ack(async_enable_ack),
	.async_update(async_update),
	.async_update_ack(async_update_ack),
	.mfi(mfi),
	.mfn(mfn),
	.mfd(mfd),
	.async_test_en(async_test_en)
);

endmodule

