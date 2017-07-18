module clock_control_logic_dup(
	output wire parent_request,
	input  wire parent_ready,
	input  wire parent_silent,
	input  wire parent_starting,
	input  wire parent_stopping,

	input  wire child0_request,
	output wire child0_ready,
	output wire child0_silent,
	output wire child0_starting,
	output wire child0_stopping,

	input  wire child1_request,
	output wire child1_ready,
	output wire child1_silent,
	output wire child1_starting,
	output wire child1_stopping
);

assign parent_request = child0_request | child1_request;

assign child0_request	= parent_request;
assign child0_ready	= parent_ready;
assign child0_silent	= parent_silent;
assign child0_starting	= parent_starting;
assign child0_stopping	= parent_stopping;

assign child1_request	= parent_request;
assign child1_ready	= parent_ready;
assign child1_silent	= parent_silent;
assign child1_starting	= parent_starting;
assign child1_stopping	= parent_stopping;

endmodule

