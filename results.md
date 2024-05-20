# From LRM (8.20)
- A method of a class may be identified with the keyword virtual.
- A virtual method shall override a method in all of its base classes
- A non-virtual method shall only override a method in that class and its descendants.

# Virtual Method
- **Definition**: A method of a class may be identified with the keyword virtual.
- **Behavior**: A virtual method shall override a method in all of its base classes.
- **Explanation**: When you declare a method as virtual in a class, you are allowing that method to be overridden in any derived (child) class.
- This means that if a base class (parent class) has a virtual method, and a derived class provides its own implementation of that method, the derived class's version will be used.


# Non-Virtual Method
- **Definition**: A non-virtual method shall only override a method in that class and its descendants.
- **Behavior**: A non-virtual method does not participate in polymorphism and shall only affect the method in the current class and its subclasses.
- **Explanation**: The method that gets called is determined by the type of the reference, not the type of the object it points to.

# First run, none of the methods are virtual
` function string drive_packet();`

## The result for first run are:
<pre>  
1. Handle type: [packet       ], Class type:[packet       ] packet_packet	drive packet with addr: 0, length: 57
2. Handle type: [packet       ], Class type:[check_packet ] packet_check	drive packet with addr: 2, length: 53
3. Handle type: [packet       ], Class type:[extend_packet] packet_extend	drive packet with addr: 2, length: 49
4. Handle type: [check_packet ], Class type:[check_packet ] check_check         drive packet with addr: 3, length: 9	check: db
5. Handle type: [check_packet ], Class type:[extend_packet] check_extend	drive packet with addr: 3, length: 41	check: 60
6. Handle type: [extend_packet], Class type:[extend_packet] extend_extend	drive packet with addr: 0, length: 30	check: 11	extend: 99
</pre>


## Down casting result
`$display(pkt.drive_packet()); Displays "check_pkt_1 drive packet with addr: 2, length: 53 check: 35"`

# Second run, virtual modifier was added to method drive_packet at class packet
` virtual function string drive_packet();`
<pre>
1. Handle type: [packet       ], Class type:[packet       ] packet_packet	drive packet with addr: 0, length: 57 
2. Handle type: [packet       ], Class type:[check_packet ] packet_check	drive packet with addr: 2, length: 53	check: 35 
3. Handle type: [packet       ], Class type:[extend_packet] packet_extend	drive packet with addr: 2, length: 49	check: 8b	extend: 78 
4. Handle type: [check_packet ], Class type:[check_packet ] check_check	        drive packet with addr: 3, length: 9	check: db 
5. Handle type: [check_packet ], Class type:[extend_packet] check_extend	drive packet with addr: 3, length: 41	check: 60	extend: 57 
6. Handle type: [extend_packet], Class type:[extend_packet] extend_extend	drive packet with addr: 0, length: 30	check: 11	extend: 99 
</pre>


# Third run, virtual modifier was removed from class packet and added to method drive_packet at class check_packet
` virtual function string drive_packet();`
<pre>
1. Handle type: [packet       ], Class type:[packet       ] packet_packet	drive packet with addr: 0, length: 57 
2. Handle type: [packet       ], Class type:[check_packet ] packet_check	drive packet with addr: 2, length: 53 
3. Handle type: [packet       ], Class type:[extend_packet] packet_extend	drive packet with addr: 2, length: 49 
4. Handle type: [check_packet ], Class type:[check_packet ] check_check	        drive packet with addr: 3, length: 9	check: db 
5. Handle type: [check_packet ], Class type:[extend_packet] check_extend	drive packet with addr: 3, length: 41	check: 60	extend: 57 
6. Handle type: [extend_packet], Class type:[extend_packet] extend_extend	drive packet with addr: 0, length: 30	check: 11	extend: 99 
</pre>

# Forth run, check queue output, virtual modifier was set to class packet method drive_packet 
<pre>
check_packet	drive packet with addr: 3, length: 52	check: c5
check_packet	drive packet with addr: 2, length: 19	check: cb
check_packet	drive packet with addr: 1, length: 57	check: ce
extend_packet	drive packet with addr: 0, length: 32	check: 34	extend: b3
packet	        drive packet with addr: 2, length: 15
extend_packet	drive packet with addr: 2, length: 5	check: a1	extend: 1e
check_packet	drive packet with addr: 3, length: 36	check: f4
check_packet	drive packet with addr: 1, length: 5	check: 22
packet	        drive packet with addr: 1, length: 54
check_packet	drive packet with addr: 3, length: 50	check: 26
extend_packet	drive packet with addr: 2, length: 59	check: 13	extend: c9
extend_packet	drive packet with addr: 1, length: 38	check: 27	extend: 69
extend_packet	drive packet with addr: 3, length: 44	check: 78	extend: 1b
check_packet	drive packet with addr: 2, length: 32	check: cc
packet	        drive packet with addr: 1, length: 8
check_packet	drive packet with addr: 2, length: 35	check: 31
</pre>
