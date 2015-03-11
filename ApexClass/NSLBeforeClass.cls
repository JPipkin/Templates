public class {{ api_name }} {
  // -------------------------------------------------------------------------------//
  // ------------------------- DESCRIPTION OF TRIGGER TASKS ------------------------//
  // ----- FORMAT : item number. date - Ticket # - description of task -------------//
  // ------------                date - Ticket # - description of change to item -- //
  // ------------                date - Ticket # - description of change to item -- //
  // ------------ : item number. date - Ticket # - description ---------------------//
  // -------------------------------------------------------------------------------//
    
    
  // -------------------------------------------------------------------------------//
  //--------------- VARIABLES THAT WILL DECIDE IF QUERIES ARE PERFORMED ------------//
  // -------------------------------------------------------------------------------//


  // -------------------------------------------------------------------------------//
  //-------------------------- VARIABLES TO HOLD QUERY RESULTS ---------------------//
  // -------------------------------------------------------------------------------//


  // -------------------------------------------------------------------------------//
  // -------------- VARIABLES TO DO CRUD ON OTHER OBJECTS --------------------------//
  // -------------------------------------------------------------------------------//



  public void doBefore()
  {
    // ------------------------------------------------------------------------------------- //
      // -- FIRST PASS OF TRIGGER MAP TO FILL VARIABLES THAT DECIDE IF QUERIES ARE EXECUTED -- //
    // ------------------------------------------------------------------------------------- //
    if(Trigger.isDelete)  {
      for({{ object_name }} Current{{ obj_var }} : (List<{{ object_name }}>)Trigger.Old) {
                
      }// For records of trigger - set up variables that control queries
    }
    else {
      for({{ object_name }} Current{{ obj_var }} : (List<{{ object_name }}>)Trigger.new) {
        {{ object_name }} Old{{ obj_var }} = null;
        if(Trigger.isUpdate)
          Old{{ obj_var } = ({{ object_name }})Trigger.OldMap.get(Current{{ obj_var }}.Id) ;
                
                
      }// For records of trigger - set up variables that control queries
    }

    // -------------------------------------------------------------------------------//
      // ------------- FUNCTIONS TO PERFORM QUERIES ----------------------------------- //
    // -------------------------------------------------------------------------------//
    
    

    // ----------------------------------------------------------------------------------//
      // -- SECOND PASS OF TRIGGER MAP TO GET VARIABLES READY FOR CRUD ON OTHER OBEJCTS -- //
    // ----------------------------------------------------------------------------------//
    if(Trigger.isDelete)  {
      for({{ object_name }} Current{{ obj_var }} : (List<{{ object_name }}>)Trigger.Old) {
                
      }// For records of trigger - set up variables that control queries
    }
    else {
      for({{ object_name }} Current{{ obj_var }} : (List<{{ object_name }}>)Trigger.new) {
        {{ object_name }} Old{{ obj_var }} = null;
        if(Trigger.isUpdate)
          Old{{ obj_var }} = ({{ object_name }})Trigger.OldMap.get(Current{{ obj_var }}.Id) ;
                
                
      }// For records of trigger - set up variables that control queries
    }

    // -------------------------------------------------------------------------------//
      // ------------- PERFORM CRUD ON OTHER OBEJCTS ---------------------------------- //
    // -------------------------------------------------------------------------------//
  }

  // -------------------------------------------------------------------------------//
    // ----------- PRIVATE METHODS FOR QUERIES ---------------------------------------//
  // -------------------------------------------------------------------------------//

    
    
    
    
  // -------------------------------------------------------------------------------//
    // ----------- PRIVATE PROCESSING METHODS ----------------------------------------//
  // -------------------------------------------------------------------------------//


}
