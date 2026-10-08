# Repozytorium Artifact Registry

Moduł `registry` znajduje się w `bootstrap/modules/registry` i jest wywoływany
przez `bootstrap/main.tf`. Wartości `registry_repo_id` i
`registry_repo_description` ustaw w lokalnym `bootstrap/terraform.auto.tfvars`.
Ustaw również `registry_region` zgodnie z lokalizacją repozytorium oraz `GOOGLE_PROJECT`.

## Jeśli repozytorium już istnieje

Zmiana katalogu nie przenosi zasobu pomiędzy osobnymi stanami Terraform.
Przed wdrożeniem wstrzymaj równoległe uruchomienia workflow i zachowaj kopie
stanów za pomocą `terraform state pull` w obu zainicjalizowanych katalogach.

1. Uruchom `terraform -chdir=infra init`, a następnie `terraform -chdir=infra plan`.
   Blok `removed` w `infra/removed.tf` powinien zaplanować zaprzestanie zarządzania
   repozytorium bez jego usunięcia. Sprawdź też pozostałe zmiany przed apply.
2. Zastosuj sprawdzony plan infra. Nie usuwaj repozytorium w GCP.
3. Uruchom `terraform -chdir=bootstrap init`.
4. Zaimportuj istniejące repozytorium do bootstrap, podając jego rzeczywisty
   projekt, region i nazwę:

   ```bash
   terraform -chdir=bootstrap import \
     module.registry.google_artifact_registry_repository.registry \
     projects/PROJECT_ID/locations/REGION/repositories/REPOSITORY_ID
   ```

5. Sprawdź `terraform -chdir=bootstrap plan`: repozytorium nie powinno wymagać
   utworzenia ani zastąpienia.

Jeśli repozytorium nie istnieje, pomiń import i utwórz je przez bootstrap.
Nie uruchamiaj bootstrap apply dla istniejącego repozytorium przed importem.
