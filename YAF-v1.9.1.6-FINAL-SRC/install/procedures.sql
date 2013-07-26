/*
  YAF SQL Stored Procedures File Created 05/15/07
	

  Remove Comments RegEx: \/\*(.*)\*\/
  Remove Extra Stuff: SET ANSI_NULLS ON\nGO\nSET QUOTED_IDENTIFIER ON\nGO\n\n\n 
*/

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_accessmask_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_accessmask_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_accessmask_delete](
                @AccessMaskID INT)
AS
    BEGIN
        DECLARE  @flag INT
        SET @flag = 1
        IF EXISTS (SELECT 1
                   FROM   yaf_ForumAccess
                   WHERE  AccessMaskID = @AccessMaskID)
            OR EXISTS (SELECT 1
                       FROM   yaf_UserForum
                       WHERE  AccessMaskID = @AccessMaskID)
        SET @flag = 0
        ELSE
        DELETE FROM yaf_AccessMask
        WHERE       AccessMaskID = @AccessMaskID
        SELECT @flag
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_accessmask_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_accessmask_list] 
GO

CREATE PROCEDURE [dbo].[yaf_accessmask_list](
                @BoardID      INT,
                @AccessMaskID INT  = NULL)
AS
    BEGIN
        IF @AccessMaskID IS NULL
        SELECT   a.*
        FROM     yaf_AccessMask a
        WHERE    a.BoardID = @BoardID
        ORDER BY a.Name
        ELSE
        SELECT   a.*
        FROM     yaf_AccessMask a
        WHERE    a.BoardID = @BoardID
        AND a.AccessMaskID = @AccessMaskID
        ORDER BY a.Name
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_accessmask_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_accessmask_save] 
GO

CREATE PROCEDURE [dbo].[yaf_accessmask_save](
                @AccessMaskID    INT  = NULL,
                @BoardID         INT,
                @Name            NVARCHAR(50),
                @ReadAccess      BIT,
                @PostAccess      BIT,
                @ReplyAccess     BIT,
                @PriorityAccess  BIT,
                @PollAccess      BIT,
                @VoteAccess      BIT,
                @ModeratorAccess BIT,
                @EditAccess      BIT,
                @DeleteAccess    BIT,
                @UploadAccess    BIT)
AS
    BEGIN
        DECLARE  @Flags INT
        SET @Flags = 0
        IF @ReadAccess <> 0
        SET @Flags = @Flags | 1
        IF @PostAccess <> 0
        SET @Flags = @Flags | 2
        IF @ReplyAccess <> 0
        SET @Flags = @Flags | 4
        IF @PriorityAccess <> 0
        SET @Flags = @Flags | 8
        IF @PollAccess <> 0
        SET @Flags = @Flags | 16
        IF @VoteAccess <> 0
        SET @Flags = @Flags | 32
        IF @ModeratorAccess <> 0
        SET @Flags = @Flags | 64
        IF @EditAccess <> 0
        SET @Flags = @Flags | 128
        IF @DeleteAccess <> 0
        SET @Flags = @Flags | 256
        IF @UploadAccess <> 0
        SET @Flags = @Flags | 512
        IF @AccessMaskID IS NULL
        INSERT INTO yaf_AccessMask
                   (Name,
                    BoardID,
                    Flags)
        VALUES     (@Name,
                    @BoardID,
                    @Flags)
        ELSE
        UPDATE yaf_AccessMask
        SET    Name = @Name,
               Flags = @Flags
        WHERE  AccessMaskID = @AccessMaskID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_active_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_active_list] 
GO

CREATE PROCEDURE [dbo].[yaf_active_list](
                @BoardID INT,
                @Guests  BIT  = 0)
AS
    BEGIN
        -- delete non-active
        DELETE FROM yaf_Active
        WHERE       Datediff(MINUTE,LastActive,Getdate()) > 5
        -- select active
        IF @Guests <> 0
        SELECT   a.UserID,
                 a.Name,
                 c.IP,
                 c.SessionID,
                 c.ForumID,
                 c.TopicID,
                 ForumName = (SELECT Name
                              FROM   yaf_Forum x
                              WHERE  x.ForumID = c.ForumID),
                 TopicName = (SELECT Topic
                              FROM   yaf_Topic x
                              WHERE  x.TopicID = c.TopicID),
                 IsGuest = (SELECT 1
                            FROM   yaf_UserGroup x,
                                   yaf_Group y
                            WHERE  x.UserID = a.UserID
                            AND y.GroupID = x.GroupID
                            AND (y.Flags & 2) <> 0),
                 c.Login,
                 c.LastActive,
                 c.Location,
                 Active = Datediff(MINUTE,c.Login,c.LastActive),
                 c.Browser,
                 c.Platform
        FROM     yaf_User a,
                 yaf_Active c
        WHERE    c.UserID = a.UserID
        AND c.BoardID = @BoardID
        ORDER BY c.LastActive DESC
        ELSE
        SELECT   a.UserID,
                 a.Name,
                 c.IP,
                 c.SessionID,
                 c.ForumID,
                 c.TopicID,
                 ForumName = (SELECT Name
                              FROM   yaf_Forum x
                              WHERE  x.ForumID = c.ForumID),
                 TopicName = (SELECT Topic
                              FROM   yaf_Topic x
                              WHERE  x.TopicID = c.TopicID),
                 IsGuest = (SELECT 1
                            FROM   yaf_UserGroup x,
                                   yaf_Group y
                            WHERE  x.UserID = a.UserID
                            AND y.GroupID = x.GroupID
                            AND (y.Flags & 2) <> 0),
                 c.Login,
                 c.LastActive,
                 c.Location,
                 Active = Datediff(MINUTE,c.Login,c.LastActive),
                 c.Browser,
                 c.Platform
        FROM     yaf_User a,
                 yaf_Active c
        WHERE    c.UserID = a.UserID
        AND c.BoardID = @BoardID
        AND NOT EXISTS (SELECT 1
                        FROM   yaf_UserGroup x,
                               yaf_Group y
                        WHERE  x.UserID = a.UserID
                        AND y.GroupID = x.GroupID
                        AND (y.Flags & 2) <> 0)
        ORDER BY c.LastActive DESC
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_active_listforum]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_active_listforum] 
GO

CREATE PROCEDURE [dbo].[yaf_active_listforum](
                @ForumID INT)
AS
    BEGIN
        SELECT   UserID = a.UserID,
                 UserName = b.Name
        FROM     yaf_Active a
                 JOIN yaf_User b
                   ON b.UserID = a.UserID
        WHERE    a.ForumID = @ForumID
        GROUP BY a.UserID,b.Name
        ORDER BY b.Name
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_active_listtopic]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_active_listtopic] 
GO

CREATE PROCEDURE [dbo].[yaf_active_listtopic](
                @TopicID INT)
AS
    BEGIN
        SELECT   UserID = a.UserID,
                 UserName = b.Name
        FROM     yaf_Active a WITH (nolock)
                 JOIN yaf_User b
                   ON b.UserID = a.UserID
        WHERE    a.TopicID = @TopicID
        GROUP BY a.UserID,b.Name
        ORDER BY b.Name
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_active_stats]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_active_stats] 
GO

CREATE PROCEDURE [dbo].[yaf_active_stats](
                @BoardID INT)
AS
    BEGIN
        SELECT ActiveUsers = (SELECT COUNT(1)
                              FROM   yaf_Active
                              WHERE  BoardID = @BoardID),
               ActiveMembers = (SELECT COUNT(1)
                                FROM   yaf_Active x
                                WHERE  BoardID = @BoardID
                                AND EXISTS (SELECT 1
                                            FROM   yaf_UserGroup y,
                                                   yaf_Group z
                                            WHERE  y.UserID = x.UserID
                                            AND y.GroupID = z.GroupID
                                            AND (z.Flags & 2) = 0)),
               ActiveGuests = (SELECT COUNT(1)
                               FROM   yaf_Active x
                               WHERE  BoardID = @BoardID
                               AND EXISTS (SELECT 1
                                           FROM   yaf_UserGroup y,
                                                  yaf_Group z
                                           WHERE  y.UserID = x.UserID
                                           AND y.GroupID = z.GroupID
                                           AND (z.Flags & 2) <> 0))
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_attachment_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_attachment_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_attachment_delete](
                @AttachmentID INT)
AS
    BEGIN
        DELETE FROM yaf_Attachment
        WHERE       AttachmentID = @AttachmentID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_attachment_download]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_attachment_download] 
GO

CREATE PROCEDURE [dbo].[yaf_attachment_download](
                @AttachmentID INT)
AS
    BEGIN
        UPDATE yaf_Attachment
        SET    Downloads = Downloads + 1
        WHERE  AttachmentID = @AttachmentID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_attachment_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_attachment_list] 
GO

CREATE PROCEDURE [dbo].[yaf_attachment_list](
                @MessageID    INT  = NULL,
                @AttachmentID INT  = NULL,
                @BoardID      INT  = NULL)
AS
    BEGIN
        IF @MessageID IS NOT NULL
        SELECT *
        FROM   yaf_Attachment
        WHERE  MessageID = @MessageID
        ELSE
        IF @AttachmentID IS NOT NULL
        SELECT *
        FROM   yaf_Attachment
        WHERE  AttachmentID = @AttachmentID
        ELSE
        SELECT   a.*,
                 Posted = b.Posted,
                 ForumID = d.ForumID,
                 ForumName = d.Name,
                 TopicID = c.TopicID,
                 TopicName = c.Topic
        FROM     yaf_Attachment a,
                 yaf_Message b,
                 yaf_Topic c,
                 yaf_Forum d,
                 yaf_Category e
        WHERE    b.MessageID = a.MessageID
        AND c.TopicID = b.TopicID
        AND d.ForumID = c.ForumID
        AND e.CategoryID = d.CategoryID
        AND e.BoardID = @BoardID
        ORDER BY d.Name,
                 c.Topic,
                 b.Posted
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_attachment_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_attachment_save] 
GO

CREATE PROCEDURE [dbo].[yaf_attachment_save](
                @MessageID   INT,
                @FileName    NVARCHAR(50),
                @Bytes       INT,
                @ContentType NVARCHAR(50)  = NULL,
                @FileData    IMAGE  = NULL)
AS
    BEGIN
        INSERT INTO yaf_Attachment
                   (MessageID,
                    FileName,
                    Bytes,
                    ContentType,
                    Downloads,
                    FileData)
        VALUES     (@MessageID,
                    @FileName,
                    @Bytes,
                    @ContentType,
                    0,
                    @FileData)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_bannedip_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_bannedip_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_bannedip_delete](
                @ID INT)
AS
    BEGIN
        DELETE FROM yaf_BannedIP
        WHERE       ID = @ID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_bannedip_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_bannedip_list] 
GO

CREATE PROCEDURE [dbo].[yaf_bannedip_list](
                @BoardID INT,
                @ID      INT  = NULL)
AS
    BEGIN
        IF @ID IS NULL
        SELECT *
        FROM   yaf_BannedIP
        WHERE  BoardID = @BoardID
        ELSE
        SELECT *
        FROM   yaf_BannedIP
        WHERE  BoardID = @BoardID
        AND ID = @ID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_bannedip_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_bannedip_save] 
GO

CREATE PROCEDURE [dbo].[yaf_bannedip_save](
                @ID      INT  = NULL,
                @BoardID INT,
                @Mask    NVARCHAR(15))
AS
    BEGIN
        IF @ID IS NULL 
            OR @ID = 0
        BEGIN
            INSERT INTO yaf_BannedIP
                       (BoardID,
                        Mask,
                        Since)
            VALUES     (@BoardID,
                        @Mask,
                        Getdate())
        END
        ELSE
        BEGIN
            UPDATE yaf_BannedIP
            SET    Mask = @Mask
            WHERE  ID = @ID
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_board_create]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_board_create] 
GO

CREATE PROCEDURE [dbo].[yaf_board_create](
                @BoardName     NVARCHAR(50),
                @AllowThreaded BIT,
                @UserName      NVARCHAR(50),
                @UserEmail     NVARCHAR(50),
                @UserPass      NVARCHAR(32),
                @IsHostAdmin   BIT)
AS
    BEGIN
        DECLARE  @BoardID INT
        DECLARE  @TimeZone INT
        DECLARE  @ForumEmail NVARCHAR(50)
        DECLARE  @GroupIDAdmin INT
        DECLARE  @GroupIDGuest INT
        DECLARE  @GroupIDMember INT
        DECLARE  @AccessMaskIDAdmin INT
        DECLARE  @AccessMaskIDModerator INT
        DECLARE  @AccessMaskIDMember INT
        DECLARE  @AccessMaskIDReadOnly INT
        DECLARE  @UserIDAdmin INT
        DECLARE  @UserIDGuest INT
        DECLARE  @RankIDAdmin INT
        DECLARE  @RankIDGuest INT
        DECLARE  @RankIDNewbie INT
        DECLARE  @RankIDMember INT
        DECLARE  @RankIDAdvanced INT
        DECLARE  @CategoryID INT
        DECLARE  @ForumID INT
        DECLARE  @UserFlags INT
        SET @TimeZone = (SELECT CAST(CAST([Value] AS NVARCHAR(50)) AS INT)
                         FROM   yaf_Registry
                         WHERE  Lower([Name]) = Lower('TimeZone'))
        SET @ForumEmail = (SELECT CAST([Value] AS NVARCHAR(50))
                           FROM   yaf_Registry
                           WHERE  Lower([Name]) = Lower('ForumEmail'))
        -- yaf_Board
        INSERT INTO yaf_Board
                   (Name,
                    AllowThreaded)
        VALUES     (@BoardName,
                    @AllowThreaded)
        SET @BoardID = Scope_identity()
        -- yaf_Rank
        INSERT INTO yaf_Rank
                   (BoardID,
                    Name,
                    Flags,
                    MinPosts)
        VALUES     (@BoardID,
                    'Administration',
                    0,
                    NULL)
        SET @RankIDAdmin = Scope_identity()
        INSERT INTO yaf_Rank
                   (BoardID,
                    Name,
                    Flags,
                    MinPosts)
        VALUES     (@BoardID,
                    'Guest',
                    0,
                    NULL)
        SET @RankIDGuest = Scope_identity()
        INSERT INTO yaf_Rank
                   (BoardID,
                    Name,
                    Flags,
                    MinPosts)
        VALUES     (@BoardID,
                    'Newbie',
                    3,
                    0)
        SET @RankIDNewbie = Scope_identity()
        INSERT INTO yaf_Rank
                   (BoardID,
                    Name,
                    Flags,
                    MinPosts)
        VALUES     (@BoardID,
                    'Member',
                    2,
                    10)
        SET @RankIDMember = Scope_identity()
        INSERT INTO yaf_Rank
                   (BoardID,
                    Name,
                    Flags,
                    MinPosts)
        VALUES     (@BoardID,
                    'Advanced Member',
                    2,
                    30)
        SET @RankIDAdvanced = Scope_identity()
        -- yaf_AccessMask
        INSERT INTO yaf_AccessMask
                   (BoardID,
                    Name,
                    Flags)
        VALUES     (@BoardID,
                    'Admin Access Mask',
                    1023)
        SET @AccessMaskIDAdmin = Scope_identity()
        INSERT INTO yaf_AccessMask
                   (BoardID,
                    Name,
                    Flags)
        VALUES     (@BoardID,
                    'Moderator Access Mask',
                    487)
        SET @AccessMaskIDModerator = Scope_identity()
        INSERT INTO yaf_AccessMask
                   (BoardID,
                    Name,
                    Flags)
        VALUES     (@BoardID,
                    'Member Access Mask',
                    423)
        SET @AccessMaskIDMember = Scope_identity()
        INSERT INTO yaf_AccessMask
                   (BoardID,
                    Name,
                    Flags)
        VALUES     (@BoardID,
                    'Read Only Access Mask',
                    1)
        SET @AccessMaskIDReadOnly = Scope_identity()
        -- yaf_Group
        INSERT INTO yaf_Group
                   (BoardID,
                    Name,
                    Flags)
        VALUES     (@BoardID,
                    'Administration',
                    1)
        SET @GroupIDAdmin = Scope_identity()
        INSERT INTO yaf_Group
                   (BoardID,
                    Name,
                    Flags)
        VALUES     (@BoardID,
                    'Guest',
                    2)
        SET @GroupIDGuest = Scope_identity()
        INSERT INTO yaf_Group
                   (BoardID,
                    Name,
                    Flags)
        VALUES     (@BoardID,
                    'Member',
                    4)
        SET @GroupIDMember = Scope_identity()
        SET @UserFlags = 2
        -- yaf_User
        INSERT INTO yaf_User
                   (BoardID,
                    RankID,
                    Name,
                    Password,
                    Joined,
                    LastVisit,
                    NumPosts,
                    TimeZone,
                    Email,
                    Gender,
                    Flags)
        VALUES     (@BoardID,
                    @RankIDGuest,
                    'Guest',
                    'na',
                    Getdate(),
                    Getdate(),
                    0,
                    @TimeZone,
                    @ForumEmail,
                    0,
                    @UserFlags)
        SET @UserIDGuest = Scope_identity()
        IF @IsHostAdmin <> 0
        SET @UserFlags = 3
        INSERT INTO yaf_User
                   (BoardID,
                    RankID,
                    Name,
                    Password,
                    Joined,
                    LastVisit,
                    NumPosts,
                    TimeZone,
                    Email,
                    Gender,
                    Flags)
        VALUES     (@BoardID,
                    @RankIDAdmin,
                    @UserName,
                    @UserPass,
                    Getdate(),
                    Getdate(),
                    0,
                    @TimeZone,
                    @UserEmail,
                    0,
                    @UserFlags)
        SET @UserIDAdmin = Scope_identity()
        -- yaf_UserGroup
        INSERT INTO yaf_UserGroup
                   (UserID,
                    GroupID)
        VALUES     (@UserIDAdmin,
                    @GroupIDAdmin)
        INSERT INTO yaf_UserGroup
                   (UserID,
                    GroupID)
        VALUES     (@UserIDGuest,
                    @GroupIDGuest)
        -- yaf_Category
        INSERT INTO yaf_Category
                   (BoardID,
                    Name,
                    SortOrder)
        VALUES     (@BoardID,
                    'Test Category',
                    1)
        SET @CategoryID = Scope_identity()
        -- yaf_Forum
        INSERT INTO yaf_Forum
                   (CategoryID,
                    Name,
                    Description,
                    SortOrder,
                    NumTopics,
                    NumPosts,
                    Flags)
        VALUES     (@CategoryID,
                    'Test Forum',
                    'A test forum',
                    1,
                    0,
                    0,
                    4)
        SET @ForumID = Scope_identity()
        -- yaf_ForumAccess
        INSERT INTO yaf_ForumAccess
                   (GroupID,
                    ForumID,
                    AccessMaskID)
        VALUES     (@GroupIDAdmin,
                    @ForumID,
                    @AccessMaskIDAdmin)
        INSERT INTO yaf_ForumAccess
                   (GroupID,
                    ForumID,
                    AccessMaskID)
        VALUES     (@GroupIDGuest,
                    @ForumID,
                    @AccessMaskIDReadOnly)
        INSERT INTO yaf_ForumAccess
                   (GroupID,
                    ForumID,
                    AccessMaskID)
        VALUES     (@GroupIDMember,
                    @ForumID,
                    @AccessMaskIDMember)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_board_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_board_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_board_delete](
                @BoardID INT)
AS
    BEGIN
        DECLARE  @tmpForumID INT;
        DECLARE forum_cursor CURSOR  FOR
        SELECT   ForumID
        FROM     yaf_Forum a
                 JOIN yaf_Category b
                   ON a.CategoryID = b.CategoryID
        WHERE    b.BoardID = @BoardID
        ORDER BY ForumID DESC
        OPEN forum_cursor
        FETCH NEXT FROM forum_cursor
        INTO @tmpForumID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC yaf_forum_delete
                 @tmpForumID;
            FETCH NEXT FROM forum_cursor
            INTO @tmpForumID
        END
        CLOSE forum_cursor
        DEALLOCATE forum_cursor
        DELETE FROM yaf_ForumAccess
        WHERE       EXISTS (SELECT 1
                FROM   yaf_Group x
                WHERE  x.GroupID = yaf_ForumAccess.GroupID
                AND x.BoardID = @BoardID)
        DELETE FROM yaf_Forum
        WHERE       EXISTS (SELECT 1
                FROM   yaf_Category x
                WHERE  x.CategoryID = yaf_Forum.CategoryID
                AND x.BoardID = @BoardID)
                
		ALTER TABLE yaf_UserGroup DISABLE TRIGGER ALL

        DELETE FROM yaf_UserGroup
        WHERE       EXISTS (SELECT 1
                FROM   yaf_User x
                WHERE  x.UserID = yaf_UserGroup.UserID
                AND x.BoardID = @BoardID)

		ALTER TABLE yaf_UserGroup ENABLE TRIGGER ALL
                
        DELETE FROM yaf_Category
        WHERE       BoardID = @BoardID
        DELETE FROM yaf_User
        WHERE       BoardID = @BoardID
        DELETE FROM yaf_Rank
        WHERE       BoardID = @BoardID
        DELETE FROM yaf_Group
        WHERE       BoardID = @BoardID
        DELETE FROM yaf_AccessMask
        WHERE       BoardID = @BoardID
        DELETE FROM yaf_Active
        WHERE       BoardID = @BoardID
        DELETE FROM yaf_Board
        WHERE       BoardID = @BoardID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_board_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_board_list] 
GO

CREATE PROCEDURE [dbo].[yaf_board_list](
                @BoardID INT  = NULL)
AS
    BEGIN
        SELECT a.*,
               SQLVersion = @@VERSION
        FROM   yaf_Board a
        WHERE  (@BoardID IS NULL 
          OR a.BoardID = @BoardID)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_board_poststats]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_board_poststats] 
GO

CREATE PROCEDURE [dbo].[yaf_board_poststats](
                @BoardID INT)
AS
    BEGIN
        SELECT Posts = (SELECT COUNT(1)
                        FROM   yaf_Message a
                               JOIN yaf_Topic b
                                 ON b.TopicID = a.TopicID
                               JOIN yaf_Forum c
                                 ON c.ForumID = b.ForumID
                               JOIN yaf_Category d
                                 ON d.CategoryID = c.CategoryID
                        WHERE  d.BoardID = @BoardID  AND (a.Flags & 8)=0),
               Topics = (SELECT COUNT(1)
                         FROM   yaf_Topic a
                                JOIN yaf_Forum b
                                  ON b.ForumID = a.ForumID
                                JOIN yaf_Category c
                                  ON c.CategoryID = b.CategoryID
                         WHERE  c.BoardID = @BoardID AND (a.Flags & 8)=0),
               Forums = (SELECT COUNT(1)
                         FROM   yaf_Forum a
                                JOIN yaf_Category b
                                  ON b.CategoryID = a.CategoryID
                         WHERE  b.BoardID = @BoardID),
               Members = (SELECT COUNT(1)
                          FROM   yaf_User a
                          WHERE  a.BoardID = @BoardID),
               LastPostInfo.*,
               LastMemberInfo.*
        FROM   (SELECT   TOP 1 LastMemberInfoID = 1,
                               LastMemberID = UserID,
                               LastMember = Name
                FROM     yaf_User
                WHERE    dbo.Yaf_bitset(Flags,2) = 1
                AND BoardID = @BoardID
                ORDER BY Joined DESC) AS LastMemberInfo
               LEFT JOIN (SELECT   TOP 1 LastPostInfoID = 1,
                                         LastPost = a.Posted,
                                         LastUserID = a.UserID,
                                         LastUser = e.Name
                          FROM     yaf_Message a
                                   JOIN yaf_Topic b
                                     ON b.TopicID = a.TopicID
                                   JOIN yaf_Forum c
                                     ON c.ForumID = b.ForumID
                                   JOIN yaf_Category d
                                     ON d.CategoryID = c.CategoryID
                                   JOIN yaf_User e
                                     ON e.UserID = a.UserID
                          WHERE    d.BoardID = @BoardID
                          ORDER BY a.Posted DESC) AS LastPostInfo
                 ON LastMemberInfoID = LastPostInfoID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_board_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_board_save] 
GO

CREATE PROCEDURE [dbo].[yaf_board_save](
                @BoardID       INT,
                @Name          NVARCHAR(50),
                @AllowThreaded BIT)
AS
    BEGIN
        UPDATE yaf_Board
        SET    Name = @Name,
               AllowThreaded = @AllowThreaded
        WHERE  BoardID = @BoardID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_board_stats]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_board_stats] 
GO

CREATE PROCEDURE [dbo].[yaf_board_stats]
AS
    BEGIN
        SELECT NumPosts = (SELECT COUNT(1)
                           FROM   yaf_Message
                           WHERE  (Flags & 24) = 16),
               NumTopics = (SELECT COUNT(1)
                            FROM   yaf_Topic),
               NumUsers = (SELECT COUNT(1)
                           FROM   yaf_User
                           WHERE  dbo.Yaf_bitset(Flags,2) <> 0),
               BoardStart = (SELECT MIN(Joined)
                             FROM   yaf_User)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_category_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_category_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_category_delete](
                @CategoryID INT)
AS
    BEGIN
        DECLARE  @flag INT
        IF EXISTS (SELECT 1
                   FROM   yaf_Forum
                   WHERE  CategoryID = @CategoryID)
        BEGIN
            SET @flag = 0
        END
        ELSE
        BEGIN
            DELETE FROM yaf_Category
            WHERE       CategoryID = @CategoryID
            SET @flag = 1
        END
        SELECT @flag
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_category_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_category_list] 
GO

CREATE PROCEDURE [dbo].[yaf_category_list](
                @BoardID    INT,
                @CategoryID INT  = NULL)
AS
    BEGIN
        IF @CategoryID IS NULL
        SELECT   *
        FROM     yaf_Category
        WHERE    BoardID = @BoardID
        ORDER BY SortOrder
        ELSE
        SELECT *
        FROM   yaf_Category
        WHERE  BoardID = @BoardID
        AND CategoryID = @CategoryID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_category_listread]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_category_listread] 
GO

CREATE PROCEDURE [dbo].[yaf_category_listread](
                @BoardID    INT,
                @UserID     INT,
                @CategoryID INT  = NULL)
AS
    BEGIN
        SELECT   a.CategoryID,
                 a.Name
        FROM     yaf_Category a
                 JOIN yaf_Forum b
                   ON b.CategoryID = a.CategoryID
                 JOIN yaf_vaccess v
                   ON v.ForumID = b.ForumID
        WHERE    a.BoardID = @BoardID
        AND v.UserID = @UserID
        AND (v.ReadAccess <> 0
              OR (b.Flags & 2) = 0)
        AND (@CategoryID IS NULL 
              OR a.CategoryID = @CategoryID)
        AND b.ParentID IS NULL
        GROUP BY a.CategoryID,a.Name,a.SortOrder
        ORDER BY a.SortOrder
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_category_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_category_save] 
GO

CREATE PROCEDURE [dbo].[yaf_category_save](
                @BoardID    INT,
                @CategoryID INT,
                @Name       NVARCHAR(128),
                @SortOrder  SMALLINT)
AS
    BEGIN
        IF @CategoryID > 0
        BEGIN
            UPDATE yaf_Category
            SET    Name = @Name,
                   SortOrder = @SortOrder
            WHERE  CategoryID = @CategoryID
            SELECT CategoryID = @CategoryID
        END
        ELSE
        BEGIN
            INSERT INTO yaf_Category
                       (BoardID,
                        [Name],
                        SortOrder)
            VALUES     (@BoardID,
                        @Name,
                        @SortOrder)
            SELECT CategoryID = Scope_identity()
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_checkemail_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_checkemail_save] 
GO

CREATE PROCEDURE [dbo].[yaf_checkemail_save](
                @UserID INT,
                @Hash   NVARCHAR(32),
                @Email  NVARCHAR(50))
AS
    BEGIN
         INSERT INTO yaf_CheckEmail (UserID, Email, Created, Hash) VALUES (@UserID , @Email, getdate(), @Hash)
    END
GO    

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_checkemail_update]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_checkemail_update] 
GO

CREATE PROCEDURE [dbo].[yaf_checkemail_update](
                @Hash NVARCHAR(32))
AS
    BEGIN
        DECLARE  @UserID INT
        DECLARE  @CheckEmailID INT
        DECLARE  @Email NVARCHAR(50)
        SET @UserID = NULL
        SELECT @CheckEmailID = CheckEmailID , @UserID = UserID , @Email = Email FROM yaf_CheckEmail WHERE HASH = @Hash
        IF @UserID IS NULL
        BEGIN
            SELECT CONVERT(BIT,0)
            RETURN
        END
        -- Update new user email
        UPDATE yaf_User
        SET    Email = @Email,
               Flags = Flags | 2
        WHERE  UserID = @UserID
        DELETE yaf_CheckEmail
        WHERE  CheckEmailID = @CheckEmailID
        SELECT CONVERT(BIT,1)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_choice_vote]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_choice_vote] 
GO

CREATE PROCEDURE [dbo].[yaf_choice_vote](
                @ChoiceID INT,
                @UserID   INT  = NULL,
                @RemoteIP NVARCHAR(10)  = NULL)
AS
    BEGIN
        DECLARE  @PollID INT
        SET @PollID = (SELECT PollID
                       FROM   yaf_Choice
                       WHERE  ChoiceID = @ChoiceID)
        IF @UserID = NULL
        BEGIN
            IF @RemoteIP != NULL
            BEGIN
                INSERT INTO yaf_PollVote
                           (PollID,
                            UserID,
                            RemoteIP)
                VALUES     (@PollID,
                            NULL,
                            @RemoteIP)
            END
        END
        ELSE
        BEGIN
            INSERT INTO yaf_PollVote
                       (PollID,
                        UserID,
                        RemoteIP)
            VALUES     (@PollID,
                        @UserID,
                        @RemoteIP)
        END
        UPDATE yaf_Choice
        SET    Votes = Votes + 1
        WHERE  ChoiceID = @ChoiceID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_eventlog_create]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_eventlog_create] 
GO

CREATE PROCEDURE [dbo].[yaf_eventlog_create](
                @UserID      INT,
                @Source      NVARCHAR(50),
                @Description NTEXT,
                @Type        INT)
AS
    BEGIN
        INSERT INTO dbo.yaf_EventLog
                   (UserID,
                    Source,
                    Description,
                    TYPE)
        VALUES     (@UserID,
                    @Source,
                    @Description,
                    @Type)
        -- delete entries older than 10 days
        DELETE FROM dbo.yaf_EventLog
        WHERE       EventTime + 10 < Getdate()
        -- or if there are more then 1000
        IF ((SELECT COUNT(* )
             FROM   yaf_eventlog) >= 1050)
        BEGIN
            DELETE FROM dbo.yaf_EventLog
            WHERE       EventLogID IN (SELECT   TOP 100 EventLogID
                           FROM     dbo.yaf_EventLog
                           ORDER BY EventTime)
        END
        
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_eventlog_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_eventlog_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_eventlog_delete](
                @EventLogID INT)
AS
    BEGIN
        DELETE FROM dbo.yaf_EventLog
        WHERE       EventLogID = @EventLogID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_eventlog_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_eventlog_list] 
GO

CREATE PROCEDURE [dbo].[yaf_eventlog_list](
                @BoardID INT)
AS
    BEGIN
        SELECT   a.*,
                 Isnull(b.[Name],'System')  AS [Name]
        FROM     dbo.yaf_EventLog a
                 LEFT JOIN dbo.yaf_User b
                   ON b.UserID = a.UserID
        WHERE    (b.UserID IS NULL 
          OR b.BoardID = @BoardID)
        ORDER BY a.EventLogID DESC
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_delete](
                @ForumID INT)
AS
    BEGIN
        -- Maybe an idea to use cascading foreign keys instead? Too bad they don't work on MS SQL 7.0...
        UPDATE yaf_Forum
        SET    LastMessageID = NULL,
               LastTopicID = NULL
        WHERE  ForumID = @ForumID
        UPDATE yaf_Topic
        SET    LastMessageID = NULL
        WHERE  ForumID = @ForumID
        DELETE FROM yaf_WatchTopic
        FROM        yaf_Topic
        WHERE       yaf_Topic.ForumID = @ForumID
        AND yaf_WatchTopic.TopicID = yaf_Topic.TopicID
        DELETE FROM yaf_Active
        FROM        yaf_Topic
        WHERE       yaf_Topic.ForumID = @ForumID
        AND yaf_Active.TopicID = yaf_Topic.TopicID
        DELETE FROM yaf_NntpTopic
        FROM        yaf_NntpForum
        WHERE       yaf_NntpForum.ForumID = @ForumID
        AND yaf_NntpTopic.NntpForumID = yaf_NntpForum.NntpForumID
        DELETE FROM yaf_NntpForum
        WHERE       ForumID = @ForumID
        DELETE FROM yaf_WatchForum
        WHERE       ForumID = @ForumID
        -- BAI CHANGED 02.02.2004
        -- Delete topics, messages and attachments
        DECLARE  @tmpTopicID INT;
        DECLARE topic_cursor CURSOR  FOR
        SELECT   TopicID
        FROM     yaf_topic
        WHERE    ForumId = @ForumID
        ORDER BY TopicID DESC
        OPEN topic_cursor
        FETCH NEXT FROM topic_cursor
        INTO @tmpTopicID
        -- Check @@FETCH_STATUS to see if there are any more rows to fetch.
        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC yaf_topic_delete
                 @tmpTopicID ,
                 1 ,
                 1;
            -- This is executed as long as the previous fetch succeeds.
            FETCH NEXT FROM topic_cursor
            INTO @tmpTopicID
        END
        CLOSE topic_cursor
        DEALLOCATE topic_cursor
        -- TopicDelete finished
        -- END BAI CHANGED 02.02.2004
        DELETE FROM yaf_ForumAccess
        WHERE       ForumID = @ForumID
        --ABOT CHANGED
        --Delete UserForums Too
        DELETE FROM yaf_UserForum
        WHERE       ForumID = @ForumID
        --END ABOT CHANGED 09.04.2004
        DELETE FROM yaf_Forum
        WHERE       ForumID = @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_list] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_list](
                @BoardID INT,
                @ForumID INT  = NULL)
AS
    BEGIN
        IF @ForumID = 0
        SET @ForumID = NULL
        IF @ForumID IS NULL
        SELECT   a.*
        FROM     yaf_Forum a
                 JOIN yaf_Category b
                   ON b.CategoryID = a.CategoryID
        WHERE    b.BoardID = @BoardID
        ORDER BY a.SortOrder
        ELSE
        SELECT a.*
        FROM   yaf_Forum a
               JOIN yaf_Category b
                 ON b.CategoryID = a.CategoryID
        WHERE  b.BoardID = @BoardID
        AND a.ForumID = @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_listall]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_listall] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_listall](
                @BoardID INT,
                @UserID  INT)
AS
    BEGIN
        SELECT   b.CategoryID,
                 Category = b.Name,
                 a.ForumID,
                 Forum = a.Name,
                 a.ParentID
        FROM     yaf_Forum a
                 JOIN yaf_Category b
                   ON b.CategoryID = a.CategoryID
                 JOIN yaf_vaccess c
                   ON c.ForumID = a.ForumID
        WHERE    c.UserID = @UserID
        AND b.BoardID = @BoardID
        AND c.ReadAccess > 0
        ORDER BY b.SortOrder,
                 a.SortOrder
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_listall_fromcat]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_listall_fromcat] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_listall_fromcat](
                @BoardID    INT,
                @CategoryID INT)
AS
    BEGIN
        SELECT   b.CategoryID,
                 b.Name       AS Category,
                 a.ForumID,
                 a.Name       AS Forum,
                 a.ParentID
        FROM     yaf_Forum a
                 INNER JOIN yaf_Category b
                   ON b.CategoryID = a.CategoryID
        WHERE    b.CategoryID = @CategoryID
        AND b.BoardID = @BoardID
        ORDER BY b.SortOrder,
                 a.SortOrder
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_listallmymoderated]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_listallmymoderated] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_listallmymoderated](
                @BoardID INT,
                @UserID  INT)
AS
    BEGIN
        SELECT   b.CategoryID,
                 Category = b.Name,
                 a.ForumID,
                 Forum = a.Name,
                 x.Indent
        FROM     (SELECT b.ForumID,
                         Indent = 0
                  FROM   yaf_Category a
                         JOIN yaf_Forum b
                           ON b.CategoryID = a.CategoryID
                  WHERE  a.BoardID = @BoardID
                  AND b.ParentID IS NULL
                  UNION 
                  SELECT c.ForumID,
                         Indent = 1
                  FROM   yaf_Category a
                         JOIN yaf_Forum b
                           ON b.CategoryID = a.CategoryID
                         JOIN yaf_Forum c
                           ON c.ParentID = b.ForumID
                  WHERE  a.BoardID = @BoardID
                  AND b.ParentID IS NULL
                  UNION 
                  SELECT d.ForumID,
                         Indent = 2
                  FROM   yaf_Category a
                         JOIN yaf_Forum b
                           ON b.CategoryID = a.CategoryID
                         JOIN yaf_Forum c
                           ON c.ParentID = b.ForumID
                         JOIN yaf_Forum d
                           ON d.ParentID = c.ForumID
                  WHERE  a.BoardID = @BoardID
                  AND b.ParentID IS NULL) AS x
                 JOIN yaf_Forum a
                   ON a.ForumID = x.ForumID
                 JOIN yaf_Category b
                   ON b.CategoryID = a.CategoryID
                 JOIN yaf_vaccess c
                   ON c.ForumID = a.ForumID
        WHERE    c.UserID = @UserID
        AND b.BoardID = @BoardID
        AND c.ModeratorAccess > 0
        ORDER BY b.SortOrder,
                 a.SortOrder
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_listpath]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_listpath] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_listpath](
                @ForumID INT)
AS
    BEGIN
        -- supports up to 4 levels of nested forums
        SELECT a.ForumID,
               a.Name
        FROM     (SELECT a.ForumID,
                         Indent = 0
                  FROM   yaf_Forum a
                  WHERE  a.ForumID = @ForumID
                  UNION 
                  SELECT b.ForumID,
                         Indent = 1
                  FROM   yaf_Forum a
                         JOIN yaf_Forum b
                           ON b.ForumID = a.ParentID
                  WHERE  a.ForumID = @ForumID
                  UNION 
                  SELECT c.ForumID,
                         Indent = 2
                  FROM   yaf_Forum a
                         JOIN yaf_Forum b
                           ON b.ForumID = a.ParentID
                         JOIN yaf_Forum c
                           ON c.ForumID = b.ParentID
                  WHERE  a.ForumID = @ForumID
                  UNION 
                  SELECT d.ForumID,
                         Indent = 3
                  FROM   yaf_Forum a
                         JOIN yaf_Forum b
                           ON b.ForumID = a.ParentID
                         JOIN yaf_Forum c
                           ON c.ForumID = b.ParentID
                         JOIN yaf_Forum d
                           ON d.ForumID = c.ParentID
                  WHERE  a.ForumID = @ForumID) AS x
                 JOIN yaf_Forum a
                   ON a.ForumID = x.ForumID
        ORDER BY x.Indent DESC
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_listread]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_listread] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_listread](
                @BoardID    INT,
                @UserID     INT,
                @CategoryID INT  = NULL,
                @ParentID   INT  = NULL)
AS
    BEGIN
        SELECT   a.CategoryID,
                 Category = a.Name,
                 ForumID = b.ForumID,
                 Forum = b.Name,
                 Description,
                 Topics = dbo.Yaf_forum_topics(b.ForumID),
                 Posts = dbo.Yaf_forum_posts(b.ForumID),
                 LastPosted = b.LastPosted,
                 LastMessageID = b.LastMessageID,
                 LastUserID = b.LastUserID,
                 LastUser = Isnull(b.LastUserName,(SELECT Name
                                                   FROM   yaf_User x
                                                   WHERE  x.UserID = b.LastUserID)),
                 LastTopicID = b.LastTopicID,
                 LastTopicName = (SELECT x.Topic
                                  FROM   yaf_Topic x
                                  WHERE  x.TopicID = b.LastTopicID),
                 b.Flags,
                 Viewing = (SELECT COUNT(1)
                            FROM   yaf_Active x
                            WHERE  x.ForumID = b.ForumID),
                 b.RemoteURL,
                 x.ReadAccess
        FROM     yaf_Category a
                 JOIN yaf_Forum b
                   ON b.CategoryID = a.CategoryID
                 JOIN yaf_vaccess x
                   ON x.ForumID = b.ForumID
        WHERE    a.BoardID = @BoardID
        AND ((b.Flags & 2) = 0
              OR x.ReadAccess <> 0)
        AND (@CategoryID IS NULL 
              OR a.CategoryID = @CategoryID)
        AND ((@ParentID IS NULL 
              AND b.ParentID IS NULL)
              OR b.ParentID = @ParentID)
        AND x.UserID = @UserID
        ORDER BY a.SortOrder,
                 b.SortOrder
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_listSubForums]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_listSubForums] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_listSubForums](
                @ForumID INT)
AS
    BEGIN
        SELECT SUM(1)
        FROM   yaf_Forum
        WHERE  ParentID = @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_listtopics]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_listtopics] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_listtopics](
                @ForumID INT)
AS
    BEGIN
        SELECT *
        FROM   yaf_Topic
        WHERE  ForumID = @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_moderatelist]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_moderatelist] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_moderatelist]
AS
    BEGIN
        SELECT   CategoryID = a.CategoryID,
                 CategoryName = a.Name,
                 ForumID = b.ForumID,
                 ForumName = b.Name,
                 MessageCount = COUNT(d.MessageID)
        FROM     yaf_Category a,
                 yaf_Forum b,
                 yaf_Topic c,
                 yaf_Message d
        WHERE    b.CategoryID = a.CategoryID
        AND c.ForumID = b.ForumID
        AND d.TopicID = c.TopicID
        AND (d.Flags & 16) = 0
        AND (c.Flags & 8) = 0
        AND (d.Flags & 8) = 0
        GROUP BY a.CategoryID,a.Name,a.SortOrder,b.ForumID,
                 b.Name,b.SortOrder
        ORDER BY a.SortOrder,
                 b.SortOrder
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_moderators]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_moderators] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_moderators]
AS
    BEGIN
        SELECT a.ForumID,
               a.GroupID,
               GroupName = b.Name
        FROM   yaf_ForumAccess a,
               yaf_Group b,
               yaf_AccessMask c
        WHERE  (c.Flags & 64) <> 0
        AND b.GroupID = a.GroupID
        AND c.AccessMaskID = a.AccessMaskID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_save] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_save](
                @ForumID      INT,
                @CategoryID   INT,
                @ParentID     INT  = NULL,
                @Name         NVARCHAR(128),
                @Description  NVARCHAR(255),
                @SortOrder    SMALLINT,
                @Locked       BIT,
                @Hidden       BIT,
                @IsTest       BIT,
                @Moderated    BIT,
                @RemoteURL    NVARCHAR(100)  = NULL,
                @ThemeURL     NVARCHAR(100)  = NULL,
                @AccessMaskID INT  = NULL)
AS
    BEGIN
        DECLARE  @BoardID INT
        DECLARE  @Flags INT
        SET @Flags = 0
        IF @Locked <> 0
        SET @Flags = @Flags | 1
        IF @Hidden <> 0
        SET @Flags = @Flags | 2
        IF @IsTest <> 0
        SET @Flags = @Flags | 4
        IF @Moderated <> 0
        SET @Flags = @Flags | 8
        IF @ForumID > 0
        BEGIN
            UPDATE yaf_Forum
            SET    ParentID = @ParentID,
                   Name = @Name,
                   Description = @Description,
                   SortOrder = @SortOrder,
                   CategoryID = @CategoryID,
                   RemoteURL = @RemoteURL,
                   ThemeURL = @ThemeURL,
                   Flags = @Flags
            WHERE  ForumID = @ForumID
        END
        ELSE
        BEGIN
            SELECT @BoardID = BoardID
            FROM   yaf_Category
            WHERE  CategoryID = @CategoryID
            INSERT INTO yaf_Forum
                       (ParentID,
                        Name,
                        Description,
                        SortOrder,
                        CategoryID,
                        NumTopics,
                        NumPosts,
                        RemoteURL,
                        ThemeURL,
                        Flags)
            VALUES     (@ParentID,
                        @Name,
                        @Description,
                        @SortOrder,
                        @CategoryID,
                        0,
                        0,
                        @RemoteURL,
                        @ThemeURL,
                        @Flags)
            SELECT @ForumID = Scope_identity()
            INSERT INTO yaf_ForumAccess
                       (GroupID,
                        ForumID,
                        AccessMaskID)
            SELECT GroupID,
                   @ForumID,
                   @AccessMaskID
            FROM   yaf_Group
            WHERE  BoardID = @BoardID
        END
        SELECT ForumID = @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_updatelastpost]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_updatelastpost] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_updatelastpost](
                @ForumID INT)
AS
    BEGIN
        UPDATE yaf_Forum
        SET    LastPosted = (SELECT   TOP 1 y.Posted
                             FROM     yaf_Topic x,
                                      yaf_Message y
                             WHERE    x.ForumID = yaf_Forum.ForumID
                             AND y.TopicID = x.TopicID
                             AND (y.Flags & 24) = 16
                             ORDER BY y.Posted DESC),
               LastTopicID = (SELECT   TOP 1 y.TopicID
                              FROM     yaf_Topic x,
                                       yaf_Message y
                              WHERE    x.ForumID = yaf_Forum.ForumID
                              AND y.TopicID = x.TopicID
                              AND (y.Flags & 24) = 16
                              ORDER BY y.Posted DESC),
               LastMessageID = (SELECT   TOP 1 y.MessageID
                                FROM     yaf_Topic x,
                                         yaf_Message y
                                WHERE    x.ForumID = yaf_Forum.ForumID
                                AND y.TopicID = x.TopicID
                                AND (y.Flags & 24) = 16
                                ORDER BY y.Posted DESC),
               LastUserID = (SELECT   TOP 1 y.UserID
                             FROM     yaf_Topic x,
                                      yaf_Message y
                             WHERE    x.ForumID = yaf_Forum.ForumID
                             AND y.TopicID = x.TopicID
                             AND (y.Flags & 24) = 16
                             ORDER BY y.Posted DESC),
               LastUserName = (SELECT   TOP 1 y.UserName
                               FROM     yaf_Topic x,
                                        yaf_Message y
                               WHERE    x.ForumID = yaf_Forum.ForumID
                               AND y.TopicID = x.TopicID
                               AND (y.Flags & 24) = 16
                               ORDER BY y.Posted DESC)
        WHERE  ForumID = @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_updatestats]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_updatestats] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_updatestats](
                @ForumID INT)
AS
    BEGIN
        UPDATE yaf_Forum
        SET    NumPosts = (SELECT COUNT(1)
                           FROM   yaf_Message x,
                                  yaf_Topic y
                           WHERE  y.TopicID = x.TopicID
                           AND y.ForumID = yaf_Forum.ForumID
                           AND (x.Flags & 24) = 16),
               NumTopics = (SELECT COUNT(DISTINCT x.TopicID)
                            FROM   yaf_Topic x,
                                   yaf_Message y
                            WHERE  x.ForumID = yaf_Forum.ForumID
                            AND y.TopicID = x.TopicID
                            AND (y.Flags & 24) = 16)
        WHERE  ForumID = @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forumaccess_group]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forumaccess_group] 
GO

CREATE PROCEDURE [dbo].[yaf_forumaccess_group](
                @GroupID INT)
AS
    BEGIN
        SELECT   a.*,
                 ForumName = b.Name,
                 CategoryName = c.Name
        FROM     yaf_ForumAccess a,
                 yaf_Forum b,
                 yaf_Category c
        WHERE    a.GroupID = @GroupID
        AND b.ForumID = a.ForumID
        AND c.CategoryID = b.CategoryID
        ORDER BY c.SortOrder,
                 b.SortOrder
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forumaccess_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forumaccess_list] 
GO

CREATE PROCEDURE [dbo].[yaf_forumaccess_list](
                @ForumID INT)
AS
    BEGIN
        SELECT a.*,
               GroupName = b.Name
        FROM   yaf_ForumAccess a,
               yaf_Group b
        WHERE  a.ForumID = @ForumID
        AND b.GroupID = a.GroupID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forumaccess_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forumaccess_save] 
GO

CREATE PROCEDURE [dbo].[yaf_forumaccess_save](
                @ForumID      INT,
                @GroupID      INT,
                @AccessMaskID INT)
AS
    BEGIN
        UPDATE yaf_ForumAccess
        SET    AccessMaskID = @AccessMaskID
        WHERE  ForumID = @ForumID
        AND GroupID = @GroupID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_group_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_group_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_group_delete](
                @GroupID INT)
AS
    BEGIN
        DELETE FROM yaf_ForumAccess
        WHERE       GroupID = @GroupID
        DELETE FROM yaf_UserGroup
        WHERE       GroupID = @GroupID
        DELETE FROM yaf_Group
        WHERE       GroupID = @GroupID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_group_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_group_list] 
GO

CREATE PROCEDURE [dbo].[yaf_group_list](
                @BoardID INT,
                @GroupID INT  = NULL)
AS
    BEGIN
        IF @GroupID IS NULL
        SELECT *
        FROM   yaf_Group
        WHERE  BoardID = @BoardID
        ELSE
        SELECT *
        FROM   yaf_Group
        WHERE  BoardID = @BoardID
        AND GroupID = @GroupID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_group_member]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_group_member] 
GO

CREATE PROCEDURE [dbo].[yaf_group_member](
                @BoardID INT,
                @UserID  INT)
AS
    BEGIN
        SELECT   a.GroupID,
                 a.Name,
                 Member = (SELECT COUNT(1)
                           FROM   yaf_UserGroup x
                           WHERE  x.UserID = @UserID
                           AND x.GroupID = a.GroupID)
        FROM     yaf_Group a
        WHERE    a.BoardID = @BoardID
        ORDER BY a.Name
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_group_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_group_save] 
GO

CREATE PROCEDURE [dbo].[yaf_group_save](
                @GroupID      INT,
                @BoardID      INT,
                @Name         NVARCHAR(50),
                @IsAdmin      BIT,
                @IsGuest      BIT,
                @IsStart      BIT,
                @IsModerator  BIT,
                @AccessMaskID INT  = NULL)
AS
    BEGIN
        DECLARE  @Flags INT
        SET @Flags = 0
        IF @IsAdmin <> 0
        SET @Flags = @Flags | 1
        IF @IsGuest <> 0
        SET @Flags = @Flags | 2
        IF @IsStart <> 0
        SET @Flags = @Flags | 4
        IF @IsModerator <> 0
        SET @Flags = @Flags | 8
        IF @GroupID > 0
        BEGIN
            UPDATE yaf_Group
            SET    Name = @Name,
                   Flags = @Flags
            WHERE  GroupID = @GroupID
        END
        ELSE
        BEGIN
            INSERT INTO yaf_Group
                       (Name,
                        BoardID,
                        Flags)
            VALUES     (@Name,
                        @BoardID,
                        @Flags);
            SET @GroupID = Scope_identity()
            INSERT INTO yaf_ForumAccess
                       (GroupID,
                        ForumID,
                        AccessMaskID)
            SELECT @GroupID,
                   a.ForumID,
                   @AccessMaskID
            FROM   yaf_Forum a
                   JOIN yaf_Category b
                     ON b.CategoryID = a.CategoryID
            WHERE  b.BoardID = @BoardID
        END
        SELECT GroupID = @GroupID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_mail_createwatch]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_mail_createwatch] 
GO

CREATE PROCEDURE [dbo].[yaf_mail_createwatch](
                @TopicID INT,
                @From    NVARCHAR(50),
                @Subject NVARCHAR(100),
                @Body    NTEXT,
                @UserID  INT)
AS
    BEGIN
        INSERT INTO yaf_Mail
                   (FromUser,
                    ToUser,
                    Created,
                    Subject,
                    Body)
        SELECT @From,
               b.Email,
               Getdate(),
               @Subject,
               @Body
        FROM   yaf_WatchTopic a,
               yaf_User b
        WHERE  b.UserID <> @UserID
        AND b.UserID = a.UserID
        AND a.TopicID = @TopicID
        AND (a.LastMail IS NULL 
              OR a.LastMail < b.LastVisit)
        INSERT INTO yaf_Mail
                   (FromUser,
                    ToUser,
                    Created,
                    Subject,
                    Body)
        SELECT @From,
               b.Email,
               Getdate(),
               @Subject,
               @Body
        FROM   yaf_WatchForum a,
               yaf_User b,
               yaf_Topic c
        WHERE  b.UserID <> @UserID
        AND b.UserID = a.UserID
        AND c.TopicID = @TopicID
        AND c.ForumID = a.ForumID
        AND (a.LastMail IS NULL 
              OR a.LastMail < b.LastVisit)
        AND NOT EXISTS (SELECT 1
                        FROM   yaf_WatchTopic x
                        WHERE  x.UserID = b.UserID
                        AND x.TopicID = c.TopicID)
        UPDATE yaf_WatchTopic
        SET    LastMail = Getdate()
        WHERE  TopicID = @TopicID
        AND UserID <> @UserID
        UPDATE yaf_WatchForum
        SET    LastMail = Getdate()
        WHERE  ForumID = (SELECT ForumID
                   FROM   yaf_Topic
                   WHERE  TopicID = @TopicID)
        AND UserID <> @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_mail_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_mail_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_mail_delete](
                @MailID INT)
AS
    BEGIN
        DELETE FROM yaf_Mail
        WHERE       MailID = @MailID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_mail_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_mail_list] 
GO

CREATE PROCEDURE [dbo].[yaf_mail_list]
AS
    BEGIN
        SELECT   TOP 10 *
        FROM     yaf_Mail
        ORDER BY Created
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_message_approve]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_message_approve] 
GO

CREATE PROCEDURE [dbo].[yaf_message_approve](
                @MessageID INT)
AS
    BEGIN
        DECLARE  @UserID INT
        DECLARE  @ForumID INT
        DECLARE  @TopicID INT
        DECLARE  @Posted DATETIME
        DECLARE  @UserName NVARCHAR(50)
        SELECT @UserID = a.UserID,
               @TopicID = a.TopicID,
               @ForumID = b.ForumID,
               @Posted = a.Posted,
               @UserName = a.UserName
        FROM   yaf_Message a,
               yaf_Topic b
        WHERE  a.MessageID = @MessageID
        AND b.TopicID = a.TopicID
        -- update yaf_Message
        UPDATE yaf_Message
        SET    Flags = Flags | 16
        WHERE  MessageID = @MessageID
        -- update yaf_User
        IF EXISTS (SELECT 1
                   FROM   yaf_Forum
                   WHERE  ForumID = @ForumID
                   AND (Flags & 4) = 0)
        BEGIN
            UPDATE yaf_User
            SET    NumPosts = NumPosts + 1
            WHERE  UserID = @UserID
            EXEC yaf_user_upgrade
                 @UserID
        END
        -- update yaf_Forum
        UPDATE yaf_Forum
        SET    LastPosted = @Posted,
               LastTopicID = @TopicID,
               LastMessageID = @MessageID,
               LastUserID = @UserID,
               LastUserName = @UserName
        WHERE  ForumID = @ForumID
        -- update yaf_Topic
        UPDATE yaf_Topic
        SET    LastPosted = @Posted,
               LastMessageID = @MessageID,
               LastUserID = @UserID,
               LastUserName = @UserName,
               NumPosts = (SELECT COUNT(1)
                           FROM   yaf_Message x
                           WHERE  x.TopicID = yaf_Topic.TopicID
                           AND (x.Flags & 24) = 16)
        WHERE  TopicID = @TopicID
        -- update forum stats
        EXEC yaf_forum_updatestats
             @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_message_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_message_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_message_delete](
                @MessageID INT)
AS
    BEGIN
        DECLARE  @TopicID INT
        DECLARE  @ForumID INT
        DECLARE  @MessageCount INT
        DECLARE  @LastMessageID INT
        -- Find TopicID and ForumID
        SELECT @TopicID = b.TopicID,
               @ForumID = b.ForumID
			FROM   yaf_Message a,
				   yaf_Topic b
			WHERE  a.MessageID = @MessageID
			AND b.TopicID = a.TopicID
        -- Update LastMessageID in Topic and Forum
        UPDATE yaf_Topic
			SET    LastPosted = NULL,
				   LastMessageID = NULL,
				   LastUserID = NULL,
				   LastUserName = NULL
			WHERE  LastMessageID = @MessageID
			UPDATE yaf_Forum
			SET    LastPosted = NULL,
				   LastTopicID = NULL,
				   LastMessageID = NULL,
				   LastUserID = NULL,
				   LastUserName = NULL
			WHERE  LastMessageID = @MessageID
        -- "Delete" message
        UPDATE yaf_Message
			SET    Flags = Flags | 8
			WHERE  MessageID = @MessageID
        -- Delete topic if there are no more messages
        SELECT @MessageCount = COUNT(1)
			FROM   yaf_Message
			WHERE  TopicID = @TopicID
			AND (Flags & 8) = 0
        IF @MessageCount = 0
			EXEC yaf_topic_delete
				 @TopicID
        -- update lastpost
        EXEC yaf_topic_updatelastpost
             @ForumID ,
             @TopicID
        EXEC yaf_forum_updatestats
             @ForumID
        -- update topic numposts
        UPDATE yaf_Topic
			SET    NumPosts = (SELECT COUNT(1)
							   FROM   yaf_Message x
							   WHERE  x.TopicID = yaf_Topic.TopicID
							   AND (x.Flags & 24) = 16)
			WHERE  TopicID = @TopicID
		-- update user's numposts
		UPDATE yaf_User
			SET NumPosts=NumPosts-1
			WHERE UserID=(SELECT UserID FROM yaf_Message WHERE MessageID = @MessageID)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_message_findunread]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_message_findunread] 
GO

CREATE PROCEDURE [dbo].[yaf_message_findunread](
                @TopicID  INT,
                @LastRead DATETIME)
AS
    BEGIN
        SELECT   TOP 1 MessageID
        FROM     yaf_Message
        WHERE    TopicID = @TopicID
        AND Posted > @LastRead
        ORDER BY Posted
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_message_getReplies]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_message_getReplies] 
GO

CREATE PROCEDURE [dbo].[yaf_message_getReplies](
                @MessageID INT)
AS
    BEGIN
        SELECT MessageID
        FROM   yaf_Message
        WHERE  ReplyTo = @MessageID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_message_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_message_list] 
GO

CREATE PROCEDURE [dbo].[yaf_message_list](
                @MessageID INT)
AS
    BEGIN
        SELECT a.MessageID,
               a.UserID,
               UserName = b.Name,
               a.Message,
               c.TopicID,
               c.ForumID,
               c.Topic,
               c.Priority,
               a.Flags,
               c.UserID                           AS TopicOwnerID,
               Edited = Isnull(a.Edited,a.Posted)
        FROM   yaf_Message a,
               yaf_User b,
               yaf_Topic c
        WHERE  a.MessageID = @MessageID
        AND b.UserID = a.UserID
        AND c.TopicID = a.TopicID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_message_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_message_save] 
GO

CREATE PROCEDURE [dbo].[yaf_message_save](
                @TopicID   INT,
                @UserID    INT,
                @Message   NTEXT,
                @UserName  NVARCHAR(50)  = NULL,
                @IP        NVARCHAR(15),
                @Posted    DATETIME  = NULL,
                @ReplyTo   INT,
                @Flags     INT,
                @MessageID INT  OUTPUT)
AS
    BEGIN
        DECLARE  @ForumFlags INT,
                 @ForumID    INT,
                 @Indent     INT,
                 @Position   INT
        IF @Posted IS NULL
        SET @Posted = Getdate()
        SELECT @ForumID = x.ForumID,
               @ForumFlags = y.Flags
        FROM   yaf_Topic x,
               yaf_Forum y
        WHERE  x.TopicID = @TopicID
        AND y.ForumID = x.ForumID
        IF @ReplyTo IS NULL
        SELECT @Position = 0,
               @Indent = 0 -- New thread
                         
        ELSE
        IF @ReplyTo < 0
        -- Find post to reply to AND indent of this post
        SELECT TOP 1 @ReplyTo = MessageID,
                     @Indent = Indent + 1
        FROM     yaf_Message
        WHERE    TopicID = @TopicID
        AND ReplyTo IS NULL
        ORDER BY Posted
        ELSE
        -- Got reply, find indent of this post
        SELECT @Indent = Indent + 1
        FROM   yaf_Message
        WHERE  MessageID = @ReplyTo
        -- Find position
        IF @ReplyTo IS NOT NULL
        BEGIN
            DECLARE  @temp INT
                           
            SELECT @temp = ReplyTo,
                   @Position = Position
            FROM   yaf_Message
            WHERE  MessageID = @ReplyTo
                        
            IF @temp IS NULL
            -- We are replying to first post
            SELECT @Position = MAX(Position) + 1
            FROM   yaf_Message
            WHERE  TopicID = @TopicID
                      
            ELSE
            -- Last position of replies to parent post
            SELECT @Position = MIN(Position)
            FROM   yaf_Message
            WHERE  ReplyTo = @temp
            AND Position > @Position
                           
            -- No replies, THEN USE parent post's position+1
            IF @Position IS NULL
            SELECT @Position = Position + 1
            FROM   yaf_Message
            WHERE  MessageID = @ReplyTo
            -- Increase position of posts after this
            UPDATE yaf_Message
            SET    Position = Position + 1
            WHERE  TopicID = @TopicID
            AND Position >= @Position
        END
        -- Add points to Users total points
        UPDATE yaf_User
        SET    Points = Points + 3
        WHERE  UserID = @UserID
        INSERT yaf_Message
              (UserID,
               Message,
               TopicID,
               Posted,
               UserName,
               IP,
               ReplyTo,
               Position,
               Indent,
               Flags)
        VALUES(@UserID,
               @Message,
               @TopicID,
               @Posted,
               @UserName,
               @IP,
               @ReplyTo,
               @Position,
               @Indent,
               @Flags & ~ 16)
        SET @MessageID = Scope_identity()
        IF (@ForumFlags & 8) = 0
        EXEC yaf_message_approve
             @MessageID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_message_unapproved]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_message_unapproved] 
GO

CREATE PROCEDURE [dbo].[yaf_message_unapproved](
                @ForumID INT)
AS
    BEGIN
        SELECT   MessageID = b.MessageID,
                 UserName = Isnull(b.UserName,c.Name),
                 Posted = b.Posted,
                 Topic = a.Topic,
                 Message = b.Message
        FROM     yaf_Topic a,
                 yaf_Message b,
                 yaf_User c
        WHERE    a.ForumID = @ForumID
        AND b.TopicID = a.TopicID
        AND (b.Flags & 16) = 0
        AND (a.Flags & 8) = 0
        AND (b.Flags & 8) = 0
        AND c.UserID = b.UserID
        ORDER BY a.Posted
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_message_update]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_message_update] 
GO

CREATE PROCEDURE [dbo].[yaf_message_update](
                @MessageID INT,
                @Priority  INT,
                @Subject   NVARCHAR(100),
                @Flags     INT,
                @Message   NTEXT)
AS
    BEGIN
        DECLARE  @TopicID INT
        DECLARE  @ForumFlags INT
        SET @Flags = @Flags & ~ 16
        SELECT @TopicID = a.TopicID,
               @ForumFlags = c.Flags
        FROM   yaf_Message a,
               yaf_Topic b,
               yaf_Forum c
        WHERE  a.MessageID = @MessageID
        AND b.TopicID = a.TopicID
        AND c.ForumID = b.ForumID
        IF (@ForumFlags & 8) = 0
        SET @Flags = @Flags | 16
        UPDATE yaf_Message
        SET    Message = @Message,
               Edited = Getdate(),
               Flags = @Flags
        WHERE  MessageID = @MessageID
        IF @Priority IS NOT NULL
        BEGIN
            UPDATE yaf_Topic
            SET    Priority = @Priority
            WHERE  TopicID = @TopicID
        END
        IF NOT @Subject = ''
           AND @Subject IS NOT NULL
        BEGIN
            UPDATE yaf_Topic
            SET    Topic = @Subject
            WHERE  TopicID = @TopicID
        END
        -- If forum is moderated, make sure last post pointers are correct
        IF (@ForumFlags & 8) <> 0
        EXEC yaf_topic_updatelastpost
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_nntpforum_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_nntpforum_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_nntpforum_delete](
                @NntpForumID INT)
AS
    BEGIN
        DELETE FROM yaf_NntpTopic
        WHERE       NntpForumID = @NntpForumID
        DELETE FROM yaf_NntpForum
        WHERE       NntpForumID = @NntpForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_nntpforum_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_nntpforum_list] 
GO

CREATE PROCEDURE [dbo].[yaf_nntpforum_list](
                @BoardID     INT,
                @Minutes     INT  = NULL,
                @NntpForumID INT  = NULL,
                @Active      BIT  = NULL)
AS
    BEGIN
        SELECT   a.Name,
                 a.Address,
                 Port = Isnull(a.Port,119),
                 a.NntpServerID,
                 b.NntpForumID,
                 b.GroupName,
                 b.ForumID,
                 b.LastMessageNo,
                 b.LastUpdate,
                 b.Active,
                 ForumName = c.Name
        FROM     yaf_NntpServer a
                 JOIN yaf_NntpForum b
                   ON b.NntpServerID = a.NntpServerID
                 JOIN yaf_Forum c
                   ON c.ForumID = b.ForumID
        WHERE    (@Minutes IS NULL 
          OR Datediff(n,b.LastUpdate,Getdate()) > @Minutes)
        AND (@NntpForumID IS NULL 
              OR b.NntpForumID = @NntpForumID)
        AND a.BoardID = @BoardID
        AND (@Active IS NULL 
              OR b.Active = @Active)
        ORDER BY a.Name,
                 b.GroupName
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_nntpforum_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_nntpforum_save] 
GO

CREATE PROCEDURE [dbo].[yaf_nntpforum_save](
                @NntpForumID  INT  = NULL,
                @NntpServerID INT,
                @GroupName    NVARCHAR(100),
                @ForumID      INT,
                @Active       BIT)
AS
    BEGIN
        IF @NntpForumID IS NULL
        INSERT INTO yaf_NntpForum
                   (NntpServerID,
                    GroupName,
                    ForumID,
                    LastMessageNo,
                    LastUpdate,
                    Active)
        VALUES     (@NntpServerID,
                    @GroupName,
                    @ForumID,
                    0,
                    Getdate(),
                    @Active)
        ELSE
        UPDATE yaf_NntpForum
        SET    NntpServerID = @NntpServerID,
               GroupName = @GroupName,
               ForumID = @ForumID,
               Active = @Active
        WHERE  NntpForumID = @NntpForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_nntpforum_update]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_nntpforum_update] 
GO

CREATE PROCEDURE [dbo].[yaf_nntpforum_update](
                @NntpForumID   INT,
                @LastMessageNo INT,
                @UserID        INT)
AS
    BEGIN
        DECLARE  @ForumID INT
        SELECT @ForumID = ForumID
        FROM   yaf_NntpForum
        WHERE  NntpForumID = @NntpForumID
        UPDATE yaf_NntpForum
        SET    LastMessageNo = @LastMessageNo,
               LastUpdate = Getdate()
        WHERE  NntpForumID = @NntpForumID
        UPDATE yaf_Topic
        SET    NumPosts = (SELECT COUNT(1)
                           FROM   yaf_message x
                           WHERE  x.TopicID = yaf_Topic.TopicID
                           AND (x.Flags & 24) = 16)
        WHERE  ForumID = @ForumID
        --exec yaf_user_upgrade @UserID
        EXEC yaf_forum_updatestats
             @ForumID
    -- exec yaf_topic_updatelastpost @ForumID,null
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_nntpserver_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_nntpserver_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_nntpserver_delete](
                @NntpServerID INT)
AS
    BEGIN
        DELETE FROM yaf_NntpTopic
        WHERE       NntpForumID IN (SELECT NntpForumID
                        FROM   yaf_NntpForum
                        WHERE  NntpServerID = @NntpServerID)
        DELETE FROM yaf_NntpForum
        WHERE       NntpServerID = @NntpServerID
        DELETE FROM yaf_NntpServer
        WHERE       NntpServerID = @NntpServerID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_nntpserver_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_nntpserver_list] 
GO

CREATE PROCEDURE [dbo].[yaf_nntpserver_list](
                @BoardID      INT  = NULL,
                @NntpServerID INT  = NULL)
AS
    BEGIN
        IF @NntpServerID IS NULL
        SELECT   *
        FROM     yaf_NntpServer
        WHERE    BoardID = @BoardID
        ORDER BY Name
        ELSE
        SELECT *
        FROM   yaf_NntpServer
        WHERE  NntpServerID = @NntpServerID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_nntpserver_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_nntpserver_save] 
GO

CREATE PROCEDURE [dbo].[yaf_nntpserver_save](
                @NntpServerID INT  = NULL,
                @BoardID      INT,
                @Name         NVARCHAR(50),
                @Address      NVARCHAR(100),
                @Port         INT,
                @UserName     NVARCHAR(50)  = NULL,
                @UserPass     NVARCHAR(50)  = NULL)
AS
    BEGIN
        IF @NntpServerID IS NULL
        INSERT INTO yaf_NntpServer
                   (Name,
                    BoardID,
                    Address,
                    Port,
                    UserName,
                    UserPass)
        VALUES     (@Name,
                    @BoardID,
                    @Address,
                    @Port,
                    @UserName,
                    @UserPass)
        ELSE
        UPDATE yaf_NntpServer
        SET    Name = @Name,
               Address = @Address,
               Port = @Port,
               UserName = @UserName,
               UserPass = @UserPass
        WHERE  NntpServerID = @NntpServerID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_nntptopic_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_nntptopic_list] 
GO


CREATE PROCEDURE [dbo].[yaf_nntptopic_list](
                @Thread CHAR(32))
AS
    BEGIN
        SELECT a.*
        FROM   yaf_NntpTopic a
        WHERE  a.Thread = @Thread
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_nntptopic_savemessage]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_nntptopic_savemessage] 
GO

CREATE PROCEDURE [dbo].[yaf_nntptopic_savemessage](
                @NntpForumID INT,
                @Topic       NVARCHAR(100),
                @Body        NTEXT,
                @UserID      INT,
                @UserName    NVARCHAR(50),
                @IP          NVARCHAR(15),
                @Posted      DATETIME,
                @Thread      CHAR(32))
AS
    BEGIN
        DECLARE  @ForumID INT
        DECLARE  @TopicID INT
        DECLARE  @MessageID INT
        SELECT @ForumID = ForumID
        FROM   yaf_NntpForum
        WHERE  NntpForumID = @NntpForumID
        IF EXISTS (SELECT 1
                   FROM   yaf_NntpTopic
                   WHERE  Thread = @Thread)
        BEGIN
            -- thread exists
            SELECT @TopicID = TopicID
            FROM   yaf_NntpTopic
            WHERE  Thread = @Thread
        END
        ELSE
        BEGIN
            -- thread doesn't exists
            INSERT INTO yaf_Topic
                       (ForumID,
                        UserID,
                        UserName,
                        Posted,
                        Topic,
                        Views,
                        Priority,
                        NumPosts)
            VALUES     (@ForumID,
                        @UserID,
                        @UserName,
                        @Posted,
                        @Topic,
                        0,
                        0,
                        0)
            SET @TopicID = Scope_identity()
            INSERT INTO yaf_NntpTopic
                       (NntpForumID,
                        Thread,
                        TopicID)
            VALUES     (@NntpForumID,
                        @Thread,
                        @TopicID)
        END
        -- save message
        INSERT INTO yaf_Message
                   (TopicID,
                    UserID,
                    UserName,
                    Posted,
                    Message,
                    IP,
                    Position,
                    Indent)
        VALUES     (@TopicID,
                    @UserID,
                    @UserName,
                    @Posted,
                    @Body,
                    @IP,
                    0,
                    0)
        SET @MessageID = Scope_identity()
        -- update user
        IF EXISTS (SELECT 1
                   FROM   yaf_Forum
                   WHERE  ForumID = @ForumID
                   AND (Flags & 4) = 0)
        BEGIN
            UPDATE yaf_User
            SET    NumPosts = NumPosts + 1
            WHERE  UserID = @UserID
        END
        -- update topic
        UPDATE yaf_Topic
        SET    LastPosted = @Posted,
               LastMessageID = @MessageID,
               LastUserID = @UserID,
               LastUserName = @UserName
        WHERE  TopicID = @TopicID
        -- update forum
        UPDATE yaf_Forum
        SET    LastPosted = @Posted,
               LastTopicID = @TopicID,
               LastMessageID = @MessageID,
               LastUserID = @UserID,
               LastUserName = @UserName
        WHERE  ForumID = @ForumID
        AND (LastPosted IS NULL 
              OR LastPosted < @Posted)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_pageload]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_pageload] 
GO

CREATE PROCEDURE [dbo].[yaf_pageload](
                @SessionID  NVARCHAR(24),
                @BoardID    INT,
                @User       NVARCHAR(50),
                @IP         NVARCHAR(15),
                @Location   NVARCHAR(50),
                @Browser    NVARCHAR(50),
                @Platform   NVARCHAR(50),
                @CategoryID INT  = NULL,
                @ForumID    INT  = NULL,
                @TopicID    INT  = NULL,
                @MessageID  INT  = NULL)
AS
    BEGIN
        DECLARE  @UserID INT
        DECLARE  @UserBoardID INT
        DECLARE  @IsGuest TINYINT
        DECLARE  @rowcount INT
        DECLARE  @PreviousVisit DATETIME
        SET implicit_transactions  off
        IF @User IS NULL 
            OR @User = ''
        BEGIN
            SELECT @UserID = a.UserID
            FROM   yaf_User a,
                   yaf_UserGroup b,
                   yaf_Group c
            WHERE  a.UserID = b.UserID
            AND a.BoardID = @BoardID
            AND b.GroupID = c.GroupID
            AND (c.Flags & 2) <> 0
            SET @rowcount = @@ROWCOUNT
            IF @rowcount <> 1
            BEGIN
                RAISERROR ('Found %d possible guest users. Only 1 guest user should be a member of the group marked as the guest group.',16,1,@rowcount)
            END
            SET @IsGuest = 1
            SET @UserBoardID = @BoardID
        END
        ELSE
        BEGIN
            SELECT @UserID = UserID,
                   @UserBoardID = BoardID
            FROM   yaf_User
            WHERE  BoardID = @BoardID
            AND Name = @User
            SET @IsGuest = 0
        END
        -- Check valid ForumID
        IF @ForumID IS NOT NULL 
           AND NOT EXISTS (SELECT 1
                           FROM   yaf_Forum
                           WHERE  ForumID = @ForumID)
        BEGIN
            SET @ForumID = NULL
        END
        -- Check valid CategoryID
        IF @CategoryID IS NOT NULL 
           AND NOT EXISTS (SELECT 1
                           FROM   yaf_Category
                           WHERE  CategoryID = @CategoryID)
        BEGIN
            SET @CategoryID = NULL
        END
        -- Check valid MessageID
        IF @MessageID IS NOT NULL 
           AND NOT EXISTS (SELECT 1
                           FROM   yaf_Message
                           WHERE  MessageID = @MessageID)
        BEGIN
            SET @MessageID = NULL
        END
        -- Check valid TopicID
        IF @TopicID IS NOT NULL 
           AND NOT EXISTS (SELECT 1
                           FROM   yaf_Topic
                           WHERE  TopicID = @TopicID)
        BEGIN
            SET @TopicID = NULL
        END
        -- get previous visit
        IF @IsGuest = 0
        BEGIN
            SELECT @PreviousVisit = LastVisit
            FROM   dbo.yaf_User
            WHERE  UserID = @UserID
        END
        -- update last visit
        UPDATE yaf_User
        SET    LastVisit = Getdate(),
               IP = @IP
        WHERE  UserID = @UserID
        -- find missing ForumID/TopicID
        IF @MessageID IS NOT NULL
        BEGIN
            SELECT @CategoryID = c.CategoryID,
                   @ForumID = b.ForumID,
                   @TopicID = b.TopicID
            FROM   yaf_Message a,
                   yaf_Topic b,
                   yaf_Forum c,
                   yaf_Category d
            WHERE  a.MessageID = @MessageID
            AND b.TopicID = a.TopicID
            AND c.ForumID = b.ForumID
            AND d.CategoryID = c.CategoryID
            AND d.BoardID = @BoardID
        END
        ELSE
        IF @TopicID IS NOT NULL
        BEGIN
            SELECT @CategoryID = b.CategoryID,
                   @ForumID = a.ForumID
            FROM   yaf_Topic a,
                   yaf_Forum b,
                   yaf_Category c
            WHERE  a.TopicID = @TopicID
            AND b.ForumID = a.ForumID
            AND c.CategoryID = b.CategoryID
            AND c.BoardID = @BoardID
        END
        ELSE
        IF @ForumID IS NOT NULL
        BEGIN
            SELECT @CategoryID = a.CategoryID
            FROM   yaf_Forum a,
                   yaf_Category b
            WHERE  a.ForumID = @ForumID
            AND b.CategoryID = a.CategoryID
            AND b.BoardID = @BoardID
        END
        -- update active
        IF @UserID IS NOT NULL 
           AND @UserBoardID = @BoardID
        BEGIN
            IF EXISTS (SELECT 1
                       FROM   yaf_Active
                       WHERE  SessionID = @SessionID
                       AND BoardID = @BoardID)
            BEGIN
                UPDATE yaf_Active
                SET    UserID = @UserID,
                       IP = @IP,
                       LastActive = Getdate(),
                       Location = @Location,
                       ForumID = @ForumID,
                       TopicID = @TopicID,
                       Browser = @Browser,
                       Platform = @Platform
                WHERE  SessionID = @SessionID
            END
            ELSE
            BEGIN
                INSERT INTO yaf_Active
                           (SessionID,
                            BoardID,
                            UserID,
                            IP,
                            Login,
                            LastActive,
                            Location,
                            ForumID,
                            TopicID,
                            Browser,
                            Platform)
                VALUES     (@SessionID,
                            @BoardID,
                            @UserID,
                            @IP,
                            Getdate(),
                            Getdate(),
                            @Location,
                            @ForumID,
                            @TopicID,
                            @Browser,
                            @Platform)
            END
            -- remove duplicate users
            IF @IsGuest = 0
            DELETE FROM yaf_Active
            WHERE       UserID = @UserID
            AND BoardID = @BoardID
            AND SessionID <> @SessionID
        END
        -- return information
        SELECT a.UserID,
               UserFlags = a.Flags,
               UserName = a.Name,
               Suspended = a.Suspended,
               ThemeFile = a.ThemeFile,
               LanguageFile = a.LanguageFile,
               TimeZoneUser = a.TimeZone,
               PreviousVisit = @PreviousVisit,
               x.*,
               CategoryID = @CategoryID,
               CategoryName = (SELECT Name
                               FROM   yaf_Category
                               WHERE  CategoryID = @CategoryID),
               ForumID = @ForumID,
               ForumName = (SELECT Name
                            FROM   yaf_Forum
                            WHERE  ForumID = @ForumID),
               TopicID = @TopicID,
               TopicName = (SELECT Topic
                            FROM   yaf_Topic
                            WHERE  TopicID = @TopicID),
               MailsPending = (SELECT COUNT(1)
                               FROM   yaf_Mail),
               Incoming = (SELECT COUNT(1)
                           FROM   yaf_UserPMessage
                           WHERE  UserID = a.UserID
                           AND IsRead = 0),
               ForumTheme = (SELECT ThemeURL
                             FROM   yaf_Forum
                             WHERE  ForumID = @ForumID)
        FROM   yaf_User a,
               yaf_vaccess x
        WHERE  a.UserID = @UserID
        AND x.UserID = a.UserID
        AND x.ForumID = Isnull(@ForumID,0)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_pmessage_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_pmessage_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_pmessage_delete](
                @PMessageID INT)
AS
    BEGIN
        DELETE FROM yaf_PMessage
        WHERE       PMessageID = @PMessageID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_pmessage_info]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_pmessage_info] 
GO

CREATE PROCEDURE [dbo].[yaf_pmessage_info]
AS
    BEGIN
        SELECT NumRead = (SELECT COUNT(1)
                          FROM   yaf_UserPMessage
                          WHERE  IsRead <> 0),
               NumUnread = (SELECT COUNT(1)
                            FROM   yaf_UserPMessage
                            WHERE  IsRead = 0),
               NumTotal = (SELECT COUNT(1)
                           FROM   yaf_UserPMessage)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_pmessage_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_pmessage_list] 
GO

CREATE PROCEDURE [dbo].[yaf_pmessage_list](
                @FromUserID INT  = NULL,
                @ToUserID   INT  = NULL,
                @PMessageID INT  = NULL)
AS
    BEGIN
        IF @PMessageID IS NULL
        BEGIN
            SELECT   a.*,
                     FromUser = b.Name,
                     ToUserID = c.UserID,
                     ToUser = c.Name,
                     d.IsRead,
                     d.UserPMessageID
            FROM     yaf_PMessage a,
                     yaf_User b,
                     yaf_User c,
                     yaf_UserPMessage d
            WHERE    b.UserID = a.FromUserID
            AND c.UserID = d.UserID
            AND d.PMessageID = a.PMessageID
            AND ((@ToUserID IS NOT NULL 
                  AND d.UserID = @ToUserID)
                  OR (@FromUserID IS NOT NULL 
                      AND a.FromUserID = @FromUserID))
            ORDER BY Created DESC
        END
        ELSE
        BEGIN
            SELECT   a.*,
                     FromUser = b.Name,
                     ToUserID = c.UserID,
                     ToUser = c.Name,
                     d.IsRead,
                     d.UserPMessageID
            FROM     yaf_PMessage a,
                     yaf_User b,
                     yaf_User c,
                     yaf_UserPMessage d
            WHERE    b.UserID = a.FromUserID
            AND c.UserID = d.UserID
            AND d.PMessageID = a.PMessageID
            AND a.PMessageID = @PMessageID
            AND c.UserID = @FromUserID
            ORDER BY Created DESC
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_pmessage_markread]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_pmessage_markread] 
GO

CREATE PROCEDURE [dbo].[yaf_pmessage_markread](
                @UserPMessageID INT  = NULL)
AS
    BEGIN
        UPDATE yaf_UserPMessage
        SET    IsRead = 1
        WHERE  UserPMessageID = @UserPMessageID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_pmessage_prune]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_pmessage_prune] 
GO

CREATE PROCEDURE [dbo].[yaf_pmessage_prune](
                @DaysRead   INT,
                @DaysUnread INT)
AS
    BEGIN
        DELETE FROM yaf_UserPMessage
        WHERE       IsRead <> 0
        AND Datediff(dd,(SELECT Created
                         FROM   yaf_PMessage x
                         WHERE  x.PMessageID = yaf_UserPMessage.PMessageID),
                     Getdate()) > @DaysRead
        DELETE FROM yaf_UserPMessage
        WHERE       IsRead = 0
        AND Datediff(dd,(SELECT Created
                         FROM   yaf_PMessage x
                         WHERE  x.PMessageID = yaf_UserPMessage.PMessageID),
                     Getdate()) > @DaysUnread
        DELETE FROM yaf_PMessage
        WHERE       NOT EXISTS (SELECT 1
                    FROM   yaf_UserPMessage x
                    WHERE  x.PMessageID = yaf_PMessage.PMessageID)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_pmessage_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_pmessage_save] 
GO

CREATE PROCEDURE [dbo].[yaf_pmessage_save](
                @FromUserID INT,
                @ToUserID   INT,
                @Subject    NVARCHAR(100),
                @Body       NTEXT,
                @Flags      INT)
AS
    BEGIN
        DECLARE  @PMessageID INT
        DECLARE  @UserID INT
        INSERT INTO yaf_PMessage
                   (FromUserID,
                    Created,
                    Subject,
                    Body,
                    Flags)
        VALUES     (@FromUserID,
                    Getdate(),
                    @Subject,
                    @Body,
                    @Flags)
        SET @PMessageID = Scope_identity()
        IF (@ToUserID = 0)
        BEGIN
            INSERT INTO yaf_UserPMessage
                       (UserID,
                        PMessageID,
                        IsRead)
            SELECT   a.UserID,
                     @PMessageID,
                     0
            FROM     yaf_User a
                     JOIN yaf_UserGroup b
                       ON b.UserID = a.UserID
                     JOIN yaf_Group c
                       ON c.GroupID = b.GroupID
            WHERE    (c.Flags & 2) = 0
            AND c.BoardID = (SELECT BoardID
                             FROM   yaf_User x
                             WHERE  x.UserID = @FromUserID)
            AND a.UserID <> @FromUserID
            GROUP BY a.UserID
        END
        ELSE
        BEGIN
            INSERT INTO yaf_UserPMessage
                       (UserID,
                        PMessageID,
                        IsRead)
            VALUES     (@ToUserID,
                        @PMessageID,
                        0)
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_poll_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_poll_save] 
GO

CREATE PROCEDURE [dbo].[yaf_poll_save](
                @Question NVARCHAR(50),
                @Choice1  NVARCHAR(50),
                @Choice2  NVARCHAR(50),
                @Choice3  NVARCHAR(50)  = NULL,
                @Choice4  NVARCHAR(50)  = NULL,
                @Choice5  NVARCHAR(50)  = NULL,
                @Choice6  NVARCHAR(50)  = NULL,
                @Choice7  NVARCHAR(50)  = NULL,
                @Choice8  NVARCHAR(50)  = NULL,
                @Choice9  NVARCHAR(50)  = NULL,
                @Closes   DATETIME  = NULL)
AS
    BEGIN
        DECLARE  @PollID INT
        INSERT INTO yaf_Poll
                   (Question,
                    Closes)
        VALUES     (@Question,
                    @Closes)
        SET @PollID = Scope_identity()
        IF @Choice1 <> ''
           AND @Choice1 IS NOT NULL
        INSERT INTO yaf_Choice
                   (PollID,
                    Choice,
                    Votes)
        VALUES     (@PollID,
                    @Choice1,
                    0)
        IF @Choice2 <> ''
           AND @Choice2 IS NOT NULL
        INSERT INTO yaf_Choice
                   (PollID,
                    Choice,
                    Votes)
        VALUES     (@PollID,
                    @Choice2,
                    0)
        IF @Choice3 <> ''
           AND @Choice3 IS NOT NULL
        INSERT INTO yaf_Choice
                   (PollID,
                    Choice,
                    Votes)
        VALUES     (@PollID,
                    @Choice3,
                    0)
        IF @Choice4 <> ''
           AND @Choice4 IS NOT NULL
        INSERT INTO yaf_Choice
                   (PollID,
                    Choice,
                    Votes)
        VALUES     (@PollID,
                    @Choice4,
                    0)
        IF @Choice5 <> ''
           AND @Choice5 IS NOT NULL
        INSERT INTO yaf_Choice
                   (PollID,
                    Choice,
                    Votes)
        VALUES     (@PollID,
                    @Choice5,
                    0)
        IF @Choice6 <> ''
           AND @Choice6 IS NOT NULL
        INSERT INTO yaf_Choice
                   (PollID,
                    Choice,
                    Votes)
        VALUES     (@PollID,
                    @Choice6,
                    0)
        IF @Choice7 <> ''
           AND @Choice7 IS NOT NULL
        INSERT INTO yaf_Choice
                   (PollID,
                    Choice,
                    Votes)
        VALUES     (@PollID,
                    @Choice7,
                    0)
        IF @Choice8 <> ''
           AND @Choice8 IS NOT NULL
        INSERT INTO yaf_Choice
                   (PollID,
                    Choice,
                    Votes)
        VALUES     (@PollID,
                    @Choice8,
                    0)
        IF @Choice9 <> ''
           AND @Choice9 IS NOT NULL
        INSERT INTO yaf_Choice
                   (PollID,
                    Choice,
                    Votes)
        VALUES     (@PollID,
                    @Choice9,
                    0)
        SELECT PollID = @PollID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_poll_stats]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_poll_stats] 
GO

CREATE PROCEDURE [dbo].[yaf_poll_stats](
                @PollID INT)
AS
    BEGIN
        SELECT a.PollID,
               b.Question,
               b.Closes,
               a.ChoiceID,
               a.Choice,
               a.Votes,
               Stats = (SELECT 100 * a.Votes / CASE SUM(x.Votes) 
                                                 WHEN 0 THEN 1
                                                 ELSE SUM(x.Votes)
                                               END
                        FROM   yaf_Choice x
                        WHERE  x.PollID = a.PollID)
        FROM   yaf_Choice a,
               yaf_Poll b
        WHERE  b.PollID = a.PollID
        AND b.PollID = @PollID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_pollvote_check]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_pollvote_check] 
GO

CREATE PROCEDURE [dbo].[yaf_pollvote_check](
                @PollID   INT,
                @UserID   INT  = NULL,
                @RemoteIP NVARCHAR(10)  = NULL)
AS
    IF @UserID IS NULL
    BEGIN
        IF @RemoteIP IS NOT NULL
        BEGIN
            -- check by remote IP
            SELECT PollVoteID
            FROM   yaf_PollVote
            WHERE  PollID = @PollID
            AND RemoteIP = @RemoteIP
        END
    END
    ELSE
    BEGIN
        -- check by userid or remote IP
        SELECT PollVoteID
        FROM   yaf_PollVote
        WHERE  PollID = @PollID
        AND (UserID = @UserID
              OR RemoteIP = @RemoteIP)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_post_last10user]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_post_last10user] 
GO

CREATE PROCEDURE [dbo].[yaf_post_last10user](
                @BoardID    INT,
                @UserID     INT,
                @PageUserID INT)
AS
    BEGIN
        SET nocount  ON
        SELECT   TOP 10 a.Posted,
                        Subject = c.Topic,
                        a.Message,
                        a.UserID,
                        a.Flags,
                        UserName = Isnull(a.UserName,b.Name),
                        b.Signature,
                        c.TopicID
        FROM     yaf_Message a
                 JOIN yaf_User b
                   ON b.UserID = a.UserID
                 JOIN yaf_Topic c
                   ON c.TopicID = a.TopicID
                 JOIN yaf_Forum d
                   ON d.ForumID = c.ForumID
                 JOIN yaf_Category e
                   ON e.CategoryID = d.CategoryID
                 JOIN yaf_vaccess x
                   ON x.ForumID = d.ForumID
        WHERE    a.UserID = @UserID
        AND x.UserID = @PageUserID
        AND x.ReadAccess <> 0
        AND e.BoardID = @BoardID
        AND (a.Flags & 24) = 16
        AND (c.Flags & 8) = 0
        ORDER BY a.Posted DESC
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_post_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_post_list] 
GO

CREATE PROCEDURE [dbo].[yaf_post_list](
                @TopicID         INT,
                @UpdateViewCount SMALLINT  = 1)
AS
    BEGIN
        SET nocount  ON
        IF @UpdateViewCount > 0
        UPDATE yaf_Topic
        SET    Views = Views + 1
        WHERE  TopicID = @TopicID
        SELECT   d.TopicID,
                 TopicFlags = d.Flags,
                 ForumFlags = g.Flags,
                 a.MessageID,
                 a.Posted,
                 Subject = d.Topic,
                 a.Message,
                 a.UserID,
                 a.Position,
                 a.Indent,
                 a.IP,
                 a.Flags,
                 UserName = Isnull(a.UserName,b.Name),
                 b.Joined,
                 b.Avatar,
                 b.Location,
                 b.Signature,
                 b.HomePage,
                 b.Weblog,
                 b.MSN,
                 b.YIM,
                 b.AIM,
                 b.ICQ,
                 Posts = b.NumPosts,
                 b.Points,
                 d.Views,
                 d.ForumID,
                 RankName = c.Name,
                 c.RankImage,
                 Edited = Isnull(a.Edited,a.Posted),
                 HasAttachments = (SELECT COUNT(1)
                                   FROM   yaf_Attachment x
                                   WHERE  x.MessageID = a.MessageID),
                 HasAvatarImage = (SELECT COUNT(1)
                                   FROM   yaf_User x
                                   WHERE  x.UserID = b.UserID
                                   AND AvatarImage IS NOT NULL)
        FROM     yaf_Message a
                 JOIN yaf_User b
                   ON b.UserID = a.UserID
                 JOIN yaf_Topic d
                   ON d.TopicID = a.TopicID
                 JOIN yaf_Forum g
                   ON g.ForumID = d.ForumID
                 JOIN yaf_Category h
                   ON h.CategoryID = g.CategoryID
                 JOIN yaf_Rank c
                   ON c.RankID = b.RankID
        WHERE    a.TopicID = @TopicID
        AND (a.Flags & 24) = 16
        ORDER BY a.Posted ASC
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_post_list_reverse10]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_post_list_reverse10] 
GO

CREATE PROCEDURE [dbo].[yaf_post_list_reverse10](
                @TopicID INT)
AS
    BEGIN
        SET nocount  ON
        SELECT   TOP 10 a.Posted,
                        Subject = d.Topic,
                        a.Message,
                        a.UserID,
                        a.Flags,
                        UserName = Isnull(a.UserName,b.Name),
                        b.Signature
        FROM     yaf_Message a,
                 yaf_User b,
                 yaf_Topic d
        WHERE    (a.Flags & 24) = 16
        AND a.TopicID = @TopicID
        AND b.UserID = a.UserID
        AND d.TopicID = a.TopicID
        ORDER BY a.Posted DESC
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_rank_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_rank_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_rank_delete](
                @RankID INT)
AS
    BEGIN
        DELETE FROM yaf_Rank
        WHERE       RankID = @RankID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_rank_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_rank_list] 
GO

CREATE PROCEDURE [dbo].[yaf_rank_list](
                @BoardID INT,
                @RankID  INT  = NULL)
AS
    BEGIN
        IF @RankID IS NULL
        SELECT   a.*
        FROM     yaf_Rank a
        WHERE    a.BoardID = @BoardID
        ORDER BY a.Name
        ELSE
        SELECT a.*
        FROM   yaf_Rank a
        WHERE  a.RankID = @RankID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_rank_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_rank_save] 
GO

CREATE PROCEDURE [dbo].[yaf_rank_save](
                @RankID    INT,
                @BoardID   INT,
                @Name      NVARCHAR(50),
                @IsStart   BIT,
                @IsLadder  BIT,
                @MinPosts  INT,
                @RankImage NVARCHAR(50)  = NULL)
AS
    BEGIN
        DECLARE  @Flags INT
        IF @IsLadder = 0
        SET @MinPosts = NULL
        IF @IsLadder = 1
           AND @MinPosts IS NULL
        SET @MinPosts = 0
        SET @Flags = 0
        IF @IsStart <> 0
        SET @Flags = @Flags | 1
        IF @IsLadder <> 0
        SET @Flags = @Flags | 2
        IF @RankID > 0
        BEGIN
            UPDATE yaf_Rank
            SET    Name = @Name,
                   Flags = @Flags,
                   MinPosts = @MinPosts,
                   RankImage = @RankImage
            WHERE  RankID = @RankID
        END
        ELSE
        BEGIN
            INSERT INTO yaf_Rank
                       (BoardID,
                        Name,
                        Flags,
                        MinPosts,
                        RankImage)
            VALUES     (@BoardID,
                        @Name,
                        @Flags,
                        @MinPosts,
                        @RankImage);
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_registry_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_registry_list] 
GO

CREATE PROCEDURE [dbo].[yaf_registry_list](
                @Name    NVARCHAR(50)  = NULL,
                @BoardID INT  = NULL)
AS
    BEGIN
        IF @BoardID IS NULL
        BEGIN
            IF @Name IS NULL 
                OR @Name = ''
            BEGIN
                SELECT *
                FROM   yaf_Registry
                WHERE  BoardID IS NULL
            END
            ELSE
            BEGIN
                SELECT *
                FROM   yaf_Registry
                WHERE  Lower(Name) = Lower(@Name)
                AND BoardID IS NULL
            END
        END
        ELSE
        BEGIN
            IF @Name IS NULL 
                OR @Name = ''
            BEGIN
                SELECT *
                FROM   yaf_Registry
                WHERE  BoardID = @BoardID
            END
            ELSE
            BEGIN
                SELECT *
                FROM   yaf_Registry
                WHERE  Lower(Name) = Lower(@Name)
                AND BoardID = @BoardID
            END
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_registry_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_registry_save] 
GO

CREATE PROCEDURE [dbo].[yaf_registry_save](
                @Name    NVARCHAR(50),
                @Value   NTEXT  = NULL,
                @BoardID INT  = NULL)
AS
    BEGIN
        IF @BoardID IS NULL
        BEGIN
            IF EXISTS (SELECT 1
                       FROM   yaf_Registry
                       WHERE  Lower(Name) = Lower(@Name))
            UPDATE yaf_Registry
            SET    VALUE = @Value
            WHERE  Lower(Name) = Lower(@Name)
            AND BoardID IS NULL
            ELSE
            BEGIN
                INSERT INTO yaf_Registry
                           (Name,
                            VALUE)
                VALUES     (Lower(@Name),
                            @Value)
            END
        END
        ELSE
        BEGIN
            IF EXISTS (SELECT 1
                       FROM   yaf_Registry
                       WHERE  Lower(Name) = Lower(@Name)
                       AND BoardID = @BoardID)
            UPDATE yaf_Registry
            SET    VALUE = @Value
            WHERE  Lower(Name) = Lower(@Name)
            AND BoardID = @BoardID
            ELSE
            BEGIN
                INSERT INTO yaf_Registry
                           (Name,
                            VALUE,
                            BoardID)
                VALUES     (Lower(@Name),
                            @Value,
                            @BoardID)
            END
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_replace_words_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_replace_words_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_replace_words_delete](
                @ID INT)
AS
    BEGIN
        DELETE FROM dbo.yaf_replace_words
        WHERE       ID = @ID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_replace_words_edit]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_replace_words_edit] 
GO

CREATE PROCEDURE [dbo].[yaf_replace_words_edit](
                @ID INT  = NULL)
AS
    BEGIN
        SELECT *
        FROM   yaf_replace_words
        WHERE  ID = @ID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_replace_words_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_replace_words_list] 
GO

CREATE PROCEDURE [dbo].[yaf_replace_words_list]
AS
    BEGIN
        SELECT *
        FROM   yaf_Replace_Words
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_replace_words_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_replace_words_save] 
GO


CREATE PROCEDURE [dbo].[yaf_replace_words_save](
                @ID       INT  = NULL,
                @badword  NVARCHAR(255),
                @goodword NVARCHAR(255))
AS
    BEGIN
        IF @ID IS NULL 
            OR @ID = 0
        BEGIN
            INSERT INTO yaf_replace_words
                       (badword,
                        goodword)
            VALUES     (@badword,
                        @goodword)
        END
        ELSE
        BEGIN
            UPDATE yaf_replace_words
            SET    badword = @badword,
                   goodword = @goodword
            WHERE  ID = @ID
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_smiley_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_smiley_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_smiley_delete](
                @SmileyID INT  = NULL)
AS
    BEGIN
        IF @SmileyID IS NOT NULL
        DELETE FROM yaf_Smiley
        WHERE       SmileyID = @SmileyID
        ELSE
        DELETE FROM yaf_Smiley
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_smiley_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_smiley_list] 
GO

CREATE PROCEDURE [dbo].[yaf_smiley_list](
                @BoardID  INT,
                @SmileyID INT  = NULL)
AS
    BEGIN
        IF @SmileyID IS NULL
        SELECT   *
        FROM     yaf_Smiley
        WHERE    BoardID = @BoardID
        ORDER BY Len(Code) DESC
        ELSE
        SELECT *
        FROM   yaf_Smiley
        WHERE  SmileyID = @SmileyID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_smiley_listunique]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_smiley_listunique] 
GO

CREATE PROCEDURE [dbo].[yaf_smiley_listunique](
                @BoardID INT)
AS
    BEGIN
        SELECT   Icon,
                 Emoticon,
                 Code = (SELECT TOP 1 Code
                         FROM   yaf_Smiley x
                         WHERE  x.Icon = yaf_Smiley.Icon)
        FROM     yaf_Smiley
        WHERE    BoardID = @BoardID
        GROUP BY Icon,Emoticon
        ORDER BY Code
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_smiley_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_smiley_save] 
GO

CREATE PROCEDURE [dbo].[yaf_smiley_save](
                @SmileyID INT  = NULL,
                @BoardID  INT,
                @Code     NVARCHAR(10),
                @Icon     NVARCHAR(50),
                @Emoticon NVARCHAR(50),
                @Replace  SMALLINT  = 0)
AS
    BEGIN
        IF @SmileyID IS NOT NULL
        BEGIN
            UPDATE yaf_Smiley
            SET    Code = @Code,
                   Icon = @Icon,
                   Emoticon = @Emoticon
            WHERE  SmileyID = @SmileyID
        END
        ELSE
        BEGIN
            IF @Replace > 0
            DELETE FROM yaf_Smiley
            WHERE       Code = @Code
            IF NOT EXISTS (SELECT 1
                           FROM   yaf_Smiley
                           WHERE  BoardID = @BoardID
                           AND Code = @Code)
            INSERT INTO yaf_Smiley
                       (BoardID,
                        Code,
                        Icon,
                        Emoticon)
            VALUES     (@BoardID,
                        @Code,
                        @Icon,
                        @Emoticon)
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_system_initialize]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_system_initialize] 
GO

CREATE PROCEDURE [dbo].[yaf_system_initialize](
                @Name       NVARCHAR(50),
                @TimeZone   INT,
                @ForumEmail NVARCHAR(50),
                @SmtpServer NVARCHAR(50),
                @User       NVARCHAR(50),
                @UserEmail  NVARCHAR(50),
                @Password   NVARCHAR(32))
AS
    BEGIN
        DECLARE  @tmpValue  AS NVARCHAR(100)
        -- initalize required 'registry' settings
        EXEC yaf_registry_save
             'Version' ,
             '1'
        EXEC yaf_registry_save
             'VersionName' ,
             '1.0.0'
        SET @tmpValue = CAST(@TimeZone AS NVARCHAR(100))
        EXEC yaf_registry_save
             'TimeZone' ,
             @tmpValue
        EXEC yaf_registry_save
             'SmtpServer' ,
             @SmtpServer
        EXEC yaf_registry_save
             'ForumEmail' ,
             @ForumEmail
        -- initalize new board
        EXEC yaf_board_create
             @Name ,
             0 ,
             @User ,
             @UserEmail ,
             @Password ,
             1
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_system_updateversion]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_system_updateversion] 
GO

CREATE PROCEDURE [dbo].[yaf_system_updateversion](
                @Version     INT,
                @VersionName NVARCHAR(50))
AS
    BEGIN
        DECLARE  @tmpValue  AS NVARCHAR(100)
        SET @tmpValue = CAST(@Version AS NVARCHAR(100))
        EXEC yaf_registry_save
             'Version' ,
             @tmpValue
        EXEC yaf_registry_save
             'VersionName' ,
             @VersionName
            
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_active]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_active] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_active](
                @BoardID    INT,
                @UserID     INT,
                @Since      DATETIME,
                @CategoryID INT  = NULL)
AS
    BEGIN
        SELECT   c.ForumID,
                 c.TopicID,
                 c.Posted,
                 LinkTopicID = Isnull(c.TopicMovedID,c.TopicID),
                 Subject = c.Topic,
                 c.UserID,
                 Starter = Isnull(c.UserName,b.Name),
                 Replies = (SELECT COUNT(1)
                            FROM   yaf_Message x
                            WHERE  x.TopicID = c.TopicID
                            AND (x.Flags & 8) = 0) - 1,
                 Views = c.Views,
                 LastPosted = c.LastPosted,
                 LastUserID = c.LastUserID,
                 LastUserName = Isnull(c.LastUserName,(SELECT Name
                                                       FROM   yaf_User x
                                                       WHERE  x.UserID = c.LastUserID)),
                 LastMessageID = c.LastMessageID,
                 LastTopicID = c.TopicID,
                 TopicFlags = c.Flags,
                 c.Priority,
                 c.PollID,
                 ForumName = d.Name,
                 c.TopicMovedID,
                 ForumFlags = d.Flags
        FROM     yaf_Topic c
                 JOIN yaf_User b
                   ON b.UserID = c.UserID
                 JOIN yaf_Forum d
                   ON d.ForumID = c.ForumID
                 JOIN yaf_vaccess x
                   ON x.ForumID = d.ForumID
                 JOIN yaf_Category e
                   ON e.CategoryID = d.CategoryID
        WHERE    @Since < c.LastPosted
        AND x.UserID = @UserID
        AND x.ReadAccess <> 0
        AND e.BoardID = @BoardID
        AND (c.Flags & 8) = 0
        AND (@CategoryID IS NULL 
              OR e.CategoryID = @CategoryID)
        ORDER BY d.Name ASC,
                 Priority DESC,
                 LastPosted DESC
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_delete](
                @TopicID        INT,
                @UpdateLastPost BIT  = 1,
                @EraseTopic     BIT  = 0)
AS
    BEGIN
        SET NOCOUNT  ON
        DECLARE  @ForumID INT
        DECLARE  @pollID INT
        SELECT @ForumID = ForumID
        FROM   yaf_Topic
        WHERE  TopicID = @TopicID
        UPDATE yaf_Topic
        SET    LastMessageID = NULL
        WHERE  TopicID = @TopicID
        UPDATE yaf_Forum
        SET    LastTopicID = NULL,
               LastMessageID = NULL,
               LastUserID = NULL,
               LastUserName = NULL,
               LastPosted = NULL
        WHERE  LastMessageID IN (SELECT MessageID
                          FROM   yaf_Message
                          WHERE  TopicID = @TopicID)
        UPDATE yaf_Active
        SET    TopicID = NULL
        WHERE  TopicID = @TopicID
        --remove polls
        SELECT @pollID = pollID
        FROM   yaf_topic
        WHERE  TopicID = @TopicID
        IF (@pollID IS NOT NULL)
        BEGIN
            DELETE FROM yaf_choice
            WHERE       PollID = @PollID
            UPDATE yaf_topic
            SET    PollID = NULL
            WHERE  TopicID = @TopicID
            DELETE FROM yaf_poll
            WHERE       PollID = @PollID
        END
        --delete messages and topics
        DELETE FROM yaf_nntptopic
        WHERE       TopicID = @TopicID
        DELETE FROM yaf_topic
        WHERE       TopicMovedID = @TopicID
        IF @EraseTopic = 0
        BEGIN
            UPDATE yaf_topic
            SET    Flags = Flags | 8
            WHERE  TopicID = @TopicID
        END
        ELSE
        BEGIN
            DELETE FROM yaf_attachment
            WHERE       MessageID IN (SELECT MessageID
                          FROM   yaf_message
                          WHERE  TopicID = @TopicID)
            DELETE FROM yaf_message
            WHERE       TopicID = @TopicID
            DELETE FROM yaf_topic
            WHERE       TopicID = @TopicID
        END
        --commit
        IF @UpdateLastPost <> 0
        EXEC yaf_forum_updatelastpost
             @ForumID
        IF @ForumID IS NOT NULL
        EXEC yaf_forum_updatestats
             @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_findnext]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_findnext] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_findnext](
                @TopicID INT)
AS
    BEGIN
        DECLARE  @LastPosted DATETIME
        DECLARE  @ForumID INT
        SELECT @LastPosted = LastPosted,
               @ForumID = ForumID
        FROM   yaf_Topic
        WHERE  TopicID = @TopicID
        SELECT   TOP 1 TopicID
        FROM     yaf_Topic
        WHERE    LastPosted > @LastPosted
        AND ForumID = @ForumID
        AND (Flags & 8) = 0
        ORDER BY LastPosted ASC
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_findprev]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_findprev] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_findprev](
                @TopicID INT)
AS
    BEGIN
        DECLARE  @LastPosted DATETIME
        DECLARE  @ForumID INT
        SELECT @LastPosted = LastPosted,
               @ForumID = ForumID
        FROM   yaf_Topic
        WHERE  TopicID = @TopicID
        SELECT   TOP 1 TopicID
        FROM     yaf_Topic
        WHERE    LastPosted < @LastPosted
        AND ForumID = @ForumID
        AND (Flags & 8) = 0
        ORDER BY LastPosted DESC
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_info]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_info] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_info](
                @TopicID     INT  = NULL,
                @ShowDeleted BIT  = 0)
AS
    BEGIN
        IF @TopicID = 0
        SET @TopicID = NULL
        IF @TopicID IS NULL
        BEGIN
            IF @ShowDeleted = 1
            SELECT *
            FROM   yaf_Topic
            ELSE
            SELECT *
            FROM   yaf_Topic
            WHERE  (Flags & 8) = 0
        END
        ELSE
        BEGIN
            IF @ShowDeleted = 1
            SELECT *
            FROM   yaf_Topic
            WHERE  TopicID = @TopicID
            ELSE
            SELECT *
            FROM   yaf_Topic
            WHERE  TopicID = @TopicID
            AND (Flags & 8) = 0
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_latest]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_latest] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_latest](
                @BoardID  INT,
                @NumPosts INT,
                @UserID   INT)
AS
BEGIN
	SET ROWCOUNT @NumPosts
	
	SELECT
		t.LastPosted,
		t.ForumID,
		f.Name as Forum,
		t.Topic,
		t.TopicID,
		t.LastMessageID,
		t.LastUserID,
		t.NumPosts,
		LastUserName = IsNull(t.LastUserName,(select [Name] from [dbo].[yaf_User] x where x.UserID = t.LastUserID))
	FROM 
		[dbo].[yaf_Topic] t
	INNER JOIN
		[dbo].[yaf_Forum] f ON t.ForumID = f.ForumID	
	INNER JOIN
		[dbo].[yaf_Category] c ON c.CategoryID = f.CategoryID
	JOIN
		[dbo].[yaf_vaccess] v ON v.ForumID=f.ForumID
	WHERE
		c.BoardID = @BoardID
		AND t.TopicMovedID is NULL
		AND v.UserID=@UserID
		AND (v.ReadAccess <> 0)
		AND (t.Flags & 8) = 0
	ORDER BY
		t.LastPosted DESC;
END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_list] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_list](
                @ForumID      INT,
                @Announcement SMALLINT,
                @Date         DATETIME  = NULL,
                @Offset       INT,
                @Count        INT)
AS
    BEGIN
        CREATE TABLE #data (
          RowNo   INT IDENTITY PRIMARY KEY NOT NULL,
          TopicID INT NOT NULL)
        INSERT INTO #data
                   (TopicID)
        SELECT   c.TopicID
        FROM     yaf_Topic c
                 JOIN yaf_User b
                   ON b.UserID = c.UserID
                 JOIN yaf_Forum d
                   ON d.ForumID = c.ForumID
        WHERE    c.ForumID = @ForumID
        AND (@Date IS NULL 
              OR c.Posted >= @Date
              OR c.LastPosted >= @Date
              OR Priority > 0)
        AND ((@Announcement = 1
              AND c.Priority = 2)
              OR (@Announcement = 0
                  AND c.Priority <> 2)
              OR (@Announcement < 0))
        AND (c.TopicMovedID IS NOT NULL 
              OR c.NumPosts > 0)
        AND (c.Flags & 8) = 0
        ORDER BY Priority DESC,
                 c.LastPosted DESC
        DECLARE  @RowCount INT
        SET @RowCount = (SELECT COUNT(1)
                         FROM   #data)
        SELECT   [RowCount] = @RowCount,
                 c.ForumID,
                 c.TopicID,
                 c.Posted,
                 LinkTopicID = Isnull(c.TopicMovedID,c.TopicID),
                 c.TopicMovedID,
                 Subject = c.Topic,
                 c.UserID,
                 Starter = Isnull(c.UserName,b.Name),
                 Replies = c.NumPosts - 1,
                 Views = c.Views,
                 LastPosted = c.LastPosted,
                 LastUserID = c.LastUserID,
                 LastUserName = Isnull(c.LastUserName,(SELECT Name
                                                       FROM   yaf_User x
                                                       WHERE  x.UserID = c.LastUserID)),
                 LastMessageID = c.LastMessageID,
                 LastTopicID = c.TopicID,
                 TopicFlags = c.Flags,
                 c.Priority,
                 c.PollID,
                 ForumFlags = d.Flags
        FROM     yaf_Topic c
                 JOIN yaf_User b
                   ON b.UserID = c.UserID
                 JOIN yaf_Forum d
                   ON d.ForumID = c.ForumID
                 JOIN #data e
                   ON e.TopicID = c.TopicID
        WHERE    e.RowNo BETWEEN @Offset + 1
                        AND @Offset + @Count
        ORDER BY e.RowNo
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_listmessages]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_listmessages] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_listmessages](
                @TopicID INT)
AS
    BEGIN
        SELECT *
        FROM   yaf_Message
        WHERE  TopicID = @TopicID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_lock]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_lock] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_lock](
                @TopicID INT,
                @Locked  BIT)
AS
    BEGIN
        IF @Locked <> 0
        UPDATE yaf_Topic
        SET    Flags = Flags | 1
        WHERE  TopicID = @TopicID
        ELSE
        UPDATE yaf_Topic
        SET    Flags = Flags & ~ 1
        WHERE  TopicID = @TopicID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_move]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_move] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_move](
                @TopicID   INT,
                @ForumID   INT,
                @ShowMoved BIT)
AS
    BEGIN
        DECLARE  @OldForumID INT
                             
        SELECT @OldForumID = ForumID
        FROM   yaf_Topic
        WHERE  TopicID = @TopicID
                  
        IF @ShowMoved <> 0
        BEGIN
            -- create a moved message
            INSERT INTO yaf_Topic
                       (ForumID,
                        UserID,
                        UserName,
                        Posted,
                        Topic,
                        Views,
                        Flags,
                        Priority,
                        PollID,
                        TopicMovedID,
                        LastPosted,
                        NumPosts)
            SELECT ForumID,
                   UserID,
                   UserName,
                   Posted,
                   Topic,
                   0,
                   Flags,
                   Priority,
                   PollID,
                   @TopicID,
                   LastPosted,
                   0
            FROM   yaf_Topic
            WHERE  TopicID = @TopicID
        END
        
        -- move the topic
        UPDATE yaf_Topic
        SET    ForumID = @ForumID
        WHERE  TopicID = @TopicID
                  
        -- update last posts
        EXEC yaf_forum_updatelastpost
             @OldForumID
        EXEC yaf_forum_updatelastpost
             @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_prune]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_prune] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_prune](
                @ForumID INT  = NULL,
                @Days    INT)
AS
    BEGIN
        DECLARE  @c CURSOR
        DECLARE  @TopicID INT
        DECLARE  @Count INT
        SET @Count = 0
        IF @ForumID = 0
        SET @ForumID = NULL
        IF @ForumID IS NOT NULL
        BEGIN
            SET @c = CURSOR FOR SELECT TopicID
                                FROM   yaf_Topic
                                WHERE  ForumID = @ForumID
                                AND Priority = 0
                                AND Datediff(dd,LastPosted,Getdate()) > @Days
        END
        ELSE
        BEGIN
            SET @c = CURSOR FOR SELECT TopicID
                                FROM   yaf_Topic
                                WHERE  Priority = 0
                                AND Datediff(dd,LastPosted,Getdate()) > @Days
        END
        OPEN @c
        FETCH  @c
        INTO @TopicID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC yaf_topic_delete
                 @TopicID ,
                 0
            SET @Count = @Count + 1
            FETCH  @c
            INTO @TopicID
        END
        CLOSE @c
        DEALLOCATE @c
        -- This takes forever with many posts...
        --exec yaf_topic_updatelastpost
        SELECT COUNT = @Count
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_save] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_save](
                @ForumID  INT,
                @Subject  NVARCHAR(128),
                @UserID   INT,
                @Message  NTEXT,
                @Priority SMALLINT,
                @UserName NVARCHAR(50)  = NULL,
                @IP       NVARCHAR(15),
                @PollID   INT  = NULL,
                @Posted   DATETIME  = NULL,
                @Flags    INT)
AS
    BEGIN
        DECLARE  @TopicID INT
        DECLARE  @MessageID INT
        IF @Posted IS NULL
        SET @Posted = Getdate()
        INSERT INTO yaf_Topic
                   (ForumID,
                    Topic,
                    UserID,
                    Posted,
                    Views,
                    Priority,
                    PollID,
                    UserName,
                    NumPosts)
        VALUES     (@ForumID,
                    @Subject,
                    @UserID,
                    @Posted,
                    0,
                    @Priority,
                    @PollID,
                    @UserName,
                    0)
        SET @TopicID = Scope_identity()
        EXEC yaf_message_save
             @TopicID ,
             @UserID ,
             @Message ,
             @UserName ,
             @IP ,
             @Posted ,
             NULL ,
             @Flags ,
             @MessageID OUTPUT
        SELECT TopicID = @TopicID,
               MessageID = @MessageID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_updatelastpost]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_updatelastpost] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_updatelastpost](
                @ForumID INT  = NULL,
                @TopicID INT  = NULL)
AS
    BEGIN
        IF @TopicID IS NOT NULL
        UPDATE yaf_Topic
        SET    LastPosted = (SELECT   TOP 1 x.Posted
                             FROM     yaf_Message x
                             WHERE    x.TopicID = yaf_Topic.TopicID
                             AND (x.Flags & 24) = 16
                             ORDER BY Posted DESC),
               LastMessageID = (SELECT   TOP 1 x.MessageID
                                FROM     yaf_Message x
                                WHERE    x.TopicID = yaf_Topic.TopicID
                                AND (x.Flags & 24) = 16
                                ORDER BY Posted DESC),
               LastUserID = (SELECT   TOP 1 x.UserID
                             FROM     yaf_Message x
                             WHERE    x.TopicID = yaf_Topic.TopicID
                             AND (x.Flags & 24) = 16
                             ORDER BY Posted DESC),
               LastUserName = (SELECT   TOP 1 x.UserName
                               FROM     yaf_Message x
                               WHERE    x.TopicID = yaf_Topic.TopicID
                               AND (x.Flags & 24) = 16
                               ORDER BY Posted DESC)
        WHERE  TopicID = @TopicID
        ELSE
        UPDATE yaf_Topic
        SET    LastPosted = (SELECT   TOP 1 x.Posted
                             FROM     yaf_Message x
                             WHERE    x.TopicID = yaf_Topic.TopicID
                             AND (x.Flags & 24) = 16
                             ORDER BY Posted DESC),
               LastMessageID = (SELECT   TOP 1 x.MessageID
                                FROM     yaf_Message x
                                WHERE    x.TopicID = yaf_Topic.TopicID
                                AND (x.Flags & 24) = 16
                                ORDER BY Posted DESC),
               LastUserID = (SELECT   TOP 1 x.UserID
                             FROM     yaf_Message x
                             WHERE    x.TopicID = yaf_Topic.TopicID
                             AND (x.Flags & 24) = 16
                             ORDER BY Posted DESC),
               LastUserName = (SELECT   TOP 1 x.UserName
                               FROM     yaf_Message x
                               WHERE    x.TopicID = yaf_Topic.TopicID
                               AND (x.Flags & 24) = 16
                               ORDER BY Posted DESC)
        WHERE  TopicMovedID IS NULL 
        AND (@ForumID IS NULL 
              OR ForumID = @ForumID)
            
        EXEC yaf_forum_updatelastpost
             @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_accessmasks]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_accessmasks] 
GO

CREATE PROCEDURE [dbo].[yaf_user_accessmasks](
                @BoardID INT,
                @UserID  INT)
AS
    BEGIN
        SELECT   *
        FROM     (SELECT   AccessMaskID = e.AccessMaskID,
                           AccessMaskName = e.Name,
                           ForumID = f.ForumID,
                           ForumName = f.Name
                  FROM     yaf_User a
                           JOIN yaf_UserGroup b
                             ON b.UserID = a.UserID
                           JOIN yaf_Group c
                             ON c.GroupID = b.GroupID
                           JOIN yaf_ForumAccess d
                             ON d.GroupID = c.GroupID
                           JOIN yaf_AccessMask e
                             ON e.AccessMaskID = d.AccessMaskID
                           JOIN yaf_Forum f
                             ON f.ForumID = d.ForumID
                  WHERE    a.UserID = @UserID
                  AND c.BoardID = @BoardID
                  GROUP BY e.AccessMaskID,e.Name,f.ForumID,f.Name
                  UNION 
                  SELECT   AccessMaskID = c.AccessMaskID,
                           AccessMaskName = c.Name,
                           ForumID = d.ForumID,
                           ForumName = d.Name
                  FROM     yaf_User a
                           JOIN yaf_UserForum b
                             ON b.UserID = a.UserID
                           JOIN yaf_AccessMask c
                             ON c.AccessMaskID = b.AccessMaskID
                           JOIN yaf_Forum d
                             ON d.ForumID = b.ForumID
                  WHERE    a.UserID = @UserID
                  AND c.BoardID = @BoardID
                  GROUP BY c.AccessMaskID,c.Name,d.ForumID,d.Name) AS x
        ORDER BY ForumName,
                 AccessMaskName
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_activity_rank]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_activity_rank] 
GO

CREATE PROCEDURE [dbo].[yaf_user_activity_rank](
                @StartDate AS DATETIME)
AS
    BEGIN
        SELECT   TOP 3 ID,
                       Name,
                       NumOfPosts
        FROM     yaf_User u
                 INNER JOIN (SELECT   m.UserID         AS ID,
                                      COUNT(m.UserID)  AS NumOfPosts
                             FROM     yaf_Message m
                             WHERE    m.Posted >= @StartDate
                             GROUP BY m.UserID) AS counter
                   ON u.UserID = counter.ID
        ORDER BY NumOfPosts DESC
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_addpoints]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_addpoints] 
GO

CREATE PROCEDURE [dbo].[yaf_user_addpoints](
                @UserID INT,
                @Points INT)
AS
    BEGIN
        UPDATE yaf_User
        SET    Points = Points + @Points
        WHERE  UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_adminsave]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_adminsave] 
GO

CREATE PROCEDURE [dbo].[yaf_user_adminsave](
                @BoardID     INT,
                @UserID      INT,
                @Name        NVARCHAR(50),
                @Email       NVARCHAR(50),
                @IsHostAdmin BIT,
                @RankID      INT)
AS
    BEGIN
        IF @IsHostAdmin <> 0
        UPDATE yaf_User
        SET    Flags = Flags | 1
        WHERE  UserID = @UserID
        ELSE
        UPDATE yaf_User
        SET    Flags = Flags & ~ 1
        WHERE  UserID = @UserID
        UPDATE yaf_User
        SET    Name = @Name,
               Email = @Email,
               RankID = @RankID
        WHERE  UserID = @UserID
        SELECT UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_approve]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_approve] 
GO

CREATE PROCEDURE [dbo].[yaf_user_approve](
                @UserID INT)
AS
    BEGIN
        DECLARE  @CheckEmailID INT
        DECLARE  @Email NVARCHAR(50)
        SELECT @CheckEmailID = CheckEmailID,
               @Email = Email
        FROM   yaf_CheckEmail
        WHERE  UserID = @UserID
        -- Update new user email
        UPDATE yaf_User
        SET    Email = @Email,
               Flags = Flags | 2
        WHERE  UserID = @UserID
        DELETE yaf_CheckEmail
        WHERE  CheckEmailID = @CheckEmailID
        SELECT CONVERT(BIT,1)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_avatarimage]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_avatarimage] 
GO

CREATE PROCEDURE [dbo].[yaf_user_avatarimage](
                @UserID INT)
AS
    BEGIN
        SELECT UserID,
               AvatarImage
        FROM   yaf_User
        WHERE  UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_changepassword]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_changepassword] 
GO

CREATE PROCEDURE [dbo].[yaf_user_changepassword](
                @UserID      INT,
                @OldPassword NVARCHAR(32),
                @NewPassword NVARCHAR(32))
AS
    BEGIN
        DECLARE  @CurrentOld NVARCHAR(32)
        SELECT @CurrentOld = Password
        FROM   yaf_User
        WHERE  UserID = @UserID
        IF @CurrentOld <> @OldPassword
        BEGIN
            SELECT Success = CONVERT(BIT,0)
            RETURN
        END
        UPDATE yaf_User
        SET    Password = @NewPassword
        WHERE  UserID = @UserID
        SELECT Success = CONVERT(BIT,1)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_user_delete](
                @UserID INT)
AS
    BEGIN
        DECLARE  @GuestUserID INT
        DECLARE  @UserName NVARCHAR(50)
        DECLARE  @GuestCount INT
        SELECT @UserName = Name
        FROM   yaf_User
        WHERE  UserID = @UserID
        SELECT TOP 1 @GuestUserID = a.UserID
        FROM   yaf_User a,
               yaf_UserGroup b,
               yaf_Group c
        WHERE  b.UserID = a.UserID
        AND b.GroupID = c.GroupID
        AND (c.Flags & 2) <> 0
        SELECT @GuestCount = COUNT(1)
        FROM   yaf_UserGroup a
               JOIN yaf_Group b
                 ON b.GroupID = a.GroupID
        WHERE  (b.Flags & 2) <> 0
        IF @GuestUserID = @UserID
           AND @GuestCount = 1
        BEGIN
            RETURN
        END
        UPDATE yaf_Message
        SET    UserName = @UserName,
               UserID = @GuestUserID
        WHERE  UserID = @UserID
        UPDATE yaf_Topic
        SET    UserName = @UserName,
               UserID = @GuestUserID
        WHERE  UserID = @UserID
        UPDATE yaf_Topic
        SET    LastUserName = @UserName,
               LastUserID = @GuestUserID
        WHERE  LastUserID = @UserID
        UPDATE yaf_Forum
        SET    LastUserName = @UserName,
               LastUserID = @GuestUserID
        WHERE  LastUserID = @UserID
        DELETE FROM yaf_Active
        WHERE       UserID = @UserID        
        DELETE FROM yaf_EventLog
        WHERE       UserID = @UserID
        DELETE FROM yaf_PMessage
        WHERE       FromUserID = @UserID
        DELETE FROM yaf_UserPMessage
        WHERE       UserID = @UserID
        DELETE FROM yaf_CheckEmail
        WHERE       UserID = @UserID
        DELETE FROM yaf_WatchTopic
        WHERE       UserID = @UserID
        DELETE FROM yaf_WatchForum
        WHERE       UserID = @UserID
        DELETE FROM yaf_UserGroup
        WHERE       UserID = @UserID
        --ABOT CHANGED
        --Delete UserForums entries Too
        DELETE FROM yaf_UserForum
        WHERE       UserID = @UserID
        --END ABOT CHANGED 09.04.2004
        DELETE FROM yaf_User
        WHERE       UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_deleteavatar]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_deleteavatar] 
GO

CREATE PROCEDURE [dbo].[yaf_user_deleteavatar](
                @UserID INT)
AS
    BEGIN
        UPDATE yaf_User
        SET    AvatarImage = NULL,
               Avatar = NULL
        WHERE  UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_deleteold]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_deleteold] 
GO

CREATE PROCEDURE [dbo].[yaf_user_deleteold](
                @BoardID INT)
AS
    BEGIN
        DECLARE  @Since DATETIME
        SET @Since = Getdate()
        DELETE FROM yaf_EventLog
        WHERE       UserID IN (SELECT UserID
                   FROM   yaf_User
                   WHERE  BoardID = @BoardID
                   AND dbo.Yaf_bitset(Flags,2) = 0
                   AND Datediff(DAY,Joined,@Since) > 2)
        DELETE FROM yaf_CheckEmail
        WHERE       UserID IN (SELECT UserID
                   FROM   yaf_User
                   WHERE  BoardID = @BoardID
                   AND dbo.Yaf_bitset(Flags,2) = 0
                   AND Datediff(DAY,Joined,@Since) > 2)
        DELETE FROM yaf_UserGroup
        WHERE       UserID IN (SELECT UserID
                   FROM   yaf_User
                   WHERE  BoardID = @BoardID
                   AND dbo.Yaf_bitset(Flags,2) = 0
                   AND Datediff(DAY,Joined,@Since) > 2)
        DELETE FROM yaf_User
        WHERE       BoardID = @BoardID
        AND dbo.Yaf_bitset(Flags,2) = 0
        AND Datediff(DAY,Joined,@Since) > 2
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_emails]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_emails] 
GO

CREATE PROCEDURE [dbo].[yaf_user_emails](
                @BoardID INT,
                @GroupID INT  = NULL)
AS
    BEGIN
        IF @GroupID = 0
        SET @GroupID = NULL
        IF @GroupID IS NULL
        SELECT a.Email
        FROM   yaf_User a
        WHERE  a.Email IS NOT NULL 
        AND a.BoardID = @BoardID
        AND a.Email IS NOT NULL
        AND a.Email <> ''
        ELSE
        SELECT a.Email
        FROM   yaf_User a
               JOIN yaf_UserGroup b
                 ON b.UserID = a.UserID
        WHERE  b.GroupID = @GroupID
        AND a.Email IS NOT NULL
        AND a.Email <> ''
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_find]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_find] 
GO

CREATE PROCEDURE [dbo].[yaf_user_find](
                @BoardID  INT,
                @Filter   BIT,
                @UserName NVARCHAR(50)  = NULL,
                @Email    NVARCHAR(50)  = NULL)
AS
    BEGIN
        IF @Filter <> 0
        BEGIN
            IF @UserName IS NOT NULL
            SET @UserName = '%' + @UserName + '%'
            SELECT   a.*,
                     IsGuest = (SELECT COUNT(1)
                                FROM   yaf_UserGroup x,
                                       yaf_Group y
                                WHERE  x.UserID = a.UserID
                                AND x.GroupID = y.GroupID
                                AND (y.Flags & 2) <> 0)
            FROM     yaf_User a
            WHERE    a.BoardID = @BoardID
            AND (@UserName IS NOT NULL 
                 AND a.Name LIKE @UserName)
             OR (@Email IS NOT NULL 
                 AND Email LIKE @Email)
            ORDER BY a.Name
        END
        ELSE
        BEGIN
            SELECT a.UserID,
                   IsGuest = (SELECT COUNT(1)
                              FROM   yaf_UserGroup x,
                                     yaf_Group y
                              WHERE  x.UserID = a.UserID
                              AND x.GroupID = y.GroupID
                              AND (y.Flags & 2) <> 0)
            FROM   yaf_User a
            WHERE  a.BoardID = @BoardID
            AND ((@UserName IS NOT NULL 
                  AND a.Name = @UserName)
                  OR (@Email IS NOT NULL 
                      AND Email = @Email))
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_getpoints]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_getpoints] 
GO

CREATE PROCEDURE [dbo].[yaf_user_getpoints](
                @UserID INT)
AS
    BEGIN
        SELECT Points
        FROM   yaf_User
        WHERE  UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_getsignature]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_getsignature] 
GO

CREATE PROCEDURE [dbo].[yaf_user_getsignature](
                @UserID INT)
AS
    BEGIN
        SELECT Signature
        FROM   yaf_User
        WHERE  UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_guest]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_guest] 
GO

CREATE PROCEDURE [dbo].[yaf_user_guest]
AS
    BEGIN
        SELECT TOP 1 a.UserID
        FROM   yaf_User a,
               yaf_UserGroup b,
               yaf_Group c
        WHERE  b.UserID = a.UserID
        AND b.GroupID = c.GroupID
        AND (c.Flags & 2) <> 0
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_list] 
GO

CREATE PROCEDURE [dbo].[yaf_user_list](
                @BoardID  INT,
                @UserID   INT  = NULL,
                @Approved BIT  = NULL,
                @GroupID  INT  = NULL,
                @RankID   INT  = NULL)
AS
    BEGIN
        IF @UserID IS NOT NULL
        SELECT   a.*,
                 a.NumPosts,
                 b.RankID,
                 RankName = b.Name,
                 NumDays = Datediff(d,a.Joined,Getdate()) + 1,
                 NumPostsForum = (SELECT COUNT(1)
                                  FROM   yaf_Message x
                                  WHERE  (x.Flags & 24) = 16),
                 HasAvatarImage = (SELECT COUNT(1)
                                   FROM   yaf_User x
                                   WHERE  x.UserID = a.UserID
                                   AND AvatarImage IS NOT NULL),
                 IsAdmin = Isnull(c.IsAdmin,0),
                 IsGuest = Isnull(c.IsGuest,0),
                 IsForumModerator = Isnull(c.IsForumModerator,0),
                 IsModerator = Isnull(c.IsModerator,0)
        FROM     yaf_User a
                 JOIN yaf_Rank b
                   ON b.RankID = a.RankID
                 LEFT JOIN yaf_vaccess c
                   ON c.UserID = a.UserID
        WHERE    a.UserID = @UserID
        AND a.BoardID = @BoardID
        AND Isnull(c.ForumID,0) = 0
        AND (@Approved IS NULL 
              OR (@Approved = 0
                  AND (a.Flags & 2) = 0)
              OR (@Approved = 1
                  AND (a.Flags & 2) = 2))
        ORDER BY a.Name
        ELSE
        IF @GroupID IS NULL 
           AND @RankID IS NULL
        SELECT   a.*,
                 a.NumPosts,
                 IsAdmin = (SELECT COUNT(1)
                            FROM   yaf_UserGroup x,
                                   yaf_Group y
                            WHERE  x.UserID = a.UserID
                            AND y.GroupID = x.GroupID
                            AND (y.Flags & 1) <> 0),
                 b.RankID,
                 RankName = b.Name
        FROM     yaf_User a
                 JOIN yaf_Rank b
                   ON b.RankID = a.RankID
        WHERE    a.BoardID = @BoardID
        AND (@Approved IS NULL 
              OR (@Approved = 0
                  AND (a.Flags & 2) = 0)
              OR (@Approved = 1
                  AND (a.Flags & 2) = 2))
        ORDER BY a.Name
        ELSE
        SELECT   a.*,
                 a.NumPosts,
                 IsAdmin = (SELECT COUNT(1)
                            FROM   yaf_UserGroup x,
                                   yaf_Group y
                            WHERE  x.UserID = a.UserID
                            AND y.GroupID = x.GroupID
                            AND (y.Flags & 1) <> 0),
                 b.RankID,
                 RankName = b.Name
        FROM     yaf_User a
                 JOIN yaf_Rank b
                   ON b.RankID = a.RankID
        WHERE    a.BoardID = @BoardID
        AND (@Approved IS NULL 
              OR (@Approved = 0
                  AND (a.Flags & 2) = 0)
              OR (@Approved = 1
                  AND (a.Flags & 2) = 2))
        AND (@GroupID IS NULL 
              OR EXISTS (SELECT 1
                         FROM   yaf_UserGroup x
                         WHERE  x.UserID = a.UserID
                         AND x.GroupID = @GroupID))
        AND (@RankID IS NULL 
              OR a.RankID = @RankID)
        ORDER BY a.Name
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_login]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_login] 
GO

CREATE PROCEDURE [dbo].[yaf_user_login](
                @BoardID  INT,
                @Name     NVARCHAR(50),
                @Password NVARCHAR(32))
AS
    BEGIN
        DECLARE  @UserID INT
        -- Try correct board first
        IF EXISTS (SELECT UserID
                   FROM   yaf_User
                   WHERE  Name = @Name
                   AND Password = @Password
                   AND BoardID = @BoardID
                   AND (Flags & 2) = 2)
        BEGIN
            SELECT UserID
            FROM   yaf_User
            WHERE  Name = @Name
            AND Password = @Password
            AND BoardID = @BoardID
            AND (Flags & 2) = 2
            RETURN
        END
        IF NOT EXISTS (SELECT UserID
                       FROM   yaf_User
                       WHERE  Name = @Name
                       AND Password = @Password
                       AND (BoardID = @BoardID
                             OR (Flags & 3) = 3))
        SET @UserID = NULL
        ELSE
        SELECT @UserID = UserID
        FROM   yaf_User
        WHERE  Name = @Name
        AND Password = @Password
        AND (BoardID = @BoardID
              OR (Flags & 1) = 1)
        AND (Flags & 2) = 2
        SELECT @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_nntp]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_nntp] 
GO

CREATE PROCEDURE [dbo].[yaf_user_nntp](
                @BoardID  INT,
                @UserName NVARCHAR(50),
                @Email    NVARCHAR(50))
AS
    BEGIN
        DECLARE  @UserID INT
        SET @UserName = @UserName + ' (NNTP)'
        SELECT @UserID = UserID
        FROM   yaf_User
        WHERE  BoardID = @BoardID
        AND Name = @UserName
        IF @@ROWCOUNT < 1
        BEGIN
            EXEC yaf_user_save
                 0 ,
                 @BoardID ,
                 @UserName ,
                 '-' ,
                 @Email ,
                 NULL ,
                 'Usenet' ,
                 NULL ,
                 0 ,
                 NULL ,
                 NULL ,
                 NULL ,
                 1 ,
                 NULL ,
                 NULL ,
                 NULL ,
                 NULL ,
                 NULL ,
                 NULL ,
                 NULL ,
                 0 ,
                 NULL
            -- The next one is not safe, but this procedure is only used for testing
            SELECT @UserID = MAX(UserID)
            FROM   yaf_User
        END
        SELECT UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_recoverpassword]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_recoverpassword] 
GO

CREATE PROCEDURE [dbo].[yaf_user_recoverpassword](
                @BoardID  INT,
                @UserName NVARCHAR(50),
                @Email    NVARCHAR(50))
AS
    BEGIN
        DECLARE  @UserID INT
        SELECT @UserID = UserID
        FROM   yaf_User
        WHERE  BoardID = @BoardID
        AND Name = @UserName
        AND Email = @Email
        IF @UserID IS NULL
        BEGIN
            SELECT UserID = CONVERT(INT,NULL)
            RETURN
        END
        ELSE
        BEGIN
            SELECT UserID = @UserID
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_removepoints]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_removepoints] 
GO

CREATE PROCEDURE [dbo].[yaf_user_removepoints](
                @UserID INT,
                @Points INT)
AS
    BEGIN
        UPDATE yaf_User
        SET    Points = Points - @Points
        WHERE  UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_removepointsbytopicid]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_removepointsbytopicid] 
GO

CREATE PROCEDURE [dbo].[yaf_user_removepointsbytopicid](
                @TopicID INT,
                @Points  INT)
AS
    BEGIN
        DECLARE  @UserID INT
        SELECT @UserID = UserID
        FROM   yaf_Topic
        WHERE  TopicID = @TopicID
        UPDATE yaf_user
        SET    points = points - @Points
        WHERE  userid = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_resetpoints]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_resetpoints] 
GO

CREATE PROCEDURE [dbo].[yaf_user_resetpoints]
AS
    BEGIN
        UPDATE yaf_User
        SET    Points = NumPosts * 3
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_save] 
GO

CREATE PROCEDURE [dbo].[yaf_user_save](
                @UserID         INT,
                @BoardID        INT,
                @UserName       NVARCHAR(50)  = NULL,
                @Password       NVARCHAR(32)  = NULL,
                @Email          NVARCHAR(50)  = NULL,
                @Hash           NVARCHAR(32)  = NULL,
                @Location       NVARCHAR(50)  = NULL,
                @HomePage       NVARCHAR(50)  = NULL,
                @TimeZone       INT,
                @Avatar         NVARCHAR(255)  = NULL,
                @LanguageFile   NVARCHAR(50)  = NULL,
                @ThemeFile      NVARCHAR(50)  = NULL,
                @Approved       BIT  = NULL,
                @MSN            NVARCHAR(50)  = NULL,
                @YIM            NVARCHAR(30)  = NULL,
                @AIM            NVARCHAR(30)  = NULL,
                @ICQ            INT  = NULL,
                @RealName       NVARCHAR(50)  = NULL,
                @Occupation     NVARCHAR(50)  = NULL,
                @Interests      NVARCHAR(100)  = NULL,
                @Gender         TINYINT  = 0,
                @Weblog         NVARCHAR(100)  = NULL,
                @PMNotification BIT  = NULL)
AS
    BEGIN
        DECLARE  @RankID INT
        DECLARE  @Flags INT
        SET @Flags = 0
        IF @Approved <> 0
            SET @Flags = @Flags | 2
        IF @Location IS NOT NULL 
           AND @Location = ''
            SET @Location = NULL
        IF @HomePage IS NOT NULL 
           AND @HomePage = ''
            SET @HomePage = NULL
        IF @Avatar IS NOT NULL 
           AND @Avatar = ''
            SET @Avatar = NULL
        IF @MSN IS NOT NULL 
           AND @MSN = ''
            SET @MSN = NULL
        IF @YIM IS NOT NULL 
           AND @YIM = ''
            SET @YIM = NULL
        IF @AIM IS NOT NULL 
           AND @AIM = ''
            SET @AIM = NULL
        IF @ICQ IS NOT NULL 
           AND @ICQ = 0
            SET @ICQ = NULL
        IF @RealName IS NOT NULL 
           AND @RealName = ''
            SET @RealName = NULL
        IF @Occupation IS NOT NULL 
           AND @Occupation = ''
            SET @Occupation = NULL
        IF @Interests IS NOT NULL 
           AND @Interests = ''
            SET @Interests = NULL
        IF @Weblog IS NOT NULL 
           AND @Weblog = ''
            SET @Weblog = NULL
        IF @PMNotification IS NULL
            SET @PMNotification = 1
        IF @UserID IS NULL 
            OR @UserID < 1
            BEGIN
                IF @Email = ''
                    SET @Email = NULL
                SELECT @RankID = RankID
                FROM   
                    yaf_Rank
                WHERE  (Flags & 1) <> 0
                AND BoardID = @BoardID
                INSERT INTO yaf_User
                           (BoardID,
                            RankID,
                            Name,
                            Password,
                            Email,
                            Joined,
                            LastVisit,
                            NumPosts,
                            Location,
                            HomePage,
                            TimeZone,
                            Avatar,
                            Gender,
                            Flags,
                            PMNotification)
                VALUES     (@BoardID,
                            @RankID,
                            @UserName,
                            @Password,
                            @Email,
                            Getdate(),
                            Getdate(),
                            0,
                            @Location,
                            @HomePage,
                            @TimeZone,
                            @Avatar,
                            @Gender,
                            @Flags,
                            @PMNotification)
                SET @UserID = Scope_identity()
                INSERT INTO yaf_UserGroup
                           (UserID,
                            GroupID)
                SELECT @UserID,
                       GroupID
                FROM   
                    yaf_Group
                WHERE  BoardID = @BoardID
                AND (Flags & 4) <> 0
                IF @Hash IS NOT NULL 
                   AND @Hash <> ''
                   AND @Approved = 0
                    BEGIN
                        INSERT INTO yaf_CheckEmail (UserID, Email, Created, Hash) VALUES (@UserID, @Email, getdate(), @Hash)
                    END
            END
        ELSE
          BEGIN
              UPDATE yaf_User
              SET    Location = @Location,
                     HomePage = @HomePage,
                     TimeZone = @TimeZone,
                     LanguageFile = @LanguageFile,
                     ThemeFile = @ThemeFile,
                     MSN = @MSN,
                     YIM = @YIM,
                     AIM = @AIM,
                     ICQ = @ICQ,
                     RealName = @RealName,
                     Occupation = @Occupation,
                     Interests = @Interests,
                     Gender = @Gender,
                     Weblog = @Weblog,
                     PMNotification = @PMNotification
              WHERE  UserID = @UserID
              IF @Email IS NOT NULL
                  UPDATE yaf_User
                  SET    Email = @Email
                  WHERE  UserID = @UserID
          END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_saveavatar]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_saveavatar] 
GO

CREATE PROCEDURE [dbo].[yaf_user_saveavatar](
                @UserID      INT,
                @Avatar      NVARCHAR(255)  = NULL,
                @AvatarImage IMAGE  = NULL)
AS
    BEGIN
        IF @Avatar IS NOT NULL
        BEGIN
            UPDATE yaf_User
            SET    Avatar = @Avatar,
                   AvatarImage = NULL
            WHERE  UserID = @UserID
        END
        ELSE
        IF @AvatarImage IS NOT NULL
        BEGIN
            UPDATE yaf_User
            SET    AvatarImage = @AvatarImage,
                   Avatar = NULL
            WHERE  UserID = @UserID
        END
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_savepassword]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_savepassword] 
GO


CREATE PROCEDURE [dbo].[yaf_user_savepassword](
                @UserID   INT,
                @Password NVARCHAR(32))
AS
    BEGIN
        UPDATE dbo.yaf_User
        SET    Password = @Password
        WHERE  UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_savesignature]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_savesignature] 
GO

CREATE PROCEDURE [dbo].[yaf_user_savesignature](
                @UserID    INT,
                @Signature NTEXT)
AS
    BEGIN
        UPDATE yaf_User
        SET    Signature = @Signature
        WHERE  UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_setpoints]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_setpoints] 
GO

CREATE PROCEDURE [dbo].[yaf_user_setpoints](
                @UserID INT,
                @Points INT)
AS
    BEGIN
        UPDATE yaf_User
        SET    Points = @Points
        WHERE  UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_suspend]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_suspend] 
GO

CREATE PROCEDURE [dbo].[yaf_user_suspend](
                @UserID  INT,
                @Suspend DATETIME  = NULL)
AS
    BEGIN
        UPDATE yaf_User
        SET    Suspended = @Suspend
        WHERE  UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_upgrade]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_upgrade] 
GO

CREATE PROCEDURE [dbo].[yaf_user_upgrade](
                @UserID INT)
AS
    BEGIN
        DECLARE  @RankID INT
        DECLARE  @Flags INT
        DECLARE  @MinPosts INT
        DECLARE  @NumPosts INT
        -- Get user and rank information
        SELECT @RankID = b.RankID,
               @Flags = b.Flags,
               @MinPosts = b.MinPosts,
               @NumPosts = a.NumPosts
        FROM   yaf_User a,
               yaf_Rank b
        WHERE  a.UserID = @UserID
        AND b.RankID = a.RankID
        -- If user isn't member of a ladder rank, exit
        IF (@Flags & 2) = 0
        RETURN
            -- See if user got enough posts for next ladder group
            SELECT TOP 1 @RankID = RankID
            FROM     yaf_Rank
            WHERE    (Flags & 2) = 2
            AND MinPosts <= @NumPosts
            AND MinPosts > @MinPosts
            ORDER BY MinPosts
        IF @@ROWCOUNT = 1
        UPDATE yaf_User
        SET    RankID = @RankID
        WHERE  UserID = @UserID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_userforum_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_userforum_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_userforum_delete](
                @UserID  INT,
                @ForumID INT)
AS
    BEGIN
        DELETE FROM yaf_UserForum
        WHERE       UserID = @UserID
        AND ForumID = @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_userforum_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_userforum_list] 
GO

CREATE PROCEDURE [dbo].[yaf_userforum_list](
                @UserID  INT  = NULL,
                @ForumID INT  = NULL)
AS
    BEGIN
        SELECT   a.*,
                 b.AccessMaskID,
                 b.Accepted,
                 Access = c.Name
        FROM     yaf_User a
                 JOIN yaf_UserForum b
                   ON b.UserID = a.UserID
                 JOIN yaf_AccessMask c
                   ON c.AccessMaskID = b.AccessMaskID
        WHERE    (@UserID IS NULL 
          OR a.UserID = @UserID)
        AND (@ForumID IS NULL 
              OR b.ForumID = @ForumID)
        ORDER BY a.Name
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_userforum_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_userforum_save] 
GO

CREATE PROCEDURE [dbo].[yaf_userforum_save](
                @UserID       INT,
                @ForumID      INT,
                @AccessMaskID INT)
AS
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   yaf_UserForum
                   WHERE  UserID = @UserID
                   AND ForumID = @ForumID)
        UPDATE yaf_UserForum
        SET    AccessMaskID = @AccessMaskID
        WHERE  UserID = @UserID
        AND ForumID = @ForumID
        ELSE
        INSERT INTO yaf_UserForum
                   (UserID,
                    ForumID,
                    AccessMaskID,
                    Invited,
                    Accepted)
        VALUES     (@UserID,
                    @ForumID,
                    @AccessMaskID,
                    Getdate(),
                    1)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_usergroup_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_usergroup_list] 
GO

CREATE PROCEDURE [dbo].[yaf_usergroup_list](
                @UserID INT)
AS
    BEGIN
        SELECT   b.GroupID,
                 b.Name
        FROM     yaf_UserGroup a
                 JOIN yaf_Group b
                   ON b.GroupID = a.GroupID
        WHERE    a.UserID = @UserID
        ORDER BY b.Name
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_usergroup_save]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_usergroup_save] 
GO

CREATE PROCEDURE [dbo].[yaf_usergroup_save](
                @UserID  INT,
                @GroupID INT,
                @Member  BIT)
AS
    BEGIN
        IF @Member = 0
        DELETE FROM yaf_UserGroup
        WHERE       UserID = @UserID
        AND GroupID = @GroupID
        ELSE
        INSERT INTO yaf_UserGroup
                   (UserID,
                    GroupID)
        SELECT @UserID,
               @GroupID
        WHERE  NOT EXISTS (SELECT 1
                    FROM   yaf_UserGroup
                    WHERE  UserID = @UserID
                    AND GroupID = @GroupID)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_userpmessage_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_userpmessage_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_userpmessage_delete](
                @UserPMessageID INT)
AS
    BEGIN
        DELETE FROM yaf_UserPMessage
        WHERE       UserPMessageID = @UserPMessageID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_userpmessage_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_userpmessage_list] 
GO

CREATE PROCEDURE [dbo].[yaf_userpmessage_list](
                @UserPMessageID INT)
AS
    BEGIN
        SELECT a.*,
               FromUser = b.Name,
               ToUserID = c.UserID,
               ToUser = c.Name,
               d.IsRead,
               d.UserPMessageID
        FROM   yaf_PMessage a,
               yaf_User b,
               yaf_User c,
               yaf_UserPMessage d
        WHERE  b.UserID = a.FromUserID
        AND c.UserID = d.UserID
        AND d.PMessageID = a.PMessageID
        AND d.UserPMessageID = @UserPMessageID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_watchforum_add]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_watchforum_add] 
GO

CREATE PROCEDURE [dbo].[yaf_watchforum_add](
                @UserID  INT,
                @ForumID INT)
AS
    BEGIN
        INSERT INTO yaf_WatchForum
                   (ForumID,
                    UserID,
                    Created)
        SELECT @ForumID,
               @UserID,
               Getdate()
        WHERE  NOT EXISTS (SELECT 1
                    FROM   yaf_WatchForum
                    WHERE  ForumID = @ForumID
                    AND UserID = @UserID)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_watchforum_check]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_watchforum_check] 
GO

CREATE PROCEDURE [dbo].[yaf_watchforum_check](
                @UserID  INT,
                @ForumID INT)
AS
    BEGIN
        SELECT WatchForumID
        FROM   yaf_WatchForum
        WHERE  UserID = @UserID
        AND ForumID = @ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_watchforum_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_watchforum_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_watchforum_delete](
                @WatchForumID INT)
AS
    BEGIN
        DELETE FROM yaf_WatchForum
        WHERE       WatchForumID = @WatchForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_watchforum_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_watchforum_list] 
GO

CREATE PROCEDURE [dbo].[yaf_watchforum_list](
                @UserID INT)
AS
    BEGIN
        SELECT a.*,
               ForumName = b.Name,
               Messages = (SELECT COUNT(1)
                           FROM   yaf_Topic x,
                                  yaf_Message y
                           WHERE  x.ForumID = a.ForumID
                           AND y.TopicID = x.TopicID),
               Topics = (SELECT COUNT(1)
                         FROM   yaf_Topic x
                         WHERE  x.ForumID = a.ForumID
                         AND x.TopicMovedID IS NULL),
               b.LastPosted,
               b.LastMessageID,
               LastTopicID = (SELECT TopicID
                              FROM   yaf_Message x
                              WHERE  x.MessageID = b.LastMessageID),
               b.LastUserID,
               LastUserName = Isnull(b.LastUserName,(SELECT Name
                                                     FROM   yaf_User x
                                                     WHERE  x.UserID = b.LastUserID))
        FROM   yaf_WatchForum a,
               yaf_Forum b
        WHERE  a.UserID = @UserID
        AND b.ForumID = a.ForumID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_watchtopic_add]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_watchtopic_add] 
GO

CREATE PROCEDURE [dbo].[yaf_watchtopic_add](
                @UserID  INT,
                @TopicID INT)
AS
    BEGIN
        INSERT INTO yaf_WatchTopic
                   (TopicID,
                    UserID,
                    Created)
        SELECT @TopicID,
               @UserID,
               Getdate()
        WHERE  NOT EXISTS (SELECT 1
                    FROM   yaf_WatchTopic
                    WHERE  TopicID = @TopicID
                    AND UserID = @UserID)
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_watchtopic_check]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_watchtopic_check] 
GO

CREATE PROCEDURE [dbo].[yaf_watchtopic_check](
                @UserID  INT,
                @TopicID INT)
AS
    BEGIN
        SELECT WatchTopicID
        FROM   yaf_WatchTopic
        WHERE  UserID = @UserID
        AND TopicID = @TopicID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_watchtopic_delete]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_watchtopic_delete] 
GO

CREATE PROCEDURE [dbo].[yaf_watchtopic_delete](
                @WatchTopicID INT)
AS
    BEGIN
        DELETE FROM yaf_WatchTopic
        WHERE       WatchTopicID = @WatchTopicID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_watchtopic_list]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_watchtopic_list] 
GO

CREATE PROCEDURE [dbo].[yaf_watchtopic_list](
                @UserID INT)
AS
    BEGIN
        SELECT a.*,
               TopicName = b.Topic,
               Replies = (SELECT COUNT(1)
                          FROM   yaf_Message x
                          WHERE  x.TopicID = b.TopicID),
               b.Views,
               b.LastPosted,
               b.LastMessageID,
               b.LastUserID,
               LastUserName = Isnull(b.LastUserName,(SELECT Name
                                                     FROM   yaf_User x
                                                     WHERE  x.UserID = b.LastUserID))
        FROM   yaf_WatchTopic a,
               yaf_Topic b
        WHERE  a.UserID = @UserID
        AND b.TopicID = a.TopicID
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_category_simplelist]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_category_simplelist] 
GO

CREATE PROCEDURE [dbo].[yaf_category_simplelist](
                @StartID INT  = 0,
                @Limit   INT  = 500)
AS
    BEGIN
        SET ROWCOUNT  @Limit
        SELECT   c.[CategoryID],
                 c.[Name]
        FROM     yaf_Category c
        WHERE    c.[CategoryID] >= @StartID
        AND c.[CategoryID] < (@StartID + @Limit)
        ORDER BY c.[CategoryID]
        SET ROWCOUNT  0
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_forum_simplelist]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_forum_simplelist] 
GO

CREATE PROCEDURE [dbo].[yaf_forum_simplelist](
                @StartID INT  = 0,
                @Limit   INT  = 500)
AS
    BEGIN
        SET ROWCOUNT  @Limit
        SELECT   f.[ForumID],
                 f.[Name]
        FROM     yaf_Forum f
        WHERE    f.[ForumID] >= @StartID
        AND f.[ForumID] < (@StartID + @Limit)
        ORDER BY f.[ForumID]
        SET ROWCOUNT  0
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_message_simplelist]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_message_simplelist] 
GO

CREATE PROCEDURE [dbo].[yaf_message_simplelist](
                @StartID INT  = 0,
                @Limit   INT  = 1000)
AS
    BEGIN
        SET ROWCOUNT  @Limit
        SELECT   m.[MessageID],
                 m.[TopicID]
        FROM     yaf_Message m
        WHERE    m.[MessageID] >= @StartID
        AND m.[MessageID] < (@StartID + @Limit)
        AND m.[TopicID] IS NOT NULL
        ORDER BY m.[MessageID]
        SET ROWCOUNT  0
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_topic_simplelist]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_topic_simplelist] 
GO

CREATE PROCEDURE [dbo].[yaf_topic_simplelist](
                @StartID INT  = 0,
                @Limit   INT  = 500)
AS
    BEGIN
        SET ROWCOUNT  @Limit
        SELECT   t.[TopicID],
                 t.[Topic]
        FROM     yaf_Topic t
        WHERE    t.[TopicID] >= @StartID
        AND t.[TopicID] < (@StartID + @Limit)
        ORDER BY t.[TopicID]
        SET ROWCOUNT  0
    END
GO

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  id = Object_id(N'[dbo].[yaf_user_simplelist]')
           AND Objectproperty(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[yaf_user_simplelist] 
GO

CREATE PROCEDURE [dbo].[yaf_user_simplelist](
                @StartID INT  = 0,
                @Limit   INT  = 500)
AS
    BEGIN
        SET ROWCOUNT  @Limit
        SELECT   a.[UserID],
                 a.[Name]
        FROM     yaf_User a
        WHERE    a.[UserID] >= @StartID
        AND a.[UserID] < (@StartID + @Limit)
        ORDER BY a.[UserID]
        SET ROWCOUNT  0
    END
GO

-- scalar functions

IF EXISTS (SELECT *
			FROM   dbo.sysobjects
			WHERE  id = Object_id(N'[dbo].[yaf_bitset]')
					AND xtype IN (N'FN',N'IF',N'TF'))
  DROP FUNCTION [dbo].[yaf_bitset]
GO

CREATE FUNCTION [dbo].[yaf_bitset]
               (@Flags INT,
				@Mask  INT)
RETURNS BIT
AS
  BEGIN
	DECLARE  @bool BIT
		IF (@Flags & @Mask) = @Mask
		SET @bool = 1
		ELSE
		SET @bool = 0
		RETURN @bool
	END
GO

IF EXISTS (SELECT *
			FROM   dbo.sysobjects
			WHERE  id = Object_id(N'[dbo].[yaf_forum_posts]')
					AND xtype IN (N'FN',N'IF',N'TF'))
  DROP FUNCTION [dbo].[yaf_forum_posts]
GO

CREATE FUNCTION [dbo].[yaf_forum_posts]
               (@ForumID INT)
RETURNS INT
AS
  BEGIN
	DECLARE  @NumPosts INT
		DECLARE  @tmp INT
		SELECT @NumPosts = NumPosts
		FROM   dbo.yaf_Forum
		WHERE  ForumID = @ForumID
		IF EXISTS (SELECT 1
					FROM   dbo.yaf_Forum
					WHERE  ParentID = @ForumID)
		BEGIN
			DECLARE c CURSOR  FOR
				SELECT ForumID
				FROM   dbo.yaf_Forum
				WHERE  ParentID = @ForumID
				OPEN c
				FETCH NEXT FROM c
				INTO @tmp
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @NumPosts = @NumPosts + dbo.Yaf_forum_posts(@tmp)
						FETCH NEXT FROM c
						INTO @tmp
					END
				CLOSE c
				DEALLOCATE c
			END
		RETURN @NumPosts
	END
GO

IF EXISTS (SELECT *
			FROM   dbo.sysobjects
			WHERE  id = Object_id(N'[dbo].[yaf_forum_topics]')
					AND xtype IN (N'FN',N'IF',N'TF'))
  DROP FUNCTION [dbo].[yaf_forum_topics]
GO

CREATE FUNCTION [dbo].[yaf_forum_topics]
               (@ForumID INT)
RETURNS INT
AS
  BEGIN
	DECLARE  @NumTopics INT
		DECLARE  @tmp INT
		SELECT @NumTopics = NumTopics
		FROM   dbo.yaf_Forum
		WHERE  ForumID = @ForumID
		IF EXISTS (SELECT 1
					FROM   dbo.yaf_Forum
					WHERE  ParentID = @ForumID)
		BEGIN
			DECLARE c CURSOR  FOR
				SELECT ForumID
				FROM   dbo.yaf_Forum
				WHERE  ParentID = @ForumID
				OPEN c
				FETCH NEXT FROM c
				INTO @tmp
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @NumTopics = @NumTopics + dbo.Yaf_forum_topics(@tmp)
						FETCH NEXT FROM c
						INTO @tmp
					END
				CLOSE c
				DEALLOCATE c
			END
		RETURN @NumTopics
	END
GO
