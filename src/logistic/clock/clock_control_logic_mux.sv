module clock_control_logic_mux(
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

	output wire async_enable0,
	output wire async_enable1,
	input  wire async_enable0_ack,
	input  wire async_enable1_ack
);

wire enable;
wire enable_delay;
wire enable_out;

reg select;


reg internal_enable0;
reg internal_enable1;
reg enable0_out;
reg enable1_out;
wire enable0_ack;
wire enable1_ack;

wire changeable_silent;
wire changeable_ready;
wire changeable = changeable_silent | changeable_ready;


always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
	begin
		internal_enable0 <= 1'b0;
		internal_enable1 <= 1'b0;
		enable0_out <= 1'b0;
		enable1_out <= 1'b0;
	end
	else if(changeable)
	begin
		internal_enable0 <= (select == 1'b0);
		internal_enable1 <= (select == 1'b1);
		enable0_out <= (select == 1'b0) & (enable | enable_delay);
		enable1_out <= (select == 1'b1) & (enable | enable_delay);
	end
	else
	begin
		enable0_out <= internal_enable0 & (enable | enable_delay);
		enable1_out <= internal_enable1 & (enable | enable_delay);
	end
end

assign async_enable0 = enable0_out;
assign async_enable1 = enable1_out;

wire select_pending = ~(select & internal_enable1 & ~internal_enable0) & ~(~select & ~internal_enable1 & internal_enable0);

wire change_done = (enable0_out == enable0_ack) & (enable1_out == enable1_ack);


always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		select <= 1'b0;
	else
		select <= select;//FIXME
end


clock_logic_cross_sync_0  enable0_ack_sync(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(async_enable0_ack),
	.data_out(enable0_ack)
);

clock_logic_cross_sync_0  enable1_ack_sync(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(async_enable1_ack),
	.data_out(enable1_ack)
);

reg changing_request;
always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		changing_request <= 1'b0;
	else if(child_ready & select_pending)
		changing_request <= 1'b1;
	else if(change_done)
		changing_request <= 1'b0;
end


wire parent_request;
wire parent_ready;
wire parent_silent;
wire parent_starting;
wire parent_stopping;



assign enable_ack = (internal_enable0 & enable0_ack) | (internal_enable1 & enable1_ack);


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

assign started = enable_out && enable_ack;
assign stopped = ~enable_out && ~enable_ack;

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

assign enable = parent_ready & ~parent_stopping & (child_request & ~clock_stopping | internal_starting);

clock_logic_delay_chain_0 enable_filter(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(enable),
	.data_delay_1(enable_delay)
);


assign enable_out = enable0_out | enable1_out;

assign changeable_silent = child_silent;
assign changeable_ready = parent0_ready & ~parent0_stopping & parent1_ready & ~parent1_stopping;

assign parent0_request = changing_request | (internal_enable0 & parent_request);
assign parent1_request = changing_request | (internal_enable1 & parent_request);

assign parent_ready = (internal_enable0 & parent0_ready) | (internal_enable1 & parent1_ready);
assign parent_silent = (internal_enable0 & parent0_silent) | (internal_enable1 & parent1_silent);
assign parent_starting = (internal_enable0 & parent0_starting) | (internal_enable1 & parent1_starting);
assign parent_stopping = (internal_enable0 & parent0_stopping) | (internal_enable1 & parent1_stopping);

endmodule

