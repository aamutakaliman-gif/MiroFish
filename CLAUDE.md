# MiroFish (fork) — catatan untuk Claude Code

Fork ini dipakai dengan endpoint yang kompatibel dengan OpenAI. Saat ini: Gemini 3.5 Flash-Lite
(tier gratis, `https://generativelanguage.googleapis.com/v1beta/openai/`). Rencana: pindah ke
Claude Haiku (`https://api.anthropic.com/v1/`, `claude-haiku-5-5`) setelah pemilik punya kunci API Anthropic.
Untuk model Claude, `backend/app/utils/openai_chat_compat.py` tidak mengirim `temperature`
(ditolak di bawah 1) dan memberi `max_tokens` bawaan 8192.

## WAJIB: pengingat keamanan data

Pemilik repo meminta selalu diingatkan. Setiap sesi:

1. Di balasan PERTAMA sesi, tampilkan satu baris:
   "⚠ Pengingat: bahan yang diunggah ke MiroFish atau ditempel ke Claude dikirim ke penyedia AI (Google/Anthropic) dan Zep Cloud. Jangan pakai dokumen dinas, bahan perkara, atau data pribadi."
2. Sebelum membaca, menyalin, mengunggah, atau mengirim file seed/bahan apa pun ke MiroFish
   (termasuk lewat API backend port 5001), sebutkan nama filenya dan minta konfirmasi dulu.
   Kalau nama atau isinya mengarah ke dokumen dinas, perkara, atau data pribadi, tolak dan beri tahu pemilik.
3. Jangan pernah menampilkan isi `.env` (berisi kunci API) dan jangan commit `.env`.

## WAJIB: setiap perubahan disinkronkan ke GitHub

Pemilik repo minta semua perubahan kode selalu ter-update ke GitHub (`origin` = github.com/aamutakaliman-gif/MiroFish, branch `main`).

1. Di awal sesi, jalankan `git pull --ff-only origin main` supaya mulai dari versi terbaru.
2. Setelah selesai mengubah file apa pun di repo ini: jalankan tes yang relevan (`cd backend && uv run pytest -q`), lalu
   `git add` file yang diubah saja, `git commit` dengan pesan yang jelas, dan `git push origin main`. Laporkan hash commit-nya.
3. JANGAN commit `.env`, bahan simulasi/unggahan, folder `backend/uploads`, hasil simulasi, atau laporan — hanya kode, konfigurasi contoh, dan dokumentasi.
4. Kalau push gagal karena belum login GitHub, minta pemilik login lewat jendela Git Credential Manager yang muncul, lalu ulangi push.

## Menjalankan

- Pemasangan Windows: `powershell -ExecutionPolicy Bypass -File .\install-windows.ps1`
- Menjalankan: `start-mirofish.bat` (atau `npm run dev`), buka http://localhost:3000
- Tes backend: `cd backend && uv run pytest -q`
- Mulai simulasi kecil (di bawah 40 ronde) karena biaya token besar.

## Mengoperasikan MiroFish lewat API (backend http://localhost:5001)

Pastikan `start-mirofish.bat` sedang jalan. Alur penuh (aturan pengingat data di atas tetap berlaku):

1. `POST /api/graph/ontology/generate` (multipart): `files` (PDF/MD/TXT), `simulation_requirement`, `project_name` → dapat `project_id`.
2. `POST /api/graph/build` JSON `{"project_id"}` → pantau `GET /api/graph/task/<task_id>`.
3. `POST /api/simulation/create` JSON `{"project_id"}` → dapat `simulation_id`.
4. `POST /api/simulation/prepare` JSON `{"simulation_id"}` → pantau `POST /api/simulation/prepare/status`.
5. `POST /api/simulation/start` JSON `{"simulation_id", "max_rounds": 5}` — selalu pakai `max_rounds` kecil (kuota Gemini gratis); pantau `GET /api/simulation/<id>/run-status`.
6. `POST /api/report/generate` JSON `{"simulation_id"}` → pantau `POST /api/report/generate/status`, baca `GET /api/report/<report_id>`.
7. Tanya-jawab: `POST /api/report/chat`, wawancara agen: `POST /api/simulation/interview`.

Detail parameter: baca `backend/app/api/graph.py`, `simulation.py`, `report.py` sebelum memanggil.
Daftar proyek/simulasi yang ada: `GET /api/graph/project/list`, `GET /api/simulation/list`, `GET /api/report/list`.
