group "default" {
  targets = ["api", "web"]
}

variable "REGISTRY" {
  default = "ghcr.io"
}

variable "OWNER" {
  // Ex: "seu-usuario-ou-org"
  default = "SEU_OWNER_AQUI"
}

variable "REPO" {
  // Ex: "seu-repo"
  default = "SEU_REPO_AQUI"
}

target "common" {
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/${OWNER}/${REPO}"
  }
  // Habilita attests nativos do buildx (proveniência e sbom)
  attest = [
    "provenance=mode=max",
    "sbom=generator=syft"
  ]
}

target "api" {
  inherits = ["common"]
  context  = "."
  dockerfile = "./apps/api/Dockerfile"        # ajuste se necessário
  // tags são injetadas pelo workflow via set: api.tags=...
  // Ex de fallback (não usados se o workflow injetar):
  tags = [
    "${REGISTRY}/${OWNER}/${REPO}/api:dev"
  ]
}

target "web" {
  inherits = ["common"]
  context  = "."
  dockerfile = "./apps/web/Dockerfile"        # ajuste se necessário
  tags = [
    "${REGISTRY}/${OWNER}/${REPO}/web:dev"
  ]
}
