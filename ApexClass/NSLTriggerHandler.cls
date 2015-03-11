public class {{ trigger_api_name }}TriggerHandler extends TriggerHandler{

   /****************************************
   * context method overrides
   ****************************************/

  protected override void afterHandler() {
    //new {{ trigger_api_name }}After().doAfter();
  } 

  protected override void beforeHandler() {
    //new {{ trigger_api_name }}Before().doBefore();
  } 

}