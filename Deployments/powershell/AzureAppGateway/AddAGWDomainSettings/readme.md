([Français](#français))

# AddAGWDomainSettings #

## Quickly and easily add settings for a new (sub)domain within an app gateway! ##

## Requirements ##

Azure Powershell Az Module: [Get It Here](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-3.6.1)

## What this script does: ##

Creates all the settings you need to support (sub)domain routing in an Azure application gateway. Save yourself some time!

* Supports up to 2 regions currently (could be extended)
* Supports KeyVault managed SSL Certificates (currently 2, but extendable; recommend wildcard certs)
* Creates a port 80 and port 443 listener for a given (sub)domain (Ex. dev.yourdept.gc.ca or yourdept.gc.ca)
* Creates Backend HTTP Settings for 443
* Creates Backend Pool for 443
* Creates Route Rule for port 80 forward to 443 (enforce SSL)
* Creates Route Rule to Backend Pool (Endpoint) using HTTP Settings (and future path based rule support)
* Creates Health Probe for the Endpoint
* Creates all objects with the Listener (sub)domain as the name. (code to allow custom name included)

## What this script doesn't do: ##

Assumes you've created a KeyVault (KV) and installed your SSL certificates there. (suggest one KV per region)

* Create KV Certificate References (need to create manually via a placeholder Listener or via Powershell)
* Create Port Configurations (need to create manually via a placeholder Listener or via Powershell)
* Create Front End IP Configurations (need to create manually via Portal or via Powershell)
* Support manually uploaded certs (.cer) to app gateway

## Handy PS commands ##

* `az network application-gateway ssl-cert list --gateway-name MyAppGateway --resource-group MyResourceGroup`
* [Adding an SSL cert from KV:](https://docs.microsoft.com/en-us/cli/azure/network/application-gateway/ssl-cert?view=azure-cli-latest#az-network-application-gateway-ssl-cert-create)
* `az network application-gateway frontend-port list --gateway-name MyAppGateway --resource-group MyResourceGroup`
* `az network application-gateway frontend-port create --gateway-name MyAppGateway --resource-group MyResourceGroup --name MyPort --port 80`
* `az network application-gateway frontend-ip list -g MyResourceGroup --gateway-name MyAppGateway`
* Private IP: `az network application-gateway frontend-ip create --gateway-name MyAppGateway --name MyFrontendIp --public-ip-address 10.10.10.50 --resource-group MyResourceGroup --subnet MySubnet --vnet-name MyVnet`
* [Public Front End IP creation](https://docs.microsoft.com/en-us/powershell/module/azurerm.network/set-azurermapplicationgatewayfrontendipconfig?view=azurermps-6.13.0)

## ToDo ##

* Update code for current breaking change warning for "Get-AzApplicationGatewayBackendHttpSetting". (Still functional)
* Expand script capability to auto generate subdomain forwards (Ex. www.yourdept.gc.ca to yourdept.gc.ca)

---
# Français

## Ajoutez rapidement et facilement les paramètres d'un nouveau (sous) domaine dans une passerelle d'application! ##

## Exigences ##

Module Azure Powershell Az: [Obtenez-le ici] (https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-3.6.1)

## Ce que fait ce script: ##

Crée tous les paramètres dont vous avez besoin pour prendre en charge le routage de (sous-) domaine dans une passerelle d'application Azure. Gagnez du temps!

* Prend en charge jusqu'à 2 régions actuellement (pourrait être étendu)
* Prend en charge les certificats SSL gérés par KeyVault (actuellement 2, mais extensible; recommande les certificats génériques)
* Crée un écouteur de port 80 et de port 443 pour un (sous) domaine donné (Ex. Dev.yourdept.gc.ca ou yourdept.gc.ca)
* Crée des paramètres HTTP backend pour 443
* Crée un pool d'arrière-plan pour 443
* Crée une règle de route pour le port 80 vers 443 (appliquer SSL)
* Crée une règle de routage vers un pool d'arrière-plan (point final) à l'aide des paramètres HTTP (et de la prise en charge future des règles basées sur le chemin)
* Crée une sonde de santé pour le point final
* Crée tous les objets avec le (sous-) domaine d'écoute comme nom. (code pour autoriser le nom personnalisé inclus)

## Ce que ce script ne fait pas: ##

Suppose que vous avez créé un KeyVault (KV) et y avez installé vos certificats SSL. (suggérer un KV par région)

* Créer des références de certificat KV (besoin de créer manuellement via un écouteur d'espace réservé ou via PowerShell)
* Créer des configurations de port (besoin de créer manuellement via un écouteur d'espace réservé ou via Powershell)
* Créer des configurations IP frontales (besoin de créer manuellement via le portail ou via Powershell)
* Prise en charge des certificats téléchargés manuellement (.cer) sur la passerelle de l'application

## Commandes PS pratiques ##

* `az network application-gateway ssl-cert list --gateway-name MyAppGateway --resource-group MyResourceGroup`
* [Ajout d'un certificat SSL à partir de KV:] (https://docs.microsoft.com/en-us/cli/azure/network/application-gateway/ssl-cert?view=azure-cli-latest#az-network -application-gateway-ssl-cert-create)
* `az network application-gateway frontend-port list --gateway-name MyAppGateway --resource-group MyResourceGroup`
* `az network application-gateway frontend-port create --gateway-name MyAppGateway --resource-group MyResourceGroup --name MyPort --port 80`
* `az network application-gateway frontend-ip list -g MyResourceGroup --gateway-name MyAppGateway`
* IP privée: `az network application-gateway frontend-ip create --gateway-name MyAppGateway --name MyFrontendIp --public-ip-address 10.10.10.50 --resource-group MyResourceGroup --subnet MySubnet --vnet-name MyVnet "
* [Création d'une IP publique frontale] (https://docs.microsoft.com/en-us/powershell/module/azurerm.network/set-azurermapplicationgatewayfrontendipconfig?view=azurermps-6.13.0)

## Faire ##

* Code de mise à jour pour l'avertissement de changement de rupture actuel pour "Get-AzApplicationGatewayBackendHttpSetting". (Toujours fonctionnel)
* Étendre la capacité de script pour générer automatiquement des sous-domaines vers l'avant (Ex. Www.yourdept.gc.ca à yourdept.gc.ca)