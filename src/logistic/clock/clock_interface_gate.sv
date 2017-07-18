module clock_interface_gate(
	input  wire clock,
	input  wire async_resetn,

	input  wire pwrite,
	input  wire psel,
	input  wire penable,
	input  wire [31:0] paddr,
	input  wire [31:0] pwdata,
	output wire [31:0] prdata,
	output wire pready,
	output wire pslverr,

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

	input  wire [31:0] parent_frequency,
	input  wire [31:0] parent_frequency_setting,
	input  wire [31:0] parent_mindrift,
	input  wire [31:0] parent_maxdrift,
	output wire [31:0] parent_minfrequency,
	output wire [31:0] parent_maxfrequency,

	output wire [31:0] parent_child_address,
	input  wire [31:0] parent_parent_address,
	input  wire [31:0] parent_prev_address,
	input  wire [31:0] parent_next_address,

	output wire [31:0] child_frequency,
	output wire [31:0] child_frequency_setting,
	output wire [31:0] child_mindrift,
	output wire [31:0] child_maxdrift,
	input  wire [31:0] child_minfrequency,
	input  wire [31:0] child_maxfrequency,

	input  wire [31:0] child_child_address,
	output wire [31:0] child_parent_address,
	output wire [31:0] child_prev_address,
	output wire [31:0] child_next_address,

	output wire async_enable,
	input  wire async_enable_ack
);

parameter TYPE = "GT10";
parameter ADDR = 32'h0;
parameter NAME = "NAME";
parameter FMAX = 32'd2000000000;

wire tran_pwrite;
wire tran_psel;
wire tran_penable;
wire [31:0] tran_paddr;
wire [31:0] tran_pwdata;
wire [31:0] tran_prdata;
wire tran_pready;
wire tran_pslverr;

wire [31:0] node_setting;
wire [31:0] node_frequency_override;
wire [31:0] node_mindrift_override;
wire [31:0] node_maxdrift_override;

clock_interface_logic_base apb_logic(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.pwrite		(pwrite),
	.psel		(psel),
	.penable	(penable),
	.paddr		(paddr),
	.pwdata		(pwdata),
	.prdata		(prdata),
	.pready		(pready),
	.pslverr	(pslverr),

	.node_type	(TYPE),
	.node_name	(NAME),
	.node_frequency	(child_frequency),
	.node_frequency_setting	(child_frequency_setting),

	.node_mindrift	(child_mindrift),
	.node_maxdrift	(child_maxdrift),
	.node_minfrequency	(child_minfrequency),
	.node_maxfrequency	(child_maxfrequency),

	.node_parent	(parent_parent_address),
	.node_child	(child_child_address),
	.node_prev	(parent_prev_address),
	.node_next	(parent_next_address),

	.node_setting	(node_setting),
	.node_frequency_override	(node_frequency_override),
	.node_mindrift_override	(node_mindrift_override),
	.node_maxdrift_override	(node_maxdrift_override),

	.tran_pwrite	(tran_pwrite),
	.tran_psel	(tran_psel),
	.tran_penable	(tran_penable),
	.tran_paddr	(tran_paddr),
	.tran_pwdata	(tran_pwdata),
	.tran_prdata	(tran_prdata),
	.tran_pready	(tran_pready),
	.tran_pslverr	(tran_pslverr)
);

wire override = node_setting[16];
wire keep = node_setting[0];

assign child_frequency = child_ready ? (override ? node_frequency_override : parent_frequency) : 32'h0;
assign child_frequency_setting = override ? node_frequency_override : parent_frequency_setting;

assign child_mindrift = override ? node_mindrift_override : parent_mindrift;
assign child_maxdrift = override ? node_maxdrift_override : parent_maxdrift;

assign parent_minfrequency = child_minfrequency;
assign parent_maxfrequency = FMAX > child_maxfrequency ? child_maxfrequency : FMAX;

assign parent_child_address = ADDR;
assign child_parent_address = ADDR;
assign child_prev_address = 32'h0;
assign child_next_address = 32'h0;


clock_interface_logic_gate logic_gate(
	.clock		(clock),
	.async_resetn	(async_resetn),

	.pwrite		(tran_pwrite),
	.psel		(tran_psel),
	.penable	(tran_penable),
	.paddr		(tran_paddr),
	.pwdata		(tran_pwdata),
	.prdata		(tran_prdata),
	.pready		(tran_pready),
	.pslverr	(tran_pslverr)
);

clock_control_logic_gate control(
	.clock(clock),
	.async_resetn(async_resetn),

	.parent_request(parent_request),
	.parent_ready(parent_ready),
	.parent_silent(parent_silent),
	.parent_starting(parent_starting),
	.parent_stopping(parent_stopping),

	.child_request(child_request | keep),
	.child_ready(child_ready),
	.child_silent(child_silent),
	.child_starting(child_starting),
	.child_stopping(child_stopping),

	.async_enable(async_enable),
	.async_enable_ack(async_enable_ack)
);

endmodule

