/*
** Create missing tables
*/
IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Active')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Active (
  SessionID  NVARCHAR(24) NOT NULL,
  BoardID    INT NOT NULL,
  UserID     INT NOT NULL,
  IP         NVARCHAR(15) NOT NULL,
  Login      DATETIME NOT NULL,
  LastActive DATETIME NOT NULL,
  Location   NVARCHAR(50) NOT NULL,
  ForumID    INT NULL,
  TopicID    INT NULL,
  Browser    NVARCHAR(50) NULL,
  Platform   NVARCHAR(50) NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_BannedIP')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_BannedIP (
  ID      INT IDENTITY( 1  , 1  ) NOT NULL,
  BoardID INT NOT NULL,
  Mask    NVARCHAR(15) NOT NULL,
  Since   DATETIME NOT NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Category')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Category (
  CategoryID INT IDENTITY( 1  , 1  ) NOT NULL,
  BoardID    INT NOT NULL,
  [Name]     NVARCHAR(128) NOT NULL,
  SortOrder  SMALLINT NOT NULL)
GO

if not exists (select 1 from sysobjects where id = object_id(N'yaf_CheckEmail') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	create table dbo.yaf_CheckEmail(
		CheckEmailID	int IDENTITY (1, 1) NOT NULL ,
		UserID			int NOT NULL ,
		Email			nvarchar (50) NOT NULL ,
		Created			datetime NOT NULL ,
		Hash			nvarchar (32) NOT NULL
	)

GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Choice')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Choice (
  ChoiceID INT IDENTITY( 1  , 1  ) NOT NULL,
  PollID   INT NOT NULL,
  Choice   NVARCHAR(50) NOT NULL,
  Votes    INT NOT NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_PollVote')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE [dbo].[yaf_PollVote] (
  [PollVoteID] [INT] IDENTITY( 1  , 1  ) NOT NULL,
  [PollID]     [INT] NOT NULL,
  [UserID]     [INT] NULL,
  [RemoteIP]   [NVARCHAR](10) NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Forum')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Forum (
  ForumID       INT IDENTITY( 1  , 1  ) NOT NULL,
  CategoryID    INT NOT NULL,
  ParentID      INT NULL,
  [Name]        NVARCHAR(128) NOT NULL,
  Description   NVARCHAR(255) NOT NULL,
  SortOrder     SMALLINT NOT NULL,
  LastPosted    DATETIME NULL,
  LastTopicID   INT NULL,
  LastMessageID INT NULL,
  LastUserID    INT NULL,
  LastUserName  NVARCHAR(50) NULL,
  NumTopics     INT NOT NULL,
  NumPosts      INT NOT NULL,
  RemoteURL     NVARCHAR(100) NULL,
  Flags         INT NOT NULL CONSTRAINT DF_yaf_Forum_Flags DEFAULT (0))
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_ForumAccess')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_ForumAccess (
  GroupID      INT NOT NULL,
  ForumID      INT NOT NULL,
  AccessMaskID INT NOT NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Group')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Group (
  GroupID INT IDENTITY( 1  , 1  ) NOT NULL,
  BoardID INT NOT NULL,
  Name    NVARCHAR(50) NOT NULL,
  Flags   INT NOT NULL CONSTRAINT DF_yaf_Group_Flags DEFAULT (0))
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Mail')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Mail (
  MailID   INT IDENTITY( 1  , 1  ) NOT NULL,
  FromUser NVARCHAR(50) NOT NULL,
  ToUser   NVARCHAR(50) NOT NULL,
  Created  DATETIME NOT NULL,
  Subject  NVARCHAR(256) NOT NULL,
  Body     NTEXT NOT NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Message')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Message (
  MessageID INT IDENTITY( 1  , 1  ) NOT NULL,
  TopicID   INT NOT NULL,
  ReplyTo   INT NULL,
  Position  INT NOT NULL,
  Indent    INT NOT NULL,
  UserID    INT NOT NULL,
  UserName  NVARCHAR(50) NULL,
  Posted    DATETIME NOT NULL,
  Message   NTEXT NOT NULL,
  IP        NVARCHAR(15) NOT NULL,
  Edited    DATETIME NULL,
  Flags     INT NOT NULL CONSTRAINT DF_yaf_Message_Flags DEFAULT (23))
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_FirstPost')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE [dbo].[yaf_FirstPost](
	[messageid] [int] NULL,
	[rating] [int] NULL,
	[ratingID] [int] IDENTITY(1,1) NOT NULL
) 
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_PMessage')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_PMessage (
  PMessageID INT IDENTITY( 1  , 1  ) NOT NULL,
  FromUserID INT NOT NULL,
  Created    DATETIME NOT NULL,
  Subject    NVARCHAR(256) NOT NULL,
  Body       NTEXT NOT NULL,
  Flags      INT NOT NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Poll')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Poll (
  PollID   INT IDENTITY( 1  , 1  ) NOT NULL,
  Question NVARCHAR(50) NOT NULL,
  Closes   DATETIME NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Smiley')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Smiley (
  SmileyID INT IDENTITY( 1  , 1  ) NOT NULL,
  BoardID  INT NOT NULL,
  Code     NVARCHAR(10) NOT NULL,
  Icon     NVARCHAR(50) NOT NULL,
  Emoticon NVARCHAR(50) NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Topic')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Topic (
  TopicID       INT IDENTITY( 1  , 1  ) NOT NULL,
  ForumID       INT NOT NULL,
  UserID        INT NOT NULL,
  UserName      NVARCHAR(50) NULL,
  Posted        DATETIME NOT NULL,
  Topic         NVARCHAR(128) NOT NULL,
  Views         INT NOT NULL,
  Priority      SMALLINT NOT NULL,
  PollID        INT NULL,
  TopicMovedID  INT NULL,
  LastPosted    DATETIME NULL,
  LastMessageID INT NULL,
  LastUserID    INT NULL,
  LastUserName  NVARCHAR(50) NULL,
  NumPosts      INT NOT NULL,
  Flags         INT NOT NULL CONSTRAINT DF_yaf_Topic_Flags DEFAULT (0))
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Rating')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE [dbo].[yaf_Rating](
	[userid] [int] NOT NULL,
	[messageid] [int] NULL,
	[rating] [int] NULL,
	[ratingID] [int] IDENTITY(1,1) NOT NULL
) 
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_User')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_User (
  UserID         INT IDENTITY( 1  , 1  ) NOT NULL,
  BoardID        INT NOT NULL,
  Name           NVARCHAR(50) NOT NULL,
  Password       NVARCHAR(32) NOT NULL,
  Email          NVARCHAR(50) NULL,
  Joined         DATETIME NOT NULL,
  LastVisit      DATETIME NOT NULL,
  IP             NVARCHAR(15) NULL,
  NumPosts       INT NOT NULL,
  Location       NVARCHAR(50) NULL,
  HomePage       NVARCHAR(50) NULL,
  TimeZone       INT NOT NULL,
  Avatar         NVARCHAR(255) NULL,
  Signature      NTEXT NULL,
  AvatarImage    IMAGE NULL,
  RankID         INT NOT NULL,
  Suspended      DATETIME NULL,
  LanguageFile   NVARCHAR(50) NULL,
  ThemeFile      NVARCHAR(50) NULL,
  MSN            NVARCHAR(50) NULL,
  YIM            NVARCHAR(30) NULL,
  AIM            NVARCHAR(30) NULL,
  ICQ            INT NULL,
  RealName       NVARCHAR(50) NULL,
  Occupation     NVARCHAR(50) NULL,
  Interests      NVARCHAR(100) NULL,
  Gender         TINYINT NOT NULL,
  Weblog         NVARCHAR(100) NULL,
  PMNotification BIT NOT NULL CONSTRAINT DF_yaf_User_PMNotification DEFAULT (1),
  Flags          INT NOT NULL CONSTRAINT DF_yaf_User_Flags DEFAULT (0))
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_WatchForum')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_WatchForum (
  WatchForumID INT IDENTITY( 1  , 1  ) NOT NULL,
  ForumID      INT NOT NULL,
  UserID       INT NOT NULL,
  Created      DATETIME NOT NULL,
  LastMail     DATETIME NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_WatchTopic')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_WatchTopic (
  WatchTopicID INT IDENTITY( 1  , 1  ) NOT NULL,
  TopicID      INT NOT NULL,
  UserID       INT NOT NULL,
  Created      DATETIME NOT NULL,
  LastMail     DATETIME NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Attachment')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Attachment (
  AttachmentID INT IDENTITY NOT NULL,
  MessageID    INT NOT NULL,
  FileName     NVARCHAR(250) NOT NULL,
  Bytes        INT NOT NULL,
  FileID       INT NULL,
  ContentType  NVARCHAR(50) NULL,
  Downloads    INT NOT NULL,
  FileData     IMAGE NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_UserGroup')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_UserGroup (
  UserID  INT NOT NULL,
  GroupID INT NOT NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Rank')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Rank (
  RankID    INT IDENTITY( 1  , 1  ) NOT NULL,
  BoardID   INT NOT NULL,
  Name      NVARCHAR(50) NOT NULL,
  MinPosts  INT NULL,
  RankImage NVARCHAR(50) NULL,
  Flags     INT NOT NULL CONSTRAINT DF_yaf_Rank_Flags DEFAULT (0))
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_AccessMask')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_AccessMask (
  AccessMaskID INT IDENTITY NOT NULL,
  BoardID      INT NOT NULL,
  Name         NVARCHAR(50) NOT NULL,
  Flags        INT NOT NULL CONSTRAINT DF_yaf_AccessMask_Flags DEFAULT (0))
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_UserForum')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_UserForum (
  UserID       INT NOT NULL,
  ForumID      INT NOT NULL,
  AccessMaskID INT NOT NULL,
  Invited      DATETIME NOT NULL,
  Accepted     BIT NOT NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Board')
               AND Objectproperty(id,N'IsUserTable') = 1)
BEGIN
    CREATE TABLE dbo.yaf_Board (
      BoardID       INT NOT NULL IDENTITY( 1  , 1  ),
      Name          NVARCHAR(50) NOT NULL,
      AllowThreaded BIT NOT NULL ,)
END
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_NntpServer')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_NntpServer (
  NntpServerID INT IDENTITY NOT NULL,
  BoardID      INT NOT NULL,
  Name         NVARCHAR(50) NOT NULL,
  Address      NVARCHAR(100) NOT NULL,
  Port         INT NULL,
  UserName     NVARCHAR(50) NULL,
  UserPass     NVARCHAR(50) NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_NntpForum')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_NntpForum (
  NntpForumID   INT IDENTITY NOT NULL,
  NntpServerID  INT NOT NULL,
  GroupName     NVARCHAR(100) NOT NULL,
  ForumID       INT NOT NULL,
  LastMessageNo INT NOT NULL,
  LastUpdate    DATETIME NOT NULL,
  Active        BIT NOT NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_NntpTopic')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_NntpTopic (
  NntpTopicID INT IDENTITY NOT NULL,
  NntpForumID INT NOT NULL,
  Thread      CHAR(32) NOT NULL,
  TopicID     INT NOT NULL)
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_UserPMessage')
               AND Objectproperty(id,N'IsUserTable') = 1)
BEGIN
    CREATE TABLE dbo.yaf_UserPMessage (
      UserPMessageID INT IDENTITY NOT NULL,
      UserID         INT NOT NULL,
      PMessageID     INT NOT NULL,
      IsRead         BIT NOT NULL)
END
GO

IF NOT EXISTS (SELECT *
               FROM   dbo.sysobjects
               WHERE  id = Object_id(N'yaf_Replace_Words')
               AND Objectproperty(id,N'IsUserTable') = 1)
CREATE TABLE dbo.yaf_Replace_Words (
  id       INT IDENTITY( 1  , 1  ) NOT NULL,
  badword  NVARCHAR(255) NULL,
  goodword NVARCHAR(255) NULL,
  CONSTRAINT PK_Replace_Words PRIMARY KEY( id  ))
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_Registry')
               AND Objectproperty(id,N'IsUserTable') = 1)
BEGIN
    CREATE TABLE dbo.yaf_Registry (
      RegistryID INT IDENTITY( 1  , 1  ) NOT NULL,
      Name       NVARCHAR(50) NOT NULL,
      VALUE      NTEXT,
      BoardID    INT,
      CONSTRAINT PK_Registry PRIMARY KEY( RegistryID  ))
END
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  id = Object_id(N'yaf_EventLog')
               AND Objectproperty(id,N'IsUserTable') = 1)
BEGIN
    CREATE TABLE dbo.yaf_EventLog (
      EventLogID  INT IDENTITY( 1  , 1  ) NOT NULL,
      EventTime   DATETIME NOT NULL CONSTRAINT DF_EventLog_EventTime DEFAULT Getdate(),
      UserID      INT NOT NULL,
      Source      NVARCHAR(50) NOT NULL,
      Description NTEXT NOT NULL,
      CONSTRAINT PK_EventLog PRIMARY KEY( EventLogID  ))
END
GO

/*
** Added columns
*/

-- yaf_User
IF EXISTS (SELECT 1
           FROM   dbo.syscolumns
           WHERE  id = Object_id(N'yaf_User')
           AND name = N'Signature'
           AND xtype <> 99)
BEGIN
    ALTER TABLE yaf_User
    ALTER COLUMN Signature NTEXT NULL
END
GO

IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_User')
               AND name = 'Flags')
BEGIN
    ALTER TABLE dbo.yaf_User
    ADD Flags INT NOT NULL CONSTRAINT DF_yaf_User_Flags DEFAULT (0)
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_User')
           AND name = 'IsHostAdmin')
BEGIN
    GRANT
      UPDATE
      ON yaf_User
    TO PUBLIC
    EXEC( 'update yaf_User set Flags = Flags | 1 where IsHostAdmin<>0')
    REVOKE UPDATE ON yaf_User FROM PUBLIC
    ALTER TABLE dbo.yaf_User
    DROP COLUMN IsHostAdmin
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_User')
           AND name = 'Approved')
BEGIN
    GRANT
      UPDATE
      ON yaf_User
    TO PUBLIC
    EXEC( 'update yaf_User set Flags = Flags | 2 where Approved<>0')
    REVOKE UPDATE ON yaf_User FROM PUBLIC
    ALTER TABLE dbo.yaf_User
    DROP COLUMN Approved
END
GO

IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_User')
               AND name = 'PMNotification')
BEGIN
    ALTER TABLE dbo.yaf_User
    ADD [PMNotification] [BIT] NOT NULL CONSTRAINT [DF_yaf_User_PMNotification] DEFAULT (1)
END
GO

IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_User')
               AND name = 'Points')
BEGIN
    ALTER TABLE dbo.yaf_User
    ADD [Points] [INT] NOT NULL CONSTRAINT [DF_yaf_User_Points] DEFAULT (0)
END
GO

-- yaf_Forum
IF NOT EXISTS (SELECT *
               FROM   syscolumns
               WHERE  id = Object_id('yaf_Forum')
               AND name = 'RemoteURL')
BEGIN
    ALTER TABLE yaf_Forum
    ADD RemoteURL NVARCHAR(100) NULL
END
GO

IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_Forum')
               AND name = 'Flags')
BEGIN
    ALTER TABLE yaf_Forum
    ADD Flags INT NOT NULL CONSTRAINT DF_yaf_Forum_Flags DEFAULT (0)
END
GO

IF NOT EXISTS (SELECT *
               FROM   syscolumns
               WHERE  id = Object_id('yaf_Forum')
               AND name = 'ThemeURL')
BEGIN
    ALTER TABLE yaf_Forum
    ADD ThemeURL NVARCHAR(50) NULL
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Forum')
           AND name = 'Locked')
BEGIN
    EXEC( 'update yaf_Forum set Flags = Flags | 1 where Locked<>0')
    ALTER TABLE dbo.yaf_Forum
    DROP COLUMN Locked
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Forum')
           AND name = 'Hidden')
BEGIN
    EXEC( 'update yaf_Forum set Flags = Flags | 2 where Hidden<>0')
    ALTER TABLE dbo.yaf_Forum
    DROP COLUMN Hidden
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Forum')
           AND name = 'IsTest')
BEGIN
    EXEC( 'update yaf_Forum set Flags = Flags | 4 where IsTest<>0')
    ALTER TABLE dbo.yaf_Forum
    DROP COLUMN IsTest
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Forum')
           AND name = 'Moderated')
BEGIN
    EXEC( 'update yaf_Forum set Flags = Flags | 8 where Moderated<>0')
    ALTER TABLE dbo.yaf_Forum
    DROP COLUMN Moderated
END
GO

-- yaf_Group
IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_Group')
               AND name = 'Flags')
BEGIN
    ALTER TABLE dbo.yaf_Group
    ADD Flags INT NOT NULL CONSTRAINT DF_yaf_Group_Flags DEFAULT (0)
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Group')
           AND name = 'IsAdmin')
BEGIN
    EXEC( 'update yaf_Group set Flags = Flags | 1 where IsAdmin<>0')
    ALTER TABLE dbo.yaf_Group
    DROP COLUMN IsAdmin
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Group')
           AND name = 'IsGuest')
BEGIN
    EXEC( 'update yaf_Group set Flags = Flags | 2 where IsGuest<>0')
    ALTER TABLE dbo.yaf_Group
    DROP COLUMN IsGuest
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Group')
           AND name = 'IsStart')
BEGIN
    EXEC( 'update yaf_Group set Flags = Flags | 4 where IsStart<>0')
    ALTER TABLE dbo.yaf_Group
    DROP COLUMN IsStart
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Group')
           AND name = 'IsModerator')
BEGIN
    EXEC( 'update yaf_Group set Flags = Flags | 8 where IsModerator<>0')
    ALTER TABLE dbo.yaf_Group
    DROP COLUMN IsModerator
END
GO

IF EXISTS (SELECT 1
           FROM   dbo.yaf_Group
           WHERE  (Flags & 2) = 2)
BEGIN
    UPDATE dbo.yaf_User
    SET    Flags = Flags | 4
    WHERE  UserID IN (SELECT DISTINCT UserID
               FROM   dbo.yaf_UserGroup a
                      JOIN dbo.yaf_Group b
                        ON b.GroupID = a.GroupID
                           AND (b.Flags & 2) = 2)
END
GO

-- yaf_AccessMask
IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_AccessMask')
               AND name = 'Flags')
BEGIN
    ALTER TABLE dbo.yaf_AccessMask
    ADD Flags INT NOT NULL CONSTRAINT DF_yaf_AccessMask_Flags DEFAULT (0)
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_AccessMask')
           AND name = 'ReadAccess')
BEGIN
    EXEC( 'update yaf_AccessMask set Flags = Flags | 1 where ReadAccess<>0')
    ALTER TABLE dbo.yaf_AccessMask
    DROP COLUMN ReadAccess
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_AccessMask')
           AND name = 'PostAccess')
BEGIN
    EXEC( 'update yaf_AccessMask set Flags = Flags | 2 where PostAccess<>0')
    ALTER TABLE dbo.yaf_AccessMask
    DROP COLUMN PostAccess
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_AccessMask')
           AND name = 'ReplyAccess')
BEGIN
    EXEC( 'update yaf_AccessMask set Flags = Flags | 4 where ReplyAccess<>0')
    ALTER TABLE dbo.yaf_AccessMask
    DROP COLUMN ReplyAccess
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_AccessMask')
           AND name = 'PriorityAccess')
BEGIN
    EXEC( 'update yaf_AccessMask set Flags = Flags | 8 where PriorityAccess<>0')
    ALTER TABLE dbo.yaf_AccessMask
    DROP COLUMN PriorityAccess
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_AccessMask')
           AND name = 'PollAccess')
BEGIN
    EXEC( 'update yaf_AccessMask set Flags = Flags | 16 where PollAccess<>0')
    ALTER TABLE dbo.yaf_AccessMask
    DROP COLUMN PollAccess
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_AccessMask')
           AND name = 'VoteAccess')
BEGIN
    EXEC( 'update yaf_AccessMask set Flags = Flags | 32 where VoteAccess<>0')
    ALTER TABLE dbo.yaf_AccessMask
    DROP COLUMN VoteAccess
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_AccessMask')
           AND name = 'ModeratorAccess')
BEGIN
    EXEC( 'update yaf_AccessMask set Flags = Flags | 64 where ModeratorAccess<>0')
    ALTER TABLE dbo.yaf_AccessMask
    DROP COLUMN ModeratorAccess
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_AccessMask')
           AND name = 'EditAccess')
BEGIN
    EXEC( 'update yaf_AccessMask set Flags = Flags | 128 where EditAccess<>0')
    ALTER TABLE dbo.yaf_AccessMask
    DROP COLUMN EditAccess
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_AccessMask')
           AND name = 'DeleteAccess')
BEGIN
    EXEC( 'update yaf_AccessMask set Flags = Flags | 256 where DeleteAccess<>0')
    ALTER TABLE dbo.yaf_AccessMask
    DROP COLUMN DeleteAccess
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_AccessMask')
           AND name = 'UploadAccess')
BEGIN
    EXEC( 'update yaf_AccessMask set Flags = Flags | 512 where UploadAccess<>0')
    ALTER TABLE dbo.yaf_AccessMask
    DROP COLUMN UploadAccess
END
GO

-- yaf_NntpForum
IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_NntpForum')
               AND name = 'Active')
BEGIN
    ALTER TABLE yaf_NntpForum
    ADD Active BIT NULL
    EXEC( 'update yaf_NntpForum set Active=1 where Active is null')
    ALTER TABLE yaf_NntpForum
    ALTER COLUMN Active BIT NOT NULL
END
GO

IF EXISTS (SELECT *
           FROM   dbo.syscolumns
           WHERE  id = Object_id(N'yaf_Replace_Words')
           AND name = 'badword'
           AND prec < 255)
BEGIN
    ALTER TABLE yaf_Replace_Words
    ALTER COLUMN badword NVARCHAR(255) NULL
END
GO

IF EXISTS (SELECT *
           FROM   dbo.syscolumns
           WHERE  id = Object_id(N'yaf_Replace_Words')
           AND name = 'goodword'
           AND prec < 255)
BEGIN
    ALTER TABLE yaf_Replace_Words
    ALTER COLUMN goodword NVARCHAR(255) NULL
END
GO

IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_Registry')
               AND name = 'BoardID')
BEGIN
    ALTER TABLE yaf_Registry
    ADD BoardID INT
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id(N'yaf_Registry')
           AND name = N'Value'
           AND xtype <> 99)
BEGIN           
	ALTER TABLE yaf_Registry
	ALTER COLUMN VALUE NTEXT NULL
END
GO

IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_PMessage')
               AND name = 'Flags')
BEGIN
    ALTER TABLE dbo.yaf_PMessage
    ADD Flags INT NOT NULL CONSTRAINT DF_yaf_Message_Flags DEFAULT (23)
END
GO

IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_Topic')
               AND name = 'Flags')
BEGIN
    ALTER TABLE dbo.yaf_Topic
    ADD Flags INT NOT NULL CONSTRAINT DF_yaf_Topic_Flags DEFAULT (0)
    UPDATE yaf_Message
    SET    Flags = Flags & 7
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Message')
           AND name = 'Approved')
BEGIN
    EXEC( 'update yaf_Message set Flags = Flags | 16 where Approved<>0')
    ALTER TABLE dbo.yaf_Message
    DROP COLUMN Approved
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Topic')
           AND name = 'IsLocked')
BEGIN
    GRANT
      UPDATE
      ON yaf_Topic
    TO PUBLIC
    EXEC( 'update yaf_Topic set Flags = Flags | 1 where IsLocked<>0')
    REVOKE UPDATE ON yaf_Topic FROM PUBLIC
    ALTER TABLE dbo.yaf_Topic
    DROP COLUMN IsLocked
END
GO

IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_Rank')
               AND name = 'Flags')
BEGIN
    ALTER TABLE dbo.yaf_Rank
    ADD Flags INT NOT NULL CONSTRAINT DF_yaf_Rank_Flags DEFAULT (0)
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Rank')
           AND name = 'IsStart')
BEGIN
    GRANT
      UPDATE
      ON yaf_Rank
    TO PUBLIC
    EXEC( 'update yaf_Rank set Flags = Flags | 1 where IsStart<>0')
    REVOKE UPDATE ON yaf_Rank FROM PUBLIC
    ALTER TABLE dbo.yaf_Rank
    DROP COLUMN IsStart
END
GO

IF EXISTS (SELECT 1
           FROM   syscolumns
           WHERE  id = Object_id('yaf_Rank')
           AND name = 'IsLadder')
BEGIN
    GRANT
      UPDATE
      ON yaf_Rank
    TO PUBLIC
    EXEC( 'update yaf_Rank set Flags = Flags | 2 where IsLadder<>0')
    REVOKE UPDATE ON yaf_Rank FROM PUBLIC
    ALTER TABLE dbo.yaf_Rank
    DROP COLUMN IsLadder
END
GO

IF NOT EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  id = Object_id('yaf_Poll')
               AND name = 'Closes')
BEGIN
    ALTER TABLE dbo.yaf_Poll
    ADD Closes DATETIME NULL
END
GO

IF NOT EXISTS (SELECT 1
               FROM   dbo.syscolumns
               WHERE  id = Object_id(N'yaf_EventLog')
               AND name = N'Type')
BEGIN
    ALTER TABLE dbo.yaf_EventLog
    ADD TYPE INT NOT NULL CONSTRAINT DF_yaf_EventLog_Type DEFAULT (0)
    EXEC( 'update yaf_EventLog set Type = 0')
END
GO

IF EXISTS (SELECT 1
           FROM   dbo.syscolumns
           WHERE  id = Object_id(N'yaf_EventLog')
           AND name = N'UserID'
           AND isnullable = 0)
BEGIN
    ALTER TABLE yaf_EventLog
    ALTER COLUMN UserID INT NULL
END
GO

IF EXISTS (SELECT 1
           FROM   dbo.syscolumns
           WHERE  id = Object_id(N'yaf_Topic')
           AND name = N'Topic'
           AND prec < 128)
BEGIN
    ALTER TABLE yaf_Topic ALTER COLUMN Topic NVARCHAR(128) NOT NULL
END
GO

IF EXISTS (SELECT 1
           FROM   dbo.syscolumns
           WHERE  id = Object_id(N'yaf_forum')
           AND name = N'Name'
           AND prec < 128)
BEGIN
    ALTER TABLE yaf_forum ALTER COLUMN [Name] NVARCHAR(128) NOT NULL
END
GO

IF EXISTS (SELECT 1
           FROM   dbo.syscolumns
           WHERE  id = Object_id(N'yaf_category')
           AND name = N'Name'
           AND prec < 128)
BEGIN
    ALTER TABLE yaf_category ALTER COLUMN [Name] NVARCHAR(128) NOT NULL
END
GO