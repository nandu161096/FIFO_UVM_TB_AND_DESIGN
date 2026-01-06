// Code your design here
module fifo_dut(
  input  logic        clk,
  input  logic        rst,
  input  logic        wr,
  input  logic        rd,
  input  logic [7:0]  din,
  output logic [7:0]  dout,
  output logic        full,
  output logic        empty
);
  
  int wptr = 0, rptr = 0, cnt = 0;
  reg [7:0] mem [15:0];
  
  always_ff @(posedge clk) begin
    if (rst) begin
      wptr <= 0;
      rptr <= 0;
      cnt <= 0;
    end
    else if (wr && !full && rd && !empty) begin
      mem[wptr] = din;
      dout <= mem[rptr];
      wptr <= wptr +1;
      rptr <= rptr +1;
    end
    else if (wr && !full) begin
      mem[wptr] = din;
      wptr <= wptr +1;
      cnt <= cnt + 1;
    end 
    else if (rd && !empty) begin
      dout <= mem[rptr];
      rptr <= rptr +1;
      cnt <= cnt - 1;
    end 
  end
  
  assign full = (cnt == 16) ? 1'b1 : 1'b0;
  assign empty = (cnt == 0) ? 1'b1 : 1'b0;    
  
endmodule

interface fifo_interface;
    logic        clk;
    logic        rst;
    logic        wr;
    logic        rd;
    logic [7:0]  din;
    logic [7:0]  dout;
    logic        full;
    logic        empty;
endinterface 

// Other way
always_ff @(posedge clk) begin
  if (rst) begin
    wptr <= 0;
    rptr <= 0;
    cnt  <= 0;
  end else begin
    case ({wr && !full, rd && !empty})
      2'b10: begin // Write only
        mem[wptr] <= din;
        wptr <= wptr + 1;
        cnt  <= cnt + 1;
      end
      2'b01: begin // Read only
        dout <= mem[rptr];
        rptr <= rptr + 1;
        cnt  <= cnt - 1;
      end
      2'b11: begin // Both
        mem[wptr] <= din;
        dout <= mem[rptr];
        wptr <= wptr + 1;
        rptr <= rptr + 1;
        // cnt stays same
      end
    endcase
  end
end
