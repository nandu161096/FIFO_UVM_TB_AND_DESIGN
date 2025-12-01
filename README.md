# FIFO_UVM_TB_AND_DESIGN

**Key points of FIFO Design:**
1) FIFO size/depth is 16 and in each index, we can store 8 bits of data
2) Frequency of clock = 50 Mhz
3) Interface is used to connect design and testbench
4) Same clock is used for both write and read. Hence, it is synchronous FIFO.
5) As name indicates, during the read transaction first inserted will be pushed out.
6) If the FIFO is full and empty, full & empty signal will be high.

**Key points of UVM Test bench:**
1) Implemented write sequencer to execute 10 WR transactions
2) When Sequencer sends the data, Driver will update the input to design & SCO via interface & TLM ports respectively.
   SCO will save the last transaction in a temp variable.
3) Monitor class will sample the datain for every postive edge of the clock cycle and send it to score board.
4) SCO will check whether the last transaction from TB is same as the data in the design.
   If both are same, the result will be PASS. Otherwise it will be fail. 

DRV sends the data to design and SCO (Expected) @ 60, 100, 140, 180, etc..
MON sends the data to SCO (Actual) @ 80, 100, 120, 140, 160, etc..

**Snippet of logs:**

# KERNEL: UVM_INFO /home/runner/testbench.sv(217) @ 0: uvm_test_top [TEST] invoking seq
# KERNEL: UVM_INFO /home/runner/testbench.sv(108) @ 60: uvm_test_top.e.a.drv [DRV] mode : Write din:80
# KERNEL: UVM_INFO /home/runner/testbench.sv(76) @ 60: uvm_test_top.e.s [SCO] Exp din 80 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 80: uvm_test_top.e.a.mon [MON] mode : Write din:80 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 80: uvm_test_top.e.s [SCO] Act din 80 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 80: uvm_test_top.e.s [SCO] Test passed din 80 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 100: uvm_test_top.e.a.mon [MON] mode : Write din:189 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 100: uvm_test_top.e.s [SCO] Act din 80 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 100: uvm_test_top.e.s [SCO] Test passed din 80 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(108) @ 100: uvm_test_top.e.a.drv [DRV] mode : Write din:189
# KERNEL: UVM_INFO /home/runner/testbench.sv(76) @ 100: uvm_test_top.e.s [SCO] Exp din 189 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 120: uvm_test_top.e.a.mon [MON] mode : Write din:189 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 120: uvm_test_top.e.s [SCO] Act din 189 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 120: uvm_test_top.e.s [SCO] Test passed din 189 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 140: uvm_test_top.e.a.mon [MON] mode : Write din:151 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 140: uvm_test_top.e.s [SCO] Act din 189 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 140: uvm_test_top.e.s [SCO] Test passed din 189 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(108) @ 140: uvm_test_top.e.a.drv [DRV] mode : Write din:151
# KERNEL: UVM_INFO /home/runner/testbench.sv(76) @ 140: uvm_test_top.e.s [SCO] Exp din 151 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 160: uvm_test_top.e.a.mon [MON] mode : Write din:151 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 160: uvm_test_top.e.s [SCO] Act din 151 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 160: uvm_test_top.e.s [SCO] Test passed din 151 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 180: uvm_test_top.e.a.mon [MON] mode : Write din:222 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 180: uvm_test_top.e.s [SCO] Act din 151 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 180: uvm_test_top.e.s [SCO] Test passed din 151 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(108) @ 180: uvm_test_top.e.a.drv [DRV] mode : Write din:222
# KERNEL: UVM_INFO /home/runner/testbench.sv(76) @ 180: uvm_test_top.e.s [SCO] Exp din 222 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 200: uvm_test_top.e.a.mon [MON] mode : Write din:222 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 200: uvm_test_top.e.s [SCO] Act din 222 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 200: uvm_test_top.e.s [SCO] Test passed din 222 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 220: uvm_test_top.e.a.mon [MON] mode : Write din:146 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 220: uvm_test_top.e.s [SCO] Act din 222 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 220: uvm_test_top.e.s [SCO] Test passed din 222 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(108) @ 220: uvm_test_top.e.a.drv [DRV] mode : Write din:146
# KERNEL: UVM_INFO /home/runner/testbench.sv(76) @ 220: uvm_test_top.e.s [SCO] Exp din 146 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 240: uvm_test_top.e.a.mon [MON] mode : Write din:146 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 240: uvm_test_top.e.s [SCO] Act din 146 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 240: uvm_test_top.e.s [SCO] Test passed din 146 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 260: uvm_test_top.e.a.mon [MON] mode : Write din:179 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 260: uvm_test_top.e.s [SCO] Act din 146 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 260: uvm_test_top.e.s [SCO] Test passed din 146 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(108) @ 260: uvm_test_top.e.a.drv [DRV] mode : Write din:179
# KERNEL: UVM_INFO /home/runner/testbench.sv(76) @ 260: uvm_test_top.e.s [SCO] Exp din 179 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 280: uvm_test_top.e.a.mon [MON] mode : Write din:179 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 280: uvm_test_top.e.s [SCO] Act din 179 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 280: uvm_test_top.e.s [SCO] Test passed din 179 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 300: uvm_test_top.e.a.mon [MON] mode : Write din:65 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 300: uvm_test_top.e.s [SCO] Act din 179 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 300: uvm_test_top.e.s [SCO] Test passed din 179 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(108) @ 300: uvm_test_top.e.a.drv [DRV] mode : Write din:65
# KERNEL: UVM_INFO /home/runner/testbench.sv(76) @ 300: uvm_test_top.e.s [SCO] Exp din 65 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 320: uvm_test_top.e.a.mon [MON] mode : Write din:65 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 320: uvm_test_top.e.s [SCO] Act din 65 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 320: uvm_test_top.e.s [SCO] Test passed din 65 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 340: uvm_test_top.e.a.mon [MON] mode : Write din:60 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 340: uvm_test_top.e.s [SCO] Act din 65 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 340: uvm_test_top.e.s [SCO] Test passed din 65 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(108) @ 340: uvm_test_top.e.a.drv [DRV] mode : Write din:60
# KERNEL: UVM_INFO /home/runner/testbench.sv(76) @ 340: uvm_test_top.e.s [SCO] Exp din 60 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 360: uvm_test_top.e.a.mon [MON] mode : Write din:60 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 360: uvm_test_top.e.s [SCO] Act din 60 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 360: uvm_test_top.e.s [SCO] Test passed din 60 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 380: uvm_test_top.e.a.mon [MON] mode : Write din:164 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 380: uvm_test_top.e.s [SCO] Act din 60 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 380: uvm_test_top.e.s [SCO] Test passed din 60 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(108) @ 380: uvm_test_top.e.a.drv [DRV] mode : Write din:164
# KERNEL: UVM_INFO /home/runner/testbench.sv(76) @ 380: uvm_test_top.e.s [SCO] Exp din 164 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 400: uvm_test_top.e.a.mon [MON] mode : Write din:164 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 400: uvm_test_top.e.s [SCO] Act din 164 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 400: uvm_test_top.e.s [SCO] Test passed din 164 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(146) @ 420: uvm_test_top.e.a.mon [MON] mode : Write din:121 dout x
# KERNEL: UVM_INFO /home/runner/testbench.sv(66) @ 420: uvm_test_top.e.s [SCO] Act din 164 dout 0
# KERNEL: UVM_INFO /home/runner/testbench.sv(68) @ 420: uvm_test_top.e.s [SCO] Test passed din 164 dout 0****

**Snippet of Signals:**
<img width="684" height="267" alt="image" src="https://github.com/user-attachments/assets/cafc436e-e189-43c5-aef2-80b3492fe871" />

**Planned enhancments:**
1) Implement read sequencer
2) Execute read and write in the same clock cycle.
