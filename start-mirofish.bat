@echo off
cd /d "%~dp0"
color 0C
echo.
echo ==================== PERINGATAN DATA ====================
echo  Semua file yang diunggah ke MiroFish dikirim ke server
echo  Anthropic (Claude) dan Zep Cloud.
echo  JANGAN unggah dokumen dinas, bahan perkara, atau data pribadi.
echo =========================================================
echo.
pause
color 07
start "" http://localhost:3000
npm run dev
