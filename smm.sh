#!/bin/bash
echo "Script dijalankan dengan benar"

# Buat database
sqlite3 panel/database.db <<EOF
CREATE TABLE IF NOT EXISTS member (
  id INTEGER PRIMARY KEY,
  username TEXT,
  password TEXT,
  saldo REAL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS layanan (
  id INTEGER PRIMARY KEY,
  nama TEXT,
  harga REAL
);
CREATE TABLE IF NOT EXISTS orders (
  id INTEGER PRIMARY KEY,
  id_layanan INTEGER,
  jumlah INTEGER,
  total_harga REAL
);
CREATE TABLE IF NOT EXISTS pengaturan (
  id INTEGER PRIMARY KEY,
  api_key TEXT
);
INSERT OR IGNORE INTO member (id, username, password, saldo) VALUES (1, 'admin', 'password', 0);
INSERT OR IGNORE INTO layanan (id, nama, harga) VALUES (1, "Layanan 1", 1000);
INSERT OR IGNORE INTO layanan (id, nama, harga) VALUES (2, "Layanan 2", 2000);
EOF

echo "Database berhasil dibuat"

# Buat file index.php
cat > panel/index.php <<EOF
<?php
  // Konfigurasi
  \$DB_FILE = "database.db";
  \$API_KEY = "YOUR_YOUTUBE_API_KEY";

  // Fungsi login
  function login() {
    // Tampilkan form login
    echo "<form action='index.php' method='post'>";
    echo "<input type='text' name='username' placeholder='Username'>";
    echo "<input type='password' name='password' placeholder='Password'>";
    echo "<button type='submit'>Login</button>";
    echo "</form>";
  }

  // Fungsi dashboard
  function dashboard() {
    // Tampilkan menu dashboard
    echo "<h1>Dashboard</h1>";
    echo "<ul>";
    echo "<li><a href='layanan.php'>Layanan</a></li>";
    echo "<li><a href='order.php'>Order</a></li>";
    echo "<li><a href='member.php'>Member</a></li>";
    echo "<li><a href='saldo.php'>Saldo</a></li>";
    echo "<li><a href='pengaturan.php'>Pengaturan</a></li>";
    echo "</ul>";
  }

  // Main program
  if (isset(\$_POST['username']) && isset(\$_POST['password'])) {
    // Proses login
    \$username = \$_POST['username'];
    \$password = \$_POST['password'];
    // Ambil data member dari database
    \$db = new PDO("sqlite:database.db");
    \$stmt = \$db->prepare("SELECT * FROM member WHERE username = ? AND password = ?");
    \$stmt->execute(array(\$username, \$password));
    if (\$stmt->fetch()) {
      // Login berhasil, tampilkan dashboard
      dashboard();
    } else {
      // Login gagal, tampilkan pesan error
      echo "Login gagal!";
    }
  } else {
    // Tampilkan form login
    login();
  }
?>
EOF

echo "File index.php berhasil dibuat"

# Tampilkan daftar file di folder panel
ls -l panel
