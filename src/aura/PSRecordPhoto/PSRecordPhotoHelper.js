({
    getImageURL: function(component) {

        var map = {};

        map['recordId'] = component.get('v.recordId');
        map['defaultURL'] = component.get('v.defaultURL');

        if (typeof component.get('v.contentId') !== "undefined" && component.get('v.contentId').length > 0)
        {
        	map['contentId'] = component.get('v.contentId');
        }
        else if (typeof component.get('v.field') !== "undefined" && component.get('v.field').length > 0)
        {
        	map['field'] = component.get('v.field');
        }
        else if (typeof component.get('v.filename') !== "undefined" && component.get('v.filename').length > 0)
        {
        	map['filename'] = component.get('v.filename');
        }
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
            }
        });
        // Enqueue the action
        $A.enqueueAction(action);

    }
})