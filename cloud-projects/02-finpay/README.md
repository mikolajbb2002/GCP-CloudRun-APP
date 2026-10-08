# FinPay_Auzre

-usefull commands 

alias k="kubectl"
az aks get-credentials -g acr-resource-group -n finpay-aks --overwrite-existing


# Add NGINX Ingress Helm Repo

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update


# Install NGINX Ingress

helm install ingress ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace

# Entra App + Service Principal creation in terminal ( temporary)

```bash
PP_ID=$(az ad app create \
  --display-name "gh-oidc-acr-push" \
  --query appId -o tsv)

az ad sp create --id "$APP_ID"

SP_OBJECT_ID=$(az ad sp show --id "$APP_ID" --query id -o tsv)

echo "APP_ID=$APP_ID"
echo "SP_OBJECT_ID=$SP_OBJECT_ID"
```

# Create federated credential from JSON file 

```bash
az ad app federated-credential create --id "$APP_ID" --parameters fic.json
```
# Add Role Service Principal for ACR push 

```bash
az role assignment create \
  --assignee-object-id "$SP_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role AcrPush \
  --scope "$ACR_SCOPE"
```

```bash
az group create -n acr-resource-group -l polandcentral
```

```bash 
az deployment sub what-if \
  --location polandcentral \
  --template-file infra-bicep/main.bicep \
  --parameters infra-bicep/main.bicepparam
```

``` bash
az deployment sub create \
  --location polandcentral \
  --template-file infra-bicep/main.bicep \
  --parameters infra-bicep/main.bicepparam
```

# Enable OIDC issuer + Workload Identity na AKS

```bash
RG="acr-resource-group"
AKS="finpay-aks"

az aks update -g "$RG" -n "$AKS" --enable-oidc-issuer --enable-workload-identity
ISSUER=$(az aks show -g "$RG" -n "$AKS" --query "oidcIssuerProfile.issuerUrl" -o tsv)
echo "$ISSUER"
```

# Create Federated Credential (UAI <-> ServiceAccount)

```bash
IDENTITY_RG="acr-resource-group"
IDENTITY_NAME="acr-resource-group-identity"

az identity federated-credential create \
  -g "$IDENTITY_RG" \
  --identity-name "$IDENTITY_NAME" \
  --name "payment-api-sa" \
  --issuer "$ISSUER" \
  --subject "system:serviceaccount:api-ns:payment-api-sa" \
  --audiences "api://AzureADTokenExchange"

```

## Deploy DB VM + ACR roles

```bash
az login

az group create -n acr-resource-group -l polandcentral

az deployment sub create \
  --location polandcentral \
  --template-file infra-bicep/main.bicep \
  --parameters infra-bicep/main.bicepparam

RG="acr-resource-group"
AKS="finpay-aks"

az aks update -g "$RG" -n "$AKS" --enable-oidc-issuer --enable-workload-identity
ISSUER=$(az aks show -g "$RG" -n "$AKS" --query "oidcIssuerProfile.issuerUrl" -o tsv)
echo "$ISSUER"

ACR="acrepository111"
ACR_ID=$(az acr show -g "$RG" -n "$ACR" --query id -o tsv)
echo "$ACR_ID"

KUBELET_OID=$(az aks show -g "$RG" -n "$AKS" --query identityProfile.kubeletidentity.objectId -o tsv)

az role assignment create \
  --assignee-object-id "$KUBELET_OID" \
  --assignee-principal-type ServicePrincipal \
  --role AcrPull \
  --scope "$ACR_ID"

APP_ID=$(az ad app create --display-name "gh-oidc-acr-push" --query appId -o tsv)
az ad sp create --id "$APP_ID"
SP_OBJECT_ID=$(az ad sp show --id "$APP_ID" --query id -o tsv)

az ad app federated-credential create --id "$APP_ID" --parameters fic.json

az role assignment create \
  --assignee-object-id "$SP_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role AcrPush \
  --scope "$ACR_ID"

az keyvault recover --name finpaykv05 --location polandcentral
```

## Postgres VM (Bastion + setup)

```bash
az network bastion tunnel \
  --name finpay-bastion \
  --resource-group acr-resource-group \
  --target-resource-id $(az vm show -g acr-resource-group -n finpay-pgvm --query id -o tsv) \
  --resource-port 22 \
  --port 50022

ssh -i ~/.ssh/finpay_pgvm -p 50022 pgvmadmin@127.0.0.1

ssh-keygen -t ed25519 -f ~/.ssh/finpay_pgvm -C "finpay_pgvm"

chmod 600 ~/.ssh/finpay_pgvm

az vm user update \
  -g acr-resource-group \
  -n finpay-pgvm \
  -u pgvmadmin \
  --ssh-key-value ~/.ssh/finpay_pgvm.pub


sudo systemctl status postgresql@14-main --no-pager

sudo -u postgres psql <<'SQL'
CREATE USER appuser WITH PASSWORD 'admin123';
CREATE DATABASE appdb OWNER appuser;
GRANT ALL PRIVILEGES ON DATABASE appdb TO appuser;
SQL

sudo sed -i "s/^#listen_addresses.*/listen_addresses = '*'/g" /etc/postgresql/14/main/postgresql.conf
echo "host    all     all     10.0.0.0/16    md5" | sudo tee -a /etc/postgresql/14/main/pg_hba.conf
sudo systemctl restart postgresql
```

## Flexible Server backup from VM

```bash
PGSSLMODE=require psql -h finpay-pg.postgres.database.azure.com -U pgadmin -d postgres -c "select 1;"

echo "finpay-pg.postgres.database.azure.com:5432:postgres:pgadmin:P@ssw0rd123!" >> ~/.pgpass
chmod 600 ~/.pgpass

sudo mkdir -p /var/backups/postgresql
sudo chown pgvmadmin:pgvmadmin /var/backups/postgresql

/usr/local/bin/pg-flex-backup.sh
```
