/* Class:       {{ api_name }}
 * Created On:  
 * Created by:  J. Pipkin (OpFocus, Inc)
 * Description: 
 */

 
public with sharing class {{ api_name }} {

	private final {{ sobj }} {{ obj_var }};

    // The extension constructor initializes the private member
    // variable {{ obj_var }} by using the getRecord method from the standard
    // controller.

    public {{ api_name }}(ApexPages.StandardController stdController) {
        this.{{ obj_var }} = ({{ sobj }})stdController.getRecord();
    }

    
}