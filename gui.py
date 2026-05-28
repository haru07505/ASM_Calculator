import subprocess
from pathlib import Path
import customtkinter as ctk
from tkinter import messagebox

SCALE = 100
BASE_DIR = Path(__file__).resolve().parent
CALCULATOR_EXE = BASE_DIR / "calculator.exe"

ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("blue")


class CalculatorApp(ctk.CTk):
    def __init__(self):
        super().__init__()

        self.title("ASM Calculator")
        self.geometry("420x670")
        self.resizable(False, False)
        self.configure(fg_color="#1f2a33")

        self.current = ""
        self.first_value = None
        self.operator = None
        self.just_calculated = False

        self.create_ui()

    def create_ui(self):
        title = ctk.CTkLabel(
            self,
            text="ASM CALCULATOR",
            font=("Segoe UI", 20, "bold"),
            text_color="#dce8f2"
        )
        title.pack(pady=(18, 6))

        subtitle = ctk.CTkLabel(
            self,
            text="Group 11",
            font=("Segoe UI", 12),
            text_color="#8fa6b8"
        )
        subtitle.pack(pady=(0, 12))

        self.display = ctk.CTkEntry(
            self,
            width=360,
            height=70,
            font=("Segoe UI", 30, "bold"),
            justify="right",
            fg_color="#273642",
            text_color="#f2f7fb",
            border_color="#3d5668",
            border_width=2,
            corner_radius=16
        )
        self.display.pack(pady=10)
        self.display.insert(0, "0")

        self.info_label = ctk.CTkLabel(
            self,
            text="",
            font=("Segoe UI", 12),
            text_color="#8fa6b8"
        )
        self.info_label.pack(pady=(0, 8))

        grid = ctk.CTkFrame(self, fg_color="#1f2a33")
        grid.pack(pady=8)

        buttons = [
            ["%", "CE", "C", "⌫"],
            ["1/x", "x²", "±", "÷"],
            ["7", "8", "9", "×"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["0", ".", "="],
        ]

        for r, row in enumerate(buttons):
            col_index = 0

            for text in row:
                if text == "0":
                    btn = ctk.CTkButton(
                        grid,
                        text=text,
                        width=174,
                        height=58,
                        font=("Segoe UI", 18, "bold"),
                        corner_radius=14,
                        fg_color=self.button_color(text),
                        hover_color=self.hover_color(text),
                        text_color="#f5f7fa",
                        command=lambda t=text: self.on_button_click(t)
                    )

                    btn.grid(row=r, column=col_index, columnspan=2, padx=5, pady=5)
                    col_index += 2

                else:
                    btn = ctk.CTkButton(
                        grid,
                        text=text,
                        width=82,
                        height=58,
                        font=("Segoe UI", 18, "bold"),
                        corner_radius=14,
                        fg_color=self.button_color(text),
                        hover_color=self.hover_color(text),
                        text_color="#f5f7fa",
                        command=lambda t=text: self.on_button_click(t)
                    )

                    btn.grid(row=r, column=col_index, padx=5, pady=5)
                    col_index += 1

    def button_color(self, text):
        if text in ["+", "-", "×", "÷", "="]:
            return "#2f80a8"
        if text in ["C", "CE", "⌫"]:
            return "#7a3e4a"
        if text in ["%", "1/x", "x²", "±"]:
            return "#3d5668"
        return "#344955"

    def hover_color(self, text):
        if text in ["+", "-", "×", "÷", "="]:
            return "#3b9cc9"
        if text in ["C", "CE", "⌫"]:
            return "#9b5060"
        if text in ["%", "1/x", "x²", "±"]:
            return "#4d6b80"
        return "#46616f"

    def get_display(self):
        return self.display.get()

    def set_display(self, value):
        self.display.delete(0, "end")
        self.display.insert(0, value)

    def append_number(self, value):
        if self.just_calculated:
            self.current = ""
            self.just_calculated = False

        if self.get_display() == "0" and value != ".":
            self.set_display(value)
        else:
            self.set_display(self.get_display() + value)

    def on_button_click(self, text):
        if text.isdigit():
            self.append_number(text)

        elif text == ".":
            if "." not in self.get_display():
                self.append_number(".")

        elif text in ["+", "-", "×", "÷", "%"]:
            self.set_operator(text)

        elif text == "=":
            self.calculate_binary()

        elif text == "C":
            self.clear_all()

        elif text == "CE":
            self.set_display("0")

        elif text == "⌫":
            self.backspace()

        elif text == "±":
            self.calculate_unary("n")

        elif text == "x²":
            self.calculate_unary("s")

        elif text == "1/x":
            self.calculate_unary("r")

    def to_scaled(self, text):
        try:
            return int(round(float(text) * SCALE))
        except ValueError:
            raise ValueError("Giá trị nhập không hợp lệ.")

    def from_scaled(self, value):
        return f"{value / SCALE:.2f}"

    def asm_operator(self, op):
        return {
            "+": "+",
            "-": "-",
            "×": "*",
            "÷": "/",
            "%": "%"
        }[op]

    def call_asm(self, a, op, b):
        if not CALCULATOR_EXE.exists():
            raise FileNotFoundError("Không tìm thấy calculator.exe. Hãy chạy build.bat trước.")

        completed = subprocess.run(
            [str(CALCULATOR_EXE), str(a), op, str(b)],
            capture_output=True,
            text=True
        )

        output = completed.stdout.strip()

        if output == "ERROR_DIV_ZERO":
            raise ZeroDivisionError("Không thể chia cho 0.")
        if output == "ERROR_OPERATOR":
            raise ValueError("Phép toán không hợp lệ.")
        if output == "ERROR_ARG":
            raise ValueError("Thiếu tham số truyền vào calculator.exe.")
        if output == "":
            raise ValueError("Assembly không trả về kết quả.")

        return int(output)

    def set_operator(self, op):
        try:
            self.first_value = self.to_scaled(self.get_display())
            self.operator = op
            self.info_label.configure(text=f"{self.get_display()} {op}")
            self.set_display("0")
        except Exception as e:
            messagebox.showerror("Lỗi", str(e))

    def calculate_binary(self):
        if self.first_value is None or self.operator is None:
            return

        try:
            second_value = self.to_scaled(self.get_display())
            asm_op = self.asm_operator(self.operator)

            result_scaled = self.call_asm(self.first_value, asm_op, second_value)
            result = self.from_scaled(result_scaled)

            self.info_label.configure(
                text=f"{self.from_scaled(self.first_value)} {self.operator} {self.from_scaled(second_value)} = {result}"
            )
            self.set_display(result)

            self.first_value = None
            self.operator = None
            self.just_calculated = True

        except Exception as e:
            messagebox.showerror("Lỗi", str(e))
            self.clear_all()

    def calculate_unary(self, asm_op):
        try:
            a = self.to_scaled(self.get_display())
            result_scaled = self.call_asm(a, asm_op, 0)
            result = self.from_scaled(result_scaled)

            label_map = {
                "n": "Đổi dấu",
                "s": "Bình phương",
                "r": "Nghịch đảo"
            }

            self.info_label.configure(text=f"{label_map[asm_op]} bằng ASM")
            self.set_display(result)
            self.just_calculated = True

        except Exception as e:
            messagebox.showerror("Lỗi", str(e))
            self.clear_all()

    def clear_all(self):
        self.first_value = None
        self.operator = None
        self.just_calculated = False
        self.info_label.configure(text="")
        self.set_display("0")

    def backspace(self):
        value = self.get_display()
        if len(value) <= 1:
            self.set_display("0")
        else:
            self.set_display(value[:-1])


if __name__ == "__main__":
    app = CalculatorApp()
    app.mainloop()