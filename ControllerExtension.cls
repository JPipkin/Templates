public class {{ api_name }} {

	private final {{ sobj }} {{ obj_var }};

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.

    public {{ api_name }}(ApexPages.StandardController stdController) {
        this.{{ obj_var }} = ({{ sobj }})stdController.getRecord();
    }

    
}