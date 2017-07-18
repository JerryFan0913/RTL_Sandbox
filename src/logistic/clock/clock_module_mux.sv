module clock_module_mux(
	input  wire clock,
	input  wire async_resetn,

	output wire parent0_request,
	input  wire parent0_ready,
	input  wire parent0_silent,
	input  wire parent0_starting,
	input  wire parent0_stopping,
	
	output wire parent1_request,
	input  wire parent1_ready,
	input  wire parent1_silent,
	input  wire parent1_starting,
	input  wire parent1_stopping,
	
	input  wire child_request,
	output wire child_ready,
	output wire child_silent,
	output wire child_starting,
	output wire child_stopping,

	output wire clock_route_path_out,
	input  wire clock_route_path_in0,
	input  wire clock_route_path_in1
);

wire async_enable0;
wire async_enable1;
wire async_enable0_ack;
wire async_enable1_ack;


clock_control_logic_mux control(
	.clock(clock),
	.async_resetn(async_resetn),

	.parent0_request(parent0_request),
	.parent0_ready(parent0_ready),
	.parent0_silent(parent0_silent),
	.parent0_starting(parent0_starting),
	.parent0_stopping(parent0_stopping),
	
	.parent1_request(parent1_request),
	.parent1_ready(parent1_ready),
	.parent1_silent(parent1_silent),
	.parent1_starting(parent1_starting),
	.parent1_stopping(parent1_stopping),
	
	.child_request(child_request),
	.child_ready(child_ready),
	.child_silent(child_silent),
	.child_starting(child_starting),
	.child_stopping(child_stopping),

	.async_enable0(async_enable0),
	.async_enable1(async_enable1),
	.async_enable0_ack(async_enable0_ack),
	.async_enable1_ack(async_enable1_ack)
);

clock_hard_macro_mux slice(
	.clock_route_path_out(clock_route_path_out),
	.clock_route_path_in0(clock_route_path_in0),
	.clock_route_path_in1(clock_route_path_in1),
	.async_resetn(async_resetn),
	.async_enable0(async_enable0),
	.async_enable1(async_enable1),
	.async_enable0_ack(async_enable0_ack),
	.async_enable1_ack(async_enable1_ack),
	.async_test_en(async_test_en)
);

endmodule

