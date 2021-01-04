///////////////////////////////////////////////////////////////////////////////
// File name    : Generic_BRAM.v
// Author       : Jose R Garcia
// Create Date  : 21/04/2019 19:25:32
// Project Name : 
// Module Name  : Generic_BRAM
// Description  : Inferred BRAM
//
// Additional Comments:
//    For Lattice ICE40 FPGA
///////////////////////////////////////////////////////////////////////////////
module Generic_BRAM #(parameter integer P_DATA_MSB    = 15,
                      parameter integer P_ADDRESS_MSB = 4,
                      parameter integer P_DEPTH       = 32)
 (
  input                    i_wclk,
  input                    i_we,
  input                    i_rclk,
  input  [P_ADDRESS_MSB:0] i_waddr,
  input  [P_ADDRESS_MSB:0] i_raddr,
  input  [P_DATA_MSB:0]    i_wdata,
  output [P_DATA_MSB:0]    o_rdata
 );

  /////////////////////////////////////////////////////////////////////////////
  // Internal Parameter Declarations
  /////////////////////////////////////////////////////////////////////////////
  // Signals Definition
  reg [P_DATA_MSB:0] r_mem [0:P_DEPTH-1];
  reg [P_DATA_MSB:0] r_rdata;

  /////////////////////////////////////////////////////////////////////////////
  // Process     : mem access
  // Description : Synchronous reads and writes to memory
  /////////////////////////////////////////////////////////////////////////////
  always @(posedge i_wclk) begin
    if (i_we == 1'b1) begin
      r_mem[i_waddr] <= i_wdata;
    end
  end

 always @(posedge i_rclk) begin
     r_rdata <= r_mem[i_raddr];
 end

assign o_rdata = r_rdata;
endmodule // Generic_BRAM