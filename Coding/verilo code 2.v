| **Aspect**                      | **Function**                                                          | **Task**                                                             |
| ------------------------------- | --------------------------------------------------------------------- | -------------------------------------------------------------------- |
| **Return Value**                | Must return a single value (using function name).                     | Cannot return directly, but can pass multiple outputs via arguments. |
| **Arguments**                   | Only **input** arguments allowed (cannot use output or inout).        | Can have **input, output, and inout** arguments.                     |
| **Timing Control (#, @, wait)** | **Not allowed** – functions must execute in **zero simulation time**. | **Allowed** – tasks can contain `#`, `@`, `wait`, etc.               |
| **Usage**                       | Used for **combinational logic, simple calculations**.                | Used for **complex operations, testbenches, sequential behavior**.   |
| **Return Type**                 | Must be declared (e.g., `integer`, `reg`, `bit`).                     | No return type. Values passed via output or inout.                   |
| **Execution Time**              | Zero time (purely combinational).                                     | Can consume simulation time.                                         |
| **Example Use Case**            | Arithmetic calculation, priority encoder logic.                       | Stimulus generation, data transactions, handshake protocols.         |

  module tb;
  reg a, b;

  initial begin
    $dumpfile("wave.vcd");  
    $dumpvars(0, tb);

    a = 0; b = 0;
    $display("Time=%0t, a=%b, b=%b", $time, a, b);
    #5 a = 1;
    #5 b = 1;
    $monitor("At Time=%0t, a=%b, b=%b", $time, a, b);
    #10 $finish;
  end
endmodule



  | **System Task**   | **Purpose**                     |
| ----------------- | ------------------------------- |
| `$display`        | Print message once              |
| `$monitor`        | Continuously monitor signals    |
| `$strobe`         | Print values at end of timestep |
| `$time/$realtime` | Get current simulation time     |
| `$finish`         | End simulation                  |
| `$stop`           | Pause simulation                |
| `$dumpfile`       | Create waveform file            |
| `$dumpvars`       | Dump signal values              |
| `$random`         | Generate random numbers         |
| `$fopen/$fclose`  | Open/close file                 |
| `$fdisplay`       | Print into file                 |


  | Directive            | Purpose                              |
| -------------------- | ------------------------------------ |
| \`define             | Define macro/constant                |
| \`include            | Include external file                |
| \`timescale          | Set simulation time unit & precision |
| `ifdef / `ifndef     | Conditional compilation              |
| \`undef              | Undefine a macro                     |
| \`default\_nettype   | Control implicit nets                |
| \`celldefine         | Mark module as a cell                |
| \`unconnected\_drive | Drive unconnected inputs             |
| \`resetall           | Reset directives                     |


1.Used for Continuous Assignment
The assign statement is used to drive net data types (like wire) continuously.
 2. Can Only Drive Nets, Not Variables
The LHS of an assign must be a net type (wire, tri, etc.), not a reg.
3.Implements Combinational Logic
Commonly used to model combinational logic (AND, OR, XOR, etc.).
Equivalent to logic gates.
4.Supports Continuous Driving of Expressions
5.Can Have Delay (Inertial Delay)
You can specify delay in an assign statement.
Delay models the propagation delay of combinational logic.
  6.Multiple Drivers Allowed on wire
  7.Cannot Be Used Inside always or initial Blocks
assign is only for continuous assignment, not procedural assignment.
  module assign_example;
  reg a, b, sel;
  wire y1, y2, y3;

  // Continuous assignments
  assign y1 = a & b;            // AND gate
  assign y2 = a | b;            // OR gate
  assign y3 = (sel) ? a : b;    // 2:1 MUX

  initial begin
    a = 0; b = 0; sel = 0;
    #5 a = 1; b = 1;
    #5 sel = 1;
    #5 b = 0;
  end
endmodule




