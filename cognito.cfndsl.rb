CloudFormation do

  Condition(:EnableCognito, FnEquals(Ref(:CreateCognitoResources), 'true'))

  SNS_Topic(:CognitoTopic)

  Cognito_UserPool(:UserPool) do
    Condition :EnableCognito
    UserPoolName user_pool['name']
  end  

  Cognito_UserPoolGroup(:UserPoolGroup) do
    Condition :EnableCognito
    GroupName user_pool_group['name']
    UserPoolId Ref(:UserPool)
  end  

  Cognito_UserPoolDomain(:UserPoolDomain) do
    Condition :EnableCognito
    Domain user_pool_domain['name']
    UserPoolId Ref(:UserPool)
  end

  Cognito_UserPoolClient(:UserPoolClient) do
    Condition :EnableCognito
    UserPoolId Ref(:UserPool)
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
  
  Output(:CognitoUserPoolId) {
    Value(FnIf(:EnableCognito, FnGetAtt(:UserPool, :Arn), ''))
  }

  Output(:CognitoUserPoolId) {
    Value(FnIf(:EnableCognito, Ref(:UserPoolClient), ''))
  }

  Output(:CognitoUserPoolId) {
    Value(FnIf(:EnableCognito, Ref(:UserPoolDomain), ''))
  }

  Output(:CongitoURL){
    Value(FnIf(:EnableCognito, FnSub("https://app.${EnvironmentName}.${DnsDomain}"),''))
  }
end
