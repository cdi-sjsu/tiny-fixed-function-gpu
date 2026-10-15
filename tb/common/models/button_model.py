class ButtonModel:
    """Model for button.sv"""

    def __init__(self, *, STABLE_COUNT: int, BUTTON_MODE: int):
        self.STABLE_COUNT = STABLE_COUNT
        self.BUTTON_MODE = BUTTON_MODE
        self.prev_btn_o = 0
        self.sync_counter = [0, 0]
        self.stable_counter = 0

    def step(self, *, rst_n, btn_i) -> int:
        """NOT FINISED"""
        if rst_n:
            self.prev_btn_o = 0
            self.sync_counter = [0, 0]
            self.stable_counter = 0
            return 0

        # Idk how else to implement this rn
        self.sync_counter[0] = btn_i
        self.sync_counter[1] = self.sync_counter[0]

        if self.prev_btn_o != self.sync_counter[1]:
            self.stable_counter = (self.stable_counter + 1) % (self.STABLE_COUNT - 1)
        else:
            self.stable_counter = 0

        if self.BUTTON_MODE == 0:  # Pulse mode
            return 0
        elif self.BUTTON_MODE == 1:  # Sustained mode
            return 0
