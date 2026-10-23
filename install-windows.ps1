# MiroFish (fork) - installer Windows (Gemini gratis atau Claude Haiku)
# Cara pakai (PowerShell, di folder repo ini):
#   powershell -ExecutionPolicy Bypass -File .\install-windows.ps1

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

function Show-DataWarning {
    Write-Host ''
    Write-Host '==================== PERINGATAN DATA ====================' -ForegroundColor Red
    Write-Host ' Semua file yang diunggah ke MiroFish dikirim ke penyedia AI' -ForegroundColor Red
    Write-Host ' (Google Gemini atau Anthropic Claude) dan Zep Cloud.' -ForegroundColor Red
    Write-Host ' JANGAN unggah dokumen dinas, bahan perkara, atau data pribadi.' -ForegroundColor Red
    Write-Host '=========================================================' -ForegroundColor Red
    Write-Host ''
}

function Test-Cmd($name) { [bool](Get-Command $name -ErrorAction SilentlyContinue) }

function Update-PathFromRegistry {
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
                [Environment]::GetEnvironmentVariable('Path', 'User')
}

function Install-IfMissing($cmd, $wingetId) {
    if (Test-Cmd $cmd) { Write-Host "[ok] $cmd sudah terpasang"; return }
    if (-not (Test-Cmd 'winget')) { throw "$cmd belum terpasang dan winget tidak tersedia. Pasang $wingetId secara manual." }
    Write-Host "[..] memasang $wingetId"
    winget install --id $wingetId -e --accept-source-agreements --accept-package-agreements
    Update-PathFromRegistry
    if (-not (Test-Cmd $cmd)) { throw "$cmd masih belum terdeteksi. Tutup PowerShell, buka lagi, lalu jalankan ulang script ini." }
}

function Read-Secret($prompt) {
    $secure = Read-Host -Prompt $prompt -AsSecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
}

Show-DataWarning

# 1. Prasyarat
Install-IfMissing 'node' 'OpenJS.NodeJS.LTS'
Install-IfMissing 'uv'   'astral-sh.uv'
# Python 3.12 diunduh oleh uv sendiri sesuai pyproject backend, tidak perlu dipasang terpisah.

# 2. File .env (kunci API diketik tersembunyi, tidak tampil di layar)
if (Test-Path '.env') {
    Write-Host '[ok] .env sudah ada, tidak ditimpa. Hapus .env lalu jalankan ulang kalau mau mengisi ulang kunci.'
} else {
    Write-Host 'Pilih penyedia AI:'
    Write-Host '  1. Google Gemini 3.5 Flash-Lite (gratis, kuota harian kecil; data tier gratis bisa dipakai Google)'
    Write-Host '  2. Anthropic Claude Haiku (berbayar)'
    $choice = Read-Host 'Ketik 1 atau 2'
    switch ($choice) {
        '1' {
            $llmKey  = Read-Secret 'Kunci API Gemini (dari aistudio.google.com)'
            $baseUrl = 'https://generativelanguage.googleapis.com/v1beta/openai/'
            $model   = 'gemini-3.5-flash-lite'
        }
        '2' {
            $llmKey  = Read-Secret 'Kunci API Anthropic (sk-ant-..., dari console.anthropic.com)'
            $baseUrl = 'https://api.anthropic.com/v1/'
            $model   = 'claude-haiku-5-5'
        }
        default { throw 'Pilihan harus 1 atau 2.' }
    }
    $zepKey = Read-Secret 'Kunci API Zep Cloud (dari app.getzep.com)'
    if (-not $llmKey -or -not $zepKey) { throw 'Kunci API tidak boleh kosong.' }

    $envText = @"
LLM_API_KEY=$llmKey
LLM_BASE_URL=$baseUrl
LLM_MODEL_NAME=$model
ZEP_API_KEY=$zepKey
FLASK_HOST=127.0.0.1
"@
    # UTF-8 tanpa BOM supaya dibaca benar oleh python-dotenv
    [IO.File]::WriteAllText((Join-Path $PSScriptRoot '.env'), $envText, (New-Object Text.UTF8Encoding($false)))
    Write-Host "[ok] .env dibuat ($model, akses hanya dari komputer ini)"
}

# 3. Dependensi
Write-Host '[..] memasang dependensi (beberapa menit)'
npm run setup:all
if ($LASTEXITCODE -ne 0) { throw 'npm run setup:all gagal. Lihat pesan error di atas.' }

Write-Host ''
Write-Host '[selesai] Jalankan MiroFish dengan dobel-klik start-mirofish.bat' -ForegroundColor Green
Show-DataWarning
