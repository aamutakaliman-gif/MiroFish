# MiroFish (fork) — catatan untuk Claude Code

Fork ini memakai Claude Haiku lewat endpoint Anthropic yang kompatibel dengan OpenAI
(`LLM_BASE_URL=https://api.anthropic.com/v1/`, `LLM_MODEL_NAME=claude-haiku-5-5`).
Untuk model Claude, `backend/app/utils/openai_chat_compat.py` tidak mengirim `temperature`
(ditolak di bawah 1) dan memberi `max_tokens` bawaan 8192.

## WAJIB: pengingat keamanan data

Pemilik repo meminta selalu diingatkan. Setiap sesi:

1. Di balasan PERTAMA sesi, tampilkan satu baris:
   "⚠ Pengingat: bahan yang diunggah ke MiroFish atau ditempel ke Claude dikirim ke Anthropic dan Zep Cloud. Jangan pakai dokumen dinas, bahan perkara, atau data pribadi."
2. Sebelum membaca, menyalin, mengunggah, atau mengirim file seed/bahan apa pun ke MiroFish
   (termasuk lewat API backend port 5001), sebutkan nama filenya dan minta konfirmasi dulu.
   Kalau nama atau isinya mengarah ke dokumen dinas, perkara, atau data pribadi, tolak dan beri tahu pemilik.
3. Jangan pernah menampilkan isi `.env` (berisi kunci API) dan jangan commit `.env`.

## Menjalankan

- Pemasangan Windows: `powershell -ExecutionPolicy Bypass -File .\install-windows.ps1`
- Menjalankan: `start-mirofish.bat` (atau `npm run dev`), buka http://localhost:3000
- Tes backend: `cd backend && uv run pytest -q`
- Mulai simulasi kecil (di bawah 40 ronde) karena biaya token besar.
