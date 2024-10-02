param location string = resourceGroup().location


module automationAccount 'br/public:avm/res/automation/automation-account:0.8.0' = {
  name: 'automationAccountDeployment'
  params: {
    // Required parameters
    name: 'aamin001'
    // Non-required parameters
    location: location
    disableLocalAuth: false
  }
}
