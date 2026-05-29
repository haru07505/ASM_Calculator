# ASM Console Calculator

## 1. Tổng quan đề tài

Đề tài xây dựng một chương trình máy tính chạy trên console bằng NASM x64
trên Windows. Assembly được dùng để điều hướng menu, đọc input, parse số, thực hiện phép tính, chuyển đổi hệ số và format kết quả.

Chương trình hỗ trợ ba chế độ chính:

- `DEC - Số thực`: xử lý số thực bằng fixed-point với `SCALE = 100`.
- `HEX - Số nguyên`: xử lý số nguyên 32-bit theo bù 2.
- `BIN - Số nguyên`: xử lý số nguyên 32-bit theo bù 2.

Menu chính:

```text
1. DEC - So thuc
2. HEX - So nguyen
3. BIN - So nguyen
4. Chuyen doi he so
0. Thoat
```

Chức năng DEC:

- Cộng
- Trừ
- Nhân
- Chia
- Đổi dấu
- Bình phương
- Nghịch đảo

Chức năng HEX/BIN:

- Cộng
- Trừ
- Nhân
- Chia
- AND
- OR
- XOR
- NOT

Quy ước hiển thị HEX/BIN:

- HEX luôn hiển thị 8 ký tự, ví dụ `-10` thành `FFFFFFF6`.
- BIN luôn hiển thị 32 bit, ví dụ `-10` thành
  `11111111111111111111111111110110`.
- Khi chuyển HEX/BIN về DEC, chương trình hiểu giá trị theo signed 32-bit
  two's complement.

Sau khi tính xong, chương trình lưu kết quả gần nhất và cho phép:

```text
1. Tiep tuc tinh voi ket qua nay
2. Doi ket qua sang he khac
3. Lam phep tinh moi
0. Menu chinh
```

Ghi chú: kết quả DEC số thực chỉ đổi sang HEX/BIN nếu không có phần lẻ.
Ví dụ `12` đổi được, `12.50` sẽ báo lỗi.

## 2. Các Tools Cần Cài Đặt

Thực hiện cài đặt các tools cần thiết theo hướng dẫn trong link:
https://docs.google.com/document/d 1a9Ime46792JdFs4ki_Jkx0VcFtgslIrb8R9GuBjVaTQ/edit?tab=t.0

## 3. Cấu trúc thư mục

```text
Calculator/
|-- main.asm
|-- app.asm
|-- state.asm
|-- console_io.asm
|-- menus.asm
|-- parser.asm
|-- formatter.asm
|-- result_output.asm
|-- dec_ops.asm
|-- int_ops.asm
|-- bit_ops.asm
|-- convert.asm
|-- constants.inc
|-- build.bat
|-- test.bat
`-- README.md
```

## 4. Giải thích từng file

`main.asm`

File khởi động chương trình. File này gọi `init_console`, sau đó chuyển vào
`program_loop`, cuối cùng gọi `ExitProcess` để thoát chương trình.

`app.asm`

File điều phối luồng chạy chính của chương trình. File này quản lý menu
chính, menu DEC, menu HEX/BIN, menu sau khi có kết quả, và gọi các hàm tính
tương ứng.

`state.asm`

Chứa các biến dùng chung như chế độ hiện tại, hệ số hiện tại, toán hạng,
kết quả phép tính, kết quả gần nhất và trạng thái chuyển đổi.

`console_io.asm`

Phụ trách nhập/xuất console. File này gọi một số Windows API tối thiểu:
`GetStdHandle`, `ReadFile`, `WriteFile`. Các API này chỉ dùng để đọc input
và in output, không xử lý logic phép tính.

`menus.asm`

Chứa nội dung các menu, thông báo lỗi, chuỗi hiển thị và ký hiệu phép tính
như `+`, `-`, `*`, `/`, `AND`, `OR`, `XOR`.

`parser.asm`

Chuyển input dạng chuỗi thành số. File này parse DEC số thực fixed-point,
DEC số nguyên, HEX số nguyên và BIN số nguyên.

`formatter.asm`

Chuyển giá trị số thành chuỗi để in ra console. File này format DEC,
fixed-point DEC, HEX 32-bit và BIN 32-bit.

`result_output.asm`

In biểu thức và kết quả theo dạng rõ ràng, ví dụ:

```text
10.50 + 2.25 = 12.75
0000000A + 00000002 = 0000000C
```

`dec_ops.asm`

Chứa các phép tính DEC số thực fixed-point: cộng, trừ, nhân, chia, đổi dấu,
bình phương và nghịch đảo.

`int_ops.asm`

Chứa các phép tính số nguyên 32-bit: cộng, trừ, nhân và chia.

`bit_ops.asm`

Chứa các phép toán bit 32-bit: AND, OR, XOR và NOT.

`convert.asm`

Quản lý menu chuyển đổi hệ số và chuyển đổi kết quả gần nhất sang DEC, HEX
hoặc BIN.

`constants.inc`

Chứa các hằng số dùng chung, ví dụ `BASE_DEC`, `BASE_HEX`, `BASE_BIN`,
`TYPE_FIXED`, `TYPE_INT`, `MAX_INPUT`.

`build.bat`

Assemble từng file `.asm` thành `.obj`, sau đó link với `kernel32` để tạo
`calculator.exe`.

`test.bat`

Chạy nhanh một số test case mẫu để kiểm tra DEC, HEX, BIN và chuyển đổi hệ
số.

## 5. Phân chia công việc

Thành viên 1: DEC số thực

Phạm vi chính: các phép tính ở chế độ DEC số thực fixed-point.

Các file và hàm/label cần phụ trách:

- `menus.asm`
  - `msg_dec_menu`: nội dung menu DEC.
  - `show_dec_menu`: in menu DEC ra console.

- `app.asm`
  - `.dec_new`: khởi tạo chế độ DEC.
  - `.dec_continue`: tiếp tục tính với kết quả DEC trước đó.
  - `.dec_menu`: đọc lựa chọn phép tính DEC.
  - `.dec_check_binary`: xác định phép toán cần một hay hai toán hạng.
  - `.dec_compute`: gọi hàm tính toán DEC.
  - `.store_fixed_result`: lưu kết quả DEC gần nhất.
  - `call_dec_selected`: điều hướng lựa chọn menu đến hàm trong `dec_ops.asm`.

- `dec_ops.asm`
  - `dec_add`: cộng fixed-point.
  - `dec_sub`: trừ fixed-point.
  - `dec_mul`: nhân fixed-point, sau đó chia lại cho `SCALE`.
  - `dec_div`: chia fixed-point, có kiểm tra chia cho 0.
  - `dec_neg`: đổi dấu.
  - `dec_square`: bình phương.
  - `dec_reciprocal`: nghịch đảo `1/x`.

- `parser.asm`
  - `read_fixed_value`: đọc input DEC số thực.
  - `parse_fixed`: chuyển chuỗi như `10.50` thành giá trị scaled `1050`.

- `formatter.asm`
  - `format_fixed`: chuyển giá trị scaled về dạng hiển thị, ví dụ `1275`
    thành `12.75`.

Thành viên 2: HEX/BIN số nguyên và phép bit

Phạm vi chính: các phép tính số nguyên ở chế độ HEX/BIN và các phép bit.

Các file và hàm/label cần phụ trách:

- `menus.asm`
  - `msg_hex_menu`: nội dung menu HEX.
  - `msg_bin_menu`: nội dung menu BIN.
  - `show_hex_menu`: in menu HEX ra console.
  - `show_bin_menu`: in menu BIN ra console.

- `app.asm`
  - `.hex_new`: khởi tạo chế độ HEX.
  - `.hex_continue`: tiếp tục tính với kết quả HEX trước đó.
  - `.bin_new`: khởi tạo chế độ BIN.
  - `.bin_continue`: tiếp tục tính với kết quả BIN trước đó.
  - `.int_menu`: chọn menu HEX hoặc BIN.
  - `.read_int_menu`: đọc lựa chọn phép tính HEX/BIN.
  - `.int_check_binary`: xác định `NOT` là phép một toán hạng.
  - `.int_compute`: gọi hàm tính toán số nguyên hoặc phép bit.
  - `.store_int_result`: lưu kết quả HEX/BIN gần nhất.
  - `call_int_selected`: điều hướng lựa chọn menu đến `int_ops.asm`
    hoặc `bit_ops.asm`.

- `int_ops.asm`
  - `int_add`: cộng số nguyên 32-bit.
  - `int_sub`: trừ số nguyên 32-bit.
  - `int_mul`: nhân số nguyên 32-bit.
  - `int_div`: chia số nguyên 32-bit, có kiểm tra chia cho 0.

- `bit_ops.asm`
  - `bit_and`: phép AND bit.
  - `bit_or`: phép OR bit.
  - `bit_xor`: phép XOR bit.
  - `bit_not`: phép NOT bit.

- `formatter.asm`
  - `format_int`: format HEX/BIN theo bù 2 32-bit.

Thành viên 3: Nhập/xuất, parse/format và chuyển đổi hệ số

Phạm vi chính: khởi động chương trình, nhập/xuất console, parse/format số,
state dùng chung và chuyển đổi hệ số.

Các file và hàm/label cần phụ trách:

- `main.asm`
  - `mainCRTStartup`: entry point của chương trình.

- `console_io.asm`
  - `init_console`: lấy handle input/output console.
  - `print_z`: in chuỗi kết thúc bằng byte `0`.
  - `read_input`: đọc một dòng input từ console.

- `parser.asm`
  - `read_choice`: đọc lựa chọn menu.
  - `read_int_value_current_base`: đọc số nguyên theo hệ hiện tại.
  - `parse_int`: parse DEC/HEX/BIN số nguyên.

- `formatter.asm`
  - `format_current_value`: chọn format theo chế độ hiện tại.
  - `format_int`: format DEC/HEX/BIN số nguyên.
  - `get_base_name`: lấy tên hệ số `DEC`, `HEX`, `BIN`.

- `convert.asm`
  - `run_conversion_menu`: menu chuyển đổi hệ số.
  - `print_conversion_result`: in kết quả chuyển đổi.
  - `show_result_conversion`: đổi kết quả gần nhất sang hệ khác.

- `state.asm`
  - `current_type`: kiểu hiện tại, ví dụ DEC fixed-point hoặc INT.
  - `current_base`: hệ số hiện tại.
  - `op_a`, `op_b`, `op_result`: toán hạng và kết quả.
  - `has_result`, `last_result`, `last_type`, `last_base`: thông tin kết
    quả gần nhất.
  - `conv_src_base`, `conv_dst_base`: hệ nguồn và hệ đích khi chuyển đổi.

- `result_output.asm`
  - `print_binary_result`: in biểu thức hai toán hạng.
  - `print_unary_result`: in biểu thức một toán hạng như `NOT`, đổi dấu,
    bình phương hoặc nghịch đảo.
