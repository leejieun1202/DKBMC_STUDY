({
    doInit : function(component, event, helper) {

        let ref = component.get('v.pageReference');    
        let recordId = ref.state.c__id;
        
        //Assigning the data back to an attribute
        component.set( 'v.recordId', recordId);
        event.setComponentEvent;
    }
})