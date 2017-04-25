global class PSRecordPhotoController
{
  public PSRecordPhotoController()
  {

  }

  @AuraEnabled
  public static String getImageURL(String params)
  {
    Map<String, String> paramMap = (Map<String, String>)JSON.deserialize(params,   Map<String, String>.class);
    PSResponse resp = new PSResponse();
    String url = paramMap.get('defaultURL');
    String recordId = paramMap.get('recordId');

    try
    {
      String source = paramMap.get('source');

      /////////////////////////////////////////////
      // get url for direct content id reference //
      /////////////////////////////////////////////
      if (source == 'Content ID')
      {
        ContentDocument cdoc = [SELECT Id, Title, FileExtension, FileType, Description, LatestPublishedVersionId
                                FROM ContentDocument
                                WHERE id = :paramMap.get('sourceValue')];
        url = '/sfc/servlet.shepherd/version/download/' + cdoc.LatestPublishedVersionId;

      }
      ////////////////////////////////////////////////////////////////////
      // get url for based on field (typically formula field) on record //
      ////////////////////////////////////////////////////////////////////
      else if (source == 'SObject Field')
      {
        Id recId = Id.valueOf(recordId);
        Schema.SObjectType token = recId.getSObjectType();
        Schema.DescribeSObjectResult dr = token.getDescribe();

        String queryStr = 'SELECT Id, ' + paramMap.get('sourceValue') + ' FROM ' + dr.getName() + ' WHERE Id=\'' + recordId + '\' LIMIT 1';

        SObject obj = Database.query(queryStr);
        String conDocId = (String)obj.get(paramMap.get('sourceValue'));

        ContentDocument cdoc = [SELECT Id, Title, FileExtension, FileType, Description, LatestPublishedVersionId
                                FROM ContentDocument
                                WHERE id = :conDocId];

        url = '/sfc/servlet.shepherd/version/download/' + cdoc.LatestPublishedVersionId;


      }
      ///////////////////////////////
      // get url based on filename //
      ///////////////////////////////
      else if (source == 'Attached Filename')
      {
        String f = paramMap.get('sourceValue').trim();
        String filename = null;
        String ext = null;
        if (f.indexOf('.') == -1)
        {
          filename = f;
        }
        else
        {
          filename = f.substringBeforeLast('.');
          ext = f.substringAfterLast('.');
        }

        System.debug('filename=' + filename);
        System.debug('ext=' + ext);

        List<ContentDocumentLink> cdlList = [SELECT Id, ContentDocumentId, ShareType, SystemModstamp, Visibility
                                             FROM ContentDocumentLink
                                             WHERE LinkedEntityId = :recordId];

        List<Id> idList = new List<Id>();
        for (ContentDocumentLink cdl : cdlList)
        {
          System.debug('adding id=' + cdl.ContentDocumentId);
          idList.add(cdl.ContentDocumentId);
        }

        ContentDocument cdoc = null;

        if (ext == null)
        {
          cdoc = [SELECT Id, Title, FileExtension, FileType, Description, LatestPublishedVersionId
                  FROM ContentDocument
                  WHERE id IN :idList AND title = :filename LIMIT 1];
        }
        else
        {
          cdoc = [SELECT Id, Title, FileExtension, FileType, Description, LatestPublishedVersionId
                  FROM ContentDocument
                  WHERE id IN :idList AND title = :filename AND FileExtension = :ext LIMIT 1];
        }

        url = '/sfc/servlet.shepherd/version/download/' + cdoc.LatestPublishedVersionId;
      }

      resp.data = url;
    }
    catch (exception e)
    {
      resp.status = PSResponse.ERROR;
      resp.msg = e.getMessage();
      resp.data = url;
    }

    return  JSON.serialize(resp);
  }
}