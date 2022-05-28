# Connect Harbor to Keycloak cheatsheet

Assumptions:
- keycloak url: keycloak.domain.com
- harbor url: harbor.domain.com
- 
Create a clients in keycloak:
- client ID: harbor
- Valid Redirect URIs: https://harbor.domain.com/*
- Access Type: confidential
- Credential/secret

In harbor:
- goto: `Administration/Configuration/Authentication`
- Auth mode: `OIDC`
- OIDC Provider Name: `keycloak.domain.com`
- OIDC Endpoint: 
- OIDC Client ID: `harbor`
- OIDC Client Secret: 
- Group Claim Name:
- OIDC Scope: 
- Automatic onboarding: `Checked`
- Username Claim: 
- OIDC Client Secret: from Keycloak/Credential/secret
- 

