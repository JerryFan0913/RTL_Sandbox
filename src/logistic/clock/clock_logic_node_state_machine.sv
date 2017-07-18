module clock_logic_node_state_machine(
	input  wire clock,
	input  wire async_resetn,
	input  wire request,
	input  wire stopped,
	input  wire started,
	output wire clock_stopping,
	output wire internal_request,
	output wire internal_silent,
	output wire internal_ready,
	output wire internal_stopping,
	output wire internal_starting
);

parameter CLOCK_NODE_STATUS_CLKREADY	= 3'b000;
parameter CLOCK_NODE_STATUS_CKSILENT	= 3'b001;
parameter CLOCK_NODE_STATUS_STOPPING	= 3'b010;
parameter CLOCK_NODE_STATUS_DFILTER0	= 3'b100;
parameter CLOCK_NODE_STATUS_STARTING	= 3'b101;

reg [2:0]state;
reg [2:0]next_state;

always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		state <= CLOCK_NODE_STATUS_CKSILENT;
	else
		state <= next_state;

end


always @(*)
begin
	case(state)
		CLOCK_NODE_STATUS_CLKREADY: next_state = request ? CLOCK_NODE_STATUS_CLKREADY : CLOCK_NODE_STATUS_DFILTER0;
		CLOCK_NODE_STATUS_DFILTER0: next_state = request ? CLOCK_NODE_STATUS_CLKREADY : CLOCK_NODE_STATUS_STOPPING;
		CLOCK_NODE_STATUS_STOPPING: next_state = stopped ? CLOCK_NODE_STATUS_CKSILENT : CLOCK_NODE_STATUS_STOPPING;
		CLOCK_NODE_STATUS_CKSILENT: next_state = request ? CLOCK_NODE_STATUS_STARTING : CLOCK_NODE_STATUS_CKSILENT;
		CLOCK_NODE_STATUS_STARTING: next_state = started ? CLOCK_NODE_STATUS_CLKREADY : CLOCK_NODE_STATUS_STARTING;
	endcase
end

assign internal_request = state != CLOCK_NODE_STATUS_CKSILENT;
assign internal_ready = state == CLOCK_NODE_STATUS_CLKREADY | state == CLOCK_NODE_STATUS_DFILTER0;
assign internal_silent  = state == CLOCK_NODE_STATUS_CKSILENT & ~request;
assign internal_stopping  = state == CLOCK_NODE_STATUS_STOPPING | state == CLOCK_NODE_STATUS_DFILTER0;
assign internal_starting  = state == CLOCK_NODE_STATUS_STARTING;

assign clock_stopping  = state == CLOCK_NODE_STATUS_STOPPING;

endmodule

