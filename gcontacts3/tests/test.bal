import ballerina/log;
import ballerina/test;
import ballerina/config;

endpoint Client gContactsEP {
    clientConfig:{
        auth:{
            accessToken:config:getAsString("ACCESS_TOKEN"),
            clientId:config:getAsString("CLIENT_ID"),
            clientSecret:config:getAsString("CLIENT_SECRET"),
            refreshToken:config:getAsString("REFRESH_TOKEN")
        }
    }
};


@test:Config
function testGetAllContacts() {
    string userEmail = "erandiganepola@gmail.com";

    log:printInfo("testGetAllContacts()");
    var response = gContactsEP -> getAllContacts(userEmail);

    match response {
        xml xmlRes => {
            test:assertNotEquals(xmlRes, null, msg = "Found null XML response!");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config
function testGetContactById() {
    string userEmail = "erandiganepola@gmail.com";
    string contactId = "fb4eab8801c6e0";

    log:printInfo("testGetContactById()");
    var response = gContactsEP -> getContactById(userEmail, contactId);

    match response {
        xml xmlRes => {
            test:assertNotEquals(xmlRes, null, msg = "Found null XML response!");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}