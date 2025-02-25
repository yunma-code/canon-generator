# Random Canon Generator

## Overview
**Canon Generator** is an interactive audiovisual system that combines **Processing** for visual presentation and **Max/MSP** for audio synthesis. The system generates a self-playing canon when the play button on the Processing canvas is clicked. Users can transpose the melodic line in real time by moving the mouse.

## Features
- **Self-Generating Canon** – Automatically plays upon activation.
- **Mouse-Controlled Transposition** – Move the mouse to shift the melody.
- **Processing for Visuals** – Provides an interactive graphical interface.
- **Max/MSP for Audio** – Generates and manipulates sound.
- **OpenSoundControl (OSC) Communication** – Uses UDP for real-time data exchange.

## OSC Communication
The system uses **OpenSoundControl (OSC)** over **UDP** to facilitate communication between Processing and Max/MSP:
- **Processing → Max/MSP**: Messages are sent to Processing through **port 9080**.
- **Max/MSP → Processing**: Messages are received from Processing through **port 9031**.

## Files
- **Max/MSP Patch**: `RandomCanonGenerator.maxpat`
- **Processing Sketch**: `RandomCanonGenerator_pde.pde`

## Getting Started
### Prerequisites
- Install **Processing** ([Download](https://processing.org/download))
- Install **Max/MSP** ([Download](https://cycling74.com/downloads))
- Install the **oscP5** library for Processing (for OSC communication)
  - In Processing, go to **Sketch** > **Import Library** > **Add Library** and search for `oscP5`.

### Running the Project
1. Open `RandomCanonGenerator.maxpat` in **Max/MSP**.
2. Open `RandomCanonGenerator_pde.pde` in **Processing**.
3. Run the Processing sketch and click the play button to start the canon.
4. Move the mouse to transpose the melody in real time.

---

Enjoy experimenting with generative music!
