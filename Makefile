cluster:
	minikube start
	minikube addons enable metrics-server
	minikube dashboard

deploy: service-lb
	minikube tunnel											# Creating network to connect to load balancing services

service-lb: deployment
	kubectl apply -f ./resource-manifest/service-lb.yaml	# Create the LoadBalancer service

deployment: hpa
	kubectl apply -f ./resource-manifest/deployment.yaml	# Create the Deployment

hpa:
	kubectl apply -f ./resource-manifest/hpa.yaml			# Create the Horizontal Pod Autoscaler

load:
	hey -z 300s -c 1000 http://localhost:8080
