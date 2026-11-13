# Geometry Meeting  6 — Test Bench Review and Catching up

**Date & Time:** 11/13/2026  | 11:30 –13:00 (PDT)<br>
**Location / Link:** Discord Call (CDI - SERVER)
**Facilitator:** Nicolas Ojeda
**Note Taker:** Nicolas Ojeda

---

### Attendees
* **Present:** Nicolas Ojeda, Sachin, Sean, Lam, preston
* **Absent / Excused:**  

---

### Agenda & Objectives
1. Review Clipping Modules (its the longest thing)
2. See what preston needs to complete/learn
3. See what Sean needs to complete left
4. Assign Lam next task

---

## Clipping Implementation Review
its not clipping.
- He is using a thing called outcodes, its the to choen sutherland algorithim as the blueprint he is using
- The module decides what to do based off the label
- it has reject, gaurd-fail
- Far things is handled by rasterization
- Outcode has a bit order for saying if things are LRTBNF
- The outputs of this will be used for clipping but its the flags that allow us
-     the send flag will allow us to send the existing vertex that wont need clipping however the new clipping vertexes will be needed to go through clipping
- hopefully in this initial test we wont need to do clipping yet
- Next jobs is : Clipping, the divider for w to make 1/w, and clocking timing.

## Action Item that will be assigned

Preston - Test bench Finish
Sean - ?
Sachin - Clipping module Still
Lam - Documentation Compilation Into Github ~ for the next 3 weeks
Nic - Yep,

### Action Items
Issues are made on the GitHub

### Next Steps & Follow-Up
* **Next Meeting:** 2026-1-13 | 11:30 – 1:00 (PDT)
* Next meeting will be the last meeting before we combine everything.
