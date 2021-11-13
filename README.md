# Test Mindbox

YAML-описание ресурса Deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 2 # -------------------------------------------------- # 1
  minReadySeconds: 15
  strategy:
    type: RollingUpdate # ----------------------------------------- # 2
    rollingUpdate:
      maxUnavailable: 1 # ----------------------------------------- # 3
      maxSurge: 1 # ----------------------------------------------- # 4
  selector:
    matchLabels:
      app: app
  template: # ----------------------------------------------------- # 5
    metadata:
      labels:
        app: app
    spec:
      containers:
      - name: app
        image: znhv/app:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 5000
        resources:
          limits: # ----------------------------------------------- # 6
            cpu: "1"                                            
            memory: "128Mi"                                     
          requests: # --------------------------------------------- # 7
            cpu: "0.1"
            memory: "128Mi"
```

1. **Replicas** Запускается с 2 экземплярами подов. Изначально запускается на 2 репликах.
2. **RollingUpdate** Стратегия RollingUpdate обеспечивает нулевое время простоя системы при обновлении.
3. **MaxUnavailable** В нашем развёртывании, подразумевающем наличие 2 реплик, значение этого свойства указывает на то, что после завершения работы одного пода ещё один будет выполняться, что делает приложение доступным в ходе обновления.
4. **MaxSurge** в нашем случае его значение, 1, означает, что, при переходе на новую версию программы, мы можем добавить в кластер ещё один под, что приведёт к тому, что у нас могут быть одновременно запущены до трёх подов.
5. **Template** объект задаёт шаблон пода, который описываемый ресурс Deployment будет использовать для создания новых подов. 
6. **Limits** лимит запроса памяти и CPU
7. **Requests** запрос памяти и CPU

## Getting Started

Use [Minikube](https://minikube.sigs.k8s.io/docs/start/) to start the cluster.

```bash
$ make cluster
```

Create a Deployment and Service.
```shell
$ make deploy
```

## Usage

```shell
# returns 'Hello, Mindbox :)'
$ curl localhost:8080
```

### Increase load

```sh
$ make load
```