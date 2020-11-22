
`timescale 1 ns / 1 ps

module testbench;
	reg clk = 1;
	reg resetn = 0;
	wire trap;
  // Create Clock
	always #5 clk = ~clk;

  // Generate a synchronous reset signal
	initial begin
		repeat (100) @(posedge clk);
		resetn <= 1;
	end
  
	// Signals Definitions
	// Instruction interface
	wire        o_inst_read;
	reg         i_inst_read_ack;
	wire [31:0] o_inst_read_addr;
	reg  [31:0] i_inst_read_data;
	// Read Interface
	wire        o_master_read;
	reg         i_master_read_ack;
	wire [31:0] o_master_read_addr;
	reg  [31:0] i_master_read_data;
	// Write Interface
	wire        o_master_write;
	reg         i_master_write_ack;
	wire [31:0] o_master_write_addr;
	wire [31:0] o_master_write_data;
	wire [3:0]  o_master_write_byte_enable;

	// DUT
	ORC_R32I #(32'h0001_0000) uut (
	  //
	  .i_clk(clk),
	  .i_reset_sync(!resetn),
      // Instruction Data Interface
      .o_inst_read(o_inst_read),           // read enable
      .i_inst_read_ack(i_inst_read_ack),   // acknowledge 
      .o_inst_read_addr(o_inst_read_addr), // address
      .i_inst_read_data(i_inst_read_data), // data
      // Master Read Interface
      .o_master_read(o_master_read),           // read enable
      .i_master_read_ack(i_master_read_ack),   // acknowledge 
      .o_master_read_addr(o_master_read_addr), // address
      .i_master_read_data(i_master_read_data), // data
      // Master Write Interface
      .o_master_write(o_master_write),                        // write enable
      .i_master_write_ack(i_master_write_ack),                // acknowledge 
      .o_master_write_addr(o_master_write_addr),              // address
      .o_master_write_data(o_master_write_data),              // data
      .o_master_write_byte_enable(o_master_write_byte_enable) // byte enable
	);

	reg [7:0] memory [0:256*1024-1];
	initial $readmemh("dhry.hex", memory);

	always @(posedge clk) begin
      if (!resetn) begin
		//
        i_inst_read_data <= 0;
        i_inst_read_ack <= 0;
        //
        i_master_read_data <= 0;
        i_master_read_ack <= 0;
		//
        i_master_write_ack <= 0;
	  end
	  else begin
		if (o_inst_read) begin
			// Core is fetchin instructions
			i_inst_read_data[ 7: 0] <= memory[o_inst_read_addr + 0];
			i_inst_read_data[15: 8] <= memory[o_inst_read_addr + 1];
			i_inst_read_data[23:16] <= memory[o_inst_read_addr + 2];
			i_inst_read_data[31:24] <= memory[o_inst_read_addr + 3];
		  i_inst_read_ack         <= 1;
		end
		else begin
          // Instruction interface
          i_inst_read_data <= i_inst_read_data;
          i_inst_read_ack  <= 0;
		end

		if (o_master_read) begin
		  // Core is fetchin from memory
		  i_master_read_data[ 7: 0] <= memory[o_master_read_addr + 0];
		  i_master_read_data[15: 8] <= memory[o_master_read_addr + 1];
		  i_master_read_data[23:16] <= memory[o_master_read_addr + 2];
		  i_master_read_data[31:24] <= memory[o_master_read_addr + 3];
		  i_master_read_ack         <= 1;
		end
		else begin
		  i_master_read_data <= i_master_read_data;
		  i_master_read_ack  <= 0;
		end

		if (o_master_write) begin
		  case (o_master_write_addr)
		  	32'h1000_0000: begin
		  		$display("%h", o_master_write_data);
		  		// $write("%c", o_master_write_data);
		  		// $fflush();
		  	end
		  	default: begin
		  	  if (o_master_write_byte_enable[0]) 
			  	  memory[o_master_write_addr + 0] <= o_master_write_data[ 7: 0];
		  	  if (o_master_write_byte_enable[1]) 
			  	  memory[o_master_write_addr + 1] <= o_master_write_data[15: 8];
		  	  if (o_master_write_byte_enable[2]) 
			  	  memory[o_master_write_addr + 2] <= o_master_write_data[23:16];
		  	  if (o_master_write_byte_enable[3]) 
			  	  memory[o_master_write_addr + 3] <= o_master_write_data[31:24];

		  	end
		  endcase
		  //
		  i_master_write_ack <= 1;
		end
		else begin
		  i_master_write_ack <= 0;
		end
	  end
	end

	initial begin
		$dumpfile("testbench_nola.vcd");
		$dumpvars(0, testbench);
	end

	always @(posedge clk) begin
		if (resetn) begin
			$display("Test Bench began running");
		    repeat (100000) @(posedge clk);
			$display("Ending Test Bench. Sending finish command");
			$finish;
		end
	end
endmodule
