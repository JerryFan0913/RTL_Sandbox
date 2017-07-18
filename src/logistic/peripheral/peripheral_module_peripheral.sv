module peripheral_module_peripheral(
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

	output wire clock_request,
	input  wire clock_ready,
	input  wire clock_silent,
	input  wire clock_starting,
	input  wire clock_stopping,

	output wire reset_request,
	input  wire reset_ready,
	input  wire reset_silent,
	input  wire reset_starting,
	input  wire reset_stopping,

	output wire switchl_request,
	input  wire switchl_ready,
	input  wire switchl_silent,
	input  wire switchl_starting,
	input  wire switchl_stopping,

	output wire switchh_request,
	input  wire switchh_ready,
	input  wire switchh_silent,
	input  wire switchh_starting,
	input  wire switchh_stopping,

	output wire isolate_request,
	input  wire isolate_ready,
	input  wire isolate_silent,
	input  wire isolate_starting,
	input  wire isolate_stopping
);

peripheral_control_logic control(
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

peripheral_route_peripheral peripheral(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.enable_req	(enable_req),
	.enable_ack	(enable_ack),

	.clock_request	(clock_request),
	.clock_ready	(clock_ready),
	.clock_silent	(clock_silent),
	.clock_starting	(clock_starting),
	.clock_stopping	(clock_stopping),

	.reset_request	(reset_request),
	.reset_ready	(reset_ready),
	.reset_silent	(reset_silent),
	.reset_starting	(reset_starting),
	.reset_stopping	(reset_stopping),

	.switchl_request(switchl_request),
	.switchl_ready	(switchl_ready),
	.switchl_silent	(switchl_silent),
	.switchl_starting	(switchl_starting),
	.switchl_stopping	(switchl_stopping),

	.switchh_request	(switchh_request),
	.switchh_ready	(switchh_ready),
	.switchh_silent	(switchh_silent),
	.switchh_starting	(switchh_starting),
	.switchh_stopping	(switchh_stopping),

	.isolate_request	(isolate_request),
	.isolate_ready	(isolate_ready),
	.isolate_silent	(isolate_silent),
	.isolate_starting	(isolate_starting),
	.isolate_stopping	(isolate_stopping)
);

endmodule

