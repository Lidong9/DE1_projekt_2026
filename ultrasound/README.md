# Ultrasonic Distance Measurer (HC-SR04)

A VHDL hardware module for the Nexys A7-50T FPGA (100 MHz) that interfaces with an HC-SR04 ultrasonic sensor and outputs the measured distance directly in millimeters.

## Hardware Design
The core module (`Ultrasound_Measurer.vhd`) uses a Finite State Machine (FSM) to handle the sensor timing autonomously:
* **Trigger Generation:** Produces a precise 10 µs pulse to start the measurement.
* **Dynamic Measurement:** Measures the `echo` pulse width. Instead of raw clock cycle division, it increments the distance register by 1 mm every 580 clock cycles (based on the 5.8 µs/mm speed of sound).
* **Acoustic Cooldown:** Enforces a 10 ms delay between measurements to prevent room echo interference.

## Interface Ports
* **Inputs:** `clk` (100 MHz), `reset`, `enable` (starts continuous measurement), `echo` (sensor response).
* **Outputs:** `trigger` (to sensor), `distance` (16-bit binary output in mm).

## Simulation & Testbench
The testbench (`ultrasound_tb.vhd`) validates the FSM by emulating real-world sound propagation delays. It verifies two specific test cases:
1. **150 mm distance:** Simulates an 870 µs echo pulse.
2. **45 mm distance:** Simulates a 261 µs echo pulse.

### Behavioral Simulation Waveform
![Simulation Waveform](images/ultrasound_tb.png)
