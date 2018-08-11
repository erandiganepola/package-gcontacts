import ballerina/config;
import ballerina/log;
import ballerina/test;

type Entry record {
    string id = "";
};

type EntryGroup record {
    string id = "";
    string title = "";
};

type Contact record {
    Entry entry = {};
};

type Groups record {
    EntryGroup entry = {};
};

type ID record {
    string ^"#text" = "";
};

type Title record {
    string ^"#text" = "";
};

Contact testData;
Groups groupData;

endpoint Client gContactsEP {
    clientConfig: {
        auth:{
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET"),
            refreshToken: config:getAsString("REFRESH_TOKEN")
        }
    }
};

@test:Config
function testGetAllContacts() {
    string userEmail = "default";

    log:printInfo("Test Get All Contacts.");
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

@test:Config {
    dependsOn: ["testGetAllContacts"]
}
function testAddContact() {
    string userEmail = "default";
    xml contactXML = xml `<atom:entry xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:gd="http://schemas.google.com/g/2005">
  <atom:category scheme="http://schemas.google.com/g/2005#kind"
    term="http://schemas.google.com/contact/2008#contact"/>
  <gd:name>
     <gd:givenName>Elizabeth</gd:givenName>
     <gd:familyName>Bennet</gd:familyName>
     <gd:fullName>Elizabeth Bennet</gd:fullName>
  </gd:name>
  <atom:content type="text">Notes</atom:content>
  <gd:email rel="http://schemas.google.com/g/2005#work"
    primary="true"
    address="liz@gmail.com" displayName="E. Bennet"/>
  <gd:email rel="http://schemas.google.com/g/2005#home"
    address="liz@example.org"/>
  <gd:phoneNumber rel="http://schemas.google.com/g/2005#work"
    primary="true">
    (206)555-1212
  </gd:phoneNumber>
  <gd:phoneNumber rel="http://schemas.google.com/g/2005#home">
    (206)555-1213
  </gd:phoneNumber>
  <gd:im address="liz@gmail.com"
    protocol="http://schemas.google.com/g/2005#GOOGLE_TALK"
    primary="true"
    rel="http://schemas.google.com/g/2005#home"/>
  <gd:structuredPostalAddress
      rel="http://schemas.google.com/g/2005#work"
      primary="true">
    <gd:city>Mountain View</gd:city>
    <gd:street>1600 Amphitheatre Pkwy</gd:street>
    <gd:region>CA</gd:region>
    <gd:postcode>94043</gd:postcode>
    <gd:country>United States</gd:country>
    <gd:formattedAddress>
      1600 Amphitheatre Pkwy Mountain View
    </gd:formattedAddress>
  </gd:structuredPostalAddress>
</atom:entry>`;

    log:printInfo("Test Add Contact.");
    var response = gContactsEP -> addContact(userEmail, contactXML);

    match response {
        xml xmlRes => {
            json s = xmlRes.toJSON({});
            testData = check <Contact> s;
            test:assertNotEquals(xmlRes, null, msg = "Found null xml response!");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn: ["testAddContact"]
}
function testGetContactById() {
    string userEmail = "default";
    string id = testData.entry.id;
    string[] splitedId = id.split("/");
    string contactId = splitedId[splitedId.count() - 1];

    log:printInfo("Test Get Contact By Id.");
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

@test:Config {
    dependsOn: ["testGetContactById"]
}
function testDeleteContactById() {
    string userEmail = "default";
    string id = testData.entry.id;
    string[] splitedId = id.split("/");
    string contactId = splitedId[splitedId.count() - 1];

    log:printInfo("Test Delete Contact By Id.");
    var response = gContactsEP -> deleteContactById(userEmail, contactId);

    match response {
        xml xmlRes => {
            test:assertNotEquals(xmlRes, null, msg = "Found null XML response!");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn: ["testDeleteContactById"]
}
function testGetAllGroups() {
    string userEmail = "default";

    log:printInfo("Test Get All Groups.");
    var response = gContactsEP -> getAllGroups(userEmail);

    match response {
        xml xmlRes => {
            test:assertNotEquals(xmlRes, null, msg = "Found null XML response!");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn: ["testGetAllGroups"]
}
function testAddGroup() {
    string userEmail = "default";
    log:printInfo("Test Add Group.");

    xml groupDetails = xml`<entry xmlns="http://www.w3.org/2005/Atom" xmlns:gd="http://schemas.google.com/g/2005">
    <category scheme="http://schemas.google.com/g/2005#kind" term="http://schemas.google.com/g/2008#group"/>
    <title>Salsa class members</title>
    </entry>`;

    var response = gContactsEP -> addGroup(userEmail, groupDetails);

    match response {
        xml xmlRes => {
            json jsonRes = xmlRes.toJSON({});
            groupData = check <Groups>jsonRes;
            test:assertNotEquals(xmlRes, null, msg = "Found null xml response!");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn: ["testAddGroup"]
}
function testGetGroupById() {
    string userEmail = "default";
    string id = groupData.entry.id;
    string[] splitedId = id.split("/");
    string groupId = splitedId[splitedId.count() - 1];

    log:printInfo("Test Get Gorup By Id.");
    var response = gContactsEP -> getGroupById(userEmail, groupId);

    match response {
        xml xmlRes => {
            test:assertNotEquals(xmlRes, null, msg = "Found null XML response!");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn: ["testGetGroupById"]
}
function testDeleteGroupById() {
    string userEmail = "default";
    string id = groupData.entry.id;
    string[] splitedId = id.split("/");
    string groupId = splitedId[splitedId.count() - 1];

    log:printInfo("Test delete group by Id.");
    var response = gContactsEP -> deleteGroupById(userEmail, groupId);

    match response {
        xml xmlRes => {
            test:assertNotEquals(xmlRes, null, msg = "Found null XML response!");
        }
        error err => {
            test:assertFail(msg = err.message);
        }
    }
}