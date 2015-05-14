global with sharing class {{ api_name }} implements Process.Plugin{

    global Process.PluginResult invoke(Process.PluginRequest request)   
    {   
        //input parameters
        //String hsize = (String) request.inputParameters.get('Household Size');
      	
        // return to Flow   
        Map<String,Object> result = new Map<String,Object>();
        return new Process.PluginResult(result);   
            
    }
    
    
    // Returns the describe information for the interface   
    global Process.PluginDescribeResult describe()   
    {   
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();  
        result.Name = 'Name';  
        result.Tag = 'NSL Custom Plugins';  
        
        //describe input parameters
        result.inputParameters =new List<Process.PluginDescribeResult.InputParameter>();  
        
        /*
        result.inputParameters.add(  
            new Process.PluginDescribeResult.InputParameter('Household Size',  
                                                            Process.PluginDescribeResult.ParameterType.String, true));*/
       
        //now output parameters
        result.outputparameters = new List<Process.PluginDescribeResult.OutputParameter>();
        /*
        result.outputparameters.add(   
            new Process.PluginDescribeResult.OutputParameter('Annual AMI',Process.PluginDescribeResult.ParameterType.Decimal));*/
        
        return result;  
    }     
}