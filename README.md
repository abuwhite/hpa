# Решение тестового задания — Mindbox

<details>
  <summary>YAML-описание — Deployment</summary>
    
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 2   # -------------------------------------------------- # 1
  minReadySeconds: 15
  strategy:
    type: RollingUpdate   # ---------------------------------------- # 2
    rollingUpdate:
      maxUnavailable: 1   # ---------------------------------------- # 3
      maxSurge: 1   # ---------------------------------------------- # 4
  selector:
    matchLabels:
      app: app
  template:   # ---------------------------------------------------- # 5
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
          limits:   # ---------------------------------------------- # 6
            cpu: "1"                                            
            memory: "128Mi"                                     
          requests:   # -------------------------------------------- # 7
            cpu: "0.1"
            memory: "128Mi"
```

1. **Replicas** — запускается с 2 экземплярами подов.
2. **RollingUpdate** — стратегия обеспечивает нулевое время простоя системы при обновлении.
3. **MaxUnavailable** — значение этого свойства указывает на то, что после завершения работы одного пода ещё один будет выполняться, что делает приложение доступным в ходе обновления.
4. **MaxSurge** — при переходе на новую версию программы, мы можем добавить в кластер ещё один под, что приведёт к тому, что у нас могут быть одновременно запущены до трёх подов.
5. **Template** — объект задаёт шаблон пода, который описываемый ресурс Deployment будет использовать для создания новых подов. 
6. **Limits** — установка лимита памяти и CPU.
7. **Requests** — установка запроса памяти и CPU.
</details>

<details>
  <summary>YAML-описание — LoadBalancer</summary>
    
```yaml
apiVersion: v1
kind: Service
metadata:
  name: app-service-lb
spec:
  selector:
    app: app  # ---------------------------------------------------- # 1
  ports:
  - protocol: TCP # ------------------------------------------------ # 2
    port: 8080  # -------------------------------------------------- # 3
    targetPort: 5000  # -------------------------------------------- # 4
  type: LoadBalancer  # -------------------------------------------- # 5

```

1. **Selector** — объект, содержащий сведения о том, с какими подами должен работать сервис.
2. **Protocol** — протокол, используемый сервисом.
3. **Port** — порт, по которому сервис принимает запросы.
4. **TargetPort** — порт, на который перенаправляются входящие запросы.
5. **Type** — тип ресурса для балансировки нагрузки между подами.
</details>

<details>
  <summary>YAML-описание — Horizontal Pod Autoscaler</summary>
    
```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: app
  minReplicas: 1  # ------------------------------------------------- # 1
  maxReplicas: 10 # ------------------------------------------------- # 2
  targetCPUUtilizationPercentage: 30  # ----------------------------- # 3
```

1. **minReplicas** — минимальное количество реплик.
2. **maxReplicas** — максимальное количество реплик.
3. **targetCPUUtilizationPercentage** — средняя загрузка CPU, если нагрузка превысит 30%, то модуль будет масштабироваться.
</details>

## Начало работы

Используйте [Minikube](https://minikube.sigs.k8s.io/docs/start/) для запуска кластера.

1. Запустите кластер
```bash
$ make cluster
```

2. Запустите развёртывание и сервис балансировки
```shell
$ make deploy
```

## Использование

```shell
# возвращается 'Hello, Mindbox :)'
$ curl localhost:8080
```

Запустите нагрузочный тест для проверки масштабирования:
```sh
$ make load
```