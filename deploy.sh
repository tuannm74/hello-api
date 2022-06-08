sudo docker pull $1:$2.$3
sudo docker stop hello-api
sudo docker rm hello-api 
sudo docker run --name hello-api -p 5000:5000 -d $1:$2.$3 
