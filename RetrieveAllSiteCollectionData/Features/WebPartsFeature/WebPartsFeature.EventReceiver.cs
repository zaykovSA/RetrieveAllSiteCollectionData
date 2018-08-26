using System;
using System.Runtime.InteropServices;
using System.Security.Permissions;
using Microsoft.SharePoint;

namespace RetrieveAllSiteCollectionData.Features.WebPartsFeature
{
    [Guid("eb636f96-73cf-41ba-b810-e8d2af57e8a5")]
    public class WebPartsFeatureEventReceiver : SPFeatureReceiver
    {
        public override void FeatureActivated(SPFeatureReceiverProperties properties)
        {

        }
    }
}
