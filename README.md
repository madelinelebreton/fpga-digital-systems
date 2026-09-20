# Digital Systems Design in Verilog

FPGA digital design projects implemented in Verilog targeting the
**Terasic DE1-SoC board (Intel/Altera Cyclone V, 5CSEMA5F31C6)**, built using
**Quartus Prime** for synthesis and **ModelSim/Questa** for simulation. Learned
from coursework in McMaster University's MECHTRON 3TB4 (Digital Systems).

Each folder is a Quartus project: open the `.qpf` file to load
it, or just read the `.v` source directly.

## Contents

| Project | Summary |
|---|---|
| [`sequential-logic-primitives/`](./sequential-logic-primitives) | A small library of fundamental sequential logic blocks: D flip-flop, D flip-flop with synchronous reset, D flip-flop with synchronous reset + enable, D latch with synchronous enable, 4-to-1 mux, 4-bit counter. Verified with functional/timing simulation, plus 7SD display decoder driven by board switches. |
| [`reaction-time-game/`](./reaction-time-game) | A 2 player reaction time game built as a finite state machine (`BLINK → WAIT_RANDOM → TIMING → RESULT`) on the DE1-SoC. Includes a parameterized clock divider, an LFSR-style random delay generator, binary-to-BCD conversion, and a 7-segment display driver, with results shown on the HEX displays and LEDs. |
| [`audio-dsp-interface/`](./audio-dsp-interface) | A digital audio path built around the DE1-SoC's onboard audio codec: serial-to-parallel and parallel-to-serial modules handle I2S-style sample framing to/from the codec, and a 3-to-1 MUX selects between processed audio streams for a simple DSP effects chain. |
| [`sdram-controller-interface/`](./sdram-controller-interface) | Interfacing the DE1-SoC's off-chip SDRAM with a Nios V soft processor built in Platform Designer: an Avalon-bus SDRAM controller wrapper, and C test programs that write/read back char, short, and int-sized values across the full memory range to verify the interface. |


## Tools

Quartus Prime · ModelSim/Questa · Verilog · Terasic DE1-SoC (Cyclone V)
