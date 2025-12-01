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
<img width="727" height="423" alt="image" src="https://github.com/user-attachments/assets/39cd0da9-f3cf-4a40-adc8-c0e0f8d09135" />


**Snippet of Signals:**
<img width="684" height="267" alt="image" src="https://github.com/user-attachments/assets/cafc436e-e189-43c5-aef2-80b3492fe871" />

**Planned enhancments:**
1) Implement read sequencer
2) Execute read and write in the same clock cycle.
