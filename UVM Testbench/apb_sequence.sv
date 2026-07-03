class APB_SEQUENCE extends uvm_sequence #(APB_TRANS);
  `uvm_object_utils(APB_SEQUENCE)
  APB_TRANS trans;
  function new(string name="APB_SEQUENCE");
    super.new(name);
  endfunction
  task body();
    repeat(10) begin
      trans=APB_TRANS::type_id::create("trans");
      `uvm_info(get_type_name(),"task body called",UVM_LOW)
      start_item(trans);
      if(!trans.randomize())
        `uvm_fatal(get_type_name(),"Randomization failed")
        
      finish_item(trans);
      trans.print();
    end
  endtask
endclass
