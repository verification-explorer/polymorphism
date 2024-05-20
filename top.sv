package pkg_lib;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class packet extends uvm_object;

    rand bit [1:0] addr;
    rand bit [5:0] length;

    `uvm_object_utils(packet)

    function new(string name="packet");
      super.new(name);
    endfunction

    virtual function string drive_packet();
      return $sformatf("%s\tdrive packet with addr: %0d, length: %0d",get_name(),addr,length);
    endfunction

  endclass

  class check_packet extends packet;

    rand bit [7:0] check;

    `uvm_object_utils(check_packet)

    function new(string name="check_packet");
      super.new(name);
    endfunction

    function string drive_packet();
      string s = super.drive_packet();
      $sformat(s,"%s\tcheck: %0h",s,check);
      return s;
    endfunction

  endclass

  class extend_packet extends check_packet;

    rand bit [7:0] extend;

    `uvm_object_utils(extend_packet)

    function new(string name="extend_packet");
      super.new(name);
    endfunction

    function string drive_packet();
      string s = super.drive_packet();
      $sformat(s,"%s\textend: %0h",s,extend);
      return s;
    endfunction

  endclass


  class packet_test extends uvm_test;

    `uvm_component_utils(packet_test)

    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    task run_phase (uvm_phase phase);

      packet        packet_packet = packet::type_id::create("packet_packet",this);
      packet        packet_check  = check_packet::type_id::create("packet_check",this);
      packet        packet_extend = extend_packet::type_id::create("packet_extend",this);
      check_packet  check_check   = check_packet::type_id::create("check_check",this);
      check_packet  check_extend  = extend_packet::type_id::create("check_extend",this);
      extend_packet extend_extend = extend_packet::type_id::create("extend_extend",this);

      assert(packet_packet.randomize());
      assert(packet_check.randomize());
      assert(check_check.randomize());
      assert(packet_extend.randomize());
      assert(check_extend.randomize());
      assert(extend_extend.randomize());

      $display("Handle type: [packet       ], Class type:[packet       ] %s ", packet_packet.drive_packet());  
      $display("Handle type: [packet       ], Class type:[check_packet ] %s ", packet_check.drive_packet()); 
      $display("Handle type: [packet       ], Class type:[extend_packet] %s ", packet_extend.drive_packet());
      $display("Handle type: [check_packet ], Class type:[check_packet ] %s ", check_check.drive_packet());
      $display("Handle type: [check_packet ], Class type:[extend_packet] %s ", check_extend.drive_packet());
      $display("Handle type: [extend_packet], Class type:[extend_packet] %s ", extend_extend.drive_packet());


      begin
        check_packet pkt;
        $cast(pkt,packet_check);
        $display(pkt.drive_packet());
      end

      begin
        packet pkt_q[$];
        packet p;
        string class_type="";
        repeat (16) begin
          randcase
            1 : begin : TYPE_PACKET
              set_type_override_by_type(packet::get_type(), packet::get_type());
              class_type="packet";
            end : TYPE_PACKET
              1 : begin : TYPE_CHECK_PACKET
              set_type_override_by_type(packet::get_type(), check_packet::get_type());
              class_type="check_packet";
            end : TYPE_CHECK_PACKET
              1 : begin : TYPE_EXTEND_PACKET
              set_type_override_by_type(packet::get_type(), extend_packet::get_type());
              class_type="extend_packet";
            end : TYPE_EXTEND_PACKET
          endcase
          p = packet::type_id::create(class_type, this);
          assert(p.randomize());
          pkt_q.push_back(p);
        end
        pkt_q.shuffle();
        foreach (pkt_q[i]) $display(pkt_q[i].drive_packet());
      end

    endtask

  endclass

endpackage

module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import pkg_lib::*;
  initial run_test("packet_test");
endmodule

