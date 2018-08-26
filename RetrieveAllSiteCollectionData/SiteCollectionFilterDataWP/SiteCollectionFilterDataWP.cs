using System.ComponentModel;
using System.Web.UI;
using System.Web.UI.WebControls.WebParts;

namespace RetrieveAllSiteCollectionData.SiteCollectionFilterDataWP
{
    [ToolboxItem(false)]
    public class SiteCollectionFilterDataWP : WebPart
    {
        private const string _ascxPath = @"~/_CONTROLTEMPLATES/15/RetrieveAllSiteCollectionData/SiteCollectionFilterDataWP/SiteCollectionFilterDataWPUserControl.ascx";

        protected override void CreateChildControls()
        {
            Control control = Page.LoadControl(_ascxPath);
            Controls.Add(control);
        }
    }
}