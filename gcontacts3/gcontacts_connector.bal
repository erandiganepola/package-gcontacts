import ballerina/http;
import ballerina/mime;
import ballerina/log;

documentation{
    Represents the Google Contacts Client Connector.

    F{{client}} HTTP Client used in Google Contacts connector
}
public type GContactsConnector object {
    public {
        http:Client client;
    }

    documentation{
        List all the contacts for a given email.

        P{{userEmail}} The user's email address.
        R{{}} If successful, returns response xml. Else returns error.
    }
    public function getAllContacts(string userEmail) returns xml | error;

    documentation{
            List contacts for a given email and contact ID

            P{{userEmail}} The user's email address.
            P{{contactId}} The user's contact ID.
            R{{}} If successful, returns response xml. Else returns error.
        }
    public function getContactById(string userEmail, string contactId) returns xml | error;

};

public function GContactsConnector::getAllContacts(string userEmail) returns xml | error{
    endpoint http:Client httpClient = self.client;
    string path = API_BASE_PATH + userEmail + FULL_SUFFIX + QUERY_PARAM_SUFFIX + API_VERSION;

    var httpResponse = httpClient->get(path);
    return checkAndSetErrors(httpResponse);
}

public function GContactsConnector::getContactById(string userEmail, string contactId) returns xml | error{
    endpoint http:Client httpClient = self.client;
    string path = API_BASE_PATH + userEmail + FULL_SUFFIX + FORWARD_SLASH + contactId + QUERY_PARAM_SUFFIX + API_VERSION;

    var httpResponse = httpClient->get(path);
    return checkAndSetErrors(httpResponse);
}