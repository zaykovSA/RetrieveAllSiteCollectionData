using Microsoft.SharePoint;
using Microsoft.SharePoint.Publishing;
using Microsoft.SharePoint.Utilities;
using System;
using System.Collections;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RetrieveAllSiteCollectionData.SiteCollectionFilterDataWP
{
    public partial class SiteCollectionFilterDataWPUserControl : UserControl
    {
        private const string websSearch = "<Webs Scope='SiteCollection' />";
        private const string listsSearch = "<Lists ServerTemplate=\"101\" />";
        private const string viewFieldsSearch = "<FieldRef Name=\"Title\"></FieldRef><FieldRef Name=\"Announcement\"></FieldRef><FieldRef Name=\"PagesCount\"></FieldRef>";
        private const string searchContentType = "0x0101007539449A8E8A43C3A926972C7D2D29ED";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack) return;
            CssScriptLink.Text = "<link rel=\"Stylesheet\" type=\"text/css\" href=\"" + SPUtility.MakeBrowserCacheSafeLayoutsUrl("RetrieveAllSiteCollectionData/CSS/SiteCollectionItemsSearch.css", false) + "\" />";
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            var searchTitle = TitleSearch.Text;
            var searchDescription = DescriptionSearch.Text;
            var searchPageCount = PagesCountSearch.Text;

            var searchTitleTemplate = $"<Contains><FieldRef Name='Title'></FieldRef><Value Type='Text'>{searchTitle}</Value></Contains>";
            var searchDescriptionTemplate = $"<Contains><FieldRef Name='Announcement'></FieldRef><Value Type='Text'>{searchDescription}</Value></Contains>";
            var searchPageCountTemplate = $"<Eq><FieldRef Name='PagesCount'></FieldRef><Value Type='Number'>{searchPageCount}</Value></Eq>";

            var propsSearchArr = new Stack();
            var totalSearchParamsCount = 0;

            if (!string.IsNullOrEmpty(searchTitle))
            {
                totalSearchParamsCount++;
                propsSearchArr.Push(searchTitleTemplate);
            }
            if (!string.IsNullOrEmpty(searchDescription))
            {
                totalSearchParamsCount++;
                propsSearchArr.Push(searchDescriptionTemplate);
            }
            if (!string.IsNullOrEmpty(searchPageCount))
            {
                totalSearchParamsCount++;
                propsSearchArr.Push(searchPageCountTemplate);
            }

            var camlQuery = string.Concat("<Where>",
                totalSearchParamsCount > 0 ? "<And>" : "",
                totalSearchParamsCount > 1 ? "<And>" : "",
                "<BeginsWith>",
                "<FieldRef Name='ContentTypeId'></FieldRef>",
                "<Value Type='ContentTypeId'>", searchContentType, "</Value>",
                "</BeginsWith>",
                totalSearchParamsCount > 0 ? propsSearchArr.Pop() : "",
                totalSearchParamsCount > 0 ? "</And>" : "",
                totalSearchParamsCount > 2 ? "<And>" : "",
                totalSearchParamsCount > 1 ? propsSearchArr.Pop() : "",
                totalSearchParamsCount > 2 ? propsSearchArr.Pop() : "",
                totalSearchParamsCount > 1 ? "</And>" : "",
                totalSearchParamsCount > 2 ? "</And>" : "",
                "</Where>",
                "<OrderBy>",
                "<FieldRef Name='Modified' Ascending='FALSE' />",
                "</OrderBy>");

            var siteQuery = new CrossListQueryInfo();
            siteQuery.Lists = listsSearch;
            siteQuery.Query = camlQuery;
            siteQuery.ViewFields = viewFieldsSearch;
            siteQuery.Webs = websSearch;
            siteQuery.UseCache = false;

            var siteQueryCache = new CrossListQueryCache(siteQuery);

            var results = siteQueryCache.GetSiteData(SPContext.Current.Site);
            foreach (DataRow row in results.Rows)
                row["PagesCount"] = row["PagesCount"].ToString().Split(new[] { "." }, StringSplitOptions.RemoveEmptyEntries)[0];
            for (var i = results.Columns.Count - 1; i >= 0; i--)
            {
                switch (results.Columns[i].ColumnName)
                {
                    case "Title":
                    case "Announcement":
                    case "PagesCount":
                        break;
                    default:
                        results.Columns.RemoveAt(i);
                        break;
                }
            }            

            ResultDocuments.DataSource = results;
            ResultDocuments.DataBind();
        }
    }
}
