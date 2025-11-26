# Direct deployment to EC2 without ECR
$EC2_IP = "16.171.136.183"
$KEY_FILE = "edu-access.pem"

Write-Host "🚀 Direct Deployment to EC2" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Green

# Check if key file exists
if (!(Test-Path $KEY_FILE)) {
    Write-Host "❌ Key file not found: $KEY_FILE" -ForegroundColor Red
    Write-Host "Please place edu-access.pem in the current directory" -ForegroundColor Yellow
    exit 1
}

# Build Docker image
Write-Host "`n📦 Building Docker image..." -ForegroundColor Cyan
docker build -t edulearn:latest .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed" -ForegroundColor Red
    exit 1
}

# Save image to tar
Write-Host "`n💾 Saving image to tar file..." -ForegroundColor Cyan
docker save edulearn:latest -o edulearn.tar
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Save failed" -ForegroundColor Red
    exit 1
}

# Copy to EC2
Write-Host "`n📤 Copying image to EC2..." -ForegroundColor Cyan
scp -i $KEY_FILE -o StrictHostKeyChecking=no edulearn.tar ubuntu@${EC2_IP}:~/
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Copy failed" -ForegroundColor Red
    exit 1
}

# Deploy on EC2
Write-Host "`n🚀 Deploying on EC2..." -ForegroundColor Cyan
ssh -i $KEY_FILE -o StrictHostKeyChecking=no ubuntu@$EC2_IP @"
    # Load image
    sudo docker load -i ~/edulearn.tar
    
    # Stop existing container
    sudo docker stop edulearn 2>/dev/null || true
    sudo docker rm edulearn 2>/dev/null || true
    
    # Run new container
    sudo docker run -d --name edulearn -p 80:80 --restart unless-stopped edulearn:latest
    
    # Show status
    echo ""
    echo "Container status:"
    sudo docker ps | grep edulearn
    
    # Cleanup
    rm ~/edulearn.tar
"@

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Deployment successful!" -ForegroundColor Green
    Write-Host "`n🌐 Application URL: http://$EC2_IP" -ForegroundColor Cyan
    Write-Host "`nTest it: curl http://$EC2_IP" -ForegroundColor Yellow
} else {
    Write-Host "`n❌ Deployment failed" -ForegroundColor Red
}

# Cleanup local tar
Remove-Item edulearn.tar -ErrorAction SilentlyContinue
