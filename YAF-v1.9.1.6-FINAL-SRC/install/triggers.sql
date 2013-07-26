/*
** Triggers
*/
IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  id = Object_id(N'yaf_Active_insert')
           AND Objectproperty(id,N'IsTrigger') = 1)
DROP TRIGGER yaf_Active_insert 
GO

CREATE TRIGGER yaf_Active_insert
ON dbo.yaf_Active
FOR INSERT
AS
    BEGIN
        DECLARE  @BoardID  INT,
                 @count    INT,
                 @countStr NVARCHAR(255),
                 @dtStr    NVARCHAR(255),
                 @max      INT,
                 @maxStr   NVARCHAR(255)
        -- Assumes only one row was inserted - shouldn't be a problem?
        SELECT @BoardID = BoardID
        FROM   inserted
        SELECT @count = COUNT(DISTINCT IP)
        FROM   yaf_Active WITH (nolock)
        WHERE  BoardID = @BoardID
        SELECT @maxStr = CAST(VALUE AS NVARCHAR)
        FROM   yaf_Registry
        WHERE  BoardID = @BoardID
        AND Name = N'maxusers'
        SELECT @max = CAST(@maxStr AS INT)
        SELECT @countStr = CAST(@count AS NVARCHAR)
        SELECT @dtStr = CONVERT(NVARCHAR,Getdate(),126)
        IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO yaf_Registry
                       (BoardID,
                        Name,
                        VALUE)
            VALUES     (@BoardID,
                        N'maxusers',
                        CAST(@countStr AS NTEXT))
            INSERT INTO yaf_Registry
                       (BoardID,
                        Name,
                        VALUE)
            VALUES     (@BoardID,
                        N'maxuserswhen',
                        CAST(@dtStr AS NTEXT))
        END
        ELSE
        IF @count > @max
        BEGIN
            UPDATE yaf_Registry
            SET    VALUE = CAST(@countStr AS NTEXT)
            WHERE  BoardID = @BoardID
            AND Name = N'maxusers'
            UPDATE yaf_Registry
            SET    VALUE = CAST(@dtStr AS NTEXT)
            WHERE  BoardID = @BoardID
            AND Name = N'maxuserswhen'
        END
    END
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  id = Object_id(N'yaf_Forum_update')
           AND Objectproperty(id,N'IsTrigger') = 1)
DROP TRIGGER yaf_Forum_update 
GO

CREATE TRIGGER yaf_Forum_update
ON dbo.yaf_Forum
FOR UPDATE
AS
    BEGIN
        IF UPDATE(LastTopicID) OR UPDATE(LastMessageID)
        BEGIN
            -- recursively update the forum
            DECLARE  @ParentID INT
            SET @ParentID = (SELECT TOP 1 ParentID
                             FROM   inserted)
            WHILE (@ParentID IS NOT NULL)
            BEGIN
                UPDATE a
                SET    a.LastPosted = b.LastPosted,
                       a.LastTopicID = b.LastTopicID,
                       a.LastMessageID = b.LastMessageID,
                       a.LastUserID = b.LastUserID,
                       a.LastUserName = b.LastUserName
                FROM   yaf_Forum a,
                       inserted b
                WHERE  a.ForumID = @ParentID
                AND ((a.LastPosted < b.LastPosted)
                      OR a.LastPosted IS NULL);
                SET @ParentID = (SELECT ParentID
                                 FROM   yaf_Forum
                                 WHERE  ForumID = @ParentID)
            END
        END
    END
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  id = Object_id(N'yaf_Group_update')
           AND Objectproperty(id,N'IsTrigger') = 1)
DROP TRIGGER yaf_Group_update 
GO

CREATE TRIGGER yaf_Group_update
ON dbo.yaf_Group
FOR UPDATE
AS
    BEGIN
        DECLARE  @BoardID INT
        DECLARE  @GroupID INT
        DECLARE  @Flags INT
        DECLARE inserted_cursor CURSOR  FOR
        SELECT BoardID,
               GroupID,
               Flags
        FROM   inserted
        OPEN inserted_cursor
        FETCH NEXT FROM inserted_cursor
        INTO @BoardID,
             @GroupID,
             @Flags
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF (@Flags & 2) <> 0
            BEGIN
                -- This is the guest group. Check for other guest groups
                IF EXISTS (SELECT 1
                           FROM   dbo.yaf_Group
                           WHERE  BoardID = @BoardID
                           AND GroupID <> @GroupID
                           AND (Flags & 2) <> 0)
                BEGIN
                    RAISERROR ('There are already other groups marked as guest groups',16,1)
                END
            END
            ELSE
            BEGIN
                -- This is not the guest group. Check for other guest groups
                IF NOT EXISTS (SELECT 1
                               FROM   dbo.yaf_Group
                               WHERE  BoardID = @BoardID
                               AND (Flags & 2) <> 0)
                BEGIN
                    RAISERROR ('There are no other groups marked as guest groups',16,1)
                END
            END
            FETCH NEXT FROM inserted_cursor
            INTO @BoardID,
                 @GroupID,
                 @Flags
        END
        CLOSE inserted_cursor
        DEALLOCATE inserted_cursor
    END
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  id = Object_id(N'yaf_Group_insert')
           AND Objectproperty(id,N'IsTrigger') = 1)
DROP TRIGGER yaf_Group_insert 
GO

CREATE TRIGGER yaf_Group_insert
ON dbo.yaf_Group
FOR UPDATE
AS
    BEGIN
        DECLARE  @BoardID INT
        DECLARE  @GroupID INT
        DECLARE  @Flags INT
        DECLARE inserted_cursor CURSOR  FOR
        SELECT BoardID,
               GroupID,
               Flags
        FROM   inserted
        OPEN inserted_cursor
        FETCH NEXT FROM inserted_cursor
        INTO @BoardID,
             @GroupID,
             @Flags
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF (@Flags & 2) <> 0
            BEGIN
                -- This is the guest group. Check for other guest groups
                IF EXISTS (SELECT 1
                           FROM   dbo.yaf_Group
                           WHERE  BoardID = @BoardID
                           AND GroupID <> @GroupID
                           AND (Flags & 2) <> 0)
                BEGIN
                    RAISERROR ('There are already other groups marked as guest groups',16,1)
                END
            END
            ELSE
            BEGIN
                -- This is not the guest group. Check for other guest groups
                IF NOT EXISTS (SELECT 1
                               FROM   dbo.yaf_Group
                               WHERE  BoardID = @BoardID
                               AND (Flags & 2) <> 0)
                BEGIN
                    RAISERROR ('There are no other groups marked as guest groups',16,1)
                END
            END
            FETCH NEXT FROM inserted_cursor
            INTO @BoardID,
                 @GroupID,
                 @Flags
        END
        CLOSE inserted_cursor
        DEALLOCATE inserted_cursor
    END
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  id = Object_id(N'yaf_UserGroup_insert')
           AND Objectproperty(id,N'IsTrigger') = 1)
DROP TRIGGER yaf_UserGroup_insert 
GO

CREATE TRIGGER yaf_UserGroup_insert
ON dbo.yaf_UserGroup
FOR INSERT
AS
    BEGIN
        DECLARE  @UserID INT
        DECLARE  @BoardID INT
        DECLARE  @GroupID INT
        DECLARE  @Flags INT
        DECLARE inserted_cursor CURSOR  FOR
        SELECT a.UserID,
               b.BoardID,
               b.GroupID,
               b.Flags
        FROM   inserted a
               JOIN dbo.yaf_Group b
                 ON b.GroupID = a.GroupID
        OPEN inserted_cursor
        FETCH NEXT FROM inserted_cursor
        INTO @UserID,
             @BoardID,
             @GroupID,
             @Flags
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF (@Flags & 2) <> 0
            BEGIN
                -- This is the guest group. Check for guest users
                IF EXISTS (SELECT 1
                           FROM   dbo.yaf_UserGroup
                           WHERE  GroupID = @GroupID
                           AND UserID <> @UserID)
                BEGIN
                    RAISERROR ('There is already a user in the guest group',16,1)
                END
            END
            FETCH NEXT FROM inserted_cursor
            INTO @UserID,
                 @BoardID,
                 @GroupID,
                 @Flags
        END
        CLOSE inserted_cursor
        DEALLOCATE inserted_cursor
    END
GO

IF EXISTS (SELECT 1
           FROM   sysobjects
           WHERE  id = Object_id(N'yaf_UserGroup_delete')
           AND Objectproperty(id,N'IsTrigger') = 1)
DROP TRIGGER yaf_UserGroup_delete 
GO

CREATE TRIGGER yaf_UserGroup_delete
ON dbo.yaf_UserGroup
FOR DELETE
AS
    BEGIN
        DECLARE  @UserID INT
        DECLARE  @BoardID INT
        DECLARE  @GroupID INT
        DECLARE  @Flags INT
        DECLARE deleted_cursor CURSOR  FOR
        SELECT a.UserID,
               b.BoardID,
               b.GroupID,
               b.Flags
        FROM   deleted a
               JOIN dbo.yaf_Group b
                 ON b.GroupID = a.GroupID
        OPEN deleted_cursor
        FETCH NEXT FROM deleted_cursor
        INTO @UserID,
             @BoardID,
             @GroupID,
             @Flags
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF (@Flags & 2) <> 0
            BEGIN
                -- This is the guest group. We can't remove users from the guest group.
                RAISERROR ('Users can not be removed from the guest group',16,1)
            END
            FETCH NEXT FROM deleted_cursor
            INTO @UserID,
                 @BoardID,
                 @GroupID,
                 @Flags
        END
        CLOSE deleted_cursor
        DEALLOCATE deleted_cursor
    END
GO