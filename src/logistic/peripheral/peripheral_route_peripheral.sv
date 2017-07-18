module peripheral_route_peripheral(
	input  wire clock,
	input  wire async_resetn,

	input  wire enable_req,
	output wire enable_ack,

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


assign isolate_request = ~isolate_stopping & enable_req & reset_ready;
assign switchl_request = ~switchl_stopping & enable_req | ~isolate_silent;
assign switchh_request = ~switchh_stopping & enable_req & switchl_ready | ~isolate_silent;
assign reset_request = ~reset_stopping & enable_req & switchh_ready | ~isolate_silent;
assign clock_request = ~clock_stopping & enable_req & isolate_ready;

reg enabled;
always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		enabled <= 1'b0;
	else if(isolate_ready & switchl_ready & switchh_ready & reset_ready & clock_ready)
		enabled <= 1'b1;
	else if(isolate_silent & switchl_silent & switchh_silent & reset_silent & clock_silent)
		enabled <= 1'b0;
end

assign enable_ack = enabled;

endmodule

/*
module testbench_peripheral_route_peripheral();
reg clock;
reg clock_root;
reg async_resetn;
reg enable_req;
initial
begin
	clock = 0;
	clock_root = 0;
	async_resetn = 0;
	enable_req = 0;
	# 10;
	async_resetn = 1;

	#100;
	enable_req <= 1;
	#1000;
	enable_req <= 0;
	#98;
	enable_req <= 1;
	#1000;
	enable_req <= 0;
	#1000;

end

always
	#10 clock = ~clock;


peripheral_route_peripheral dut(
	.clock(clock),
	.async_resetn(async_resetn),

	.enable_req(enable_req),
	.enable_ack(),

	.peripheral()
);

endmodule
*/

