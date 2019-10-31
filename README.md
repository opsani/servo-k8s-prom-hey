# Optune Servo with Kubernetes (adjust), 'Hey' (load generator) and Prometheus (measure) drivers

## Build servo container
```
docker build . -t example.com/servo-k8s-prom-hey
```

## --- Running servo as a Deployment within the application namespace

WIP

> The `OPTUNE_USE_DEFAULT_NAMESPACE` environment variable set to `1` is used when the servo is embedded in the application itself (e.g., runs as a pod within the same namespace); this allows the namespace to be different from the `app_id` given to the servo.

## --- Running servo outside of the application namespace/cluster

WIP

Notes:
- `app_id` has to match the namespace
- if not running on the same cluster, map `/root/.kube/config` into the servo filesystem

## --- Running servo as a Docker service

### Create a docker secret with your authentication token
```
echo -n 'myToken'|docker secret create optune_auth_token -
```

### Run Servo (as a docker service)
This will will pass your k8s config file to the servo container and will use the default cluster that is configured in the config file. The servo will optimize all `deployment` objects in the namespace provided in the command (`app1` in this example). This expects `/root/.kube/config` to exist on the node where the servo is running and have access to the k8s cluster.

```
docker service create -t --name optune-servo \
    --secret optune_auth_token \
    --mount type=bind,source=/root/.kube/config,destination=/root/.kube/config \
    example.com/servo-k8s-prom-hey \
    app1 --account myAccount
```

If you named your docker secret anything other than `optune_auth_token`, then specify the path to it:
```
docker service create -t --name optune-servo \
    --secret acme-app1-auth \
    -v /root/.kube/config:/root/.kube/config \
    example.com/servo-k8s-prom-hey \
    app1 --account myAccount  --auth-token /run/secrets/acme-app1-auth
```

