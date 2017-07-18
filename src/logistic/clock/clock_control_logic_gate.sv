module clock_control_logic_gate(
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

	output wire async_enable,
	input  wire async_enable_ack
);


wire enable_ack_sync;

clock_logic_cross_sync_0  enable_ack_syncer(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(async_enable_ack),
	.data_out(enable_ack_sync)
);


wire clock_stopping;
wire internal_request;
wire internal_ready;
wire internal_silent;
wire internal_starting;
wire internal_stopping;
wire started;
wire stopped;

assign parent_request = child_request | internal_request;
assign child_ready = parent_ready & internal_ready;
assign child_silent = parent_silent | internal_silent;
assign child_starting = internal_starting;
assign child_stopping = internal_stopping;

assign started = async_enable && enable_ack_sync;
assign stopped = ~async_enable && ~enable_ack_sync;

clock_logic_node_state_machine state_machine(
	.clock(clock),
	.async_resetn(async_resetn),
	.request(child_request),
	.stopped(stopped),
	.started(started),
	.clock_stopping(clock_stopping),
	.internal_request(internal_request),
	.internal_silent(internal_silent),
	.internal_ready(internal_ready),
	.internal_stopping(internal_stopping),
	.internal_starting(internal_starting)
);

wire enable = parent_ready & ~parent_stopping & (child_request & ~clock_stopping | internal_starting);
wire enable_delay;

clock_logic_delay_chain_0 enable_filter(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(enable),
	.data_delay_1(enable_delay)
);

assign enable_out = enable | enable_delay;

clock_logic_delay_chain_0 enable_output(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(enable_out),
	.data_delay_1(async_enable)
);

endmodule

