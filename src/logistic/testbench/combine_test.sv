
module combine_test();

reg clock;
reg clock_root;
reg async_resetn;
reg peripheral_request;
initial
begin

        $dumpfile("test.vcd");
        $dumpvars(0,combine_test);
	clock = 0;
	clock_root = 0;
	peripheral_request = 0;
	async_resetn = 0;
	# 10;
	async_resetn = 1;
	#1000;
	peripheral_request = 1;
	#10000;
	peripheral_request = 0;
	#10000;
	peripheral_request = 1;
	#10000;
	peripheral_request = 0;
	#10000;
	$finish();
end


always
	#10 clock = ~clock;

always
	#1 clock_root = ~clock_root;


power_module_isolation iso(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(rootlink_request),
	.parent_ready	(1'b1),
	.parent_silent	(1'b0),
	.parent_starting(1'b0),
	.parent_stopping(1'b0),
	
	.child_request	(isolate_request),
	.child_ready	(isolate_ready),
	.child_silent	(isolate_silent),
	.child_starting	(isolate_starting),
	.child_stopping	(isolate_stopping),

	.isolation	(target_isolation)
);


power_module_switch switch_lf(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(rootpowerl_request),
	.parent_ready	(1'b1),
	.parent_silent	(1'b0),
	.parent_starting(1'b0),
	.parent_stopping(1'b0),
	
	.child_request	(switchl_request),
	.child_ready	(switchl_ready),
	.child_silent	(switchl_silent),
	.child_starting	(switchl_starting),
	.child_stopping	(switchl_stopping),

	.switch_enb	(target_power_lf),
	.switch_ack	(target_power_lf)
);

power_module_switch switch_hf(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(rootpowerh_request),
	.parent_ready	(1'b1),
	.parent_silent	(1'b0),
	.parent_starting(1'b0),
	.parent_stopping(1'b0),
	
	.child_request	(switchh_request),
	.child_ready	(switchh_ready),
	.child_silent	(switchh_silent),
	.child_starting	(switchh_starting),
	.child_stopping	(switchh_stopping),

	.switch_enb	(target_power_hf),
	.switch_ack	(target_power_hf)
);


reset_module_reset reset(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(rootfunc_request),
	.parent_ready	(1'b1),
	.parent_silent	(1'b0),
	.parent_starting(1'b0),
	.parent_stopping(1'b0),
	
	.child_request	(reset_request),
	.child_ready	(reset_ready),
	.child_silent	(reset_silent),
	.child_starting	(reset_starting),
	.child_stopping	(reset_stopping),

	.reset_resetn	(target_resetn),
	.reset_clock	(target_reset_clock)
);

clock_module_gate lpcg(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(rootclock_request),
	.parent_ready	(1'b1),
	.parent_silent	(1'b0),
	.parent_starting(1'b0),
	.parent_stopping(1'b0),
	
	.child_request	(clock_request),
	.child_ready	(clock_ready),
	.child_silent	(clock_silent),
	.child_starting	(clock_starting),
	.child_stopping	(clock_stopping),

	.clock_route_path_out	(target_clock),
	.clock_route_path_in	(clock_root)
);

peripheral_module_peripheral peripheral(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.parent_request	(rootperipheral_request),
	.parent_ready	(1'b1),
	.parent_silent	(1'b0),
	.parent_starting(1'b0),
	.parent_stopping(1'b0),
	
	.child_request	(peripheral_request),
	.child_ready	(peripheral_ready),
	.child_silent	(peripheral_silent),
	.child_starting	(peripheral_starting),
	.child_stopping	(peripheral_stopping),

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

