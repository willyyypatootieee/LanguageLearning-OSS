# Modul Autentikasi

Modul ini menangani semua fitur autentikasi pada aplikasi BeLing, termasuk login, registrasi, dan manajemen sesi.

## Struktur Folder

```
auth/
├── auth.dart              # File export utama
├── constants/             # Konstanta untuk auth
├── controllers/           # Controller untuk logika auth
├── models/                # Model data untuk auth
├── screens/               # UI Screens (login, register)
├── services/              # Service untuk komunikasi dengan API
└── viewmodels/            # ViewModel untuk state management
```

## Cara Kerja

Modul ini menggunakan arsitektur MVVM (Model-View-ViewModel):
1. **Model**: Representasi data pengguna dan respons API
2. **View**: Tampilan UI seperti layar login dan registrasi
3. **ViewModel**: Mengelola state dan logika bisnis
4. **Service**: Menangani komunikasi dengan API
5. **Controller**: Menghubungkan ViewModel dengan Service

## API Endpoint

Aplikasi ini menggunakan API yang di-host di:
`https://beling-4ef8e653eda6.herokuapp.com`

Endpoint yang tersedia:
- `/api/auth/register` - Pendaftaran pengguna baru
- `/api/auth/login` - Login pengguna

## Penggunaan

1. **Login**:
   - Email/Username + Password
   - Menyimpan token untuk sesi berikutnya

2. **Registrasi**:
   - Username, Email, Password, dan Tanggal Lahir
   - Validasi input secara lokal sebelum mengirim ke server

3. **Pengelolaan Sesi**:
   - Menyimpan token di SharedPreferences
   - Auto login jika token masih valid
