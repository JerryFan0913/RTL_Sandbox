module clock_testbench_mux();

reg clock;
reg [31:0]clock_root;
wire [31:0] root_request;
reg async_resetn;
reg tie5_request;
initial
begin

        $dumpfile("test.vcd");
        $dumpvars(0,clock_testbench_mux);
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

genvar i;


wire [15:0] tie1_request;
wire [15:0] tie1_ready;
wire [15:0] tie1_silent;
wire [15:0] tie1_starting;
wire [15:0] tie1_stopping;
wire [15:0] clock_tie1;

generate for(i=0; i<16; i=i+1)
begin
clock_module_mux mux_tie1(
	.clock			(clock),
	.async_resetn		(async_resetn),

	.parent0_request	(root_request[i*2]),
	.parent0_ready		(1'b1),
	.parent0_silent		(1'b0),
	.parent0_starting	(1'b0),
	.parent0_stopping	(1'b0),
	
	.parent1_request	(root_request[i*2+1]),
	.parent1_ready		(1'b1),
	.parent1_silent		(1'b0),
	.parent1_starting	(1'b0),
	.parent1_stopping	(1'b0),
	
	.child_request		(tie1_request[i]),
	.child_ready		(tie1_ready[i]),
	.child_silent		(tie1_silent[i]),
	.child_starting		(tie1_starting[i]),
	.child_stopping		(tie1_stopping[i]),

	.clock_route_path_out	(clock_tie1[i]),
	.clock_route_path_in0	(clock_root[i*2]),
	.clock_route_path_in1	(clock_root[i*2+1])
);
end
endgenerate


wire [7:0] clock_tie2;
wire [7:0] tie2_request;
wire [7:0] tie2_ready;
wire [7:0] tie2_silent;
wire [7:0] tie2_starting;
wire [7:0] tie2_stopping;

generate for(i=0; i<8; i=i+1)
begin
clock_module_mux mux_tie2(
	.clock			(clock),
	.async_resetn		(async_resetn),

	.parent0_request	(tie1_request[i*2]),
	.parent0_ready		(tie1_ready[i*2]),
	.parent0_silent		(tie1_silent[i*2]),
	.parent0_starting	(tie1_starting[i*2]),
	.parent0_stopping	(tie1_stopping[i*2]),
	
	.parent1_request	(tie1_request[i*2+1]),
	.parent1_ready		(tie1_ready[i*2+1]),
	.parent1_silent		(tie1_silent[i*2+1]),
	.parent1_starting	(tie1_starting[i*2+1]),
	.parent1_stopping	(tie1_stopping[i*2+1]),
	
	.child_request		(tie2_request[i]),
	.child_ready		(tie2_ready[i]),
	.child_silent		(tie2_silent[i]),
	.child_starting		(tie2_starting[i]),
	.child_stopping		(tie2_stopping[i]),

	.clock_route_path_out	(clock_tie2[i]),
	.clock_route_path_in0	(clock_tie1[i*2]),
	.clock_route_path_in1	(clock_tie1[i*2+1])
);
end
endgenerate


wire [3:0] clock_tie3;
wire [3:0] tie3_request;
wire [3:0] tie3_ready;
wire [3:0] tie3_silent;
wire [3:0] tie3_starting;
wire [3:0] tie3_stopping;

generate for(i=0; i<4; i=i+1)
begin
clock_module_mux mux_tie3(
	.clock			(clock),
	.async_resetn		(async_resetn),

	.parent0_request	(tie2_request[i*2]),
	.parent0_ready		(tie2_ready[i*2]),
	.parent0_silent		(tie2_silent[i*2]),
	.parent0_starting	(tie2_starting[i*2]),
	.parent0_stopping	(tie2_stopping[i*2]),
	
	.parent1_request	(tie2_request[i*2+1]),
	.parent1_ready		(tie2_ready[i*2+1]),
	.parent1_silent		(tie2_silent[i*2+1]),
	.parent1_starting	(tie2_starting[i*2+1]),
	.parent1_stopping	(tie2_stopping[i*2+1]),
	
	.child_request		(tie3_request[i]),
	.child_ready		(tie3_ready[i]),
	.child_silent		(tie3_silent[i]),
	.child_starting		(tie3_starting[i]),
	.child_stopping		(tie3_stopping[i]),

	.clock_route_path_out	(clock_tie3[i]),
	.clock_route_path_in0	(clock_tie2[i*2]),
	.clock_route_path_in1	(clock_tie2[i*2+1])
);
end
endgenerate


wire [1:0] clock_tie4;
wire [1:0] tie4_request;
wire [1:0] tie4_ready;
wire [1:0] tie4_silent;
wire [1:0] tie4_starting;
wire [1:0] tie4_stopping;

generate for(i=0; i<2; i=i+1)
begin
clock_module_mux mux_tie4(
	.clock			(clock),
	.async_resetn		(async_resetn),

	.parent0_request	(tie3_request[i*2]),
	.parent0_ready		(tie3_ready[i*2]),
	.parent0_silent		(tie3_silent[i*2]),
	.parent0_starting	(tie3_starting[i*2]),
	.parent0_stopping	(tie3_stopping[i*2]),
	
	.parent1_request	(tie3_request[i*2+1]),
	.parent1_ready		(tie3_ready[i*2+1]),
	.parent1_silent		(tie3_silent[i*2+1]),
	.parent1_starting	(tie3_starting[i*2+1]),
	.parent1_stopping	(tie3_stopping[i*2+1]),
	
	.child_request		(tie4_request[i]),
	.child_ready		(tie4_ready[i]),
	.child_silent		(tie4_silent[i]),
	.child_starting		(tie4_starting[i]),
	.child_stopping		(tie4_stopping[i]),

	.clock_route_path_out	(clock_tie4[i]),
	.clock_route_path_in0	(clock_tie3[i*2]),
	.clock_route_path_in1	(clock_tie3[i*2+1])
);
end
endgenerate



generate for(i=0; i<1; i=i+1)
begin
clock_module_mux mux_tie5(
	.clock			(clock),
	.async_resetn		(async_resetn),

	.parent0_request	(tie4_request[i*2]),
	.parent0_ready		(tie4_ready[i*2]),
	.parent0_silent		(tie4_silent[i*2]),
	.parent0_starting	(tie4_starting[i*2]),
	.parent0_stopping	(tie4_stopping[i*2]),
	
	.parent1_request	(tie4_request[i*2+1]),
	.parent1_ready		(tie4_ready[i*2+1]),
	.parent1_silent		(tie4_silent[i*2+1]),
	.parent1_starting	(tie4_starting[i*2+1]),
	.parent1_stopping	(tie4_stopping[i*2+1]),
	
	.child_request		(tie5_request),
	.child_ready		(tie5_ready),
	.child_silent		(tie5_silent),
	.child_starting		(tie5_starting),
	.child_stopping		(tie5_stopping),

	.clock_route_path_out	(clock_tie5),
	.clock_route_path_in0	(clock_tie4[i*2]),
	.clock_route_path_in1	(clock_tie4[i*2+1])
);
end
endgenerate


endmodule

