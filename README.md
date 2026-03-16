# 🏥 HealthRecord App
### Aplikasi Manajemen Riwayat Kesehatan Pribadi

---

## 📖 Deskripsi Aplikasi

**HealthRecord** adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna mencatat dan mengelola riwayat kesehatan pribadi secara digital, aman, dan terorganisir. Dengan aplikasi ini, pengguna tidak perlu lagi menyimpan catatan kesehatan secara manual — semua data tersimpan di cloud menggunakan **Supabase** dan dapat diakses kapan saja.

Setiap pengguna memiliki akun pribadi sehingga data riwayat kesehatannya bersifat **privat dan tidak dapat diakses oleh pengguna lain**. Aplikasi ini hadir dengan tampilan yang bersih, modern, dan mendukung **Light Mode maupun Dark Mode** agar nyaman digunakan kapan saja — baik siang maupun malam hari.

---

## ✨ Fitur Aplikasi

### 🔐 Autentikasi Pengguna
Aplikasi dilengkapi dengan sistem **Login dan Register** menggunakan Supabase. Pengguna cukup mendaftar dengan email dan password, lalu dapat langsung masuk ke dalam aplikasi. Sesi login tersimpan otomatis sehingga pengguna tidak perlu login ulang setiap membuka aplikasi.
Berikut tampilan aplikasinya:

https://github.com/Manisha-05caw/minpro_pab2/blob/minpro/img/Screenshot%202026-03-15%20181525.png?raw=true (login)

https://github.com/Manisha-05caw/minpro_pab2/blob/minpro/img/Screenshot%202026-03-15%20181638.png?raw=true (register)


### 🏠 Dashboard Utama
Halaman utama menampilkan **ringkasan data kesehatan** pengguna, termasuk total riwayat yang sudah tercatat. Dari sini pengguna dapat dengan cepat menuju halaman daftar riwayat atau langsung menambah data baru. Tersedia juga tombol toggle untuk berpindah antara **Light Mode dan Dark Mode**.

### 📋 Manajemen Riwayat Kesehatan (CRUD)
Pengguna dapat melakukan pengelolaan data riwayat kesehatan secara lengkap:
- **Tambah** — mencatat riwayat kesehatan baru dengan mengisi form lengkap
  
  link img : https://github.com/Manisha-05caw/minpro_pab2/blob/minpro/img/Screenshot%202026-03-15%20181353.png?raw=true

- **Lihat** — menampilkan seluruh daftar riwayat dalam tampilan card yang informatif

link img : https://github.com/Manisha-05caw/minpro_pab2/blob/minpro/img/Screenshot%202026-03-15%20181443.png?raw=true
  
- **Edit** — memperbarui data riwayat yang sudah ada

  link img : https://github.com/Manisha-05caw/minpro_pab2/blob/minpro/img/Screenshot%202026-03-15%20181304.png?raw=true
  
- **Hapus** — menghapus data dengan konfirmasi dialog agar tidak terjadi penghapusan tidak sengaja

### 📝 Form Input Lengkap & Tervalidasi
Form pencatatan riwayat kesehatan terdiri dari:
- **Tanggal Pemeriksaan** — dipilih menggunakan date picker kalender
- **Nama Dokter / Faskes** — dilengkapi fitur dropdown dengan saran nama dokter dan fasilitas kesehatan (Puskesmas, RS Umum, berbagai spesialis)
- **Diagnosis** — hasil diagnosis dari dokter
- **Obat yang Diresepkan** — daftar obat yang diberikan
- **Tekanan Darah** — input sistolik dan diastolik secara terpisah, dan hanya menerima angka.
- **Berat & Tinggi Badan** — dua field terpisah, ini juga hanya menerima angka
- **Catatan Tambahan** — catatan bebas dari dokter.

### 🌙 Light Mode & Dark Mode
Pengguna dapat beralih antara tampilan terang dan gelap kapan saja melalui tombol toggle di halaman utama maupun ikon di AppBar. Perubahan tema berlaku secara instan di seluruh halaman aplikasi.

link img : https://github.com/Manisha-05caw/minpro_pab2/blob/minpro/img/Screenshot%202026-03-15%20181158.png?raw=true

https://github.com/Manisha-05caw/minpro_pab2/blob/minpro/img/Screenshot%202026-03-15%20181222.png?raw=true


### ☁️ Penyimpanan Cloud (Supabase)
Seluruh data riwayat kesehatan disimpan secara aman di database **Supabase** dengan fitur Row Level Security (RLS), memastikan setiap pengguna hanya dapat mengakses data miliknya sendiri.

---

## 🖼️ Tampilan Aplikasi

| Halaman | Keterangan |
|---------|-----------|
| **Login** | Halaman masuk dengan email & password, tersedia link ke halaman Register |
| **Register** | Halaman daftar akun baru dengan konfirmasi password |
| **Dashboard** | Ringkasan total data, menu utama, dan toggle dark mode |
| **List Riwayat** | Daftar semua riwayat kesehatan dalam bentuk card |
| **Form Tambah/Edit** | Form lengkap dengan validasi dan autocomplete dokter |
| **Detail Riwayat** | Tampilan lengkap satu data dengan tombol edit dan hapus |

---

## 🧩 Widget yang Digunakan

### Struktur & Layout
| Widget | Kegunaan |
|--------|---------|
| `MaterialApp` | Root widget aplikasi dengan pengaturan tema global |
| `Scaffold` | Struktur dasar setiap halaman |
| `AppBar` | Navigasi atas dengan judul dan tombol aksi |
| `CustomScrollView` + `SliverAppBar` | Efek AppBar yang dapat diperluas di Dashboard |
| `Column`, `Row` | Susunan elemen vertikal dan horizontal |
| `Expanded`, `SizedBox` | Proporsi ruang dan jarak antar elemen |
| `SingleChildScrollView` | Konten yang dapat di-scroll |
| `Container` | Kustomisasi tampilan dengan warna, border, dan radius |
| `SafeArea` | Menghindari area notch dan status bar |

### Input & Form
| Widget | Kegunaan |
|--------|---------|
| `Form` + `GlobalKey<FormState>` | Manajemen dan validasi form secara terpusat |
| `TextFormField` | Input teks dengan label, hint, ikon, dan validasi |
| `Autocomplete` | Dropdown saran nama dokter/faskes saat mengetik |
| `FilteringTextInputFormatter` | Membatasi input hanya angka pada field vital |
| `LengthLimitingTextInputFormatter` | Membatasi jumlah karakter yang dapat diinput |
| `showDatePicker` | Kalender untuk memilih tanggal pemeriksaan |

### Tombol & Navigasi
| Widget | Kegunaan |
|--------|---------|
| `ElevatedButton` | Tombol utama (Masuk, Daftar, Simpan) |
| `OutlinedButton` | Tombol hapus dengan border merah |
| `TextButton` | Tombol sekunder (Batal) |
| `IconButton` | Tombol ikon di AppBar (edit, hapus, tema, logout) |
| `FloatingActionButton.extended` | Tombol tambah data di halaman list |
| `Switch` | Toggle untuk berpindah Light/Dark Mode |
| `GestureDetector` | Area klik pada teks link (Daftar/Masuk di sini) |

### Dialog & Notifikasi
| Widget | Kegunaan |
|--------|---------|
| `AlertDialog` | Konfirmasi sebelum hapus data atau logout |
| `SnackBar` | Notifikasi floating saat aksi berhasil atau gagal |
| `CircularProgressIndicator` | Indikator loading saat proses berlangsung |

### State Management & Tema
| Widget | Kegunaan |
|--------|---------|
| `Provider` + `ChangeNotifier` | Manajemen state untuk tema Light/Dark Mode |
| `context.watch<ThemeProvider>()` | Subscribe perubahan tema secara real-time |

---

## 🛠️ Tools yang Digunakan

| Tools | Kegunaan |
|-----------|---------|
| **Flutter** | Framework utama pengembangan aplikasi mobile |
| **Dart** | Bahasa pemrograman |
| **Supabase** | Backend as a Service — database dan autentikasi |
| **Provider** | State management untuk tema aplikasi |
