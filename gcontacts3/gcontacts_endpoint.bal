import ballerina/http;

documentation{
    Represents Google Contacts endpoint.

    E{{}}
    F{{gcontactsConfig}} Google Contacts endpoint configuration
    F{{gcontactsConnector}} Google Contacts connector
}
public type Client object {
    
    public GContactsConfiguration gcontactsConfig;
    public GContactsConnector gcontactsConnector;

    documentation{
        Gets called when the Google Contacts endpoint is beign initialized.

        P{{gcontactsConfiguration}} Google Contacts connector configuration
    }
    public function init(GContactsConfiguration gcontactsConfiguration) {
        gcontactsConfig = gcontactsConfiguration;
        gcontactsConfig.clientConfig.url = BASE_URL;
        match gcontactsConfig.clientConfig.auth {
            () => {}
            http:AuthConfig authConfig => {
                authConfig.refreshUrl = REFRESH_TOKEN_EP;
                authConfig.scheme = "OAuth2";
            }
        }
        self.gcontactsConnector = new;
        self.gcontactsConnector.client.init(gcontactsConfig.clientConfig);
    }

    documentation{
        Returns the connector that client code uses.
    }
    public function getCallerActions() returns GContactsConnector {
        return self.gcontactsConnector;
    }
};

documentation{
    Represents the Google Contacts client endpoint configuration.

    F{{clientConfig}} The HTTP Client endpoint configuration
}
public type GContactsConfiguration record {
    http:ClientEndpointConfig clientConfig;
};
