# DE1_projekt_2026
# Ultrasonic Distance Measurement (HC-SR04, VHDL)

## Modules Description

---

### Ultrasound Module (`ultrasound.vhd`)

The `ultrasound` module controls the HC-SR04 ultrasonic sensor and calculates the distance based on the duration of the echo signal.

#### Functionality
- Generates a trigger pulse to start measurement
- Waits for the echo signal from the sensor
- Measures how long the echo signal stays HIGH
- Converts the measured time into distance
- Stores the last measured value

#### Finite State Machine (FSM)
- `IDLE` – waiting for start signal
- `SEND_TRIG` – generates trigger pulse
- `WAIT_ECHO_START` – waits for echo signal to go HIGH
- `MEASURE_ECHO` – measures echo duration
- `SAVE_DATA` – stores measured value
- `COOLDOWN` – delay before next measurement

#### Inputs
| Signal | Description |
|------|-------------|
| clk  | System clock |
| rst  | Reset signal |
| start| Start measurement |
| echo | Echo signal from sensor |

#### Outputs
| Signal   | Description |
|----------|-------------|
| trig     | Trigger signal to sensor |
| distance | Measured distance |

---

### Top Module (`top_ultrasound.vhd`)

The `top_ultrasound` module integrates all components of the system and connects them to FPGA inputs and outputs.

#### Functionality
- Connects the ultrasonic sensor module with the FPGA
- Handles button input using a debounce circuit
- Sends measured distance to the display driver

#### Description
- Button press → debounced → start signal
- Ultrasound module performs measurement
- Result is forwarded to the display

#### Inputs
| Signal | Description |
|------|-------------|
| clk  | System clock |
| rst  | Reset signal |
| btn  | User button |
| echo | Echo signal from sensor |

#### Outputs
| Signal | Description |
|--------|-------------|
| trig   | Trigger signal to sensor |
| seg    | 7-segment display segments |
| an     | Display digit enable |

---

###  Display Driver (`display_driver.vhd`)

The `display_driver` module controls a multiplexed 7-segment display.

#### Functionality
- Displays numeric value (distance)
- Converts binary value into decimal digits
- Controls multiplexing of display digits

#### Description
- Input value is split into individual digits
- Each digit is converted using `bin2seg`
- Digits are displayed using fast multiplexing

#### Multiplexing
- Only one digit is active at a time
- Digits switch rapidly → appear simultaneously to human eye

#### Inputs
| Signal | Description |
|------|-------------|
| clk  | System clock |
| rst  | Reset signal |
| data | Value to display |

#### Outputs
| Signal | Description |
|--------|-------------|
| seg    | Segment control (a–g) |
| an     | Digit selection |

---

## Notes

!Edit schematu!

Pridat simulace 

Popis design souboru 

Pridat PNG do readme 


---
