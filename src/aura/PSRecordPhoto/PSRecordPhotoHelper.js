({
    getImageURL: function(component) {

        var map = {};

        map['recordId'] = component.get('v.recordId');
        map['defaultURL'] = component.get('v.defaultURL');
        map['source'] = component.get('v.source');
        map['sourceValue'] = component.get('v.sourceValue');

        console.log('paramMap=' + JSON.stringify(map));

        var action = component.get("c.getImageURL");
        action.setParams({
            "params": JSON.stringify(map)
        });

        action.setCallback(self, function(a) {
            console.log(a.getReturnValue());
            var resp = JSON.parse(a.getReturnValue());

            if (resp.status === 'SUCCESS') {
                component.set('v.imageURL', resp.data);
            } else {
                component.set('v.imageURL', resp.data);
            }
        });
        // Enqueue the action
        $A.enqueueAction(action);

    }
})