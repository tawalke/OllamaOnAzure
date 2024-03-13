param name string
param location string
param lawClientId string
param lawClientSecret string

resource env 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: name
  location: location
  properties: {
    type: 'managed'
    internalLoadBalancerEnabled: false
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: lawClientId
        sharedKey: lawClientSecret
      }
    }
    workloadProfiles: [
      {
        name: 'Consumption',
        workloadProfileType: "Consumption"
      }
      {
        maximumCount: 3
        minimumCount: 1
        name: 'ollama-gpu'
        workloadProfileType: 'NC48-A100'
      }
    ]
  }
}
output id string = env.id