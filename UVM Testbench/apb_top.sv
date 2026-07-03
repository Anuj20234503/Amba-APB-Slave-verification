// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
`include "APB_PKG.sv"
import uvm_pkg::*;
import pkg::*;
module tb;
  bit PCLK;
  bit PRESETn;
  intf inf(PCLK);
  initial begin
    PCLK=0;
    forever #5 PCLK=~PCLK;
  end
  initial begin
    PRESETn=1'b0;
    #20;
    PRESETn=1'b1;
  end
  apb_slave dut(
    .PCLK(inf.PCLK),
    .PRESETn(inf.PRESETn),
    .PSEL(inf.PSEL),
    .PENABLE(inf.PENABLE),
    .PWRITE(inf.PWRITE),
    .PADDR(inf.PADDR),
    .PWDATA(inf.PWDATA),
    .PRDATA(inf.PRDATA),
    .PSLVERR(inf.PSLVERR),
    .PREADY(inf.PREADY)
  );
  initial begin
    uvm_config_db#(virtual intf)::set(null,"*","intf",inf);
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb);
  end
  initial begin
    run_test("APB_TEST");
  end
endmodule
