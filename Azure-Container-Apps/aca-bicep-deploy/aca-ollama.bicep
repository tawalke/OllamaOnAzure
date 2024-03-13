/ general Azure Container App settings
param location string
param name string
param containerAppEnvironmentId string

// Container Image ref
param containerImage string = 'docker.io/ollama/ollama:latest'
param cpuCore string = '24'
param memorySize string = '220'   

// Networking
param useExternalIngress bool = true
param containerPort int = 11434   
param envVars array = []

resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: name
  location: location
  properties: {
    managedEnvironmentId: containerAppEnvironmentId
    configuration: {
      ingress: {
        external: useExternalIngress
        targetPort: containerPort
        allowInsecure: true
      }
    }
    template: {
      containers: [
        {
          image: containerImage
          name: name
          resources: {
            cpu: json(cpuCore)
            memory: '${memorySize}Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
      }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn