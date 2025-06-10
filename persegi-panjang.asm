.data
    # Data untuk informasi kelompok
    info_kelompok:  .asciiz "Kelompok 4\nAsyifa Izayani Safari 1206230016\nMuhammad Pandu Prapyusta 1206230005\nFadiya Zahra Qatranada 1206230034\nFebycandra Carmelinda 1206230007\n"
    exit_msg:       .asciiz "\nUntuk keluar, masukkan 2002 sebagai panjang\n\n"
    
    # Pesan input
    msg_panjang:    .asciiz "Masukkan panjang (bilangan positif > 0): "
    msg_lebar:      .asciiz "Masukkan lebar (bilangan positif > 0): "
    
    # Pesan error
    error_negatif:  .asciiz "Error: Masukkan bilangan positif > 0!\n"
    error_sama:     .asciiz "Error: Panjang dan lebar tidak boleh sama!\n"
    
    # Pesan output
    msg_luas:       .asciiz "Luas persegi panjang: "
    msg_kategori:   .asciiz "Kategori: "
    kecil:          .asciiz "PERSEGI PANJANG KECIL\n"
    sedang:         .asciiz "PERSEGI PANJANG SEDANG\n"
    besar:          .asciiz "PERSEGI PANJANG BESAR\n"
    newline:        .asciiz "\n"

.text
.globl main

main:
    # Tampilkan info kelompok
    li $v0, 4
    la $a0, info_kelompok
    syscall
    
    # Tampilkan petunjuk keluar
    li $v0, 4
    la $a0, exit_msg
    syscall

program_loop:
    # === INPUT PANJANG ===
    # Tampilkan pesan input panjang
    li $v0, 4
    la $a0, msg_panjang
    syscall
    
    # Baca input panjang
    li $v0, 5
    syscall
    move $t0, $v0       # Simpan panjang di $t0
    
    # Cek jika input = 2002 (untuk keluar)
    li $t1, 2002
    beq $t0, $t1, exit
    
    # Validasi panjang > 0
    blez $t0, error_panjang_input
    j lebar_input
    
error_panjang_input:
    li $v0, 4
    la $a0, error_negatif
    syscall
    j program_loop

lebar_input:
    # === INPUT LEBAR ===
    # Tampilkan pesan input lebar
    li $v0, 4
    la $a0, msg_lebar
    syscall
    
    # Baca input lebar
    li $v0, 5
    syscall
    move $t1, $v0       # Simpan lebar di $t1
    
    # Validasi lebar > 0
    blez $t1, error_lebar_input
    
    # Validasi panjang != lebar
    beq $t0, $t1, error_sama_input
    j hitung_luas
    
error_lebar_input:
    li $v0, 4
    la $a0, error_negatif
    syscall
    j lebar_input
    
error_sama_input:
    li $v0, 4
    la $a0, error_sama
    syscall
    j lebar_input

hitung_luas:
    # === HITUNG LUAS ===
    # Hitung luas dengan penjumlahan berulang
    # $t0 = panjang, $t1 = lebar
    li $t2, 0           # inisialisasi hasil luas
    li $t3, 0           # counter
    
hitung_loop:
    beq $t3, $t1, tampilkan_hasil   # jika counter = lebar, selesai
    add $t2, $t2, $t0               # tambahkan panjang ke hasil
    addi $t3, $t3, 1                # increment counter
    j hitung_loop

tampilkan_hasil:
    # === TAMPILKAN HASIL ===
    # Tampilkan luas ($t2 berisi hasil luas)
    li $v0, 4
    la $a0, msg_luas
    syscall
    
    li $v0, 1
    move $a0, $t2
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Tampilkan kategori
    li $v0, 4
    la $a0, msg_kategori
    syscall
    
    # Tentukan kategori berdasarkan luas
    li $t4, 100         # batas kecil
    li $t5, 500         # batas besar
    
    blt $t2, $t4, kategori_kecil    # jika luas < 100
    bge $t2, $t5, kategori_besar    # jika luas >= 500
    
    # Kategori sedang (100 <= luas < 500)
    li $v0, 4
    la $a0, sedang
    syscall
    j selesai_tampil
    
kategori_kecil:
    li $v0, 4
    la $a0, kecil
    syscall
    j selesai_tampil
    
kategori_besar:
    li $v0, 4
    la $a0, besar
    syscall
    
selesai_tampil:
    # Tampilkan newline tambahan
    li $v0, 4
    la $a0, newline
    syscall
    
    # Ulangi program
    j program_loop

exit:
    # Keluar dari program
    li $v0, 10
    syscall