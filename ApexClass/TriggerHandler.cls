/* Class:       {{ api_name }}
 * Created On:  {{ today }}
 * Created by:  OpFocus Team
 * Description: Trigger handler for SObject {{ obj_abbrev }}
 */

public class {{ api_name }} extends TriggerHandler{

   /****************************************
   * context method overrides
   ****************************************/

  protected override void afterHandler() {
    //new {{ obj_abbrev }}After().doAfter();
  } 

  protected override void beforeHandler() {
    //new {{ obj_abbrev }}Before().doBefore();
  } 

}