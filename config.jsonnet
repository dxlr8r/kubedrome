(import 'default.jsonnet') + {
  namespace: 'navidrome',
  volume_size:: '20Gi',
  volume_access_modes:: ['ReadWriteOnce'],
  fqdn:: 'navidrome.example.com',
  ingress_annotations:: {},
  navidrome_version:: '0.49.3'
}
