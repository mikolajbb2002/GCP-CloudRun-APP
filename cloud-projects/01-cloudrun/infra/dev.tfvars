region = "europe-central2"

vpc_name           = "flask-vpc"
subnet_01_name     = "flask-subnet-01"
subnet_01_cidr     = "10.10.1.0/24"
subnet_02_name     = "flask-subnet-02"
subnet_02_cidr     = "10.10.2.0/24"
vpc_connector_name = "flask-connector"
connector_cidr     = "10.10.3.0/28"
router_name        = "flask-router"
nat_name           = "flask-nat"

cloud_service_name = "flask-app"
# Obraz jest przekazywany przez TF_VAR_image w GitHub Actions.
secret_id  = "flask-app-secret"
account_id = "sa-flask-app"