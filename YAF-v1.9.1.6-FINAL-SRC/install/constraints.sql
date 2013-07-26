/*
** Drop old Foreign keys
*/

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Active_Forum'
           AND parent_obj = Object_id('yaf_Active')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Active
DROP CONSTRAINT FK_Active_Forum
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Active_Topic'
           AND parent_obj = Object_id('yaf_Active')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Active
DROP CONSTRAINT FK_Active_Topic
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Active_User'
           AND parent_obj = Object_id('yaf_Active')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Active
DROP CONSTRAINT FK_Active_User
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_CheckEmail_User'
           AND parent_obj = Object_id('yaf_CheckEmail')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_CheckEmail
DROP CONSTRAINT FK_CheckEmail_User
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Choice_Poll'
           AND parent_obj = Object_id('yaf_Choice')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Choice
DROP CONSTRAINT FK_Choice_Poll
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Forum_Category'
           AND parent_obj = Object_id('yaf_Forum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Forum
DROP CONSTRAINT FK_Forum_Category
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Forum_Message'
           AND parent_obj = Object_id('yaf_Forum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Forum
DROP CONSTRAINT FK_Forum_Message
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Forum_Topic'
           AND parent_obj = Object_id('yaf_Forum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Forum
DROP CONSTRAINT FK_Forum_Topic
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Forum_User'
           AND parent_obj = Object_id('yaf_Forum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Forum
DROP CONSTRAINT FK_Forum_User
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_ForumAccess_Forum'
           AND parent_obj = Object_id('yaf_ForumAccess')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_ForumAccess
DROP CONSTRAINT FK_ForumAccess_Forum
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_ForumAccess_Group'
           AND parent_obj = Object_id('yaf_ForumAccess')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_ForumAccess
DROP CONSTRAINT FK_ForumAccess_Group
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Message_Topic'
           AND parent_obj = Object_id('yaf_Message')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Message
DROP CONSTRAINT FK_Message_Topic
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Message_User'
           AND parent_obj = Object_id('yaf_Message')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Message
DROP CONSTRAINT FK_Message_User
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_PMessage_User1'
           AND parent_obj = Object_id('yaf_PMessage')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_PMessage
DROP CONSTRAINT FK_PMessage_User1
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Topic_Forum'
           AND parent_obj = Object_id('yaf_Topic')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
DROP CONSTRAINT FK_Topic_Forum
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Topic_Message'
           AND parent_obj = Object_id('yaf_Topic')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
DROP CONSTRAINT FK_Topic_Message
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Topic_Poll'
           AND parent_obj = Object_id('yaf_Topic')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
DROP CONSTRAINT FK_Topic_Poll
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Topic_Topic'
           AND parent_obj = Object_id('yaf_Topic')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
DROP CONSTRAINT FK_Topic_Topic
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Topic_User'
           AND parent_obj = Object_id('yaf_Topic')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
DROP CONSTRAINT FK_Topic_User
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Topic_User2'
           AND parent_obj = Object_id('yaf_Topic')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
DROP CONSTRAINT FK_Topic_User2
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_WatchForum_Forum'
           AND parent_obj = Object_id('yaf_WatchForum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_WatchForum
DROP CONSTRAINT FK_WatchForum_Forum
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_WatchForum_User'
           AND parent_obj = Object_id('yaf_WatchForum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_WatchForum
DROP CONSTRAINT FK_WatchForum_User
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_WatchTopic_Topic'
           AND parent_obj = Object_id('yaf_WatchTopic')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_WatchTopic
DROP CONSTRAINT FK_WatchTopic_Topic
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_WatchTopic_User'
           AND parent_obj = Object_id('yaf_WatchTopic')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_WatchTopic
DROP CONSTRAINT FK_WatchTopic_User
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Active_Forum'
           AND parent_obj = Object_id('yaf_Active')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Attachment
DROP CONSTRAINT FK_Attachment_Message
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_UserGroup_User'
           AND parent_obj = Object_id('yaf_UserGroup')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserGroup
DROP CONSTRAINT FK_UserGroup_User
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_UserGroup_Group'
           AND parent_obj = Object_id('yaf_UserGroup')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserGroup
DROP CONSTRAINT FK_UserGroup_Group
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Attachment_Message'
           AND parent_obj = Object_id('yaf_Attachment')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Attachment
DROP CONSTRAINT FK_Attachment_Message
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_NntpForum_NntpServer'
           AND parent_obj = Object_id('yaf_NntpForum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_NntpForum
DROP CONSTRAINT FK_NntpForum_NntpServer
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_NntpForum_Forum'
           AND parent_obj = Object_id('yaf_NntpForum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_NntpForum
DROP CONSTRAINT FK_NntpForum_Forum
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_NntpTopic_NntpForum'
           AND parent_obj = Object_id('yaf_NntpTopic')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_NntpTopic
DROP CONSTRAINT FK_NntpTopic_NntpForum
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_NntpTopic_Topic'
           AND parent_obj = Object_id('yaf_NntpTopic')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_NntpTopic
DROP CONSTRAINT FK_NntpTopic_Topic
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_ForumAccess_AccessMask'
           AND parent_obj = Object_id('yaf_ForumAccess')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_ForumAccess
DROP CONSTRAINT FK_ForumAccess_AccessMask
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_UserForum_User'
           AND parent_obj = Object_id('yaf_UserForum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserForum
DROP CONSTRAINT FK_UserForum_User
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_UserForum_Forum'
           AND parent_obj = Object_id('yaf_UserForum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserForum
DROP CONSTRAINT FK_UserForum_Forum
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_UserForum_AccessMask'
           AND parent_obj = Object_id('yaf_UserForum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserForum
DROP CONSTRAINT FK_UserForum_AccessMask
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Category_Board'
           AND parent_obj = Object_id('yaf_Category')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Category
DROP CONSTRAINT FK_Category_Board
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_AccessMask_Board'
           AND parent_obj = Object_id('yaf_AccessMask')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_AccessMask
DROP CONSTRAINT FK_AccessMask_Board
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Active_Board'
           AND parent_obj = Object_id('yaf_Active')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Active
DROP CONSTRAINT FK_Active_Board
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_BannedIP_Board'
           AND parent_obj = Object_id('yaf_BannedIP')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_BannedIP
DROP CONSTRAINT FK_BannedIP_Board
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Group_Board'
           AND parent_obj = Object_id('yaf_Group')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Group
DROP CONSTRAINT FK_Group_Board
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_NntpServer_Board'
           AND parent_obj = Object_id('yaf_NntpServer')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_NntpServer
DROP CONSTRAINT FK_NntpServer_Board
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Rank_Board'
           AND parent_obj = Object_id('yaf_Rank')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Rank
DROP CONSTRAINT FK_Rank_Board
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Smiley_Board'
           AND parent_obj = Object_id('yaf_Smiley')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Smiley
DROP CONSTRAINT FK_Smiley_Board
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_User_Rank'
           AND parent_obj = Object_id('yaf_User')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_User
DROP CONSTRAINT FK_User_Rank
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_User_Board'
           AND parent_obj = Object_id('yaf_User')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_User
DROP CONSTRAINT FK_User_Board
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Forum_Forum'
           AND parent_obj = Object_id('yaf_Forum')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Forum
DROP CONSTRAINT FK_Forum_Forum
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Message_Message'
           AND parent_obj = Object_id('yaf_Message')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Message
DROP CONSTRAINT FK_Message_Message
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_UserPMessage_User'
           AND parent_obj = Object_id('yaf_UserPMessage')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserPMessage
DROP CONSTRAINT FK_UserPMessage_User
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_UserPMessage_PMessage'
           AND parent_obj = Object_id('yaf_UserPMessage')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserPMessage
DROP CONSTRAINT FK_UserPMessage_PMessage
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_Registry_Board'
           AND parent_obj = Object_id('yaf_Registry')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Registry
DROP CONSTRAINT FK_Registry_Board
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_EventLog_User'
           AND parent_obj = Object_id('yaf_EventLog')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_EventLog
DROP CONSTRAINT FK_EventLog_User
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = 'FK_yaf_PollVote_yaf_Poll'
           AND parent_obj = Object_id('yaf_PollVote')
           AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_PollVote
DROP CONSTRAINT FK_yaf_PollVote_yaf_Poll
GO

/* Drop old primary keys */
IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_BannedIP')
           AND name = 'PK_BannedIP')
ALTER TABLE dbo.yaf_BannedIP
DROP CONSTRAINT PK_BannedIP
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Category')
           AND name = 'PK_Category')
ALTER TABLE dbo.yaf_Category
DROP CONSTRAINT PK_Category
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_CheckEmail')
           AND name = 'PK_CheckEmail')
ALTER TABLE dbo.yaf_CheckEmail
DROP CONSTRAINT PK_CheckEmail
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Choice')
           AND name = 'PK_Choice')
ALTER TABLE dbo.yaf_Choice
DROP CONSTRAINT PK_Choice
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Forum')
           AND name = 'PK_Forum')
ALTER TABLE dbo.yaf_Forum
DROP CONSTRAINT PK_Forum
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_ForumAccess')
           AND name = 'PK_ForumAccess')
ALTER TABLE dbo.yaf_ForumAccess
DROP CONSTRAINT PK_ForumAccess
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Group')
           AND name = 'PK_Group')
ALTER TABLE dbo.yaf_Group
DROP CONSTRAINT PK_Group
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Mail')
           AND name = 'PK_Mail')
ALTER TABLE dbo.yaf_Mail
DROP CONSTRAINT PK_Mail
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Message')
           AND name = 'PK_Message')
ALTER TABLE dbo.yaf_Message
DROP CONSTRAINT PK_Message
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_PMessage')
           AND name = 'PK_PMessage')
ALTER TABLE dbo.yaf_PMessage
DROP CONSTRAINT PK_PMessage
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Poll')
           AND name = 'PK_Poll')
ALTER TABLE dbo.yaf_Poll
DROP CONSTRAINT PK_Poll
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Smiley')
           AND name = 'PK_Smiley')
ALTER TABLE dbo.yaf_Smiley
DROP CONSTRAINT PK_Smiley
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Topic')
           AND name = 'PK_Topic')
ALTER TABLE dbo.yaf_Topic
DROP CONSTRAINT PK_Topic
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_User')
           AND name = 'PK_User')
ALTER TABLE dbo.yaf_User
DROP CONSTRAINT PK_User
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_WatchForum')
           AND name = 'PK_WatchForum')
ALTER TABLE dbo.yaf_WatchForum
DROP CONSTRAINT PK_WatchForum
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_WatchTopic')
           AND name = 'PK_WatchTopic')
ALTER TABLE dbo.yaf_WatchTopic
DROP CONSTRAINT PK_WatchTopic
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_UserGroup')
           AND name = 'PK_UserGroup')
ALTER TABLE dbo.yaf_UserGroup
DROP CONSTRAINT PK_UserGroup
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Rank')
           AND name = 'PK_Rank')
ALTER TABLE dbo.yaf_Rank
DROP CONSTRAINT PK_Rank
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_NntpServer')
           AND name = 'PK_NntpServer')
ALTER TABLE dbo.yaf_NntpServer
DROP CONSTRAINT PK_NntpServer
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_NntpForum')
           AND name = 'PK_NntpForum')
ALTER TABLE dbo.yaf_NntpForum
DROP CONSTRAINT PK_NntpForum
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_NntpTopic')
           AND name = 'PK_NntpTopic')
ALTER TABLE dbo.yaf_NntpTopic
DROP CONSTRAINT PK_NntpTopic
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_AccessMask')
           AND name = 'PK_AccessMask')
ALTER TABLE dbo.yaf_AccessMask
DROP CONSTRAINT PK_AccessMask
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_UserForum')
           AND name = 'PK_UserForum')
ALTER TABLE dbo.yaf_UserForum
DROP CONSTRAINT PK_UserForum
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Board')
           AND name = 'PK_Board')
ALTER TABLE dbo.yaf_Board
DROP CONSTRAINT PK_Board
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Active')
           AND name = 'PK_Active')
ALTER TABLE dbo.yaf_Active
DROP CONSTRAINT PK_Active
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_UserPMessage')
           AND name = 'PK_UserPMessage')
ALTER TABLE dbo.yaf_UserPMessage
DROP CONSTRAINT PK_UserPMessage
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Attachment')
           AND name = 'PK_Attachment')
ALTER TABLE dbo.yaf_Attachment
DROP CONSTRAINT PK_Attachment
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Active')
           AND name = 'PK_Active')
ALTER TABLE dbo.yaf_Active
DROP CONSTRAINT PK_Active
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_PollVote')
           AND name = 'PK_PollVote')
ALTER TABLE dbo.yaf_PollVote
DROP CONSTRAINT PK_PollVote
GO

/*
** Unique constraints
*/
IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_CheckEmail')
           AND name = 'IX_CheckEmail')
ALTER TABLE dbo.yaf_CheckEmail
DROP CONSTRAINT IX_CheckEmail
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Forum')
           AND name = 'IX_Forum')
ALTER TABLE dbo.yaf_Forum
DROP CONSTRAINT IX_Forum
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_WatchForum')
           AND name = 'IX_WatchForum')
ALTER TABLE dbo.yaf_WatchForum
DROP CONSTRAINT IX_WatchForum
GO

IF EXISTS (SELECT 1
           FROM   sysindexes
           WHERE  id = Object_id('yaf_WatchTopic')
           AND name = 'IX_WatchTopic')
ALTER TABLE dbo.yaf_WatchTopic
DROP CONSTRAINT IX_WatchTopic
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Category')
           AND name = 'IX_Category')
ALTER TABLE dbo.yaf_Category
DROP CONSTRAINT IX_Category
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Rank')
           AND name = 'IX_Rank')
ALTER TABLE dbo.yaf_Rank
DROP CONSTRAINT IX_Rank
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_User')
           AND name = 'IX_User')
ALTER TABLE dbo.yaf_User
DROP CONSTRAINT IX_User
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Group')
           AND name = 'IX_Group')
ALTER TABLE dbo.yaf_Group
DROP CONSTRAINT IX_Group
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_BannedIP')
           AND name = 'IX_BannedIP')
ALTER TABLE dbo.yaf_BannedIP
DROP CONSTRAINT IX_BannedIP
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Smiley')
           AND name = 'IX_Smiley')
ALTER TABLE dbo.yaf_Smiley
DROP CONSTRAINT IX_Smiley
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_BannedIP')
           AND name = 'IX_BannedIP')
ALTER TABLE dbo.yaf_BannedIP
DROP CONSTRAINT IX_BannedIP
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Category')
           AND name = 'IX_Category')
ALTER TABLE dbo.yaf_Category
DROP CONSTRAINT IX_Category
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_CheckEmail')
           AND name = 'IX_CheckEmail')
ALTER TABLE dbo.yaf_CheckEmail
DROP CONSTRAINT IX_CheckEmail
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Forum')
           AND name = 'IX_Forum')
ALTER TABLE dbo.yaf_Forum
DROP CONSTRAINT IX_Forum
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Group')
           AND name = 'IX_Group')
ALTER TABLE dbo.yaf_Group
DROP CONSTRAINT IX_Group
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Rank')
           AND name = 'IX_Rank')
ALTER TABLE dbo.yaf_Rank
DROP CONSTRAINT IX_Rank
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_Smiley')
           AND name = 'IX_Smiley')
ALTER TABLE dbo.yaf_Smiley
DROP CONSTRAINT IX_Smiley
GO

IF EXISTS (SELECT *
           FROM   sysindexes
           WHERE  id = Object_id('yaf_User')
           AND name = 'IX_User')
ALTER TABLE dbo.yaf_User
DROP CONSTRAINT IX_User
GO

/* Build new constraints */

/*
** Primary keys
*/
IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_BannedIP')
               AND name = 'PK_yaf_BannedIP')
ALTER TABLE dbo.yaf_BannedIP
WITH NOCHECK ADD CONSTRAINT PK_yaf_BannedIP PRIMARY KEY CLUSTERED( ID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Category')
               AND name = 'PK_yaf_Category')
ALTER TABLE dbo.yaf_Category
WITH NOCHECK ADD CONSTRAINT PK_yaf_Category PRIMARY KEY CLUSTERED( CategoryID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_CheckEmail')
               AND name = 'PK_yaf_CheckEmail')
ALTER TABLE dbo.yaf_CheckEmail
WITH NOCHECK ADD CONSTRAINT PK_yaf_CheckEmail PRIMARY KEY CLUSTERED( CheckEmailID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Choice')
               AND name = 'PK_yaf_Choice')
ALTER TABLE dbo.yaf_Choice
WITH NOCHECK ADD CONSTRAINT PK_yaf_Choice PRIMARY KEY CLUSTERED( ChoiceID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Forum')
               AND name = 'PK_yaf_Forum')
ALTER TABLE dbo.yaf_Forum
WITH NOCHECK ADD CONSTRAINT PK_yaf_Forum PRIMARY KEY CLUSTERED( ForumID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_ForumAccess')
               AND name = 'PK_yaf_ForumAccess')
ALTER TABLE dbo.yaf_ForumAccess
WITH NOCHECK ADD CONSTRAINT PK_yaf_ForumAccess PRIMARY KEY CLUSTERED( GroupID  , ForumID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Group')
               AND name = 'PK_yaf_Group')
ALTER TABLE dbo.yaf_Group
WITH NOCHECK ADD CONSTRAINT PK_yaf_Group PRIMARY KEY CLUSTERED( GroupID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Mail')
               AND name = 'PK_yaf_Mail')
ALTER TABLE dbo.yaf_Mail
WITH NOCHECK ADD CONSTRAINT PK_yaf_Mail PRIMARY KEY CLUSTERED( MailID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Message')
               AND name = 'PK_yaf_Message')
ALTER TABLE dbo.yaf_Message
WITH NOCHECK ADD CONSTRAINT PK_yaf_Message PRIMARY KEY CLUSTERED( MessageID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_PMessage')
               AND name = 'PK_yaf_PMessage')
ALTER TABLE dbo.yaf_PMessage
WITH NOCHECK ADD CONSTRAINT PK_yaf_PMessage PRIMARY KEY CLUSTERED( PMessageID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Poll')
               AND name = 'PK_yaf_Poll')
ALTER TABLE dbo.yaf_Poll
WITH NOCHECK ADD CONSTRAINT PK_yaf_Poll PRIMARY KEY CLUSTERED( PollID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Smiley')
               AND name = 'PK_yaf_Smiley')
ALTER TABLE dbo.yaf_Smiley
WITH NOCHECK ADD CONSTRAINT PK_yaf_Smiley PRIMARY KEY CLUSTERED( SmileyID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Topic')
               AND name = 'PK_yaf_Topic')
ALTER TABLE dbo.yaf_Topic
WITH NOCHECK ADD CONSTRAINT PK_yaf_Topic PRIMARY KEY CLUSTERED( TopicID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_User')
               AND name = 'PK_yaf_yaf_User')
ALTER TABLE dbo.yaf_User
WITH NOCHECK ADD CONSTRAINT PK_yaf_yaf_User PRIMARY KEY CLUSTERED( UserID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_WatchForum')
               AND name = 'PK_yaf_WatchForum')
ALTER TABLE dbo.yaf_WatchForum
WITH NOCHECK ADD CONSTRAINT PK_yaf_WatchForum PRIMARY KEY CLUSTERED( WatchForumID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_WatchTopic')
               AND name = 'PK_yaf_WatchTopic')
ALTER TABLE dbo.yaf_WatchTopic
WITH NOCHECK ADD CONSTRAINT PK_yaf_WatchTopic PRIMARY KEY CLUSTERED( WatchTopicID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_UserGroup')
               AND name = 'PK_yaf_UserGroup')
ALTER TABLE dbo.yaf_UserGroup
WITH NOCHECK ADD CONSTRAINT PK_yaf_UserGroup PRIMARY KEY CLUSTERED( UserID  , GroupID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Rank')
               AND name = 'PK_yaf_Rank')
ALTER TABLE dbo.yaf_Rank
WITH NOCHECK ADD CONSTRAINT PK_yaf_Rank PRIMARY KEY CLUSTERED( RankID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_NntpServer')
               AND name = 'PK_yaf_NntpServer')
ALTER TABLE dbo.yaf_NntpServer
WITH NOCHECK ADD CONSTRAINT PK_yaf_NntpServer PRIMARY KEY CLUSTERED( NntpServerID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_NntpForum')
               AND name = 'PK_yaf_NntpForum')
ALTER TABLE dbo.yaf_NntpForum
WITH NOCHECK ADD CONSTRAINT PK_yaf_NntpForum PRIMARY KEY CLUSTERED( NntpForumID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_NntpTopic')
               AND name = 'PK_yaf_NntpTopic')
ALTER TABLE dbo.yaf_NntpTopic
WITH NOCHECK ADD CONSTRAINT PK_yaf_NntpTopic PRIMARY KEY CLUSTERED( NntpTopicID  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_AccessMask')
               AND name = 'PK_yaf_AccessMask')
ALTER TABLE dbo.yaf_AccessMask
WITH NOCHECK ADD CONSTRAINT PK_yaf_AccessMask PRIMARY KEY CLUSTERED( AccessMaskID  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_UserForum')
               AND name = 'PK_yaf_UserForum')
ALTER TABLE dbo.yaf_UserForum
WITH NOCHECK ADD CONSTRAINT PK_yaf_UserForum PRIMARY KEY CLUSTERED( UserID  , ForumID  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Board')
               AND name = 'PK_yaf_Board')
ALTER TABLE dbo.yaf_Board
WITH NOCHECK ADD CONSTRAINT PK_yaf_Board PRIMARY KEY CLUSTERED( BoardID  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Active')
               AND name = 'PK_yaf_Active')
ALTER TABLE dbo.yaf_Active
WITH NOCHECK ADD CONSTRAINT PK_yaf_Active PRIMARY KEY CLUSTERED( SessionID  , BoardID  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_UserPMessage')
               AND name = 'PK_yaf_UserPMessage')
ALTER TABLE dbo.yaf_UserPMessage
WITH NOCHECK ADD CONSTRAINT PK_yaf_UserPMessage PRIMARY KEY CLUSTERED( UserPMessageID  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Attachment')
               AND name = 'PK_yaf_Attachment')
ALTER TABLE dbo.yaf_Attachment
WITH NOCHECK ADD CONSTRAINT PK_yaf_Attachment PRIMARY KEY CLUSTERED( AttachmentID  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Active')
               AND name = 'PK_yaf_Active')
ALTER TABLE dbo.yaf_Active
WITH NOCHECK ADD CONSTRAINT PK_yaf_Active PRIMARY KEY CLUSTERED( SessionID  , BoardID  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_PollVote')
               AND name = 'PK_yaf_PollVote')
ALTER TABLE dbo.yaf_PollVote
WITH NOCHECK ADD CONSTRAINT PK_yaf_PollVote PRIMARY KEY CLUSTERED( PollVoteID  )
GO

/*
** Unique constraints
*/
IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_CheckEmail')
               AND name = 'IX_yaf_CheckEmail')
/*
** Unique constraints
*/
IF NOT EXISTS ( SELECT 1 FROM sysindexes WHERE id = Object_id ( 'yaf_CheckEmail' ) AND name = 'IX_yaf_CheckEmail' ) ALTER TABLE dbo.yaf_CheckEmail ADD CONSTRAINT IX_yaf_CheckEmail UNIQUE NONCLUSTERED ( HASH ) 
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Forum')
               AND name = 'IX_yaf_Forum')
ALTER TABLE dbo.yaf_Forum
 ADD CONSTRAINT IX_yaf_Forum UNIQUE NONCLUSTERED( CategoryID  , Name  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_WatchForum')
               AND name = 'IX_yaf_WatchForum')
ALTER TABLE dbo.yaf_WatchForum
 ADD CONSTRAINT IX_yaf_WatchForum UNIQUE NONCLUSTERED( ForumID  , UserID  )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysindexes
               WHERE  id = Object_id('yaf_WatchTopic')
               AND name = 'IX_yaf_WatchTopic')
ALTER TABLE dbo.yaf_WatchTopic
 ADD CONSTRAINT IX_yaf_WatchTopic UNIQUE NONCLUSTERED( TopicID  , UserID  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Category')
               AND name = 'IX_yaf_Category')
ALTER TABLE dbo.yaf_Category
 ADD CONSTRAINT IX_yaf_Category UNIQUE NONCLUSTERED( BoardID  , Name  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Rank')
               AND name = 'IX_yaf_Rank')
ALTER TABLE dbo.yaf_Rank
 ADD CONSTRAINT IX_yaf_Rank UNIQUE( BoardID  , Name  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_User')
               AND name = 'IX_yaf_User')
ALTER TABLE dbo.yaf_User
 ADD CONSTRAINT IX_yaf_User UNIQUE NONCLUSTERED( BoardID  , Name  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Group')
               AND name = 'IX_yaf_Group')
ALTER TABLE dbo.yaf_Group
 ADD CONSTRAINT IX_yaf_Group UNIQUE NONCLUSTERED( BoardID  , Name  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_BannedIP')
               AND name = 'IX_yaf_BannedIP')
ALTER TABLE dbo.yaf_BannedIP
 ADD CONSTRAINT IX_yaf_BannedIP UNIQUE NONCLUSTERED( BoardID  , Mask  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Smiley')
               AND name = 'IX_yaf_Smiley')
ALTER TABLE dbo.yaf_Smiley
 ADD CONSTRAINT IX_yaf_Smiley UNIQUE NONCLUSTERED( BoardID  , Code  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_BannedIP')
               AND name = 'IX_yaf_BannedIP')
ALTER TABLE dbo.yaf_BannedIP
 ADD CONSTRAINT IX_yaf_BannedIP UNIQUE NONCLUSTERED( BoardID  , Mask  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Category')
               AND name = 'IX_yaf_Category')
ALTER TABLE dbo.yaf_Category
 ADD CONSTRAINT IX_yaf_Category UNIQUE NONCLUSTERED( BoardID  , Name  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_CheckEmail')
               AND name = 'IX_yaf_CheckEmail')
IF NOT EXISTS ( SELECT * FROM sysindexes WHERE id = Object_id ( 'yaf_CheckEmail' ) AND name = 'IX_yaf_CheckEmail' ) ALTER TABLE dbo.yaf_CheckEmail ADD CONSTRAINT IX_yaf_CheckEmail UNIQUE NONCLUSTERED ( HASH ) 
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Forum')
               AND name = 'IX_yaf_Forum')
ALTER TABLE dbo.yaf_Forum
 ADD CONSTRAINT IX_yaf_Forum UNIQUE NONCLUSTERED( CategoryID  , Name  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Group')
               AND name = 'IX_yaf_Group')
ALTER TABLE dbo.yaf_Group
 ADD CONSTRAINT IX_yaf_Group UNIQUE NONCLUSTERED( BoardID  , Name  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Rank')
               AND name = 'IX_yaf_Rank')
ALTER TABLE dbo.yaf_Rank
 ADD CONSTRAINT IX_yaf_Rank UNIQUE NONCLUSTERED( BoardID  , Name  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_Smiley')
               AND name = 'IX_yaf_Smiley')
ALTER TABLE dbo.yaf_Smiley
 ADD CONSTRAINT IX_yaf_Smiley UNIQUE NONCLUSTERED( BoardID  , Code  )
GO

IF NOT EXISTS (SELECT *
               FROM   sysindexes
               WHERE  id = Object_id('yaf_User')
               AND name = 'IX_yaf_User')
ALTER TABLE dbo.yaf_User
 ADD CONSTRAINT IX_yaf_User UNIQUE NONCLUSTERED( BoardID  , Name  )
GO

/*
** Foreign keys
*/
IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Active_yaf_Forum'
               AND parent_obj = Object_id('yaf_Active')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Active
 ADD CONSTRAINT FK_yaf_Active_yaf_Forum FOREIGN KEY( ForumID ) REFERENCES dbo.yaf_Forum( ForumID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Active_yaf_Topic'
               AND parent_obj = Object_id('yaf_Active')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Active
 ADD CONSTRAINT FK_yaf_Active_yaf_Topic FOREIGN KEY( TopicID ) REFERENCES dbo.yaf_Topic( TopicID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Active_yaf_User'
               AND parent_obj = Object_id('yaf_Active')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Active
 ADD CONSTRAINT FK_yaf_Active_yaf_User FOREIGN KEY( UserID ) REFERENCES dbo.yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_CheckEmail_yaf_User'
               AND parent_obj = Object_id('yaf_CheckEmail')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_CheckEmail
 ADD CONSTRAINT FK_yaf_CheckEmail_yaf_User FOREIGN KEY( UserID ) REFERENCES dbo.yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Choice_yaf_Poll'
               AND parent_obj = Object_id('yaf_Choice')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Choice
 ADD CONSTRAINT FK_yaf_Choice_yaf_Poll FOREIGN KEY( PollID ) REFERENCES dbo.yaf_Poll( PollID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Forum_yaf_Category'
               AND parent_obj = Object_id('yaf_Forum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Forum
 ADD CONSTRAINT FK_yaf_Forum_yaf_Category FOREIGN KEY( CategoryID ) REFERENCES dbo.yaf_Category( CategoryID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Forum_yaf_Message'
               AND parent_obj = Object_id('yaf_Forum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Forum
 ADD CONSTRAINT FK_yaf_Forum_yaf_Message FOREIGN KEY( LastMessageID ) REFERENCES dbo.yaf_Message( MessageID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Forum_yaf_Topic'
               AND parent_obj = Object_id('yaf_Forum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Forum
 ADD CONSTRAINT FK_yaf_Forum_yaf_Topic FOREIGN KEY( LastTopicID ) REFERENCES dbo.yaf_Topic( TopicID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Forum_yaf_User'
               AND parent_obj = Object_id('yaf_Forum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Forum
 ADD CONSTRAINT FK_yaf_Forum_yaf_User FOREIGN KEY( LastUserID ) REFERENCES dbo.yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_ForumAccess_yaf_Forum'
               AND parent_obj = Object_id('yaf_ForumAccess')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_ForumAccess
 ADD CONSTRAINT FK_yaf_ForumAccess_yaf_Forum FOREIGN KEY( ForumID ) REFERENCES dbo.yaf_Forum( ForumID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_ForumAccess_yaf_Group'
               AND parent_obj = Object_id('yaf_ForumAccess')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_ForumAccess
 ADD CONSTRAINT FK_yaf_ForumAccess_yaf_Group FOREIGN KEY( GroupID ) REFERENCES dbo.yaf_Group( GroupID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Message_yaf_Topic'
               AND parent_obj = Object_id('yaf_Message')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Message
 ADD CONSTRAINT FK_yaf_Message_yaf_Topic FOREIGN KEY( TopicID ) REFERENCES dbo.yaf_Topic( TopicID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Message_yaf_User'
               AND parent_obj = Object_id('yaf_Message')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Message
 ADD CONSTRAINT FK_yaf_Message_yaf_User FOREIGN KEY( UserID ) REFERENCES dbo.yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_PMessage_yaf_User1'
               AND parent_obj = Object_id('yaf_PMessage')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_PMessage
 ADD CONSTRAINT FK_yaf_PMessage_yaf_User1 FOREIGN KEY( FromUserID ) REFERENCES dbo.yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Topic_yaf_Forum'
               AND parent_obj = Object_id('yaf_Topic')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
 ADD CONSTRAINT FK_yaf_Topic_yaf_Forum FOREIGN KEY( ForumID ) REFERENCES dbo.yaf_Forum( ForumID ) ON DELETE CASCADE
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Topic_yaf_Message'
               AND parent_obj = Object_id('yaf_Topic')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
 ADD CONSTRAINT FK_yaf_Topic_yaf_Message FOREIGN KEY( LastMessageID ) REFERENCES dbo.yaf_Message( MessageID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Topic_yaf_Poll'
               AND parent_obj = Object_id('yaf_Topic')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
 ADD CONSTRAINT FK_yaf_Topic_yaf_Poll FOREIGN KEY( PollID ) REFERENCES dbo.yaf_Poll( PollID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Topic_yaf_Topic'
               AND parent_obj = Object_id('yaf_Topic')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
 ADD CONSTRAINT FK_yaf_Topic_yaf_Topic FOREIGN KEY( TopicMovedID ) REFERENCES dbo.yaf_Topic( TopicID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Topic_yaf_User'
               AND parent_obj = Object_id('yaf_Topic')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
 ADD CONSTRAINT FK_yaf_Topic_yaf_User FOREIGN KEY( UserID ) REFERENCES dbo.yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Topic_yaf_User2'
               AND parent_obj = Object_id('yaf_Topic')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Topic
 ADD CONSTRAINT FK_yaf_Topic_yaf_User2 FOREIGN KEY( LastUserID ) REFERENCES dbo.yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_WatchForum_yaf_Forum'
               AND parent_obj = Object_id('yaf_WatchForum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_WatchForum
 ADD CONSTRAINT FK_yaf_WatchForum_yaf_Forum FOREIGN KEY( ForumID ) REFERENCES dbo.yaf_Forum( ForumID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_WatchForum_yaf_User'
               AND parent_obj = Object_id('yaf_WatchForum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_WatchForum
 ADD CONSTRAINT FK_yaf_WatchForum_yaf_User FOREIGN KEY( UserID ) REFERENCES dbo.yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_WatchTopic_yaf_Topic'
               AND parent_obj = Object_id('yaf_WatchTopic')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_WatchTopic
 ADD CONSTRAINT FK_yaf_WatchTopic_yaf_Topic FOREIGN KEY( TopicID ) REFERENCES dbo.yaf_Topic( TopicID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_WatchTopic_yaf_User'
               AND parent_obj = Object_id('yaf_WatchTopic')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_WatchTopic
 ADD CONSTRAINT FK_yaf_WatchTopic_yaf_User FOREIGN KEY( UserID ) REFERENCES dbo.yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Active_yaf_Forum'
               AND parent_obj = Object_id('yaf_Active')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Attachment
 ADD CONSTRAINT FK_yaf_Active_yaf_Forum FOREIGN KEY( MessageID ) REFERENCES yaf_Message( MessageID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_UserGroup_yaf_User'
               AND parent_obj = Object_id('yaf_UserGroup')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserGroup
 ADD CONSTRAINT FK_yaf_UserGroup_yaf_User FOREIGN KEY( UserID ) REFERENCES yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_UserGroup_yaf_Group'
               AND parent_obj = Object_id('yaf_UserGroup')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserGroup
 ADD CONSTRAINT FK_yaf_UserGroup_yaf_Group FOREIGN KEY( GroupID ) REFERENCES yaf_Group( GroupID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Attachment_yaf_Message'
               AND parent_obj = Object_id('yaf_Attachment')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Attachment
 ADD CONSTRAINT FK_yaf_Attachment_yaf_Message FOREIGN KEY( MessageID ) REFERENCES yaf_Message( MessageID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_NntpForum_yaf_NntpServer'
               AND parent_obj = Object_id('yaf_NntpForum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_NntpForum
 ADD CONSTRAINT FK_yaf_NntpForum_yaf_NntpServer FOREIGN KEY( NntpServerID ) REFERENCES yaf_NntpServer( NntpServerID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_NntpForum_yaf_Forum'
               AND parent_obj = Object_id('yaf_NntpForum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_NntpForum
 ADD CONSTRAINT FK_yaf_NntpForum_yaf_Forum FOREIGN KEY( ForumID ) REFERENCES yaf_Forum( ForumID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_NntpTopic_yaf_NntpForum'
               AND parent_obj = Object_id('yaf_NntpTopic')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_NntpTopic
 ADD CONSTRAINT FK_yaf_NntpTopic_yaf_NntpForum FOREIGN KEY( NntpForumID ) REFERENCES yaf_NntpForum( NntpForumID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_NntpTopic_yaf_Topic'
               AND parent_obj = Object_id('yaf_NntpTopic')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_NntpTopic
 ADD CONSTRAINT FK_yaf_NntpTopic_yaf_Topic FOREIGN KEY( TopicID ) REFERENCES yaf_Topic( TopicID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_ForumAccess_yaf_AccessMask'
               AND parent_obj = Object_id('yaf_ForumAccess')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_ForumAccess
 ADD CONSTRAINT FK_yaf_ForumAccess_yaf_AccessMask FOREIGN KEY( AccessMaskID ) REFERENCES yaf_AccessMask( AccessMaskID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_UserForum_yaf_User'
               AND parent_obj = Object_id('yaf_UserForum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserForum
 ADD CONSTRAINT FK_yaf_UserForum_yaf_User FOREIGN KEY( UserID ) REFERENCES yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_UserForum_yaf_Forum'
               AND parent_obj = Object_id('yaf_UserForum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserForum
 ADD CONSTRAINT FK_yaf_UserForum_yaf_Forum FOREIGN KEY( ForumID ) REFERENCES yaf_Forum( ForumID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_UserForum_yaf_AccessMask'
               AND parent_obj = Object_id('yaf_UserForum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserForum
 ADD CONSTRAINT FK_yaf_UserForum_yaf_AccessMask FOREIGN KEY( AccessMaskID ) REFERENCES yaf_AccessMask( AccessMaskID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Category_yaf_Board'
               AND parent_obj = Object_id('yaf_Category')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Category
 ADD CONSTRAINT FK_yaf_Category_yaf_Board FOREIGN KEY( BoardID ) REFERENCES yaf_Board( BoardID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_AccessMask_yaf_Board'
               AND parent_obj = Object_id('yaf_AccessMask')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_AccessMask
 ADD CONSTRAINT FK_yaf_AccessMask_yaf_Board FOREIGN KEY( BoardID ) REFERENCES yaf_Board( BoardID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Active_yaf_Board'
               AND parent_obj = Object_id('yaf_Active')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Active
 ADD CONSTRAINT FK_yaf_Active_yaf_Board FOREIGN KEY( BoardID ) REFERENCES yaf_Board( BoardID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_BannedIP_yaf_Board'
               AND parent_obj = Object_id('yaf_BannedIP')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_BannedIP
 ADD CONSTRAINT FK_yaf_BannedIP_yaf_Board FOREIGN KEY( BoardID ) REFERENCES yaf_Board( BoardID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Group_yaf_Board'
               AND parent_obj = Object_id('yaf_Group')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Group
 ADD CONSTRAINT FK_yaf_Group_yaf_Board FOREIGN KEY( BoardID ) REFERENCES yaf_Board( BoardID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_NntpServer_yaf_Board'
               AND parent_obj = Object_id('yaf_NntpServer')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_NntpServer
 ADD CONSTRAINT FK_yaf_NntpServer_yaf_Board FOREIGN KEY( BoardID ) REFERENCES yaf_Board( BoardID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Rank_yaf_Board'
               AND parent_obj = Object_id('yaf_Rank')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Rank
 ADD CONSTRAINT FK_yaf_Rank_yaf_Board FOREIGN KEY( BoardID ) REFERENCES yaf_Board( BoardID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Smiley_yaf_Board'
               AND parent_obj = Object_id('yaf_Smiley')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Smiley
 ADD CONSTRAINT FK_yaf_Smiley_yaf_Board FOREIGN KEY( BoardID ) REFERENCES yaf_Board( BoardID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_User_yaf_Rank'
               AND parent_obj = Object_id('yaf_User')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_User
 ADD CONSTRAINT FK_yaf_User_yaf_Rank FOREIGN KEY( RankID ) REFERENCES yaf_Rank( RankID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_User_yaf_Board'
               AND parent_obj = Object_id('yaf_User')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_User
 ADD CONSTRAINT FK_yaf_User_yaf_Board FOREIGN KEY( BoardID ) REFERENCES yaf_Board( BoardID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Forum_yaf_Forum'
               AND parent_obj = Object_id('yaf_Forum')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Forum
 ADD CONSTRAINT FK_yaf_Forum_yaf_Forum FOREIGN KEY( ParentID ) REFERENCES yaf_Forum( ForumID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Message_yaf_Message'
               AND parent_obj = Object_id('yaf_Message')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Message
 ADD CONSTRAINT FK_yaf_Message_yaf_Message FOREIGN KEY( ReplyTo ) REFERENCES yaf_Message( MessageID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_UserPMessage_yaf_User'
               AND parent_obj = Object_id('yaf_UserPMessage')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserPMessage
 ADD CONSTRAINT FK_yaf_UserPMessage_yaf_User FOREIGN KEY( UserID ) REFERENCES yaf_User( UserID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_UserPMessage_yaf_PMessage'
               AND parent_obj = Object_id('yaf_UserPMessage')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_UserPMessage
 ADD CONSTRAINT FK_yaf_UserPMessage_yaf_PMessage FOREIGN KEY( PMessageID ) REFERENCES yaf_PMessage( PMessageID )
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_Registry_yaf_Board'
               AND parent_obj = Object_id('yaf_Registry')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_Registry
 ADD CONSTRAINT FK_yaf_Registry_yaf_Board FOREIGN KEY( BoardID ) REFERENCES yaf_Board( BoardID ) ON DELETE CASCADE
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_PollVote_yaf_Poll'
               AND parent_obj = Object_id('yaf_PollVote')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_PollVote
 ADD CONSTRAINT FK_yaf_PollVote_yaf_Poll FOREIGN KEY( PollID ) REFERENCES yaf_Poll( PollID ) ON DELETE CASCADE
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = 'FK_yaf_EventLog_yaf_User'
               AND parent_obj = Object_id('yaf_EventLog')
               AND Objectproperty(id,N'IsForeignKey') = 1)
ALTER TABLE dbo.yaf_EventLog
 ADD CONSTRAINT FK_yaf_EventLog_yaf_User FOREIGN KEY( UserID ) REFERENCES dbo.yaf_User( UserID ) ON DELETE CASCADE
GO

/* Default Constraints */
IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = N'DF_yaf_Message_Flags'
           AND parent_obj = Object_id(N'yaf_Message'))
ALTER TABLE dbo.yaf_Message
DROP CONSTRAINT DF_yaf_Message_Flags
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = N'DF_yaf_Message_Flags'
               AND parent_obj = Object_id(N'yaf_Message'))
IF NOT EXISTS ( SELECT 1 FROM sysobjects WHERE name = N'DF_yaf_Message_Flags' AND parent_obj = Object_id ( N'yaf_Message' ) ) ALTER TABLE dbo.yaf_Message ADD CONSTRAINT DF_yaf_Message_Flags DEFAULT ( 23 ) FOR Flags 
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = N'DF_EventLog_EventTime'
           AND parent_obj = Object_id(N'yaf_EventLog'))
ALTER TABLE dbo.yaf_EventLog
DROP CONSTRAINT DF_EventLog_EventTime
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = N'DF_yaf_EventLog_EventTime'
               AND parent_obj = Object_id(N'yaf_EventLog'))
IF NOT EXISTS ( SELECT 1 FROM sysobjects WHERE name = N'DF_yaf_EventLog_EventTime' AND parent_obj = Object_id ( N'yaf_EventLog' ) ) ALTER TABLE dbo.yaf_EventLog ADD CONSTRAINT DF_yaf_EventLog_EventTime DEFAULT ( getdate ( ) ) FOR EventTime 
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  name = N'DF_EventLog_Type'
           AND parent_obj = Object_id(N'yaf_EventLog'))
ALTER TABLE dbo.yaf_EventLog
DROP CONSTRAINT DF_EventLog_Type
GO

IF NOT EXISTS (SELECT 1
               FROM   sysobjects
               WHERE  name = N'DF_yaf_EventLog_Type'
               AND parent_obj = Object_id(N'yaf_EventLog'))
IF NOT EXISTS ( SELECT 1 FROM sysobjects WHERE name = N'DF_yaf_EventLog_Type' AND parent_obj = Object_id ( N'yaf_EventLog' ) ) ALTER TABLE dbo.yaf_EventLog ADD CONSTRAINT DF_yaf_EventLog_Type DEFAULT ( 0 ) FOR TYPE 
GO
