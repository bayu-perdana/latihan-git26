from flask import Flask, render_template, request, jsonify, session, redirect, url_for
import mysql.connector
import os

app = Flask(__name__)
app.secret_key = 'kunci_rahasia_sangat_aman'

# Konfigurasi Koneksi Database MySQL

def get_db_connection():
    connection = mysql.connector.connect(
        host=os.environ.get('DB_HOST', 'localhost'),
        user=os.environ.get('DB_USER', 'root'),
        password=os.environ.get('DB_PASSWORD', ''),
        database=os.environ.get('DB_NAME', 'retail_db')
    )
    return connection

# Halaman Utama
@app.route('/')
def index():
    return render_template('index.html')

# Proses Login
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data.get('username')
    password = data.get('password')

    if username == 'admin' and password == '12345':
        session['user'] = username
        return jsonify({'success': True})
    else:
        return jsonify({'success': False, 'message': 'Username atau password salah!'})

# Proses Logout
@app.route('/logout', methods=['POST', 'GET'])
def logout():
    session.pop('user', None)
    return jsonify({'success': True})

# Endpoint API: Mengambil semua data dari MySQL untuk Frontend
@app.route('/api/data', methods=['GET'])
def get_data():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM pelanggan")
    pelanggan = cursor.fetchall()

    cursor.execute("SELECT * FROM produk")
    produk = cursor.fetchall()

    cursor.execute("SELECT * FROM pesanan")
    pesanan = cursor.fetchall()

    cursor.execute("SELECT * FROM detail_pesanan")
    detail_pesanan = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify({
        'pelanggan': pelanggan,
        'produk': produk,
        'pesanan': pesanan,
        'detail_pesanan': detail_pesanan
    })

# --- CRUD PELANGGAN ---
@app.route('/api/pelanggan', methods=['POST'])
def add_pelanggan():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO pelanggan (nama_pelanggan, email, telepon, kota) VALUES (%s, %s, %s, %s)",
                   (data.get('nama_pelanggan'), data.get('email'), data.get('telepon'), data.get('kota')))
    conn.commit()
    new_id = cursor.lastrowid
    cursor.close()
    conn.close()
    return jsonify({'success': True, 'id_pelanggan': new_id})

@app.route('/api/pelanggan/<int:id>', methods=['PUT'])
def update_pelanggan(id):
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE pelanggan SET nama_pelanggan=%s, email=%s, telepon=%s, kota=%s WHERE id_pelanggan=%s",
                   (data.get('nama_pelanggan'), data.get('email'), data.get('telepon'), data.get('kota'), id))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'success': True})

@app.route('/api/pelanggan/<int:id>', methods=['DELETE'])
def delete_pelanggan(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM pelanggan WHERE id_pelanggan=%s", (id,))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'success': True})

# --- CRUD PRODUK & STOK ---
@app.route('/api/produk', methods=['POST'])
def add_produk():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO produk (nama_produk, kategori, harga, stok) VALUES (%s, %s, %s, %s)",
                   (data.get('nama_produk'), data.get('kategori'), data.get('harga'), data.get('stok')))
    conn.commit()
    new_id = cursor.lastrowid
    cursor.close()
    conn.close()
    return jsonify({'success': True, 'id_produk': new_id})

@app.route('/api/produk/<int:id>', methods=['PUT'])
def update_produk(id):
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE produk SET nama_produk=%s, kategori=%s, harga=%s, stok=%s WHERE id_produk=%s",
                   (data.get('nama_produk'), data.get('kategori'), data.get('harga'), data.get('stok'), id))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'success': True})

@app.route('/api/produk/<int:id>/stok', methods=['PUT'])
def update_stok(id):
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE produk SET stok=%s WHERE id_produk=%s", (data.get('stok'), id))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'success': True})

@app.route('/api/produk/<int:id>', methods=['DELETE'])
def delete_produk(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM produk WHERE id_produk=%s", (id,))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'success': True})

# Endpoint API: Checkout Transaksi POS & Potong Stok MySQL
@app.route('/api/checkout', methods=['POST'])
def checkout():
    data = request.json
    id_pelanggan = data.get('id_pelanggan')
    cart = data.get('cart')
    total_harga = sum(item['subtotal'] for item in cart)

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        query_pesanan = "INSERT INTO pesanan (id_pelanggan, tanggal_pesan, total_harga) VALUES (%s, CURDATE(), %s)"
        cursor.execute(query_pesanan, (id_pelanggan, total_harga))
        id_pesanan_baru = cursor.lastrowid

        for item in cart:
            query_detail = "INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, subtotal) VALUES (%s, %s, %s, %s)"
            cursor.execute(query_detail, (id_pesanan_baru, item['id_produk'], item['jumlah'], item['subtotal']))

            query_stok = "UPDATE produk SET stok = stok - %s WHERE id_produk = %s"
            cursor.execute(query_stok, (item['jumlah'], item['id_produk']))

        conn.commit()
        response = {'success': True, 'id_pesanan': id_pesanan_baru}
    except Exception as e:
        conn.rollback()
        response = {'success': False, 'message': str(e)}
    finally:
        cursor.close()
        conn.close()

    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True)