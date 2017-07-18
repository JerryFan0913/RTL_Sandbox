module power_testbench_switch();

reg clock;
reg power_root;
reg async_resetn;
reg tie6_request;
initial
begin

        $dumpfile("test.vcd");
        $dumpvars(0,power_testbench_switch);
	clock = 0;
	power_root = 0;
	async_resetn = 0;
	tie6_request = 0;
	# 10;
	async_resetn = 1;

	#100;
	tie6_request <= 1;
	#1000;
	tie6_request <= 0;
	#1000;
	tie6_request <= 1;
	#1000;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 1;
	#100;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 1;

	#100;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 1;
	#100;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 1;

	#100;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 0;
	@(posedge clock) tie6_request <= 1;

	#1000;
	@(posedge clock) tie6_request <= 0;
	#400;
	@(posedge clock) tie6_request <= 1;

end


always
	#10 clock = ~clock;

always
	#1 power_root = ~power_root;


power_module_switch root(
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

	.switch_enb	(power_tie1),
	.switch_ack	(power_root)
);

power_module_switch tie1(
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

	.switch_enb	(power_tie2),
	.switch_ack	(power_tie1)
);

power_module_switch tie2(
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

	.switch_enb	(power_tie3),
	.switch_ack	(power_tie2)
);

power_module_switch tie3(
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

	.switch_enb	(power_tie4),
	.switch_ack	(power_tie3)
);

power_module_switch tie4(
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

	.switch_enb	(power_tie5),
	.switch_ack	(power_tie4)
);

power_module_switch tie5(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(tie5_request),
	.parent_ready	(tie5_ready),
	.parent_silent	(tie5_silent),
	.parent_starting(tie5_starting),
	.parent_stopping(tie5_stopping),
	
	.child_request	(tie6_request),
	.child_ready	(tie6_ready),
	.child_silent	(tie6_silent),
	.child_starting	(tie6_starting),
	.child_stopping	(tie6_stopping),

	.switch_enb	(power_tie6),
	.switch_ack	(power_tie5)
);




endmodule

