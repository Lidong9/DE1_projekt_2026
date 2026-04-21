# DE1_projekt_2026
# Ultrasonic Distance Measurement (HC-SR04, VHDL)

## Project Description

This project implements an ultrasonic distance measurement system using the HC-SR04 sensor on an FPGA board. The system measures the duration of the echo signal and determines the distance to an object.

The design is implemented in VHDL as a synchronous digital circuit.

---

## Functionality

1. A trigger pulse is generated to start the measurement.
2. The ultrasonic sensor sends a signal and sets the echo signal HIGH.
3. The system measures how long the echo signal remains HIGH.
4. This time is used to estimate distance.
5. The result is displayed on a 7-segment display.

---

## Top-Level Interface

| Signal | Direction | Width | Description                |
| ------ | --------- | ----- | -------------------------- |
| clk    | input     | 1     | System clock               |
| rst    | input     | 1     | Reset signal               |
| echo   | input     | 1     | Echo signal from sensor    |
| trig   | output    | 1     | Trigger signal to sensor   |
| seg    | output    | 7     | 7-segment display segments |
| an     | output    | 4     | Digit enable               |

---

## Block Diagram

The design consists of interconnected logical blocks as shown in the provided diagram.
# Měření vzdálenosti pomocí ultrazvukového senzoru na Nexys A7-50T

Tento projekt implementuje měřič vzdálenosti v jazyce VHDL pomocí ultrazvukového senzoru HC-SR04 a vývojové desky Nexys A7-50T (nebo 100T). Naměřená vzdálenost je zobrazována v milimetrech na 7-segmentovém displeji.

## Blokové schéma (Architektura)

```mermaid
flowchart LR
    %% Vstupy
    clk([clk])
    btn_rst([btn_rst])
    sw_enable([sw_enable])
    echo_in([echo])

    %% Komponenty
    DEB[debounce]
    ULT[Ultrasound Measurer]
    DISP[display driver]

    %% Zapojeni vstupu
    clk --> DEB
    clk --> ULT
    clk --> DISP

    btn_rst -->|btn_in| DEB
    0([0]) -.->|rst| DEB
    
    sw_enable -->|enable| ULT
    echo_in -->|echo| ULT

    %% Vnitrni signaly a sbernice
    DEB -->|"btn_state \n (sig_rst_clean)"| ULT
    DEB -->|"btn_state \n (sig_rst_clean)"| DISP
    
    ULT ==>|"distance [15:0] \n (sig_distance)"| DISP

    %% Vystupy
    ULT -->|trigger| trigger_out([trigger])
    DISP ==>|"seg [6:0]"| seg_out([seg 6:0])
    
    DISP ==>|"anode [3:0] \n (sig_anode_4bit)"| AN_LOGIC{Doplneni na 8}
    AN_LOGIC ==>|"an [7:0]"| an_out([an 7:0])
```

## Popis vstupů a výstupů (I/O porty)

| Port | Směr | Šířka | Popis | Mapování (Nexys A7) |
| :--- | :--- | :--- | :--- | :--- |
| `clk` | Vstup | 1 bit | Hlavní hodinový signál (100 MHz). | `E3` |
| `btn_rst` | Vstup | 1 bit | Tlačítko pro asynchronní reset. | `N17` (BTNC) |
| `sw_enable` | Vstup | 1 bit | Přepínač zapnutí/vypnutí měření. | `J15` (SW0) |
| `echo` | Vstup | 1 bit | Vstupní signál ze senzoru. | `D18` (PMOD JA2) |
| `trigger` | Výstup | 1 bit | Inicializační puls pro senzor. | `C17` (PMOD JA1) |
| `an` | Výstup | 8 bitů | Společné anody pro displej. | Displej (anody) |
| `seg` | Výstup | 7 bitů | Katody displeje (segmenty A-G). | Displej (katody) |
Each block processes signals and passes results to the next stage.

---

## Modules

### 1. Debouncer

Removes noise from the mechanical button input.

Inputs:

* clk
* btn

Outputs:

* btn_clean

---

### 2. Ultrasound

Core module that controls the ultrasonic sensor and performs measurement.

Functions:

* generates trigger signal
* measures echo signal duration
* processes measured value

Inputs:

* clk
* rst
* echo
* btn_clean

Outputs:

* trig
* distance [15:0]

---

### 3. Display Driver

Displays the measured distance on a 7-segment display.

Inputs:

* clk
* distance [15:0]

Outputs:

* seg [6:0]
* an [3:0]

---

## Internal Signals

| Signal    | Width | Description             |
| --------- | ----- | ----------------------- |
| btn_clean | 1     | Debounced button signal |
| distance  | 16    | Measured distance value |

---

---

## Internal Signals

| Signal         | Width | Description            |
| -------------- | ----- | ---------------------- |
| count          | 16    | Measured echo duration |
| distance       | 8     | Value used for display |
| enable_counter | 1     | Enables counting       |
| start          | 1     | Start measurement      |
| stop           | 1     | Stop measurement       |

---

## Notes

!Edit schematu!

Pridat simulace 

Popis design souboru 

Pridat PNG do readme 


---
