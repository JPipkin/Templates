public class {{ api_name }} extends TriggerHandler{

   /****************************************
   * context method overrides
   ****************************************/

  protected override void afterHandler() {
    //new {{ trigger_name }}After().doAfter();
  } 

  protected override void beforeHandler() {
    //new {{ trigger_name }}Before().doBefore();
  } 

}