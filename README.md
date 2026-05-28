# Máy Tính Bỏ Túi Sử Dụng Assembly NASM

## 1. Mục tiêu

Đề tài xây dựng một ứng dụng máy tính bỏ túi với phần xử lý phép toán được viết bằng Assembly NASM x64. Giao diện người dùng được xây dựng bằng Python, còn C đóng vai trò trung gian để gọi hàm Assembly.

Mục tiêu chính:

* Vận dụng kiến thức Kiến trúc máy tính và Hợp ngữ.
* Sử dụng thanh ghi và lệnh Assembly trong xử lý số học.
* Kết hợp Assembly với ngôn ngữ bậc cao để xây dựng ứng dụng hoàn chỉnh.
* Xử lý lỗi và điều hướng chương trình bằng lệnh nhảy.

Các chức năng chính:

* Cộng `+`
* Trừ `-`
* Nhân `*`
* Chia `/`
* Chia lấy dư `%`
* Đổi dấu `±`
* Bình phương `x²`
* Nghịch đảo `1/x`

---

## 2. Cấu trúc project

```text
Calculator/
│
├── calc_core.asm
├── basic_ops.asm
├── mul_div_ops.asm
├── advanced_ops.asm
│
├── main.c
├── gui.py
├── build.bat
├── test.bat
└── README.md
```

---

## 3. Giải thích từng phần

### `calc_core.asm`

Đóng vai trò điều phối phép toán. File này kiểm tra ký hiệu phép toán và gọi đến hàm Assembly tương ứng.

Ví dụ:

```text
+  → asm_add
*  → asm_mul
r  → asm_reciprocal
```

---

### `basic_ops.asm`

Chứa các phép toán cơ bản:

* Cộng `+`
* Trừ `-`
* Đổi dấu `±`

Các lệnh chính sử dụng:

```text
MOV
ADD
SUB
NEG
```

---

### `mul_div_ops.asm`

Chứa các phép toán:

* Nhân `*`
* Chia `/`
* Chia lấy dư `%`

Các lệnh chính sử dụng:

```text
IMUL
IDIV
CQO
CMP
```

Ngoài ra file này còn xử lý lỗi chia cho 0.

---

### `advanced_ops.asm`

Chứa các phép toán nâng cao:

* Bình phương `x²`
* Nghịch đảo `1/x`

File này sử dụng kỹ thuật fixed-point để xử lý số thực trong Assembly.

---

### `main.c`

Đóng vai trò trung gian giữa hệ điều hành và Assembly.

Nhiệm vụ:

* Nhận tham số command line.
* Gọi hàm `calc`.
* Nhận kết quả từ Assembly.
* In kết quả hoặc mã lỗi.

---

### `gui.py`

Xây dựng giao diện bằng Python Tkinter.

Nhiệm vụ:

* Nhập dữ liệu từ người dùng.
* Gọi `calculator.exe`.
* Hiển thị kết quả.

Python không trực tiếp xử lý phép toán chính, mà Assembly là phần xử lý cốt lõi của chương trình.

---

### `build.bat`

Dùng để build project:

```text
ASM → OBJ → EXE
```

Lệnh chính:

```bat
nasm -f win64 ...
gcc ...
```

---

### `test.bat`

Dùng để kiểm tra nhanh các phép toán sau khi build.

Ví dụ:

```bat
calculator.exe 1250 + 320
calculator.exe 1250 / 200
```

---

## 4. Kỹ thuật fixed-point

Để xử lý số thực trong Assembly, chương trình sử dụng kỹ thuật fixed-point với:

```text
SCALE = 100
```

Ví dụ:

```text
12.50 → 1250
3.20  → 320
```

Sau khi tính toán, kết quả sẽ được chuyển ngược về dạng số thực để hiển thị trên giao diện.

---

## 5. Cách build và chạy

### Build project

```bat
build.bat
```

### Test bằng terminal

```bat
calculator.exe 1250 + 320
```

### Chạy giao diện

```bat
python gui.py
```
