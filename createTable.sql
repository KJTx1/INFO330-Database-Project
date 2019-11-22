-- create database sausage --

USE Proj_B7

CREATE TABLE tblTWEET 
(TweetID INT IDENTITY(1, 1) primary key NOT NULL,
Content varchar(140) NOT NULL,
UserID INT FOREIGN KEY REFERENCES tblUSER(UserID) NOT NULL,
EventID INT FOREIGN KEY REFERENCES tblTWEET_EVENT(EventID) NOT NULL,
TopicTypeID INT FOREIGN KEY REFERENCES tblTopicType(TopicTypeID) NOT NULL,
Date_Time DATE DEFAULT GetDate() NOT NULL,
LocationID INT FOREIGN KEY REFERENCES tblLOCATION(LocationID) NOT NULL
)

CREATE TABLE tblUSER
(UserID INT IDENTITY(1,1) primary key NOT NULL, 
DisplayName VARCHAR(20) NOT NULL,
Bio VARCHAR(140),
Banner VARCHAR(100),
Icon VARCHAR(100) NOT NULL,
DateJoined DATE DEFAULT GetDate() NOT NULL
)

-- UserID1 is performing the event in relation to UserID2 -- 
-- For example, UserID1 can follow, block and unfollow UserID2 -- 
CREATE TABLE tblUSER_EVENT
(UserEventID INT IDENTITY(1,1) primary key NOT NULL,
UserEventTypeID INT FOREIGN KEY REFERENCES tblUSER_EVENT_TYPE(UserEventTypeID) NOT NULL,
UserID1 INT FOREIGN KEY REFERENCES tblUSER(UserID) NOT NULL,
UserID2 INT FOREIGN KEY REFERENCES tblUSER(UserID) NOT NULL,
Date_Time DATE DEFAULT GetDate() NOT NULL
)

CREATE TABLE tblUSER_EVENT_TYPE
(UserEventTypeID INT IDENTITY(1,1) primary key NOT NULL,
UserEventTypeName VARCHAR(20) NOT NULL,
UserEventTypeDescr VARCHAR(100)
)

CREATE TABLE tblTWEET_EVENT
(EventID INT IDENTITY(1,1) primary key NOT NULL,
EventName VARCHAR(20) NOT NULL,
EventDescr VARCHAR(100)
)

CREATE TABLE tblLOCATION
(LocationID INT IDENTITY(1,1) primary key NOT NULL,
LocationName VARCHAR(100)
)

CREATE TABLE tblTWEET_HASHTAG
(HashtagID INT FOREIGN KEY REFERENCES tblHASHTAG(HashtagID) NOT NULL,
TweetID INT FOREIGN KEY REFERENCES tblTWEET(TweetID) NOT NULL
)

CREATE TABLE tblHASHTAG
(HashtagID INT IDENTITY(1,1) primary key NOT NULL,
HashtagName VARCHAR(140) NOT NULL
)

CREATE TABLE tblTopicType
(TopicTypeID INT IDENTITY(1,1) primary key NOT NULL,
TopicTypeName VARCHAR(50)
)

CREATE TABLE tblATTACHMENT 
(AttachmentID INT IDENTITY(1,1) primary key NOT NULL,
AttachmentTypeID INT FOREIGN KEY REFERENCES tblATTACHMENT_TYPE(AttachmentTypeID) NOT NULL,
TweetID INT FOREIGN KEY REFERENCES tblTWEET(TweetID) NOT NULL,
Link VARCHAR(200) NOT NULL
)

CREATE TABLE tblATTACHMENT_TYPE
(AttachmentTypeID INT IDENTITY(1,1) primary key NOT NULL,
AttachmentTypeName VARCHAR(20) NOT NULL
)

INSERT INTO tblTopicType(TopicTypeName) VALUES ('Entertainment'), ('News'), ('Sports'), ('Fun')

INSERT INTO tblATTACHMENT_TYPE(AttachmentTypeName) VALUES ('Video'), ('Image'), ('GIF')

INSERT INTO tblTWEET_EVENT(EventName, EventDescr) VALUES 
('Mention', 'A Tweet that contains another person’s username anywhere in the body of the Tweet'),
('Reply', 'A response to another person’s Tweet.'),
('Retweet', 'A Tweet that you share publicly with your followers')

INSERT INTO tblUSER_EVENT_TYPE(UserEventTypeName, UserEventTypeDescr) VALUES 
('Follow', 'The user are subscribing to their Tweets as a follower, their updates will appear in your Home timeline, that person is able to send you Direct Messages'),
('Block', 'Blocking helps people in restricting specific accounts from contacting them, seeing their Tweets, and following them.'),
('Unfollow', 'People unfollow other accounts when they no longer wish to see its Tweets in its home timeline.')

INSERT INTO tblLOCATION(LocationName) VALUES 
('Alabama'), ('Alaska'), ('Arizona'), ('Arkansas'), ('California'), ('Colorado'), ('Connecticut'),
('Delaware'), ('Florida'), ('Georgia'), ('Hawaii'), ('Idaho'), ('Illinois'), ('Indiana'), ('Iowa'),
('Kansas'), ('Kentucky'), ('Louisiana'), ('Maine'), ('Maryland'), ('Massachusetts'), ('Michigan'), 
('Minnesota'), ('Mississippi'), ('Missouri'), ('Montana'), ('Nebraska'), ('Nevada'), ('New Hampshire'), 
('New Jersey'), ('New Mexico'), ('New York'), ('North Carolina'), ('North Dakota'), ('Ohio'), ('Oklahoma'), 
('Oregon'), ('Pennsylvania'), ('Rhode Island'), ('South Carolina'), ('South Dakota'), ('Tennessee'), ('Texas'), 
('Utah'), ('Vermont'), ('Virginia'), ('Washington'), ('West Virginia'), ('Wisconsin'), ('Wyoming')

INSERT INTO tblUSER(DisplayName) VALUES ('Jchang'), ('JAsonY'), ('ChrisC'), ('Gthay'), ('KennytheCat')

GO

-- INSERT INTO tblTWEET(Content, UserID, EventID, TopicTypeID, LocationID) VALUES 

CREATE PROCEDURE populate_tweets
    @Content VARCHAR(140),
    @DisplayName varchar(20),
    @EventName VARCHAR(20),
    @TopicTypeName varchar(50),
    @LocationName VARCHAR(100)
    AS
    DECLARE @UserID INT, @EventID INT , @TopicTypeID INT, @LocationID INT
    SET @UserID = (SELECT UserID FROM tblUSER WHERE DisplayName = @DisplayName)
    SET @EventID = (SELECT EventID FROM tblTWEET_EVENT WHERE EventName = @EventName)
    SET @TopicTypeID = (SELECT TopicTypeID FROM tblTopicType WHERE TopicTypeName = @TopicTypeName)
    SET @LocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)

    BEGIN TRANSACTION T1
        INSERT INTO tblTWEET(Content, UserID, EventID, TopicTypeID, LocationID)
        VALUES(@Content, @UserID, @EventID, @TopicTypeID, @LocationID)
    COMMIT TRANSACTION T1
GO

EXEC populate_tweets
@displayname = 'ChrisC',
@content = 'BTS is legend',
@eventname = 'tweet',
@TopicTypeName = 'Entertaiment',
@locationname = 'California'

EXEC populate_tweets
@displayname = 'Jchang',
@content = 'Greg holds the key to a vault of Cliff Bars.',
@eventname = 'tweet',
@TopicTypeName = 'Entertaiment',
@locationname = 'Washington'

EXEC populate_tweets
@displayname = 'KennytheCat',
@content ='Kenny the Cat wants to become a youtube vlogger. Kenny first got 37 subscribers from INFO 330 B section.',
@eventname = 'tweet',
@TopicTypeName = 'News',
@locationname = 'Illinois'

EXEC populate_tweets
@displayname = 'Gthay',
@content ='Kenny the Cat wants to become a youtube vlogger. Kenny first got 37 subscribers from INFO 330 B section',
@eventname = 'retweet',
@TopicTypeName = 'Entertaiment',
@locationname = 'Oregon'


EXEC populate_tweets
@displayname = 'JasonY',
@content ='Greg feeds cats, raises plants, and does ASMR in Zoom meetings.',
@eventname = 'tweet',
@TopicTypeName = 'Fun',
@locationname = 'New York'

GO

CREATE PROCEDURE populate_user
@DisplayName varchar(20),
@Description VARCHAR(140),
@Banner varchar(100),
@Icon VARCHAR(100)
AS
    BEGIN TRANSACTION T1
        INSERT INTO tblUSER(DisplayName, Bio, Banner, Icon)
        VALUES(@DisplayName, @Description, @Banner, @Icon)
    COMMIT TRANSACTION T1
GO

EXEC populate_user
@Displayname = 'JasonY',
@Description = 'an assiduous 330 student',
@Banner = 'https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/20992707_1883478058645945_5708501379096891682_n.jpg?_nc_cat=103&_nc_oc=AQm9pfr0Wr9oHiWJwlyY_k7gZV6FkPEg9Amv_B2xAImoIKPm-u9L6B1kD3XIl6iiokQ&_nc_ht=scontent-sea1-1.xx&oh=c0728af458279531fc73c9f25872b617&oe=5E467663',
@Icon = 'https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/70987434_2397297587263987_1417482354645008384_n.jpg?_nc_cat=100&_nc_oc=AQk4-SWkGbom7InDKEQQH73mya3LbMf-teSUlgXWkqF5bybksrTRUG6jM4bckpGgp_I&_nc_ht=scontent-sea1-1.xx&oh=4e8e8dd9327a24401d0b6d3b821df7ff&oe=5E452BB0'

EXEC populate_user
@Displayname = 'KennytheCat',
@Description = 'THE CAT',
@Banner = 'https://vignette.wikia.nocookie.net/spongebob/images/9/90/Kenny_the_Cat_title_card.png/revision/latest/scale-to-width-down/700?cb=20180726154623',
@Icon = 'https://pbs.twimg.com/media/C9QDnbcUIAAYmC4.jpg'

EXEC populate_user
@Displayname = 'ChrisC',
@Description = 'Just for BTS.',
@Banner = 'https://twitter.com/Cookiewrestler1/photo',
@Icon = 'https://twitter.com/Cookiewrestler1/header_photo'

EXEC populate_user
@Displayname = 'Jchang',
@Description = 'The Best 330 project leader:)',
@Banner = 'https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/70185163_110747073648549_347894313776054272_o.jpg?_nc_cat=102&_nc_oc=AQl3rzFMCLkqmtXNyTiDspYfhcCX65A6cUGN9yDOrw_6UB50q5Nw-b1ghmck0j6xEuw&_nc_ht=scontent-sea1-1.xx&oh=fc45ef26e9db2f1480f8d0f57a73c570&oe=5E517033',
@Icon = 'https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/73528726_157345612322028_3611512238269005824_n.jpg?_nc_cat=111&_nc_oc=AQmGA5JXstUw4111d8NZjWf7G40tEEFHhQAvuX-iyv5aKONIpJLZqx_ZoqdvGGx6qR8&_nc_ht=scontent-sea1-1.xx&oh=cb6a45227718248e5fa697dd084fc7da&oe=5E4E843C'

EXEC populate_user
@Displayname = 'Gthay',
@Description = 'Database, Cat, and Cliff Bar',
@Banner = 'https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/70987434_2397297587263987_1417482354645008384_n.jpg?_nc_cat=100&_nc_oc=AQk4-SWkGbom7InDKEQQH73mya3LbMf-teSUlgXWkqF5bybksrTRUG6jM4bckpGgp_I&_nc_ht=scontent-sea1-1.xx&oh=4e8e8dd9327a24401d0b6d3b821df7ff&oe=5E452BB0',
@Icon = 'https://assets.ischool.uw.edu/ai/gthay/pci/gthay-200x-1.jpg'

GO 

CREATE PROCEDURE populate_userevent
@usereventtypename VARCHAR(20),
@user1name VARCHAR(20),
@user2name VARCHAR(20)

AS
DECLARE @UserID1 INT, @UserID2 INT, @usereventtype INT
SET @UserID1 = (SELECT UserID FROM tblUSER WHERE DisplayName = @user1name)
SET @UserID1 = (SELECT UserID FROM tblUSER WHERE DisplayName = @user2name)
SET @UserEventTypeID = (SELECT EventID FROM tblTWEET_EVENT WHERE EventName = @eventname)

BEGIN TRANSACTION T1
    INSERT INTO tblUSER_EVENT(UserEventTypeID, User1ID, User2ID)
    VALUES(@UserEventTypeID, @user1name, @user2name)
COMMIT TRANSACTION T1

EXEC populate_userevent
@usereventtypename = 'Follow',
@user1name = 'Gthay',
@user2name = 'KennytheCat'

EXEC populate_userevent
@usereventtypename = 'Follow',
@user1name = 'JAsonY',
@user2name = 'Gthay'

EXEC populate_userevent
@usereventtypename = 'Follow',
@user1name = 'ChrisC',
@user2name = 'Gthay'

EXEC populate_userevent
@usereventtypename = 'Follow',
@user1name = 'Jchang',
@user2name = 'KennytheCat'


EXEC populate_userevent
@usereventtypename = 'Follow',
@user1name = 'ChrisC',
@user2name = 'KennytheCat'

GO


CREATE PROCEDURE populate_attachment
@AttachmentTypeName VARCHAR(20),
@Text VARCHAR(140),
@User1Name VARCHAR(20),
@EventName VARCHAR(20),
@TopicName VARCHAR(50),
@LocationName VARCHAR(100),
@AttachmentLink VARCHAR(200)
AS
DECLARE @AttachmentTypeID INT, @TweetID INT, @UserID INT, @LocationID INT, @EventID INT, @TopicID INT
SET @AttachmentTypeID = (SELECT AttachmentTypeID FROM tblATTACHMENT_TYPE WHERE AttachmentTypeName = @AttachmentTypeName)
SET @UserID = (SELECT UserID FROM tblUSER WHERE DisplayName = @User1Name)
SET @EventID = (SELECT EventID FROM tblTWEET_EVENT WHERE EventName = @EventName)
SET @TopicID = (SELECT TopicID FROM tblTOPIC_TYPE WHERE TopicTypeName = @TopicName)
SET @LocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)
SET @TweetID = (SELECT TweetID FROM tblTWEET WHERE Text = @text AND UserID = @UserID 
                AND LocationID = @LocationID AND TopicID = @TopicID AND EventID = @EventID)

BEGIN TRANSACTION T1
    INSERT INTO tblATTACHMENT(AttachmentTypeID, TweetID, AttachmentLink)
    VALUES(@AttachmentTypeID, @TweetID, @attachmentlink)
COMMIT TRANSACTION T1

GO

CREATE PROCEDURE populate_hashtag
@HashtagName VARCHAR(140)
AS
BEGIN TRANSACTION T1
    INSERT INTO tblHASHTAG(HashtagName)
    VALUES(@HashtagName)
COMMIT TRANSACTION T1

GO

CREATE PROCEDURE populate_tweetHashtag
@HashtagName VARCHAR(140),
@Text VARCHAR(140),
@UserName VARCHAR(20),
@EventName VARCHAR(20),
@TopicName VARCHAR(50),
@LocationName VARCHAR(100),
@Date_Time DATE
AS
DECLARE @TweetID INT, @HashtagID INT, @UserID INT, @EventID INT, @TopicID INT, @LocationID INT
SET @HashtagID = (SELECT HashtagID FROM tblHASHTAG WHERE HashtagName = @HashtagName)
SET @UserID = (SELECT UserID FROM tblUSER WHERE DisplayName = @UserName)
SET @EventID = (SELECT EventID FROM tblTWEET_EVENT WHERE EventName = @EventName)
SET @TopicID = (SELECT TopicID FROM tblTOPIC_TYPE WHERE TopicTypeName = @TopicName)
SET @LocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)
SET @TweetID = (SELECT TweetID FROM tblTWEET WHERE Text = @Text AND UserID = @UserID 
                AND LocationID = @LocationID AND TopicID = @TopicID AND EventID = @EventID)

BEGIN TRANSACTION T1
    INSERT INTO tblTWEET_HASHTAG(HashtagID, TweetID)
    VALUES(@HashtagID, @TweetID)
COMMIT TRANSACTION T1

GO

CREATE PROCEDURE populate_topic
@TopicTypeName VARCHAR(100)
AS
    BEGIN TRANSACTION T1
        INSERT INTO tblTOPIC_TYPE(TopicTypeName)
        VALUES(@TopicTypeName)
    COMMIT TRANSACTION T1
GO

CREATE FUNCTION FN_TweetTopic(@PK INT)
RETURNS INT 
AS 
BEGIN 
    DECLARE @RET INT 
<<<<<<< HEAD
    SET @RET = (SELECT COUNT(T.TweetID) AS NumOfTweets
=======
    SET @RET = (SELECT COUNT(T.TweetID) AS NumOfTweetsTopic
>>>>>>> 420100af127da8c84d61ebe46fe51298e8b5464c
                FROM tblTWEET T
                WHERE T.TopicTypeID = @PK)
    RETURN @RET
END
GO 

ALTER TABLE tblTOPIC_TYPE
ADD NumOfTweets AS (dbo.FN_TweetTopic(TopicTypeID))
GO

CREATE FUNCTION FN_TweetLocation(@PK INT)
RETURNS INT 
AS
BEGIN 
    DECLARE @RET INT 
    SET @RET = (SELECT COUNT(T.TweetID) AS NumOfTweetsLocation
                FROM tblTWEET T 
                WHERE T.LocationID = @PK)
    RETURN @RET
END
GO

ALTER TABLE tblLOCATION 
ADD NumOfTweets AS (dbo.FN_TweetLocation(LocationID))
GO

CREATE FUNCTION FN_TweetHashtag(@PK INT)
RETURNS INT 
AS
BEGIN 
    DECLARE @RET INT 
    SET @RET = (SELECT COUNT(T.TweetID) AS NumOfTweetsHashtag
                FROM tblTWEET T
                JOIN tblTWEET_HASHTAG TH ON T.TweetID = TH.TweetID 
                WHERE TH.HashtagID = @PK)
    RETURN @RET
END
GO

ALTER TABLE tblHASHTAG 
ADD NumOfTweets AS (dbo.FN_TweetHashtag(HashtagaID))
GO

<<<<<<< HEAD
-- Business rule: A tweet can only contain one hashtag -- 
-- This is so we can more accurately track which hashtag is affecting engagements. -- 
-- If there were multiple hashtags per tweet, it would be ambiguous as to which hashtag --
-- is affecting the level of engagement. --
CREATE FUNCTION FN_1HashtagPerTweet()
RETURNS INT 
AS 
BEGIN 
    DECLARE @PK INT 
    IF EXISTS(SELECT T.TweetID FROM tblTWEET T 
            JOIN tblTWEET_HASHTAG TH ON T.TweetID = TH.TweetID
            WHERE COUNT(TH.TweetID) = 1)
    BEGIN 
        SET @RET = 1
    END 
RETURN @RET
END
GO

ALTER TABLE tblTWEET 
ADD CONSTRAINT CK_1HashtagPerTweet
CHECK(dbo.FN_1HashtagPerTweet() = 1)

-- Business rule: A user cannot follow the same person twice -- 


-- Business rule: A user cannot unfollow a user they do not already follow --



-- Business rule: No repeating Display_Name in tblTWEET --


-- Cannot perform TWEET_EVENT 'Like' Twice --

-- Business rule: 1 Attachment can be added per TWEET -- 

=======
CREATE FUNCTION FN_FollowerPerUser(@PK INT)
RETURNS INT 
AS
BEGIN 
    DECLARE @RET INT 
    SET @RET = (SELECT COUNT(*) AS NumOfFollowers
                FROM tblUSER U
                JOIN tblUSER_EVENT UE ON U.UserID = UE.User2ID
                JOIN tblUSER_EVENT_TYPE UET ON UE.UserEventTypeID = UET.UserEventTypeID
                WHERE UserID = @PK AND UserEventTypeName = 'Follow')
    RETURN @RET
END
GO

ALTER TABLE tblUSER 
ADD NumOfFollowers AS (dbo.FN_FollowerPerUser(UserID))
GO

CREATE FUNCTION FN_FollowingPerUser(@PK INT)
RETURNS INT 
AS
BEGIN 
    DECLARE @RET INT 
    SET @RET = (SELECT COUNT(*) AS NumOfFollowering
                FROM tblUSER U
                JOIN tblUSER_EVENT UE ON U.UserID = UE.User1ID
                JOIN tblUSER_EVENT_TYPE UET ON UE.UserEventTypeID = UET.UserEventTypeID
                WHERE UserID = @PK AND UserEventTypeName = 'Follow')
    RETURN @RET
END
GO

ALTER TABLE tblUSER 
ADD NumOfFollowering AS (dbo.FN_FollowingPerUser(UserID))
GO

CREATE FUNCTION FN_TweetEventNum(@PK INT)
RETURNS INT 
AS
BEGIN 
    DECLARE @RET INT 
    SET @RET = (SELECT COUNT(T.TweetID) AS NumOfTweetEvents
                FROM tblTWEET T
                JOIN tblTWEET_EVENT TE ON T.EventID = TE.EventID 
                WHERE T.TweetID = @PK)
    RETURN @RET
END
GO

ALTER TABLE tblTWEET 
ADD NumOfTweetEvents AS (dbo.FN_TweetEventNum(TweetID))
GO
>>>>>>> 420100af127da8c84d61ebe46fe51298e8b5464c
