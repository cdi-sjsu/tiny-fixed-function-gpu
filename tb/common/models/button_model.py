class ButtonModel:
    """Model for button.sv"""

    def __init__(self, *, STABLE_COUNT: int, BUTTON_MODE: int):
        self.STABLE_COUNT = STABLE_COUNT
        self.BUTTON_MODE = BUTTON_MODE
        self.sync_counter = [0, 0]
        self.debounced_state = 0
        self.prev_debounced_state = 0
        self.stable_counter = 0
        self.btn_o = 0

    def step(self, *, rst_n, btn_i) -> int:
        """Cycle by cycle intended behavior for button returning btn_o"""
        if not rst_n:
            self.sync_counter = [0, 0]
            self.debounced_state = 0
            self.prev_debounced_state = 0
            self.stable_counter = 0
            self.btn_o = 0
            return self.btn_o

        self.prev_debounced_state = self.debounced_state

        # 2-stage sync
        self.sync_counter[1], self.sync_counter[0] = self.sync_counter[0], btn_i

        # Start counter whenever the 2-phase sync and debounced_state are different
        if self.debounced_state != self.sync_counter[1]:
            self.stable_counter += 1
            if self.stable_counter >= self.STABLE_COUNT:
                self.debounced_state = self.sync_counter[1]
                self.stable_counter = 0
        else:
            self.stable_counter = 0

        if self.BUTTON_MODE == 0:  # Pulse mode
            self.btn_o = self.btn_o = int(
                self.debounced_state == 1 and self.prev_debounced_state == 0
            )
        elif self.BUTTON_MODE == 1:  # Sustained mode
            self.btn_o = int(self.debounced_state)
        else:
            raise ValueError("BUTTON_MODE must have a value [0, 1].")

        return self.btn_o

    def get_btn_o(self) -> int:
        return self.btn_o
