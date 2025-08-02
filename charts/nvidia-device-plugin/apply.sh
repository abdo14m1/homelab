helm upgrade -i nvdp nvdp/nvidia-device-plugin \
  --version 0.17.3 \
  --namespace nvidia-device-plugin \
  --create-namespace \
  -f values.yaml
