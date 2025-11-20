# Test local Docker deployment
Write-Host "🧪 Testing Local Docker Deployment" -ForegroundColor Cyan

# Build image
Write-Host "`n📦 Building Docker image..." -ForegroundColor Yellow
docker build -t edulearn-test:latest .

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Build successful" -ForegroundColor Green

# Run container
Write-Host "`n🚀 Starting container..." -ForegroundColor Yellow
docker run -d -p 8080:80 --name edulearn-test edulearn-test:latest

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Container start failed" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Container started" -ForegroundColor Green

# Wait for app to start
Write-Host "`n⏳ Waiting for app to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Test endpoint
Write-Host "`n🔍 Testing application..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Application is responding!" -ForegroundColor Green
        Write-Host "`n🎉 Local deployment test PASSED" -ForegroundColor Green
        Write-Host "`nOpen browser: http://localhost:8080" -ForegroundColor Cyan
    }
} catch {
    Write-Host "❌ Application not responding" -ForegroundColor Red
}

# Show logs
Write-Host "`n📋 Container logs:" -ForegroundColor Yellow
docker logs edulearn-test

Write-Host "`n🧹 Cleanup:" -ForegroundColor Yellow
Write-Host "To stop: docker stop edulearn-test" -ForegroundColor Gray
Write-Host "To remove: docker rm edulearn-test" -ForegroundColor Gray
