# Как устроен `make deploy`

Проект развертывается на базе Kubernetes при помощи [Minikube](https://minikube.sigs.k8s.io/docs/start/).

## 1. HorizontalPodAutoscaler
Создается HorizontalPodAutoscaler с 2-я минимальными репликами и 
максимальными 10 репликами. С каждым разом увеличивая количество реплик,
когда поды требуют больше 50% ресурсов.

## 2. Deployment
Создается Deployment с контейнером и требуемыми ресурсами.

## 3. Service LoudBalancer
Создается Service LoudBalancer, которые будет гонять трафик.