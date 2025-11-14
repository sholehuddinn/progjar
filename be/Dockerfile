# Gunakan image Node.js resmi sebagai base
FROM node:18-alpine

# Tentukan working directory di dalam container
WORKDIR /usr/src/app

# Salin file package.json dan package-lock.json terlebih dahulu
COPY package*.json ./

# Jalankan npm install untuk menginstal dependencies
RUN npm install

# Salin seluruh kode aplikasi ke dalam container
COPY . .

# Ekspos port aplikasi (sesuai dengan yang digunakan Express)
EXPOSE 5173

# Jalankan perintah untuk memulai aplikasi
CMD ["node", "app.js"]
