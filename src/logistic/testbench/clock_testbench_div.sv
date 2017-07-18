module clock_testbench_div();

reg clock;
reg clock_root;
reg async_resetn;
reg tie5_request;
initial
begin

        $dumpfile("test.vcd");
        $dumpvars(0,clock_testbench_div);
	clock = 0;
	clock_root = 0;
	async_resetn = 0;
	tie5_request = 0;
	# 10;
	async_resetn = 1;

	#100;
	tie5_request <= 1;
	#300000;
	tie5_request <= 0;
	#300000;
	tie5_request <= 1;
	#10000;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 1;
	#1000;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 1;

	#1000;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 1;
	#1000;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 1;

	#1000;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 0;
	@(posedge clock) tie5_request <= 1;

	#10000;
	@(posedge clock) tie5_request <= 0;
	#4000;
	@(posedge clock) tie5_request <= 1;

	#300000;
	$finish;
end


always
	#10 clock = ~clock;

always
	#1 clock_root = ~clock_root;


clock_module_div root(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(root_request),
	.parent_ready	(1'b1),
	.parent_silent	(1'b0),
	.parent_starting(1'b0),
	.parent_stopping(1'b0),
	
	.child_request	(tie1_request),
	.child_ready	(tie1_ready),
	.child_silent	(tie1_silent),
	.child_starting	(tie1_starting),
	.child_stopping	(tie1_stopping),

	.clock_route_path_out	(clock_tie1),
	.clock_route_path_in	(clock_root)
);

clock_module_div tie1(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(tie1_request),
	.parent_ready	(tie1_ready),
	.parent_silent	(tie1_silent),
	.parent_starting(tie1_starting),
	.parent_stopping(tie1_stopping),
	
	.child_request	(tie2_request),
	.child_ready	(tie2_ready),
	.child_silent	(tie2_silent),
	.child_starting	(tie2_starting),
	.child_stopping	(tie2_stopping),

	.clock_route_path_out	(clock_tie2),
	.clock_route_path_in	(clock_tie1)
);

clock_module_div tie2(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(tie2_request),
	.parent_ready	(tie2_ready),
	.parent_silent	(tie2_silent),
	.parent_starting(tie2_starting),
	.parent_stopping(tie2_stopping),
	
	.child_request	(tie3_request),
	.child_ready	(tie3_ready),
	.child_silent	(tie3_silent),
	.child_starting	(tie3_starting),
	.child_stopping	(tie3_stopping),

	.clock_route_path_out	(clock_tie3),
	.clock_route_path_in	(clock_tie2)
);

clock_module_div tie3(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(tie3_request),
	.parent_ready	(tie3_ready),
	.parent_silent	(tie3_silent),
	.parent_starting(tie3_starting),
	.parent_stopping(tie3_stopping),
	
	.child_request	(tie4_request),
	.child_ready	(tie4_ready),
	.child_silent	(tie4_silent),
	.child_starting	(tie4_starting),
	.child_stopping	(tie4_stopping),

	.clock_route_path_out	(clock_tie4),
	.clock_route_path_in	(clock_tie3)
);

clock_module_div tie4(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(tie4_request),
	.parent_ready	(tie4_ready),
	.parent_silent	(tie4_silent),
	.parent_starting(tie4_starting),
	.parent_stopping(tie4_stopping),
	
	.child_request	(tie5_request),
	.child_ready	(tie5_ready),
	.child_silent	(tie5_silent),
	.child_starting	(tie5_starting),
	.child_stopping	(tie5_stopping),

	.clock_route_path_out	(clock_tie5),
	.clock_route_path_in	(clock_tie4)
);



endmodule

