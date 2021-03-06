USE [SQLMonitor]
GO

IF OBJECT_ID(N'[Reporting].[uspReportServerInformation]') IS NOT NULL
DROP PROCEDURE [Reporting].[uspReportServerInformation]
GO

CREATE PROCEDURE [Reporting].[uspReportServerInformation]
    @TabularReport bit = 1,
    @HTMLOutput xml = '' OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM [Monitor].[ServerInfo] AS ServerInfo WHERE ServerInfo.RecordStatus = 'A'
        )
    BEGIN
        IF (@TabularReport = 1)
        BEGIN
            SELECT 
                ServerName, ProductVersion, ProductLevel, ResourceLastUpdateDateTime, ResourceVersion, 
                ServerAuthentication, Edition, InstanceName, ComputerNamePhysicalNetBIOS, BuildClrVersion, 
                Collation, IsClustered, IsFullTextInstalled, SqlCharSetName, SqlSortOrderName, SqlRootPath, 
                Product, [Language], [Platform], LogicalProcessors, OSVersion, TotalMemoryMB
            FROM [Monitor].[ServerInfo] AS ServerInfo
            WHERE ServerInfo.RecordStatus = 'A'
            ORDER BY 
                CASE 
                    WHEN [ServerName] LIKE 'CFS%' THEN 1 
                    WHEN [ServerName] LIKE 'STG%' THEN 2 
                    WHEN [ServerName] LIKE 'DEV%' THEN 3 
                    ELSE 4 
                END;
        END
        ELSE
        BEGIN
            SET @HTMLOutput =
                N'<H2>Server Information</H2>' +
                N'<table border="1">' +
                N'<thead><tr>' +
                    '<th align="left">ServerName</th>' +
                    '<th align="left">ProductVersion</th>' +
                    '<th align="left">ProductLevel</th>' +
                    '<th align="left">ResourceLastUpdateDateTime</th>' +
                    '<th align="left">ResourceVersion</th>' +
                    '<th align="left">ServerAuthentication</th>' +
                    '<th align="left">Edition</th>' +
                    '<th align="left">InstanceName</th>' +
                    '<th align="left">ComputerNamePhysicalNetBIOS</th>' +
                    '<th align="left">BuildClrVersion</th>' +
                    '<th align="left">Collation</th>' +
                    '<th align="left">IsClustered</th>' +
                    '<th align="left">IsFullTextInstalled</th>' +
                    '<th align="left">SqlCharSetName</th>' +
                    '<th align="left">SqlSortOrderName</th>' +
                    '<th align="left">SqlRootPath</th>' +
                    '<th align="left">Product</th>' +
                    '<th align="left">Language</th>' +
                    '<th align="left">Platform</th>' +
                    '<th align="left">LogicalProcessors</th>' +
                    '<th align="left">OSVersion</th>' +
                    '<th align="left">TotalMemoryMB</th>' +
                N'</tr></thead>' +
                N'<tbody>' +
                CAST ( ( SELECT 
                            td = [ServerName], '', 
                            td = [ProductVersion],  '', 
                            td = [ProductLevel],  '', 
                            td = [ResourceLastUpdateDateTime],  '', 
                            td = [ResourceVersion],  '', 
                            td = [ServerAuthentication],  '', 
                            td = [Edition], '', 
                            td = [InstanceName], '', 
                            td = [ComputerNamePhysicalNetBIOS], '', 
                            td = [BuildClrVersion], '', 
                            td = [Collation], '', 
                            td = [IsClustered], '', 
                            td = [IsFullTextInstalled], '', 
                            td = [SqlCharSetName], '', 
                            td = [SqlSortOrderName], '', 
                            td = [SqlRootPath], '', 
                            td = [Product], '', 
                            td = [Language], '', 
                            td = [Platform], '', 
                            td = [LogicalProcessors], '', 
                            td = [OSVersion], '', 
                            td = [TotalMemoryMB], ''
                        FROM [Monitor].[ServerInfo] AS ServerInfo
                        ORDER BY 
                            CASE 
                                WHEN [ServerName] LIKE 'CFS%' THEN 1 
                                WHEN [ServerName] LIKE 'STG%' THEN 2 
                                WHEN [ServerName] LIKE 'DEV%' THEN 3 
                                ELSE 4 
                            END
                        FOR XML PATH('tr'), TYPE 
                ) AS NVARCHAR(MAX) ) +
                N'</tbody></table><p/>';
        END
    END
    ELSE
    BEGIN
        SET @HTMLOutput = '';
    END

    RETURN 0;
END

GO


USE [master]
GO

/*
USE [SQLMonitor];
DECLARE @emailbody xml = '';
EXEC [Reporting].[uspReportServerInformation] @TabularReport = 0, @HTMLOutput = @emailbody OUTPUT;
SELECT @emailbody AS HTMLOutput;
*/