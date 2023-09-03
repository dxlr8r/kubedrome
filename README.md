# kubedrome

A simple wrapper to adopt [Navidrome](https://www.navidrome.org/) to Kubernetes using [tanka-compose](https://github.com/dxlr8r/tanka_compose).

## Install

First you need to clone this repository:

```sh
git clone https://github.com/dxlr8r/kubedrome.git
```

Then setup the config file, `config.jsonnet`, additional navidrome configuration goes into `navidrome.toml`.

Then install/update Navidrome, to the current Kubernetes context/cluster, using [`tk`](https://tanka.dev/install).

```sh
tk apply chart --tla-str context=$(kubectl config current-context) --tla-code config='import "config.jsonnet"'
```

## Post install

For Navidrome you might want to make sure that the PV isn't deleted if you uninstall `kubedrome`. The default setting is set by your StorageClass, and cannot be defined with the pv claim (pvc). Therefore this need to be done manually unless this already is the default.

Change PV to retain:

```sh
navidrome=$(tk eval chart --tla-str context=$(kubectl config current-context) --tla-code config='import "config.jsonnet"' -e 'data.config' | jq -r '{name: .name, namespace: .namespace} | @json') && \
kubectl get pv -o json | jq --argjson navidrome "$navidrome" '.items[] | select(.spec.claimRef.name == $navidrome.name and .spec.claimRef.namespace == $navidrome.namespace) | .spec.persistentVolumeReclaimPolicy = "Retain"' | kubectl apply -f -
```

## Update

To get the newest version, simply use git `git pull` and update using `tk apply ...` as shown above in the installation.
