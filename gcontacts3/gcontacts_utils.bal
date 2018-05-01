function checkAndSetErrors(http:Response|error response)
    returns xml|error {
    match response {
        http:Response httpResponse => {
            //if success
            match httpResponse.getXmlPayload() {
                xml xmlResponse => {
                    return xmlResponse;
                }
                error err => {
                    return err;
                }
            }
        }
        error err => {
            return err;
        }
    }
}