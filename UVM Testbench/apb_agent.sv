class APB_AGENT extends uvm_agent;
  `uvm_component_utils(APB_AGENT)
  APB_DRIVER driver;
  APB_MONITOR monitor;
  APB_SEQUENCER sequencer;
  function new(string name="APB_AGENT",uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor=APB_MONITOR::type_id::create("monitor",this);
    driver=APB_DRIVER::type_id::create("driver",this);
    sequencer=APB_SEQUENCER::type_id::create("sequencer",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
endclass
