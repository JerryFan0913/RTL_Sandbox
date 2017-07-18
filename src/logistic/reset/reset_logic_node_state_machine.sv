module reset_logic_node_state_machine(
	input  wire clock,
	input  wire async_resetn,
	input  wire request,
	input  wire stopped,
	input  wire started,
	output wire reset_stopping,
	output wire internal_request,
	output wire internal_silent,
	output wire internal_ready,
	output wire internal_stopping,
	output wire internal_starting
);

parameter POWER_NODE_STATUS_CLKREADY	= 3'b000;
parameter POWER_NODE_STATUS_CKSILENT	= 3'b001;
parameter POWER_NODE_STATUS_STOPPING	= 3'b010;
parameter POWER_NODE_STATUS_DFILTER0	= 3'b100;
parameter POWER_NODE_STATUS_STARTING	= 3'b101;

reg [2:0]state;
reg [2:0]next_state;

always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		state <= POWER_NODE_STATUS_CKSILENT;
	else
		state <= next_state;

end


always @(*)
begin
	case(state)
		POWER_NODE_STATUS_CLKREADY: next_state = request ? POWER_NODE_STATUS_CLKREADY : POWER_NODE_STATUS_DFILTER0;
		POWER_NODE_STATUS_DFILTER0: next_state = request ? POWER_NODE_STATUS_CLKREADY : POWER_NODE_STATUS_STOPPING;
		POWER_NODE_STATUS_STOPPING: next_state = stopped ? POWER_NODE_STATUS_CKSILENT : POWER_NODE_STATUS_STOPPING;
		POWER_NODE_STATUS_CKSILENT: next_state = request ? POWER_NODE_STATUS_STARTING : POWER_NODE_STATUS_CKSILENT;
		POWER_NODE_STATUS_STARTING: next_state = started ? POWER_NODE_STATUS_CLKREADY : POWER_NODE_STATUS_STARTING;
	endcase
end

assign internal_request = state != POWER_NODE_STATUS_CKSILENT;
assign internal_ready = state == POWER_NODE_STATUS_CLKREADY | state == POWER_NODE_STATUS_DFILTER0;
assign internal_silent  = state == POWER_NODE_STATUS_CKSILENT & ~request;
assign internal_stopping  = state == POWER_NODE_STATUS_STOPPING | state == POWER_NODE_STATUS_DFILTER0;
assign internal_starting  = state == POWER_NODE_STATUS_STARTING;

assign reset_stopping  = state == POWER_NODE_STATUS_STOPPING;

endmodule

