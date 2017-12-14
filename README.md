# PSRecordPhoto

The purpose of the component is to show a single photo that is attached to the record that the component is placed on. This component was developed mainly because Salesforce new attachment storage uses the new ContentDocument and ContentVersion objects which can make it tough to auto-generate a URL to a photo image that you may want to show on a record. My specific use case was to show a driver license photo on a "person" record.

The following is example of using the component on a record.

![alt text](https://github.com/thedges/PSRecordPhoto/blob/master/screenshot1.png "Sample Image")

<b>Dependency:</b> Install the [Lightning Strike](https://github.com/thedges/Lightning-Strike) and  [PSCommon](https://github.com/thedges/PSCommon) packages first

* This component can be dropped on any sobject
* The component configuration fields are (only provide one value for either contentId, field or filename):
  - <b>Photo Source</b> - 3 options: 'Content ID' where you select the content document id; 'SObject Field' where a field (typcially formula field) on the object will specify the content document id; and 'Attached Filename' where you provide a filename which the component will display latest version of that file
  - <b>Photo Source Value</b> - the photo source value depending on the choice selected: a content id, an SObject field API name, or a filename string
  - <b>Default Content Document URL</b> - the default URL to an image file that will show if the component cannot find an image based on the provided parameters
 
<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
