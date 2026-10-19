from dataclasses import dataclass

from fxpmath.objects import Fxp


@dataclass
class XYZWVector:
    x: Fxp
    y: Fxp
    z: Fxp
    w: Fxp
