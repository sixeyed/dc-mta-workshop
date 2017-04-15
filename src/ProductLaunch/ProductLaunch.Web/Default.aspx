<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ProductLaunch.Web._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>Have you tried Image2Docker?</h1>
        <p class="lead">Image2Docker - tools for extracting apps from VMs into Dockerfiles.</p>
    </div>

    <div class="row">
        <div class="col-md-8">
            <h2>Automatically migrate workloads to Docker</h2>
            <p>
                Image2Docker is your first step in lifting and shifting existing worrkloads to Docker, without changing code. They&#39;re open source tools which come in Linux and Windows variants.</p>
            <p>
                Currently the tools are focused on Web workloads, so you can extract LAMP apps from Linux, and ASP.NET apps from Windows - straight into Dockerfiles. </p>
            <p>
                <a class="btn btn-default" href="https://www.docker.com/enterprise">Check out Image2Docker for Linux</a> | 
                <a class="btn btn-default" href="https://www.docker.com/enterprise">Check out Image2Docker for Windows</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Interested? Get the newsletter!</h2>
            <p>
                Give us your details and we&#39;ll keep you posted.</p>
            <p>
                It only takes 30 seconds to sign up.
            </p>
            <p>
                And we probably won't spam you very much.
            </p>
            <p>
                <a class="btn btn btn-primary btn-lg" href="SignUp.aspx">Sign Up &raquo;</a>
            </p>
        </div>
    </div>

</asp:Content>
