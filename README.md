# PSRecordPhoto
THIS SOFTWARE IS COVERED BY [THIS DISCLAIMER](https://raw.githubusercontent.com/thedges/Disclaimer/master/disclaimer.txt).

Demo component to show a related photo attachment on the record. Primary use cases could be to show certification, driver license picture, or asset image.

The component has following configuration options:
  1. <b>Photo Source</b> - this defines the source of the image to show:
     * SObject Field - a field on the SObject will contain the content id of the image to show
     * Content ID - provide a specific content id for the image to display. 
     * Attached Filename - contains the filename of a "chatter file" attached to the record. 
  2. <b>Photo Source Value</b> - value for the configuration selection chosen above. Values would be for corresponding photo source are:
     * SObject Field - the SObject field api name. Example would be "driver_lic_photo__c"
     * Content ID - This should be the ID field from the ContentDocument table. This content id values should start with '069'.
     * Attached Filename - Do not include file extension. So a file named "driver-license.jpg", you should just specific "driver-license".
  3. <b>Photo Height</b> - optional integer value to set image height (in pixels_
  4. <b>Default Content Document URL</b> - a URL to an image to show as default image if configuration doesn't result in a found image. Typically would use a static resource related URL of format "/resource/<static-resource-name>".

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
