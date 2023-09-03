local navidrome_toml=importstr 'navidrome.toml';

{
  name: 'navidrome',
  namespace: 'navidrome',
  ConfigMap: {
    'navidrome.toml': navidrome_toml,
  },
  Volume+: {
    accessModes: $.volume_access_modes,
    size_request: $.volume_size
  },
  Ingress+: {
    mixin: {
      metadata+: {
        annotations: $.ingress_annotations }}
  },
  Service+: {},
  Deployment+: {
    replicas: 1,
    containers: {
      navidrome: {
        image: 'docker.io/deluan/navidrome:%s' % $.navidrome_version,
        mountPathConfigMap: '/config',
        mountPathVolume: '/navidrome/music',
        subPathVolume: 'music',
        ports: {
          ingress: 4533,
          liveness: 4533
        },
        ingress: {
          name: $.fqdn,
          tls_secret: std.strReplace($.fqdn, '.', '-'),
        },
        mixin: {
          env+:[
            { name: 'TZ', value: 'UTC' },
            { name: 'ND_MUSICFOLDER', value: '/navidrome/music' },
            { name: 'ND_CONFIGFILE', value: '/config/navidrome.toml' }
            { name: 'ND_DATAFOLDER', value: '/navidrome/data' }
          ],
          volumeMounts+: [{
            mountPath: '/navidrome/data',
            subPath: 'data',
            name: 'pvc-navidrome'
          }]
        }
      }
    }
  }
}
