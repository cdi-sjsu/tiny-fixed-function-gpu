# Geometry Meeting 2 — Dot Product Arithmetic Architecture

**Date & Time:** 10/23/2026  | 11:30 –13:00 (PDT)<br>
**Location / Link:** Discord Call (CDI - SERVER)
**Facilitator:** Nicolas Ojeda
**Note Taker:** Nicolas Ojeda
**Meeting Status:** Completed on October 19, 2026.

---

### Attendees
* **Present:** Nicolas Ojeda, Sachin, Preston, Sean
* **Absent / Excused:** No one

---

### Agenda & Objectives
1. Review our work so far
2. Go over Normalization (projection & division with w)
3. Go over interpolation (rasterization but so we know what theyre dealing with at highlevel) 
---

## Sin Cos What it do?

Sean: 
- explain the sin cosine LUT you made and your general process to what it's doing
- Does this impact our Q16.16 math?
- any extra pieces of important information
Notes in master doc and future documentation will be created

## Proposed Geometry Arithmetic Unit (ALU/GAU)

The proposed arithmetic unit will use:

- Four parallel Q16.16 multipliers
- A pipelined addition tree
- Pipeline registers to store data (the Matrices, the outputs, the calculated values throughout the computation)
- one matrix row per dot product
- Four dot products per transformed vertex
- Repeat

## Teaching Clipping and Color 

Sachin:
- Clipping , and Color 
- How does clipping work?
- Important formulas to implement?
- How does it effect our final outputs
- What are we getting from color
  Basically for these read the document notes 

## Projection & Interpolation
what is it? Look in master doc for my half notes

## Decisions Made
- Clipping 
There will be a Gaurd Band for our display
We will drop triangles where their greater majority dont display all the way
-1 is left side vga wall +1 is right side vga wall.
Sin LUT will just be from 0-45 degrees and there will be in the Octal binary value
color will be put

Research to be needed
- Going backwards from clipping: look into projection matrices to get our clipping values

- How does projection work? Perspective projection.
- What are the key formulas we need to get the Matrix itself.
- Choose/Make standards necessary for Projection
- https://learn.microsoft.com/en-us/windows/win32/direct3d9/projection-transform


- Look into how to convert and extrapolate important information from the two blender files
  

**who is getting what for these action items:**

Completion of Vector Arithmetic Logic Unit - Verilog/System Verilog
Sin Cos implementation - Verilog/System Verilog
Projection matrices research & Implementation - Research + Verilog/System Verilog
Processing Geometry Data from The Obj. an Mat. File -- side bit, what do we need from both? - Python
Color will be included with the Vertex structure

### Action Items
| Owner | Deliverable | Due Date | Status |
| :--- | :--- | :---: | :---: |
| **Nic** | Workin on VGA | 2026-10-23 | 50% complete |
| **Preston** |  Vector Arithmetic Logic Unit (VALU) implementation | 2026-10-23 | Continue Working on |
| **Sean** | Sin/Cos Implementation | 2026-10-30 | Not Started |
| **Sachin** | Projection Matrices & Implementation | 2026-10-30 | Not Started |
| **Lam** | Processing Geometry Data | 2026-10-30 | Not Started |

### Next Steps & Follow-Up
* **Next Meeting:** 2026-10-23 | 11:30 – 1:00 (PDT)
* Review our deliverables - next meeting Implement what hasn't yet 
****
