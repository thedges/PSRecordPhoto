# PSRecordPhoto

The purpose of the component is to show a single photo that is attached to the record that the component is placed on. This component was developed mainly because Salesforce new attachment storage uses the new ContentDocument and ContentVersion objects which can make it tough to auto-generate a URL to a photo image that you may want to show on a record. My specific use case was to show a driver license photo on a "person" record.

The following is example of using the component on a record.

![alt text](https://github.com/thedges/PSRecordPhoto/blob/master/screenshot1.png "Sample Image")

<b>Dependency:</b> Install the [PSCommon](https://github.com/thedges/PSCommon) package first

* This component can be dropped on any sobject
* The component configuration fields are (only provide one value for either contentId, field or filename):
  - <b>contentId</b> - the id of a Content Document to show
  - <b>field</b> - the field API name on the object that returns a Content Document ID to show on the record. Use this in formula field or populate some hidden field if you have apex code that loads photo to a record.
  - <b>filename</b> - the filename of photo attached to the record that you want to show. The latest version of the document found with that filename will be shown.
  - <b>defaultURL</b> - the default URL to an image file that will show if the component cannot find an image based on the provided parameters
 
<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
