
module clock_route_control_div(
	input  wire clock,
	input  wire async_resetn,
	input  wire async_enable,
	output  reg async_enable_ack,
	input  wire async_update,
	output wire async_update_ack,
	input  wire [7:0] mfi,
	input  wire [7:0] mfn,
	input  wire [7:0] mfd,
	output wire control_path_data0_or_gate,
	output wire control_path_data1_and_gate
);



wire	[7:0] podf_in_active;
reg	[7:0] ratio_samp;
reg	[7:0] count;
reg	counter_in_1;
wire	[7:0] short;
wire	[7:0] long;
reg	pre_data0_clk;
reg	data0_clk;
reg	data1_clk;

reg	[7:0] remainder;
reg	remainder_overflow;

clock_logic_cross_sync_0  enable_sync(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(async_enable),
	.data_out(enable)
);

always @(negedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		async_enable_ack <= 1'b0;
	else if(counter_in_1)
		async_enable_ack <= enable;
end

wire update;
wire update_prev;
wire update_edge = ~update_prev & update;

clock_logic_cross_sync_0  update_sync(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(async_update),
	.data_out(update)
);

clock_logic_delay_chain_0 update_delay(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(update),
	.data_delay_1(update_prev)
);

assign async_update_ack = update_prev;

reg	[7:0] mfi_int;
reg	[7:0] mfd_int;
reg	[7:0] mfn_int;
always @(negedge clock or negedge async_resetn)
begin
	if(~async_resetn)
	begin
		mfi_int <= 8'h0;
		mfn_int <= 8'b0;
		mfd_int <= 8'b0;
	end
	else if(update_edge)
	begin
		mfi_int <= mfi;
		mfn_int <= mfn;
		mfd_int <= mfd;
	end
end


always @(negedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		remainder <= 8'b0;
	else if(update_edge)
		remainder <= 8'b0;
	else if(counter_in_1)
		remainder <= (remainder + mfn_int) > mfd_int ? (remainder + mfn_int - mfd_int) : (remainder + mfn_int);
end

always @(negedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		remainder_overflow <= 1'b0;
	else if(counter_in_1)
		remainder_overflow <= (remainder + mfn_int) > mfd_int ? 1 : 0;
end


assign podf_in_active = mfi_int + (remainder_overflow ? 1 : 0);


always @(negedge clock or negedge async_resetn)
begin
    if(~async_resetn)
        counter_in_1 <= 1'b1;
    else 
        counter_in_1 <= ((podf_in_active == 1) | (count == 2)) | (~async_enable_ack);
end

//counter
always @(negedge clock or negedge async_resetn)
begin
    if (~async_resetn) 
        count <= 8'b0;
    else if (podf_in_active == 1)
        count <= 8'b1;
    else if (~async_enable_ack)
        count <= 8'b0;
    else if (counter_in_1 & enable)
        count <= podf_in_active;
    else
        count <= count - 1'b1;
end


always @(negedge clock or negedge async_resetn)
begin
    if(~async_resetn)
        ratio_samp <= 8'b0;
    else if (counter_in_1)
        ratio_samp <= podf_in_active;
end


assign short = (ratio_samp) / 2;
assign long =  (ratio_samp + 1) / 2;

always @(negedge clock or negedge async_resetn)
begin
    if(~async_resetn)
        data1_clk <= 1'b0;
    else
        data1_clk <=  (count > short);
end

always @(negedge clock or negedge async_resetn)
begin
    if(~async_resetn)
        pre_data0_clk <= 1'b0;
    else
        pre_data0_clk <=  (count > long);
end

always @(clock or async_resetn or pre_data0_clk) 
begin
        if (~async_resetn) 
                data0_clk <= 1'b0;
        else if (clock)
                data0_clk <= pre_data0_clk;
end

assign control_path_data0_or_gate = data0_clk;
assign control_path_data1_and_gate = data1_clk;

endmodule

