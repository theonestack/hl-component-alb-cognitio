CfhighlanderTemplate do
  Name 'cognito'

  Parameters do
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', isGlobal: true
    ComponentParam 'DnsDomain', isGlobal: true
    ComponentParam 'CreateCognitoResources', 'true', allowedValues: ['true','false']
    ComponentParam 'CustomUserPoolId', ''
  end
end
