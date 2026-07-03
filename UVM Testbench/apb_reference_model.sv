class APB_reference extends uvm_component;
  `uvm_component_utils(APB_reference)
  uvm_analysis_imp #(APB_TRANS,APB_reference) ap_port;
  uvm_blocking_put_port #(APB_TRANS) put_port;
  bit [`DATA_WIDTH-1:0] mem[int];
  function new(string name="APB_reference",uvm_component parent);
    super.new(name,parent);
    ap_port=new("ap_port",this);
    put_port=new("put_port",this);
  endfunction
  function void write(APB_TRANS trans);
    APB_TRANS ref_trans;
    ref_trans=APB_TRANS::type_id::create("ref_trans");
    if (trans.PWRITE) begin
      mem[trans.PADDR]=trans.PWDATA;
      `uvm_info(get_type_name(),$sformatf("Reference model WRITE stored:ADDR=0x%0h DATA=0x%0h",trans.PADDR,trans.PWDATA),UVM_MEDIUM)
    end
    else begin
      if(mem.exists(trans.PADDR)) begin
        ref_trans.PRDATA=mem[trans.PADDR];
      end
      else begin
        ref_trans.PRDATA=1'b0;
      end
      `uvm_info(get_type_name(),$sformatf("Reference model READ expected:ADDR=0x%0h DATA=0x%0h",trans.PADDR,ref_trans.PRDATA),UVM_MEDIUM)
      fork
        automatic APB_TRANS tmp=ref_trans;
        put_port.put(tmp);
      join_none
    end
  endfunction
endclass
