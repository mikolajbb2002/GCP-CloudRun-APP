# Repozytorium jest teraz zarządzane przez bootstrap.
# Zachowaj istniejące repozytorium podczas usuwania go ze stanu infra.
removed {
  from = module.registry

  lifecycle {
    destroy = false
  }
}
