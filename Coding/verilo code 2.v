| **Aspect**                      | **Function**                                                          | **Task**                                                             |
| ------------------------------- | --------------------------------------------------------------------- | -------------------------------------------------------------------- |
| **Return Value**                | Must return a single value (using function name).                     | Cannot return directly, but can pass multiple outputs via arguments. |
| **Arguments**                   | Only **input** arguments allowed (cannot use output or inout).        | Can have **input, output, and inout** arguments.                     |
| **Timing Control (#, @, wait)** | **Not allowed** – functions must execute in **zero simulation time**. | **Allowed** – tasks can contain `#`, `@`, `wait`, etc.               |
| **Usage**                       | Used for **combinational logic, simple calculations**.                | Used for **complex operations, testbenches, sequential behavior**.   |
| **Return Type**                 | Must be declared (e.g., `integer`, `reg`, `bit`).                     | No return type. Values passed via output or inout.                   |
| **Execution Time**              | Zero time (purely combinational).                                     | Can consume simulation time.                                         |
| **Example Use Case**            | Arithmetic calculation, priority encoder logic.                       | Stimulus generation, data transactions, handshake protocols.         |


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



