# Geometry Meeting  5 — Module reviews

**Date & Time:** 11/06/2026  | 11:30 –13:00 (PDT)<br>
**Location / Link:** Discord Call (CDI - SERVER)
**Facilitator:** Nicolas Ojeda
**Note Taker:** Nicolas Ojeda
**Meeting Status:** Completed on October 19, 2026.

---

### Attendees
* **Present:** Nicolas Ojeda, Sachin, Sean, Lam, preston
* **Absent / Excused:**  

---

### Agenda & Objectives
1. review our current work we made from meeting 4
2. Understand which part of the project we are on
3. assign new tasks (Test benches and more modules)

---

## Teachings from all teamates 

### Lam
 - Made the LUT for the 3d model with color and triangle vertices
 - made a .mem (memorization file) file
 - multiplies the object's float values into a 16 bit file thorugh bit shifting through 2^16 since we are in Q16.16 fixed point
 - It parses the obj to color map it looks up the material name and then finds the corresponding mtl files color. wait thats genius
 - it splits the obj to triangles.
 - it generates a color for the triangle

### Preston
-not here :(

### Sachin
- resourceful
- makes a 4x4 projection matrix
- lots of trig math
- how does the trig relate to our final output in what we are inputting? seems like the result is completely outside of the FPGA
- the math related to this projection is
- the verilog generates an empty 4x4 table then indexes those values as something for what we can use
- uses Direct3D

### Sean
- will make a sin testing indexing thingy yooo 


## Action Item that will be assigned

Preston - Test bench
Sean - Test Bench
Sachin - Clipping module
Lam - Fix bug issues etc.

### Action Items
Theryre just issues on the project im no longer doing ts its so tedious 

### Next Steps & Follow-Up
* **Next Meeting:** 2026-11-13 | 11:30 – 1:00 (PDT)
* Review our test benches and clipping modules
