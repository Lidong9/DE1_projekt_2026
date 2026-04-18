# Design Sources

This folder contains VHDL source files for the ultrasonic distance measurement project using the HC-SR04 sensor on the Nexys A7 FPGA board.

The modules in this folder are used mainly for display control, timing generation, and signal processing.

---

## File Overview

| File Name            | Description                                                                          |
| -------------------- | ------------------------------------------------------------------------------------ |
| `display_driver.vhd` | Main driver for multiplexed 8-digit 7-segment display. Displays measured data value. |
| `bin2seg.vhd`        | Converts binary/hexadecimal input value into 7-segment encoding.                     |
| `clk_en.vhd`         | Clock enable generator used for slower timing pulses from system clock.              |
| `counter.vhd`        | Generic synchronous counter used for timing and internal counting operations.        |

---

## Module Description

### display_driver.vhd

Controls the onboard 7-segment display.

Functions:

* multiplexes individual digits
* selects active digit using `an(7:0)`
* outputs segment pattern on `seg(6:0)`
* displays incoming measured value

Inputs:

* `clk`
* `rst`
* `data_in`

Outputs:

* `an(7:0)`
* `seg(6:0)`

---

### bin2seg.vhd

Combinational decoder converting numeric digit values to 7-segment LED patterns.

Used by:

* `display_driver.vhd`

Outputs patterns for digits:

* 0–9
* optional hexadecimal A–F (if implemented)

---

### clk_en.vhd

Generates periodic enable pulse from the main FPGA clock.

Used for:

* display multiplex refresh
* slower internal timing control

---

### counter.vhd

Reusable synchronous counter module.

Functions:

* increments on clock edge
* reset support
* terminal count generation (if used)

Used in:

* timing circuits
* display scanning
* measurement logic

---

## Simulation

Waveform verification of the display driver module:

![Display Driver Simulation](../images/display_driver_tb_sim.png)

The simulation confirms correct digit multiplexing and proper segment output values.

---

## Notes

* All modules are written in VHDL.
* Designed for Vivado toolchain.
* Target platform: Nexys A7 Artix-7 50T FPGA board.

---
