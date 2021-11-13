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
	kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://app-service-lb:8080; done"
