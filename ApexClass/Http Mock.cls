/* Class:       {{ api_name }}
 * Created On:  
 * Created by:  OpFocus Team
 * Description: Test class for Http Callout responses
 */
 
@isTest
global class {{ api_name }} implements HttpCalloutMock{

	protected Integer code = 200;
	protected String status = 'OK';
	protected String bodyAsString;
	protected Blob bodyAsBlob;

	public {{ api_name }}(Integer code, String status, String body) {
		this.code = code;
		this.status = status;
		this.bodyAsString = body;
		this.bodyAsBlob = null;
	}

	public {{ api_name }}(Integer code, String status, Blob body) {
		this.code = code;
		this.status = status;
		this.bodyAsBlob = body;
		this.bodyAsString = null;
	}

	public {{ api_name }}(String body){
		this.bodyAsString = body;
	}

	public {{ api_name }}(Blob body){
		this.bodyAsBlob = body;
	}

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse resp = new HttpResponse();
		resp.setStatusCode(code);
		resp.setStatus(status);
		if (bodyAsBlob != null) {
			resp.setBodyAsBlob(bodyAsBlob);
		} else {
			resp.setBody(bodyAsString);
		}
		return resp;
    }
}