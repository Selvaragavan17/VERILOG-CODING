| Feature        | `initial` Block                                                            | `always` Block                                                                 |
| -------------- | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| **Execution**  | Executes **only once** at the start of simulation.                         | Executes **repeatedly**, as long as simulation runs.                           |
| **Usage**      | Used for **testbench code**, stimulus generation, or initializing signals. | Used for **design logic**, like modeling combinational or sequential circuits. |
| **Start time** | Starts at simulation **time 0**.                                           | Also starts at **time 0**.                                                     |
| **End time**   | Ends when it reaches the last statement.                                   | Never ends (loops forever).                                                    |
| **Synthesis**  | Not synthesizable (ignored by hardware).                                   | Synthesizable (forms actual logic in hardware).                                |
| **Common in**  | Testbenches, initialization of variables.                                  | RTL design (flip-flops, combinational logic).                                  |



| Feature                 | Sequential Block (`begin…end`)                             | Parallel Block (`fork…join`)                                                        |
| ----------------------- | ---------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| **Execution**           | Statements execute **one after another** (serial).         | Statements execute **concurrently** (in parallel).                                  |
| **Timing control**      | Next statement waits until previous one finishes.          | All statements start together, each with its own delay.                             |
| **Usage**               | Used for **ordered operations** (e.g., reset then assign). | Used for **concurrent operations** (e.g., two signals toggling at different times). |
| **Example**             | `verilog<br>initial begin<br>  a=1;<br>  #5 b=1;<br>end`   | `verilog<br>initial fork<br>  #5 a=1;<br>  #10 b=1;<br>join`                        |
| **Simulation behavior** | Total time = sum of all delays inside the block.           | Total time = maximum of branch delays.                                              |

