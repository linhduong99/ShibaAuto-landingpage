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

## Triển khai

Trang tĩnh một file nên deploy ở đâu cũng được. Nhanh nhất là GitHub Pages: vào **Settings → Pages**, chọn nhánh `main` và folder `/ (root)`.
