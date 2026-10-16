# Geometry Meeting 2 — Dot Product Arithmetic Architecture

**Date:** 10/16/2026  
**Time:** 11:30 AM–1:00 PM   
**Geoemtry team**
## Meeting Goal

Understand sequential and parallel dot-product hardware and decide who should develop the Arithmetic unit, Rotation Matrix (Python) LUT, research how Clipping will work, and figure out how material data will passthrough to rasterization team   .

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
| Type       | how long it took for EDA Playground simulation timing | Pros                            | Cons                                                           |
|------------|------------------|---------------------------------|-----------------------------------------------------------------------------------------------------|
| Sequential | 45 nano sec      | Its super cheap, easy to reuse  | we dont really need super cheap, its 9 times slower for just one dot product (not even a vertex!)   |
| Parralel   | 5 nano sec       | its more expensive, much faster | since we have to consider more variables at once it can get way harder to debug and pinpoint issues |

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
| Clock 1: multipliers work on A  |                         |                        |   |
|---------------------------------|-------------------------|------------------------|---|
|  Clock 2: multipliers work on B |  first adders work on A |                        |   |
| Clock 3: multipliers work on C  | first adders work on B  | final adder works on A |   |
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

## Action Items
nic must make action item in github project
| Owner | Deliverable | Due Date | Status |
| Nic | :--- | :--- | :--- |
| Preston | :--- | :--- | :--- |
| Sean | :--- | :--- | :--- |
| Sachin | :--- | :--- | :--- |

### Next Steps & Follow-Up
* **Next Meeting:** 2026-10-23 | 11:30 – 1:00
* Review the three follow-up deliverables after their deadline;
