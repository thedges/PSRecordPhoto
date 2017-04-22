global class PSRecordPhotoController {
    public PSRecordPhotoController() {

    }

    @AuraEnabled
    public static String getImageURL(String params) {
        Map<String, String> paramMap = (Map<String, String>)JSON.deserialize(params,   Map<String, String>.class);
        PSResponse resp = new PSResponse();
        String url = paramMap.get('defaultURL');

        String recordId = paramMap.get('recordId');

        try {
            /////////////////////////////////////////////
            // get url for direct content id reference //
            /////////////////////////////////////////////
            if (paramMap.get('contentId') != null) {
                ContentDocument cdoc = [SELECT Id, Title, FileExtension, FileType, Description, LatestPublishedVersionId
                                        FROM ContentDocument
                                        WHERE id = :paramMap.get('contentId')];
                url = '/sfc/servlet.shepherd/version/download/' + cdoc.LatestPublishedVersionId;
                ////////////////////////////////////////////////////////////////////
                // get url for based on field (typically formula field) on record //
                ////////////////////////////////////////////////////////////////////
            } else if (paramMap.get('field') != null) {
                Id recId = Id.valueOf(recordId);
                Schema.SObjectType token = recId.getSObjectType();
                Schema.DescribeSObjectResult dr = token.getDescribe();

                String queryStr = 'SELECT Id, ' + paramMap.get('field') + ' FROM ' + dr.getName() + ' WHERE Id=\'' + recordId + '\' LIMIT 1';

                SObject obj = Database.query(queryStr);
                String conDocId = (String)obj.get(paramMap.get('field'));

                ContentDocument cdoc = [SELECT Id, Title, FileExtension, FileType, Description, LatestPublishedVersionId
                                        FROM ContentDocument
                                        WHERE id = :conDocId];

                url = '/sfc/servlet.shepherd/version/download/' + cdoc.LatestPublishedVersionId;

                ///////////////////////////////
                // get url based on filename //
                ///////////////////////////////
            } else if (paramMap.get('filename') != null) {
                String f = paramMap.get('filename').trim();
                String filename = null;
                String ext = null;
                if (f.indexOf('.') == -1) {
                    filename = f;
                } else {
                    filename = f.substringBeforeLast('.');
                    ext = f.substringAfterLast('.');
                }

                System.debug('filename=' + filename);
                System.debug('ext=' + ext);

                List<ContentDocumentLink> cdlList = [SELECT Id, ContentDocumentId, ShareType, SystemModstamp, Visibility
                                                     FROM ContentDocumentLink
                                                     WHERE LinkedEntityId = :recordId];

                List<Id> idList = new List<Id>();
                for (ContentDocumentLink cdl : cdlList) {
                    System.debug('adding id=' + cdl.ContentDocumentId);
                    idList.add(cdl.ContentDocumentId);
                }

                ContentDocument cdoc = null;

                if (ext == null) {
                    cdoc = [SELECT Id, Title, FileExtension, FileType, Description, LatestPublishedVersionId
                            FROM ContentDocument
                            WHERE id IN :idList AND title = :filename LIMIT 1];
                } else {
                    cdoc = [SELECT Id, Title, FileExtension, FileType, Description, LatestPublishedVersionId
                            FROM ContentDocument
                            WHERE id IN :idList AND title = :filename AND FileExtension = :ext LIMIT 1];
                }

                url = '/sfc/servlet.shepherd/version/download/' + cdoc.LatestPublishedVersionId;
            }

            resp.data = url;
        } catch (exception e) {
            resp.status = PSResponse.ERROR;
            resp.msg = e.getMessage();
            resp.data = url;
        }

        return  JSON.serialize(resp);
    }
}