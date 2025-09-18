Directed Testcases (10)
D1 — Reset behavior (asynchronous)

Purpose: Verify reset clears pointers, flags, and data.

Setup: Power-up, assert rst_n=0 for multiple ns then release.

Steps: While writing/reading randomly, assert rst_n=0 asynchronously, hold one clock, then release rst_n=1.

Expected: fifo_count=0, fifo_empty=1, fifo_full=0, fifo_overrun=0, fifo_underrun=0, rd_data undefined/0, pointers = 0.

Pass: After release and one clock, all flags/pointers reflect empty FIFO.

D2 — Basic write and read order (FIFO property)

Purpose: Ensure first-in-first-out ordering.

Setup: Reset released, FIFO empty.

Steps: Write values 0x01,0x02,0x03 (one per write cycle). Then read three times.

Expected: Reads return 0x01,0x02,0x03 in that exact order.

Pass: Data order preserved and fifo_count increments/decrements accordingly.

D3 — Full flag and almost_full flag

Purpose: Check fifo_full and fifo_almost_full.

Setup: FIFO empty.

Steps: Write 7 entries — check fifo_almost_full == 1 when count==7. Write 1 more entry to reach 8 — check fifo_full == 1.

Expected: almost_full asserted at 7, full asserted at 8. almost_full may remain 1 alongside full.

Pass: Flags assert at correct counts.

D4 — Empty and almost_empty flags

Purpose: Verify fifo_empty and fifo_almost_empty.

Setup: Fill FIFO with 4 entries.

Steps: Read until 1 entry left; verify fifo_almost_empty == 1 when count==1; read final entry and check fifo_empty == 1.

Expected: almost_empty at 1, empty at 0.

Pass: Flags assert exactly at thresholds.

D5 — Overrun (write when full)

Purpose: Verify fifo_overrun set on write attempt when full.

Setup: Fill FIFO to full (8 entries).

Steps: Assert wr_enb=1 and attempt to write one cycle.

Expected: No data is written; fifo_overrun asserted for at least one cycle; fifo_count remains 8.

Pass: Overrun asserted and no corruption of stored data.

D6 — Underrun (read when empty)

Purpose: Verify fifo_underrun when reading empty FIFO.

Setup: Ensure FIFO empty.

Steps: Assert rd_enb=1 for a cycle.

Expected: fifo_underrun asserted; fifo_count remains 0; rd_data should not be treated as valid.

Pass: Underrun asserted and no pointer change.

D7 — Concurrent read and write (same cycle)

Purpose: Verify correct behavior when wr_enb and rd_enb both asserted.

Setup: Fill FIFO with 4 entries.

Steps: On cycle N assert both wr_enb (new value X) and rd_enb simultaneously for multiple cycles and observe fifo_count and data flow.

Expected: fifo_count remains steady if both succeed (write adds, read removes). No data lost and order preserved (new writes occupy next slot).

D8 — Pointer wrap-around

Purpose: Confirm read/write pointers wrap correctly after reaching max depth.

Setup: Reset released, FIFO empty.

Steps: Write 8 entries → Read 8 entries → Write 2 entries → Read 2 entries.

Expected: Pointers wrap back to zero smoothly, no data corruption.

Pass: Data matches written order, no pointer collision errors.

D9 — Flag stability (no glitches)

Purpose: Ensure flags stay stable when no operation happens.

Setup: Write 3 entries, stop operations.

Steps: Wait 5–10 clock cycles without write/read.

Expected: fifo_count stays 3, fifo_full/empty unchanged, no spurious overrun/underrun.

Pass: Flags remain stable until the next operation.

D10 — Reset during activity

Purpose: Check reset behavior while operations are active.

Setup: FIFO half-full, continuous writes happening.

Steps: Assert rst_n=0 asynchronously for one cycle while wr_enb=1. Then release reset.

Expected: After reset release, FIFO completely empty, all flags cleared, pointers reset to 0.

Pass: Reset overrides operations, FIFO always comes back clean.

---------------------------------------------------------------------------------------------------------

✅ Random Test Scenarios for FIFO

R1 — Random write burst

Purpose: Check FIFO can handle a random number of continuous writes.

Setup: FIFO empty after reset.

Steps: Generate a random number between 1–8, write that many values.

Expected: fifo_count matches the number written, no overrun unless full.

Pass: fifo_count increments correctly, no corruption.

R2 — Random read burst

Purpose: Validate reading random number of entries.

Setup: Preload FIFO with 8 values.

Steps: Randomly read 1–8 entries.

Expected: Data order preserved, fifo_count decrements properly, underrun only if extra reads attempted.

Pass: Reads match written sequence, no unexpected underrun.

R3 — Random mix of read and write

Purpose: Simulate realistic usage.

Setup: FIFO partially filled.

Steps: For 20 cycles, randomly choose to assert wr_enb or rd_enb.

Expected: FIFO behaves correctly, no data corruption.

Pass: Data sequence preserved, no illegal flag activity.

R4 — Random reset injection

Purpose: Verify reset works at unpredictable times.

Setup: FIFO active with ongoing operations.

Steps: Apply reset randomly during writes/reads.

Expected: FIFO clears immediately, flags reset, pointers reset.

Pass: After reset, fifo_count=0, fifo_empty=1, no stale data.

R5 — Random overrun attempts

Purpose: Stress overrun flag.

Setup: FIFO full.

Steps: Randomly attempt writes beyond depth.

Expected: fifo_overrun asserted, fifo_count stays at max.

Pass: No extra data stored, overrun flagged.

R6 — Random underrun attempts

Purpose: Stress underrun flag.

Setup: FIFO empty.

Steps: Randomly attempt reads when empty.

Expected: fifo_underrun asserted, fifo_count stays at 0.

Pass: No pointer change, underrun flagged.

R7 — Random back-to-back read+write

Purpose: Test simultaneous usage.

Setup: FIFO half-full.

Steps: Randomly choose cycles where both wr_enb and rd_enb are active.

Expected: fifo_count remains stable, data order maintained.

Pass: No loss of data, no false flags.

R8 — Random data values

Purpose: Verify data integrity.

Setup: FIFO empty.

Steps: Write random 8-bit values into FIFO, then read them out.

Expected: Output data matches input sequence.

Pass: Read data exactly equals written data.

R9 — Random idle cycles

Purpose: Confirm stability when idle.

Setup: FIFO half-full.

Steps: Insert random delays (do nothing) between operations.

Expected: Flags remain stable, fifo_count unchanged.

Pass: No spurious overrun/underrun, state consistent.

R10 — Long random stress test

Purpose: Ensure FIFO survives long activity.

Setup: FIFO starts empty.

Steps: Run 100+ cycles with random reads, writes, resets.

Expected: No hangs, data order preserved, flags assert correctly.

Pass: Simulation completes with expected data flow and correct flags.

Pass: Data continuity preserved; no spurious overrun/underrun.
