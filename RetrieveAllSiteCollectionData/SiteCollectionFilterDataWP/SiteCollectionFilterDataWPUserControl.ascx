<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %> 
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SiteCollectionFilterDataWPUserControl.ascx.cs" Inherits="RetrieveAllSiteCollectionData.SiteCollectionFilterDataWP.SiteCollectionFilterDataWPUserControl" %>

<asp:Literal ID="CssScriptLink" runat="server"></asp:Literal>

<SharePoint:ScriptLink ID="JqueryScriptLink" language="javascript" runat="server" name="RetrieveAllSiteCollectionData/JS/jquery-2.2.4.min.js"></SharePoint:ScriptLink>
<SharePoint:ScriptLink ID="CustomScriptLink" language="javascript" runat="server" name="RetrieveAllSiteCollectionData/JS/SiteCollectionItemsSearch.js"></SharePoint:ScriptLink>

<div class="webPartBlock">
    <div class="searchBlock">
        <div class="searchBlockRow">
            <div class="input-container">
                <asp:TextBox ID="TitleSearch" runat="server" ClientIDMode="Static" CssClass="searchInput"></asp:TextBox>
                <label for="TitleSearch" unselectable="on">Название для поиска</label>
            </div>
        </div>
        <div class="searchBlockRow">
            <div class="input-container">
                <asp:TextBox ID="DescriptionSearch" runat="server" ClientIDMode="Static" CssClass="searchInput"></asp:TextBox>
                <label for="DescriptionSearch" unselectable="on">Описание для поиска</label>
            </div>
        </div>
        <div class="searchBlockRow">
            <div class="input-container">
                <asp:TextBox ID="PagesCountSearch" TextMode="Number" runat="server" ClientIDMode="Static" CssClass="searchInput"></asp:TextBox>
                <label for="PagesCountSearch" unselectable="on">Количество страниц для поиска</label>
            </div>
        </div>
        <div class="searchBlockRow">
            <asp:LinkButton ID="SearchButton" runat="server" OnClick="SearchButton_Click" CssClass="searchButton" Text="Найти"/>
        </div>
    </div>
    <div class="resultsBlock">
        <asp:GridView ID="ResultDocuments" runat="server" CssClass="resultTable"></asp:GridView>
    </div>
</div>