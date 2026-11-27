# Shiba Auto — Landing Page

Trang giới thiệu Shiba Auto — auto VLCM cho cả bản Client và Web H5 (Võ Lâm Chi Mộng, Võ Lâm Chân Mệnh, Mộng Chí Tôn, Mộng Kiếm Hiệp), giới thiệu hai phiên bản: V1 (ứng dụng Windows) và V2 (Windows, Linux, VPS).

Toàn bộ trang nằm trong một file `index.html` duy nhất: HTML, CSS và JS viết chung, không cần build, không phụ thuộc package nào. Font lấy từ Google Fonts qua CDN.

## Chạy thử

Mở trực tiếp `index.html` bằng trình duyệt, hoặc chạy một web server tĩnh:

```powershell
python -m http.server 8000
```

Rồi vào http://localhost:8000

## Cần thay trước khi đưa lên mạng

`index.html` không còn comment, nên tìm theo các chuỗi dưới đây:

| Tìm | Nội dung cần thay |
| --- | --- |
| `Hướng dẫn cài đặt` | Link hướng dẫn sử dụng (footer, đang trỏ `#batdau`) |
| `Shiba Auto V1 &amp; V2 · Client` | Badge ở hero, thêm số phiên bản nếu muốn |

## Liên hệ & SEO

- Mọi nút tải Shiba Auto (nav, hero, khối liên hệ) và mọi nút liên hệ (gói bản quyền, FAQ, footer) trỏ về nhóm Zalo `https://zalo.me/g/cuyyjpst6ssfei4cwmlu`.
- Mã QR ở khối liên hệ là SVG inline (`<svg class="qr">`) mã hoá đúng link trên. Đổi nhóm thì tạo QR mới (vd. npm `qrcode`: `QRCode.toString(url,{type:'svg'})`) và thay thẻ đó.
- SEO: `title`, `description`, `keywords`, Open Graph, JSON-LD (`SoftwareApplication` + `FAQPage`). Từ khoá (auto, auto vlcm, mộng chí tôn, mộng kiếm hiệp, võ lâm chân mệnh, võ lâm chi mệnh…) nằm trong thẻ `<meta name="keywords">`.

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

Tên miền: **https://shiba-auto.com** (đã ghi trong `canonical`, `og:url`, `og:image`, `twitter:image`, JSON-LD, `robots.txt`, `sitemap.xml`).

| File | Dùng để làm gì |
| --- | --- |
| `CNAME` | Báo GitHub Pages tên miền riêng `shiba-auto.com` |
| `robots.txt` | Cho phép bot tìm kiếm vào trang, chỉ đường tới sitemap |
| `sitemap.xml` | Danh sách URL gửi cho Google / Bing; đổi `lastmod` khi sửa nội dung lớn |

### GitHub Pages

1. Repo → **Settings → Pages**: Source chọn nhánh `main`, folder `/ (root)`.
2. Ô **Custom domain** điền `shiba-auto.com` (file `CNAME` đã có sẵn), bấm Save.
3. DNS xong và GitHub cấp chứng chỉ thì tích **Enforce HTTPS**.

### Bản ghi DNS (tạo ở nơi mua tên miền)

| Loại | Tên / Host | Giá trị |
| --- | --- | --- |
| A | `@` | `185.199.108.153` |
| A | `@` | `185.199.109.153` |
| A | `@` | `185.199.110.153` |
| A | `@` | `185.199.111.153` |
| AAAA | `@` | `2606:50c0:8000::153` |
| AAAA | `@` | `2606:50c0:8001::153` |
| AAAA | `@` | `2606:50c0:8002::153` |
| AAAA | `@` | `2606:50c0:8003::153` |
| CNAME | `www` | `linhduong99.github.io` |

Xoá các bản ghi A / CNAME mặc định (trang đỗ của nhà đăng ký) trước khi thêm. DNS thường nhận sau vài phút đến vài giờ.

### Sau khi trang chạy

- Thêm trang vào [Google Search Console](https://search.google.com/search-console) (loại Domain, xác minh bằng bản ghi TXT), rồi gửi `https://shiba-auto.com/sitemap.xml`.
- Làm tương tự với [Bing Webmaster Tools](https://www.bing.com/webmasters) (có thể nhập thẳng từ Search Console).

Các file PNG trong repo không bắt buộc phải lên hosting — thiếu chúng thì trang vẫn chạy, chỉ mất icon khi lưu ra màn hình chính iPhone. Riêng `apple-touch-icon.png` và `shiba-icon-512.png` (ảnh share link) nên để cùng cấp với `index.html`.
