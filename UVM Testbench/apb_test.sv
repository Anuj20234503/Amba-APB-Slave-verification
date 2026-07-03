class APB_TEST extends uvm_test;
  `uvm_component_utils(APB_TEST)
  APB_ENV env;
  APB_SEQUENCE sequences;
  function new(string name="APB_TEST",uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=APB_ENV::type_id::create("env",this);
    sequences=APB_SEQUENCE::type_id::create("sequences",this);
  endfunction
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    sequences.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass
