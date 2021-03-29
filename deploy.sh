#Build the docker images
docker build -t swintonp/multi-client:latest -t swintonp/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t swintonp/multi-server:latest -t swintonp/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t swintonp/multi-worker:latest -t swintonp/multi-worker:$SHA -f ./worker/Dockerfile ./worker
#Push the newly built images to docker.hub (or local cache)
docker push swintonp/multi-client:latest 
docker push swintonp/multi-server:latest 
docker push swintonp/multi-worker:latest 
docker push swintonp/multi-client:$SHA 
docker push swintonp/multi-server:$SHA 
docker push swintonp/multi-worker:$SHA 
#Apply all of the Kubernetes config files to kubernetes
kubectl apply -f k8s
#Set an image for the deployment to use (you have to make sure it picks up the different version)
kubectl set image deployments/server-deployment server=swintonp/multi-server:$SHA
kubectl set image deployments/client-deployment client=swintonp/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=swintonp/multi-worker:$SHA
