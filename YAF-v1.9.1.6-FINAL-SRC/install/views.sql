/*
** Views
*/
IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  id = Object_id(N'yaf_vaccess')
           AND Objectproperty(id,N'IsView') = 1)
DROP VIEW yaf_vaccess
GO

CREATE VIEW dbo.yaf_vaccess
AS
  SELECT   UserID = a.UserID,
           ForumID = x.ForumID,
           IsAdmin = MAX(CONVERT(INT,b.Flags & 1)),
           IsGuest = MAX(CONVERT(INT,b.Flags & 2)),
           IsForumModerator = MAX(CONVERT(INT,b.Flags & 8)),
           IsModerator = (SELECT COUNT(1)
                          FROM   dbo.yaf_UserGroup v,
                                 dbo.yaf_Group w,
                                 dbo.yaf_ForumAccess x,
                                 dbo.yaf_AccessMask y
                          WHERE  v.UserID = a.UserID
                          AND w.GroupID = v.GroupID
                          AND x.GroupID = w.GroupID
                          AND y.AccessMaskID = x.AccessMaskID
                          AND (y.Flags & 64) <> 0),
           ReadAccess = MAX(x.ReadAccess),
           PostAccess = MAX(x.PostAccess),
           ReplyAccess = MAX(x.ReplyAccess),
           PriorityAccess = MAX(x.PriorityAccess),
           PollAccess = MAX(x.PollAccess),
           VoteAccess = MAX(x.VoteAccess),
           ModeratorAccess = MAX(x.ModeratorAccess),
           EditAccess = MAX(x.EditAccess),
           DeleteAccess = MAX(x.DeleteAccess),
           UploadAccess = MAX(x.UploadAccess)
  FROM     (SELECT b.UserID,
                   b.ForumID,
                   ReadAccess = CONVERT(INT,c.Flags & 1),
                   PostAccess = CONVERT(INT,c.Flags & 2),
                   ReplyAccess = CONVERT(INT,c.Flags & 4),
                   PriorityAccess = CONVERT(INT,c.Flags & 8),
                   PollAccess = CONVERT(INT,c.Flags & 16),
                   VoteAccess = CONVERT(INT,c.Flags & 32),
                   ModeratorAccess = CONVERT(INT,c.Flags & 64),
                   EditAccess = CONVERT(INT,c.Flags & 128),
                   DeleteAccess = CONVERT(INT,c.Flags & 256),
                   UploadAccess = CONVERT(INT,c.Flags & 512)
            FROM   dbo.yaf_UserForum b
                   JOIN dbo.yaf_AccessMask c
                     ON c.AccessMaskID = b.AccessMaskID
            UNION 
            SELECT b.UserID,
                   c.ForumID,
                   ReadAccess = CONVERT(INT,d.Flags & 1),
                   PostAccess = CONVERT(INT,d.Flags & 2),
                   ReplyAccess = CONVERT(INT,d.Flags & 4),
                   PriorityAccess = CONVERT(INT,d.Flags & 8),
                   PollAccess = CONVERT(INT,d.Flags & 16),
                   VoteAccess = CONVERT(INT,d.Flags & 32),
                   ModeratorAccess = CONVERT(INT,d.Flags & 64),
                   EditAccess = CONVERT(INT,d.Flags & 128),
                   DeleteAccess = CONVERT(INT,d.Flags & 256),
                   UploadAccess = CONVERT(INT,d.Flags & 512)
            FROM   dbo.yaf_UserGroup b
                   JOIN dbo.yaf_ForumAccess c
                     ON c.GroupID = b.GroupID
                   JOIN dbo.yaf_AccessMask d
                     ON d.AccessMaskID = c.AccessMaskID
            UNION 
            SELECT a.UserID,
                   ForumID = CONVERT(INT,0),
                   ReadAccess = CONVERT(INT,0),
                   PostAccess = CONVERT(INT,0),
                   ReplyAccess = CONVERT(INT,0),
                   PriorityAccess = CONVERT(INT,0),
                   PollAccess = CONVERT(INT,0),
                   VoteAccess = CONVERT(INT,0),
                   ModeratorAccess = CONVERT(INT,0),
                   EditAccess = CONVERT(INT,0),
                   DeleteAccess = CONVERT(INT,0),
                   UploadAccess = CONVERT(INT,0)
            FROM   dbo.yaf_User a) AS x
           JOIN dbo.yaf_UserGroup a
             ON a.UserID = x.UserID
           JOIN dbo.yaf_Group b
             ON b.GroupID = a.GroupID
  GROUP BY a.UserID,x.ForumID
GO
