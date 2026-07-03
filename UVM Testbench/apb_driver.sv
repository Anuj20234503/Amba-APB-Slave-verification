class APB_DRIVER extends uvm_driver #(APB_TRANS);
  `uvm_component_utils(APB_DRIVER)
  virtual intf inf;
  APB_TRANS req;
  function new(string name ="APB_DRIVER",uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual intf)::get(this,"","intf",inf)) begin
      `uvm_fatal(get_type_name(),"Interface not set in config db")
    end
  endfunction
      
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      send_to_dut(req);
      seq_item_port.item_done();
    end
  endtask
    
  task send_to_dut(APB_TRANS req);
    @(posedge inf.PCLK);
    inf.DRV_CB.PADDR<=req.PADDR;
    inf.DRV_CB.PWDATA<=req.PWDATA;
    inf.DRV_CB.PWRITE<=req.PWRITE;
    inf.DRV_CB.PSEL<=1;
    inf.DRV_CB.PENABLE<=0;
    inf.DRV_CB.PRESETn<=1;
    
    @(posedge inf.PCLK);
    inf.DRV_CB.PENABLE<=1;
    wait (inf.DRV_CB.PREADY==1);
    inf.DRV_CB.PSEL<=1;
    inf.DRV_CB.PENABLE<=0;
    `uvm_info(get_type_name(),$sformatf("APB %s transfer is completed:ADDR=0x%0h,DATA=0x%0h",(req.PWRITE?"WRITE":"READ"),req.PADDR,(req.PWRITE?req.PWDATA:inf.DRV_CB.PRDATA)),UVM_MEDIUM)
  endtask
endclass
    
      
    
