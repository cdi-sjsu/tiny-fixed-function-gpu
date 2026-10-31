# Geometry Meeting  4 — VALU implementation review, Projection Matrices, Geometry Pre-processing, and Sin implementation

**Date & Time:** 10/16/2026  | 11:30 –13:00 (PDT)<br>
**Location / Link:** Discord Call (CDI - SERVER)
**Facilitator:** Nicolas Ojeda
**Note Taker:** Nicolas Ojeda
**Meeting Status:** Completed on October 19, 2026.

---

### Attendees
* **Present:** Nicolas Ojeda, Sachin, Preston, Sean, lam
* **Absent / Excused:** No one

---

### Agenda & Objectives
1. review what preston has done and sill needs to do
2. quickly go over what sachin has worked on and what he needs to do
3. look at sean's plans for rasterization framebuffering and geometry
4. look over what lam has done for pre-processing

---

## Things Talked about that isn't research note explanations

Preston's Current Progress: 
- Has chosen a single cycle dot product complete 👍
- Each stage in the pipeline has clear steps
     - Valid handshaking
     - Updating is a good approach
     - good for a general line by line dot product module
 - We need to now tie things together for it to output the full matrix as a whole
 - We need to fix the bit width issues
 - see how the other part of the matrix that gets multiplied can be inputted as

Sachins PRojection: 
- Projection matrices are 4x4 matrices (duhh)
- Normalized Device Coordinates will help us chose which vertices are closer or further
- This creates a clipping value that matches boundries
- n: the distance between the near plane from the camera
- how do we choose n? -
- y_p/n = y_e/d -> yp = n*y_e/d
- This is stored in w since we arent doing division
- tao
- how to choose FOV's Theta for THeta/2
      - t=ntang(theta/2) or cot(theta/2) for zoom factor
  theres Y_n = s*Y_e/d : has theta be a coeficent to change our values
- FOC range is 45* to 90*
- 4/3 is our aspect ratio
- idealy we just choose f to have 100cm depth range


## Action Item that will be assigned

Preston - After Nic's review will make changes or research accordingly
Sachin - How does Theta get chosen (from literal number 45-90?) 
Nic - find out 16 bits 8 bits for depth buffer (i think its 16?)


### Action Items
| Owner | Deliverable | Due Date | Status |
| :--- | :--- | :---: | :---: |
| **Nic** | Workin on VGA | ASAP |50%|
| **Preston** | bug fixes for VALU | November 6  |Not yet |
| **Sean** |Sin Implentation | November 6 | Started  |
| **Sachin** | Projection Implmentation | November 6 | Started |
| **Lam** | Pre-processing | November 6 | Not Yet |

### Next Steps & Follow-Up
* **Next Meeting:** 2026-10-23 | 11:30 – 1:00 (PDT)
* Review the 4 follow-up deliverables after their deadline; and decide where to go from there
