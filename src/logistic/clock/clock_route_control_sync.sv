module clock_route_control_sync(
	input  wire async_resetn,
	input  wire clock,
	input  wire async_enable,
	output wire async_enable_ack,
	input  wire control_path_clock,
	output wire control_path_enable,
	output  reg control_path_data0_or_gate,
	output  reg control_path_data1_and_gate
);

wire control_path_clock_sync;

clock_logic_cross_sync_0  clock_sync(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(control_path_clock),
	.data_out(control_path_clock_sync)
);

always @(posedge clock or negedge async_resetn) 
begin
        if (~async_resetn) 
                control_path_data0_or_gate <= 1'b0;
        else
                control_path_data0_or_gate <= control_path_clock_sync;
end

always @(clock or async_resetn or control_path_clock_sync) 
begin
        if (~async_resetn) 
                control_path_data1_and_gate <= 1'b0;
        else if (~clock)
                control_path_data1_and_gate <= control_path_clock_sync;
end

wire control_path_clock_sync_delay1;
wire control_path_clock_sync_delay2;

clock_logic_delay_chain_0 delay(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(control_path_clock_sync),
	.data_delay_1(control_path_clock_sync_delay1),
	.data_delay_2(control_path_clock_sync_delay2),
	.data_delay_3(),
	.data_delay_4()
);


wire enable_sync;

clock_logic_cross_sync_0  en_sync(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(async_enable),
	.data_out(enable_sync)
);

reg internal_enable;

always @(posedge clock or negedge async_resetn) 
begin
        if (~async_resetn) 
                internal_enable <= 1'b0;
        else if(~enable_sync)
                internal_enable <= 1'b0;
        else if(control_path_clock_sync_delay1 ^ control_path_clock_sync_delay2)
                internal_enable <= 1'b1;
end


assign control_path_enable = async_enable & internal_enable;

assign async_enable_ack = internal_enable;

endmodule

