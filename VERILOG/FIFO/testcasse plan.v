
Reset the FIFO.	            FIFO becomes empty, empty=1, full=0.
	Write one value, then read it back.	        Same value comes out.
	Write 3 values, then read them back.    	Values come out in the same order.
 FIFO	Keep writing until FIFO has 8 values.    	full=1 when FIFO is full.
	Try to write when FIFO is already full.        	Extra data not stored, FIFO stays full.
	Try to read when FIFO is empty.        	No new data, FIFO stays empty.
	Do a read and write at the same time.	        FIFO size unchanged, new data written in.
Write full, read some, then write again (to test pointer wrap).        	FIFO still works, correct data order.
	Write 2 values, then read 3 times.	      First 2 values come, last read gives nothing.
	Keep writing more than 8 values.	      Only 8 stored, FIFO becomes full.
	Write A,B,C and read them.	        Output order is A,B,C (FIFO rule).
	Do random writes and reads.        	FIFO always works, no data loss or error.
	Write 2, read 1, write again, read all.      	Reads give correct remaining data.
	Fill FIFO, read some, then write more.	      FIFO accepts new data after reads.
Many random writes/reads for long time.	        FIFO works without error for all operations.
