module power_module_isolation(
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

	output wire isolation
);

power_control_logic control(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(parent_request),
	.parent_ready	(parent_ready),
	.parent_silent	(parent_silent),
	.parent_starting(parent_starting),
	.parent_stopping(parent_stopping),
	
	.child_request	(child_request),
	.child_ready	(child_ready),
	.child_silent	(child_silent),
	.child_starting	(child_starting),
	.child_stopping	(child_stopping),

	.enable_req	(enable_req),
	.enable_ack	(enable_ack)
);

power_route_isolation isolate(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.enable_req	(enable_req),
	.enable_ack	(enable_ack),

	.isolation	(isolation)
);

endmodule

