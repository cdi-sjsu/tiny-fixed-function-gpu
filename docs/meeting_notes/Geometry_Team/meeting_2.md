# Geometry Meeting 2 — Dot Product Arithmetic Architecture

**Date & Time:** 10/16/2026  | 11:30 –13:00 (PDT)<br>
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
1. Understanding Sequential Vs Parralel Dot-Product hardware
2. Decide who does the VALU (Vector ALU)
3. Decide who does The Research for Clipping and Material Passthrough
4. Decide who does the Sine & Cos Pre-Processing

---

## DEMO

We will compare two four-term signed Q16.16 dot products:

- Sequential implementation:
  - One multiplier
  - One accumulator
  - Four terms processed separately

- Parallel implementation:
  - Four multipliers
  - Two first-level adders
  - One final adder
  - Balanced addition tree
### Demo Comparison
| Type | EDA Simulation Time | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **Sequential** | 45 ns | Low area cost; easy logic reuse | 9× slower for a single dot product (doesn't scale well for complete vertices) |
| **Parallel** | 5 ns | Significantly higher throughput | Higher area cost; increased variable tracking makes debug/isolation harder |
<img width="3726" height="291" alt="image" src="https://github.com/user-attachments/assets/cde612d6-1afd-450d-a324-41c6bba87d75" />

[EDA Playground Sim](https://edaplayground.com/x/hzKt)

## Proposed Geometry Arithmetic Unit (ALU/GAU)

The proposed arithmetic unit will use:

- Four parallel Q16.16 multipliers
- A pipelined addition tree
- Pipeline registers to store data (the Matrices, the outputs, the calculated values throughout the computation)
- one matrix row per dot product
- Four dot products per transformed vertex
- Repeat

THe pipeline diagram:
<img width="724" height="698" alt="image" src="https://github.com/user-attachments/assets/ea493993-0406-4e83-b61f-a449ae902e42" />


## Decisions Made


- Dot-product architecture:
    - for example
### Pipeline Stage Timing Example
| Clock Cycle | Multipliers | First-Level Adders | Final Adder |
| :---: | :--- | :--- | :--- |
| **1** | Process Vertex A | — | — |
| **2** | Process Vertex B | Process Vertex A | — |
| **3** | Process Vertex C | Process Vertex B | Process Vertex A |
    - Or you have two have these ALU models and it would be 2x faster working this way so one works on A B other works on C
    - and if we really wanted since we want to maximize time, four of these could work, FYI A B C is each vertice but the ALU were making or GAU
    - the GAU is only doing one row at a time, so we could do one GAU does 4 repeats on A efficiently
    - or we do multiple GAUs like 3 GAUs that have a dedicated vertex. i like this one we just need to make one for now
- Pipeline stages: That is for above really. we also get to talk about
    - How we are going to store the Matrices that can transform themselves.
    - Option 1 i can think of: Completely hardwired constants - it makes it good if it never changes like identity matrix
    - Option 2 reading from LUTs directly (this uses some registers we create to store the data then it reads from it)
          - AI excerpt :  else if (load_rotation_matrix && lut_valid) begin
        // Capture the current LUT outputs into the matrix.
        matrix_reg[0][0] <=  cosine_value;
        matrix_reg[0][1] <= -sine_value;
        matrix_reg[0][2] <=  Q16_ZERO;
        matrix_reg[0][3] <=  Q16_ZERO;
      -Option 3 theres a middle ground of having registers set up with inputs and then for now we explicitly define them for things like translation etc

    THen why even talk about the "three options?" -- its to show we need to mix and match and not choose one for this as the identity matrix will be fine as a hardcoded Zero and One variable
  however for other matrices we probably want to think about the future and what we can do to prepare for it. we want CPU control so lets make it so a CPU could control it if you turned your head and squinted.
  
- Triangle processing order:
    - we want a full triangle to be ready to go
    - we need to decide the thing above do we want A complete then go onto B then go onto C once B is complete. or do we want A and while is being complete then B and so on, or what could we do?
          - Two/four GAUs? speed up our process more?
- Fixed-point behavior:
    - i should probably write a document on how to do fixed-point behavoir
- Other decisions:

**who is getting what for these action items:**

Initial Geometry Arithmetic Unit implementation
Python Q16.16 sine/cosine LUT generator
Clipping algorithm and interface research
Material/color pass-through proposal for rasterization

### Action Items
| Owner | Deliverable | Due Date | Status |
| :--- | :--- | :---: | :---: |
| **Nic** | Workin on VGA | 2026-10-23 | Not Started |
| **Preston** | Initial Geometry Arithmetic Unit (GAU/VALU) implementation | 2026-10-23 | Not Started |
| **Sean** | Python Q16.16 sine/cosine LUT generator | 2026-10-23 | Started |
| **Sachin** | Clipping Algorithm/Interface & Material/color pass-through proposal for rasterization | 2026-10-23 | Not Started |

### Next Steps & Follow-Up
* **Next Meeting:** 2026-10-23 | 11:30 – 1:00 (PDT)
* Review the three follow-up deliverables after their deadline; and decide where to go from there
