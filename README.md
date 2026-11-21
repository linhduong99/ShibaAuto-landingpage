# Shiba Auto — Landing Page

Trang giới thiệu Shiba Auto, phần mềm hỗ trợ Võ Lâm Chi Mộng bản web (H5) trên Windows.

Toàn bộ trang nằm trong một file `index.html` duy nhất: HTML, CSS và JS viết chung, không cần build, không phụ thuộc package nào. Font lấy từ Google Fonts qua CDN.

## Chạy thử

Mở trực tiếp `index.html` bằng trình duyệt, hoặc chạy một web server tĩnh:

```powershell
python -m http.server 8000
```

Rồi vào http://localhost:8000

## Cần thay trước khi đưa lên mạng

Tìm chữ `TODO:` trong `index.html`, có 5 nhóm:

| Mốc | Nội dung cần thay |
| --- | --- |
| `TODO:DOWNLOAD` | Link tải gói ZIP (3 nút: nav, hero, cuối trang) |
| `TODO:VERSION` | Số phiên bản hiện tại (badge ở hero) |
| `TODO:CONTACT` | Zalo / Telegram (3 nút gói bản quyền + footer) |
| `TODO:GUIDE` | Link hướng dẫn sử dụng (nút cuối trang + footer) |
| `TODO:LEGAL` | Điều khoản, chính sách (footer) |

## Tuỳ biến

- **Màu sắc**: sửa 3 biến `--amber`, `--amber2`, `--ember` trong `:root` ở đầu phần `<style>`.
- **Giá bản quyền**: mặc định để "Liên hệ" để không phải sửa trang mỗi lần đổi giá. Muốn hiện giá cố định thì sửa `.price` trong `<section id="banquyen">`.
- **Ảnh chụp**: hai khung giao diện trong trang được vẽ bằng CSS (class `.shot`), không phải ảnh thật. Có screenshot thì thay bằng thẻ `<img>` vào đúng chỗ đó.

## Favicon

Favicon và logo (ở nav + footer) dùng chung ảnh đầu Shiba, nhúng thẳng vào `index.html` dưới dạng base64 nên trang vẫn chạy độc lập một file:

- **Favicon** 64×64, nằm trong thẻ `<link rel="icon">`
- **Logo** 96×96, khai báo một lần trong CSS `.logo .mark` rồi dùng chung cho nav (38px) và footer (34px)

| File | Dùng để làm gì |
| --- | --- |
| `icon-source.png` | Ảnh gốc 1254×1254, nền trong suốt |
| `make-favicon.ps1` | Script tạo lại toàn bộ icon từ ảnh gốc |
| `apple-touch-icon.png` | 180×180, cho iPhone/iPad khi lưu ra màn hình chính |
| `shiba-icon-512.png` | 512×512, để dành cho `og:image` khi share link |

Muốn đổi icon khác: thay `icon-source.png` rồi chạy

```powershell
powershell -ExecutionPolicy Bypass -File make-favicon.ps1
```

Script tự cắt viền trong suốt, chừa 6% padding, xuất các kích thước, ghi base64 mới vào cả favicon và logo trong `index.html`, rồi đọc ngược lại để kiểm tra ảnh giải mã được.

## Triển khai

Phần trang web chỉ cần `index.html`, deploy ở đâu cũng được. Nhanh nhất là GitHub Pages: vào **Settings → Pages**, chọn nhánh `main` và folder `/ (root)`.

Các file PNG trong repo không bắt buộc phải lên hosting — thiếu chúng thì trang vẫn chạy, chỉ mất icon khi lưu ra màn hình chính iPhone. Riêng `apple-touch-icon.png` nếu muốn dùng thì để cùng cấp với `index.html`.
