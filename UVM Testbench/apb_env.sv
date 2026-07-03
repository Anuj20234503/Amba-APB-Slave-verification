class APB_ENV extends uvm_env;
  `uvm_component_utils(APB_ENV)
  APB_AGENT agent;
  APB_reference reference;
  APB_SCOREBOARD scoreboard;
  function new(string name="APB_ENV",uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent=APB_AGENT::type_id::create("agent",this);
    scoreboard=APB_SCOREBOARD::type_id::create("scoreboard",this);
    reference=APB_reference::type_id::create("reference",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.ap_port.connect(scoreboard.ap_port);
    agent.monitor.ap_port.connect(reference.ap_port);
    reference.put_port.connect(scoreboard.get_port);
  endfunction
endclass
