cmd.exe /c "aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 337059792605.dkr.ecr.eu-west-1.amazonaws.com"
docker build -t legacyapp/web:latest .
docker tag legacyapp/web:latest 337059792605.dkr.ecr.eu-west-1.amazonaws.com/legacyapp:latest
docker push 337059792605.dkr.ecr.eu-west-1.amazonaws.com/legacyapp:latest
# aws ecs update-service --cluster legacyapp --service legacyapp-service --force-new-deployment --region eu-west-1