# start.ps1
Write-Host "=== Iniciando stack con Docker Compose ==="

# 1. Comprobar si Docker Desktop está corriendo
$dockerProcess = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue

if (-not $dockerProcess) {
    Write-Host "Docker Desktop no está corriendo. Iniciando..."
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    Start-Sleep -Seconds 10
}

# 2. Esperar a que Docker Engine esté disponible
$maxRetries = 30
$retry = 0
while ($retry -lt $maxRetries) {
    try {
        docker version | Out-Null
        Write-Host "Docker Engine está listo ✅"
        break
    } catch {
        Write-Host "Esperando a que Docker Engine arranque... ($retry/$maxRetries)"
        Start-Sleep -Seconds 5
        $retry++
    }
}

if ($retry -eq $maxRetries) {
    Write-Error "Docker Engine no se pudo iniciar. Revisa Docker Desktop."
    exit 1
}

# 3. Levantar el stack
Write-Host "Parando contenedores previos..."
docker-compose down -v

Write-Host "Construyendo imágenes..."
docker-compose build

Write-Host "Levantando servicios..."
docker-compose up -d

Write-Host "=== Stack levantado con éxito 🚀 ==="
