from dataclasses import dataclass

from XYZWVector import XYZWVector


@dataclass
class DisplayTriangle:
    vector_1: XYZWVector
    vector_2: XYZWVector
    vector_3: XYZWVector
