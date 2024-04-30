CloudFormation do

  Condition(:EnableCognito, FnEquals(Ref(:CreateCognitoResources), 'true'))
  Condition(:ExternalUserPool, FnNot(FnEquals(Ref(:CustomUserPoolId), '')))
  Condition(:CreateUserPool, FnAnd([Condition('EnableCognito'), FnNot(Condition('ExternalUserPool'))]))
  SNS_Topic(:CognitoTopic)

  Cognito_UserPool(:UserPool) do
    Condition :CreateUserPool
    UserPoolName user_pool['name']
  end  

  Cognito_UserPoolGroup(:UserPoolGroup) do
    Condition :CreateUserPool
    GroupName user_pool_group['name']
    UserPoolId FnIf('CreateUserPool', Ref('UserPool'), Ref('CustomUserPoolId'))
  end  

  Cognito_UserPoolDomain(:UserPoolDomain) do
    Condition :CreateUserPool
    Domain user_pool_domain['name']
    UserPoolId FnIf('CreateUserPool', Ref('UserPool'), Ref('CustomUserPoolId'))
  end

  Cognito_UserPoolClient(:UserPoolClient) do
    Condition :EnableCognito
    UserPoolId FnIf('CreateUserPool', Ref('UserPool'), Ref('CustomUserPoolId'))
    ClientName user_pool_client['name']
    GenerateSecret user_pool_client['generate_secret']
    AllowedOAuthFlows user_pool_client['allowed_oauth_flows']
    AllowedOAuthScopes user_pool_client['allowed_ouath_scopes']
    AllowedOAuthFlowsUserPoolClient user_pool_client['allowed_oauth_flows_userpool_client']
    CallbackURLs user_pool_client['call_back_urls']
    DefaultRedirectURI user_pool_client['default_redirect_uri']
    SupportedIdentityProviders user_pool_client['supported_identity_providers']
    RefreshTokenValidity user_pool_client['refresh_token_validity']
    AccessTokenValidity user_pool_client['access_token_validity']
    ExplicitAuthFlows user_pool_client['explicit_auth_flows']
  end
  
  Output(:UserPoolId) {
    Value(FnIf(:CreateUserPool, FnGetAtt(:UserPool, :Arn), ''))
  }

  Output(:UserPoolClientId) {
    Value(FnIf(:EnableCognito, Ref(:UserPoolClient), ''))
  }

  Output(:UserPoolDomainName) {
    Value(FnIf(:CreateUserPool, Ref(:UserPoolDomain), ''))
  }

  Output(:URL){
    Value(FnIf(:EnableCognito, FnSub("https://app.${EnvironmentName}.${DnsDomain}"),''))
  }
end
