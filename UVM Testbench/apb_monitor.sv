class APB_MONITOR extends uvm_monitor;
  `uvm_component_utils(APB_MONITOR)
  uvm_analysis_port #(APB_TRANS) ap_port;
  APB_TRANS req;
  virtual intf inf;
  function new(string name="APB_MONITOR",uvm_component parent);
    super.new(name,parent);
    ap_port=new("ap_port",this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual intf)::get(this,"","intf",inf)) begin
      `uvm_fatal(get_type_name(),"Interface not set in config DB")
    end
    `uvm_info(get_type_name(),"Build phase completed,interface received",UVM_LOW)
  endfunction
  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"Run phase started",UVM_LOW)
    forever begin
      get_from_dut();
    end
  endtask
  task get_from_dut();
    @((inf.MON_CB) iff(inf.MON_CB.PSEL && inf.MON_CB.PENABLE && inf.MON_CB.PREADY));
    `uvm_info(get_type_name(),"Monitor Invoked",UVM_LOW)
    req=APB_TRANS::type_id::create("req");
    req.PADDR=inf.MON_CB.PADDR;
    req.PWRITE=inf.MON_CB.PWRITE;
    req.PSLVERR=inf.MON_CB.PSLVERR;
    if (inf.MON_CB.PWRITE) begin
      req.PWDATA=inf.MON_CB.PWDATA;
      `uvm_info(get_type_name(),$sformatf("Captured WRITE to:addr=0x%0h,data=0x%0h",req.PADDR,req.PWDATA),UVM_MEDIUM)
    end
    else begin
      req.PRDATA=inf.MON_CB.PRDATA;
      `uvm_info(get_type_name(),$sformatf("Captured READ to:addr=0x%0h,data=0x%0h",req.PADDR,req.PRDATA),UVM_MEDIUM)
    end
    ap_port.write(req);
    req.print();
  endtask
endclass
