trigger {{ api_name }} on {{ object_name }} (before insert, before update, before delete, before undelete, after insert, after update, after delete, after undelete){
	new {{ api_name }}TriggerHandler().run();
}