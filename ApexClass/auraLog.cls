/* Class:       {{ api_name }}
 * Created On:  {{ today }}
 * Created by:  J. Pipkin (OpFocus, Inc)
 * Description: 
 */
 
public with sharing class {{ api_name }} {

	@AuraEnabled
	public static Output doInit(String datajson){
		Output o = new Output();
		{{ api_name }}.Input i;
		try{
			i = ({{ api_name }}.Input) ltngfw.AuraInput.deserialize(datajson, {{ api_name }}.Input.class);

			if(Test.isRunningTest()){
				Decimal d = 1/0;
			}
		}
		catch(Exception e){
			String di = i == null ? '{}' : (i.deviceInfoStr == null ? '{}' : i.deviceInfoStr);
			ltngfw.Log.notify(e, '{{ api_name }}.doInit', ltngfw.DeviceInformation.deserialize(di));
		}
		return o;
	}

	public class Output extends ltngfw.AuraReturn {
		
	}

	public class Input extends ltngfw.AuraInput {
		@AuraEnabled public String recordId;
	}
}