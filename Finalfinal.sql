CREATE DATABASE Proj_B7
GO

USE Proj_B7
GO
--------------------- Create Tables ----------------------

CREATE TABLE tblHASHTAG
(HashtagID INT IDENTITY(1,1) primary key NOT NULL,
HashtagName VARCHAR(140) NOT NULL
)

CREATE TABLE tblTOPIC
(TopicID INT IDENTITY(1,1) primary key NOT NULL,
TopicName VARCHAR(50)
)

CREATE TABLE tblLOCATION
(LocationID INT IDENTITY(1,1) primary key NOT NULL,
LocationName VARCHAR(100)
)

CREATE TABLE tblUSER
(UserID INT IDENTITY(1,1) primary key NOT NULL, 
DisplayName VARCHAR(20) NOT NULL,
Bio VARCHAR(140),
Banner VARCHAR(100),
Icon VARCHAR(100) NOT NULL,
DateJoined DATE NOT NULL
)

CREATE TABLE tblTWEET 
(TweetID INT IDENTITY(1, 1) primary key NOT NULL,
Content varchar(140) NOT NULL,
TopicID INT FOREIGN KEY REFERENCES tblTOPIC(TopicID) NOT NULL,
Date_Time DATETIME NOT NULL,
LocationID INT FOREIGN KEY REFERENCES tblLOCATION(LocationID) NOT NULL
)

CREATE TABLE tblTWEET_USER_EVENT_TYPE
(EventTypeID INT IDENTITY(1,1) primary key NOT NULL,
EventTypeName VARCHAR(50),
EventTypeDescr VARCHAR(100))

CREATE TABLE tblTWEET_USER_EVENT
(TweetID INT FOREIGN KEY REFERENCES tblTWEET(TweetID) NOT NULL,
UserID INT FOREIGN KEY REFERENCES tblUSER(UserID) NOT NULL,
EventTypeID INT FOREIGN KEY REFERENCES tblTWEET_USER_EVENT_TYPE(EventTypeID) NOT NULL)

CREATE TABLE tblUSER_EVENT_TYPE
(UserEventTypeID INT IDENTITY(1,1) primary key NOT NULL,
UserEventTypeName VARCHAR(20) NOT NULL,
UserEventTypeDescr VARCHAR(100)
)

-- UserID1 is performing the event in relation to UserID2 -- 
-- For example, UserID1 can follow, block and unfollow UserID2 -- 
CREATE TABLE tblUSER_EVENT
(UserEventID INT IDENTITY(1,1) primary key NOT NULL,
UserEventTypeID INT FOREIGN KEY REFERENCES tblUSER_EVENT_TYPE(UserEventTypeID) NOT NULL,
UserID1 INT FOREIGN KEY REFERENCES tblUSER(UserID) NOT NULL,
UserID2 INT FOREIGN KEY REFERENCES tblUSER(UserID) NOT NULL,
Date_Time DATETIME NOT NULL
)

CREATE TABLE tblTWEET_HASHTAG
(HashtagID INT FOREIGN KEY REFERENCES tblHASHTAG(HashtagID) NOT NULL,
TweetID INT FOREIGN KEY REFERENCES tblTWEET(TweetID) NOT NULL
)

CREATE TABLE tblATTACHMENT_TYPE
(AttachmentTypeID INT IDENTITY(1,1) primary key NOT NULL,
AttachmentTypeName VARCHAR(20) NOT NULL)

CREATE TABLE tblATTACHMENT 
(AttachmentID INT IDENTITY(1,1) primary key NOT NULL,
AttachmentTypeID INT FOREIGN KEY REFERENCES tblATTACHMENT_TYPE(AttachmentTypeID) NOT NULL,
TweetID INT FOREIGN KEY REFERENCES tblTWEET(TweetID) NOT NULL,
Link VARCHAR(200) NOT NULL
)

INSERT INTO tblTopic(TopicName) VALUES ('Entertainment'), ('News'), ('Sports'), ('Fun'), 
('Random'), ('BTS MV'), ('Cat domain'), ('SeattleAurora'), ('CongratsJack'), ('ThrowbackThursday')
GO

INSERT INTO tblATTACHMENT_TYPE(AttachmentTypeName) VALUES ('Video'), ('Image'), ('GIF')
GO

INSERT INTO tblUSER_EVENT_TYPE(UserEventTypeName, UserEventTypeDescr) VALUES 
('Follow', 'The user are subscribing to their Tweets as a follower.'),
('Block', 'Blocking helps people in restricting specific accounts from contacting them.'),
('Unfollow', 'People unfollow other accounts when they no longer wish to see its Tweets in its home timeline.'),
('Unblock', 'When you unblock someone, they will be able to see all of their activties.')
GO

INSERT INTO tblTWEET_USER_EVENT_TYPE(EventTypeName, EventTypeDescr) VALUES 
('Tweet', 'The user creates a post on Twitter.'),
('Retweet', 'A Tweet that you share publicly with your followers.'),
('Reply', 'A response to another person’s Tweet.'),
('Mentioned', 'A user got mentioned in another users Tweet.'),
('Like', 'A user likes a Tweet.')
GO

INSERT INTO tblLOCATION(LocationName) VALUES 
('Alabama'), ('Alaska'), ('Arizona'), ('Arkansas'), ('California'), ('Colorado'), ('Connecticut'),
('Delaware'), ('Florida'), ('Georgia'), ('Hawaii'), ('Idaho'), ('Illinois'), ('Indiana'), ('Iowa'),
('Kansas'), ('Kentucky'), ('Louisiana'), ('Maine'), ('Maryland'), ('Massachusetts'), ('Michigan'), 
('Minnesota'), ('Mississippi'), ('Missouri'), ('Montana'), ('Nebraska'), ('Nevada'), ('New Hampshire'), 
('New Jersey'), ('New Mexico'), ('New York'), ('North Carolina'), ('North Dakota'), ('Ohio'), ('Oklahoma'), 
('Oregon'), ('Pennsylvania'), ('Rhode Island'), ('South Carolina'), ('South Dakota'), ('Tennessee'), ('Texas'), 
('Utah'), ('Vermont'), ('Virginia'), ('Washington'), ('West Virginia'), ('Wisconsin'), ('Wyoming')
GO

INSERT INTO tblHASHTAG(HashtagName) VALUES
('Crowdfunding'), ('Cryptocurrency'), ('Medicaid'), ('Giveaway'), ('tbt')
GO

--------------------- Populate Tables ----------------------

CREATE PROCEDURE populate_tweets
    @Content VARCHAR(140),
    @TopicName varchar(50),
    @Date_Time DATETIME,
    @LocationName VARCHAR(100)
    AS
    DECLARE @TopicID INT, @LocationID INT
    SET @TopicID = (SELECT TopicID FROM tblTOPIC WHERE TopicName = @TopicName)
    SET @LocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)
    BEGIN TRANSACTION T1
        INSERT INTO tblTWEET(Content, TopicID, Date_Time, LocationID)
        VALUES(@Content, @TopicID, @Date_Time, @LocationID)
    COMMIT TRANSACTION T1
GO


EXEC populate_tweets
@Content = 'BTS is legend',
@TopicName = 'Entertainment',
@Date_Time = '2018-06-30 23:23:16',
@LocationName = 'California'
GO

EXEC populate_tweets
@Content = 'Greg holds the key to a vault of Cliff Bars.',
@TopicName = 'Sports',
@Date_Time = '2019-11-20 15:10:04',
@LocationName = 'Washington'
GO

EXEC populate_tweets
@Content = 'Kenny the Cat wants to become a youtube vlogger. Kenny first got 37 subscribers from INFO 330 B section.',
@TopicName = 'News',
@Date_Time = '2019-10-03 09:25:20',
@LocationName = 'Illinois'
GO

EXEC populate_tweets
@Content = 'When I do ERD, I got my sway on.',
@TopicName = 'Random',
@Date_Time = '2018-04-07 13:39:40',
@LocationName = 'Oregon'
GO

EXEC populate_tweets
@Content = 'Greg feeds cats, raises plants, and does ASMR in Zoom meetings.',
@TopicName = 'Fun',
@Date_Time = '2019-11-20 15:10:30',
@LocationName = 'New York'
GO

CREATE PROCEDURE populate_user
@DisplayName varchar(20),
@Bio VARCHAR(140),
@Banner varchar(100),
@Icon VARCHAR(100),
@DateJoined DATETIME
AS
    BEGIN TRANSACTION T1
        INSERT INTO tblUSER(DisplayName, Bio, Banner, Icon, DateJoined)
        VALUES(@DisplayName, @Bio, @Banner, @Icon, @DateJoined)
    COMMIT TRANSACTION T1
GO

EXEC populate_user
@Displayname = 'JasonY',
@Bio = 'an assiduous 330 student',
@Banner = 'https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/20992707_1883478058645945_5708501379096891682_n.jpg?_nc_cat=103&_nc_oc=AQm9pfr0Wr9oHiWJwlyY_k7gZV6FkPEg9Amv_B2xAImoIKPm-u9L6B1kD3XIl6iiokQ&_nc_ht=scontent-sea1-1.xx&oh=c0728af458279531fc73c9f25872b617&oe=5E467663',
@Icon = 'https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/70987434_2397297587263987_1417482354645008384_n.jpg?_nc_cat=100&_nc_oc=AQk4-SWkGbom7InDKEQQH73mya3LbMf-teSUlgXWkqF5bybksrTRUG6jM4bckpGgp_I&_nc_ht=scontent-sea1-1.xx&oh=4e8e8dd9327a24401d0b6d3b821df7ff&oe=5E452BB0',
@DateJoined = 'January 1, 1999'
GO

EXEC populate_user
@Displayname = 'KennytheCat',
@Bio = 'THE CAT',
@Banner = 'https://vignette.wikia.nocookie.net/spongebob/images/9/90/Kenny_the_Cat_title_card.png/revision/latest/scale-to-width-down/700?cb=20180726154623',
@Icon = 'https://pbs.twimg.com/media/C9QDnbcUIAAYmC4.jpg',
@DateJoined = 'August 5, 2005'
GO

EXEC populate_user
@Displayname = 'ChrisC',
@Bio = 'Just for BTS.',
@Banner = 'https://twitter.com/Cookiewrestler1/photo',
@Icon = 'https://twitter.com/Cookiewrestler1/header_photo',
@DateJoined = 'October 7, 2008'
GO

EXEC populate_user
@Displayname = 'Jchang',
@Bio = 'The Best 330 project leader:)',
@Banner = 'https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/70185163_110747073648549_347894313776054272_o.jpg?_nc_cat=102&_nc_oc=AQl3rzFMCLkqmtXNyTiDspYfhcCX65A6cUGN9yDOrw_6UB50q5Nw-b1ghmck0j6xEuw&_nc_ht=scontent-sea1-1.xx&oh=fc45ef26e9db2f1480f8d0f57a73c570&oe=5E517033',
@Icon = 'https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/73528726_157345612322028_3611512238269005824_n.jpg?_nc_cat=111&_nc_oc=AQmGA5JXstUw4111d8NZjWf7G40tEEFHhQAvuX-iyv5aKONIpJLZqx_ZoqdvGGx6qR8&_nc_ht=scontent-sea1-1.xx&oh=cb6a45227718248e5fa697dd084fc7da&oe=5E4E843C',
@DateJoined = 'July 25, 2010'
GO

EXEC populate_user
@Displayname = 'Gthay',
@Bio = 'Database, Cat, and Cliff Bar',
@Banner = 'https://s3.amazonaws.com/secretsaucefiles/photos/images/000/101/826/large/clif-bar-feature.jpeg?1485304492',
@Icon = 'https://assets.ischool.uw.edu/ai/gthay/pci/gthay-200x-1.jpg',
@DateJoined = 'March 17, 2009'
GO 

CREATE PROCEDURE populate_attachment
@AttachmentTypeName VARCHAR(20),
@Text VARCHAR(140),
@TopicName VARCHAR(50),
@LocationName VARCHAR(100),
@AttachmentLink VARCHAR(200),
@Date_Time DATETIME
AS
DECLARE @AttachmentTypeID INT, @TweetID INT, @UserID INT, @LocationID INT, @TopicID INT
SET @AttachmentTypeID = (SELECT AttachmentTypeID FROM tblATTACHMENT_TYPE WHERE AttachmentTypeName = @AttachmentTypeName)
SET @TopicID = (SELECT TopicID FROM tblTOPIC WHERE TopicName = @TopicName)
SET @LocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)
SET @TweetID = (SELECT TweetID FROM tblTWEET WHERE Content = @Text 
                AND LocationID = @LocationID AND TopicID = @TopicID AND Date_Time = @Date_Time)
BEGIN TRANSACTION T1
    INSERT INTO tblATTACHMENT(AttachmentTypeID, TweetID, Link)
    VALUES(@AttachmentTypeID, @TweetID, @attachmentlink)
COMMIT TRANSACTION T1
GO

EXEC populate_attachment
@AttachmentTypeName = 'Video',
@Text = 'BTS is legend',
@TopicName = 'Entertainment',
@LocationName = 'California',
@AttachmentLink = 'https://youtu.be/7C2z4GqqS5E',
@Date_Time = '2018-06-30 23:23:16'
GO

EXEC populate_attachment
@AttachmentTypeName = 'GIF',
@Text = 'Kenny the Cat wants to become a youtube vlogger. Kenny first got 37 subscribers from INFO 330 B section.',
@TopicName = 'News',
@LocationName = 'Illinois',
@AttachmentLink = 'https://images.app.goo.gl/3PrEb1ZAYazFkwubA',
@Date_Time = '2019-10-03 09:25:20'
GO

EXEC populate_attachment
@AttachmentTypeName = 'Image',
@Text = 'Greg feeds cats, raises plants, and does ASMR in Zoom meetings.',
@TopicName = 'Fun',
@LocationName = 'New York',
@AttachmentLink = 'https://images.app.goo.gl/PaH4RJqXgmua9vvR9',
@Date_Time = '2019-11-20 15:10:30'
GO

EXEC populate_attachment
@AttachmentTypeName = 'Image',
@Text = 'Greg holds the key to a vault of Cliff Bars.',
@TopicName = 'Sports',
@LocationName = 'Washington',
@AttachmentLink = 'https://images.app.goo.gl/jxeo5NLf1T8triiHA',
@Date_Time = '2019-11-20 15:10:04'
GO

EXEC populate_attachment
@AttachmentTypeName = 'Image',
@Text = 'When I do ERD, I got my sway on.',
@TopicName = 'Random',
@LocationName = 'Oregon',
@AttachmentLink = 'https://www.microsoft.com/en-us/visitorcenter/default',
@Date_Time = '2018-04-07 13:39:40'
GO

CREATE PROCEDURE populate_tweet_user_event
@DisplayName VARCHAR(20),
@EventTypeName VARCHAR(50),
@Text VARCHAR(140),
@TopicName VARCHAR(50),
@LocationName VARCHAR(100),
@Date_Time DATETIME
AS
DECLARE @UserID INT, @TweetID INT, @EventTypeID INT, @TopicID INT, @LocationID INT
SET @UserID = (SELECT UserID FROM tblUSER WHERE DisplayName = @DisplayName)
SET @TopicID = (SELECT TopicID FROM tblTOPIC WHERE TopicName = @TopicName)
SET @LocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)
SET @TweetID = (SELECT TweetID FROM tblTWEET WHERE Content = @Text
                AND LocationID = @LocationID AND TopicID = @TopicID AND Date_Time = @Date_Time)
SET @EventTypeID = (SELECT EventTypeID FROM tblTWEET_USER_EVENT_TYPE WHERE EventTypeName = @EventTypeName)
BEGIN TRANSACTION T1
    INSERT INTO tblTWEET_USER_EVENT(TweetID, UserID, EventTypeID)
    VALUES(@TweetID, @UserID, @EventTypeID)
COMMIT TRANSACTION T1
GO

EXEC populate_tweet_user_event
@DisplayName = 'ChrisC',
@EventTypeName = 'Mentioned',
@Text = 'BTS is legend',
@TopicName = 'Entertainment',
@LocationName = 'California',
@Date_Time = '2018-06-30 23:23:16'
GO


EXEC populate_tweet_user_event
@DisplayName = 'Jchang',
@EventTypeName = 'Mentioned',
@Text = 'Greg holds the key to a vault of Cliff Bars.',
@TopicName = 'Sports',
@LocationName = 'Washington',
@Date_Time = '2019-11-20 15:10:04'
GO

EXEC populate_tweet_user_event
@DisplayName = 'ChrisC',
@EventTypeName = 'Reply',
@Text = 'Kenny the Cat wants to become a youtube vlogger. Kenny first got 37 subscribers from INFO 330 B section.',
@TopicName = 'News',
@LocationName = 'Illinois',
@Date_Time = '2019-10-03 09:25:20'
GO

EXEC populate_tweet_user_event
@DisplayName = 'KennytheCat',
@EventTypeName = 'Retweet',
@Text = 'When I do ERD, I got my sway on.',
@TopicName = 'Random',
@LocationName = 'Oregon',
@Date_Time = '2018-04-07 13:39:40'
GO

EXEC populate_tweet_user_event
@DisplayName = 'JasonY',
@EventTypeName = 'Tweet',
@Text = 'Greg feeds cats, raises plants, and does ASMR in Zoom meetings.',
@TopicName = 'Fun',
@LocationName = 'New York',
@Date_Time = '2019-11-20 15:10:30'
GO

CREATE PROCEDURE populate_userevent
@UserEventTypename VARCHAR(20),
@user1name VARCHAR(20),
@user2name VARCHAR(20),
@date DATETIME
AS
DECLARE @UserID1 INT, @UserID2 INT, @UserEventTypeID INT
SET @UserID1 = (SELECT UserID FROM tblUSER WHERE DisplayName = @user1name)
SET @UserID2 = (SELECT UserID FROM tblUSER WHERE DisplayName = @user2name)
SET @UserEventTypeID = (SELECT UserEventTypeID FROM tblUSER_EVENT_TYPE WHERE UserEventTypeName = @UserEventTypename)

BEGIN TRANSACTION T1
    INSERT INTO tblUSER_EVENT(UserEventTypeID, UserID1, UserID2, Date_Time)
    VALUES(@UserEventTypeID, @UserID1, @UserID2, @date)
COMMIT TRANSACTION T1
GO

EXEC populate_userevent
@UserEventTypename = 'Follow',
@user1name = 'Gthay',
@user2name = 'KennytheCat',
@date = '2018-09-21 15:10:30'
GO

EXEC populate_userevent
@UserEventTypename = 'Follow',
@user1name = 'JAsonY',
@user2name = 'Gthay',
@date = '2019-11-20 15:10:30'
GO

EXEC populate_userevent
@UserEventTypename = 'Follow',
@user1name = 'ChrisC',
@user2name = 'Gthay',
@date = '2019-04-12 15:10:30'
GO

EXEC populate_userevent
@UserEventTypename = 'Follow',
@user1name = 'Jchang',
@user2name = 'KennytheCat',
@date = '2017-10-30 15:10:30'
GO

EXEC populate_userevent
@UserEventTypename = 'Follow',
@user1name = 'ChrisC',
@user2name = 'KennytheCat',
@date = '2019-11-20 15:10:30'
GO

CREATE PROCEDURE populate_tweethashtag
@HashtagName VARCHAR(140),
@Text VARCHAR(140),
@TopicName VARCHAR(50),
@LocationName VARCHAR(100),
@Date_Time DATETIME
AS
DECLARE @HashtagID INT, @TweetID INT, @UserID INT, @LocationID INT, @TopicID INT
SET @HashtagID = (SELECT HashtagID FROM tblHASHTAG WHERE HashtagName = @HashtagName)
SET @TopicID = (SELECT TopicID FROM tblTOPIC WHERE TopicName = @TopicName)
SET @LocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)
SET @TweetID = (SELECT TweetID FROM tblTWEET WHERE Content = @Text 
                AND LocationID = @LocationID AND TopicID = @TopicID AND Date_Time = @Date_Time)
BEGIN TRANSACTION T1
    INSERT INTO tblTWEET_HASHTAG (HashtagID, TweetID)
    VALUES (@HashtagID, @TweetID)
COMMIT TRANSACTION T1
GO

EXEC populate_tweethashtag
@HashtagName = 'Crowdfunding',
@Text = 'Greg feeds cats, raises plants, and does ASMR in Zoom meetings.',
@TopicName = 'Fun',
@LocationName = 'New York',
@Date_Time = '2019-11-20 15:10:30'
GO

EXEC populate_tweethashtag
@HashtagName = 'Cryptocurrency',
@Text = 'When I do ERD, I got my sway on.',
@TopicName = 'Random',
@LocationName = 'Oregon',
@Date_Time = '2018-04-07 13:39:40'
GO

EXEC populate_tweethashtag
@HashtagName = 'Medicaid',
@Text = 'Kenny the Cat wants to become a youtube vlogger. Kenny first got 37 subscribers from INFO 330 B section.',
@TopicName = 'News',
@LocationName = 'Illinois',
@Date_Time = '2019-10-03 09:25:20'
GO

EXEC populate_tweethashtag
@HashtagName = 'tbt',
@Text = 'Greg holds the key to a vault of Cliff Bars.',
@TopicName = 'Sports',
@LocationName = 'Washington',
@Date_Time = '2019-11-20 15:10:04'
GO

EXEC populate_tweethashtag
@HashtagName = 'Giveaway',
@Text = 'BTS is legend',
@TopicName = 'Entertainment',
@LocationName = 'California',
@Date_Time = '2018-06-30 23:23:16'
GO

-- WE STOPPED HERE --

------ COMPUTED COLUMN  -----
-- How many tweets are in each topic 

CREATE FUNCTION FN_TweetTopic(@PK INT)
RETURNS INT 
AS 
BEGIN 
    DECLARE @RET INT 
    SET @RET = (SELECT COUNT(*) AS NumOfTweetsTopic
                FROM tblTWEET T
                WHERE T.TopicID = @PK)
    RETURN @RET
END
GO 

ALTER TABLE tblTOPIC
ADD NumOfTweets AS (dbo.FN_TweetTopic(TopicID))
GO

-- How many tweets are in each location

CREATE FUNCTION FN_TweetLocation(@PK INT)
RETURNS INT 
AS
BEGIN 
    DECLARE @RET INT 
    SET @RET = (SELECT COUNT(*) AS NumOfTweetsLocation
                FROM tblTWEET T 
                WHERE T.LocationID = @PK)
    RETURN @RET
END
GO

ALTER TABLE tblLOCATION 
ADD NumOfTweets AS (dbo.FN_TweetLocation(LocationID))
GO

-- How many tweets for each hashtag

CREATE FUNCTION FN_TweetHashtag(@PK INT)
RETURNS INT 
AS
BEGIN 
    DECLARE @RET INT 
    SET @RET = (SELECT COUNT(*) AS NumOfTweetsHashtag
                FROM tblTWEET T
                JOIN tblTWEET_HASHTAG TH ON T.TweetID = TH.TweetID 
                WHERE TH.HashtagID = @PK)
    RETURN @RET
END
GO

ALTER TABLE tblHASHTAG 
ADD NumOfTweets AS (dbo.FN_TweetHashtag(HashtagID))
GO

-- How many followers for each user

CREATE FUNCTION FN_FollowerPerUser(@PK INT)
RETURNS INT 
AS
BEGIN 
    DECLARE @RET INT 
    SET @RET = (SELECT COUNT(*) AS NumOfFollowers
                FROM tblUSER U
                JOIN tblUSER_EVENT UE ON U.UserID = UE.UserID2
                JOIN tblUSER_EVENT_TYPE UET ON UE.UserEventTypeID = UET.UserEventTypeID
                WHERE UserID = @PK AND UserEventTypeName = 'Follow')
    RETURN @RET
END
GO

ALTER TABLE tblUSER 
ADD NumOfFollowers AS (dbo.FN_FollowerPerUser(UserID))
GO

-- How many people each user is following 

CREATE FUNCTION FN_FollowingPerUser(@PK INT)
RETURNS INT 
AS
BEGIN 
    DECLARE @RET INT 
    SET @RET = (SELECT COUNT(*) AS NumOfFollowering
                FROM tblUSER U
                JOIN tblUSER_EVENT UE ON U.UserID = UE.UserID1
                JOIN tblUSER_EVENT_TYPE UET ON UE.UserEventTypeID = UET.UserEventTypeID
                WHERE UserID = @PK AND UserEventTypeName = 'Follow')
    RETURN @RET
END
GO

ALTER TABLE tblUSER 
ADD NumOfFollowering AS (dbo.FN_FollowingPerUser(UserID))
GO

-- How many tweets for each tweet event type

CREATE FUNCTION FN_TweetEventNum(@PK INT)
RETURNS INT 
AS
BEGIN 
    DECLARE @RET INT 
    SET @RET = (SELECT COUNT(TUE.TweetID) AS NumOfTweetEvents
                FROM tblTWEET_USER_EVENT TUE
                JOIN tblTWEET_USER_EVENT_TYPE TUET ON TUE.EventTypeID = TUET.EventTypeID
                WHERE TUE.EventTypeID = @PK)
    RETURN @RET
END
GO

ALTER TABLE tblTWEET_USER_EVENT_TYPE 
ADD NumOfTweetEvents AS (dbo.FN_TweetEventNum(EventTypeID))
GO

--------------------- Business Rule ----------------------

-- Business rule: A tweet can only contain one hashtag -- 
-- This is so we can more accurately track which hashtag is affecting engagements. -- 
-- If there were multiple hashtags per tweet, it would be ambiguous as to which hashtag --
-- is affecting the level of engagement. --
CREATE FUNCTION FN_1HashtagPerTweet()
RETURNS INT 
AS 
BEGIN 
    DECLARE @RET INT = 0
    IF EXISTS(SELECT TH.TweetID, COUNT(TH.HashtagID)
            FROM tblTWEET_HASHTAG TH
            GROUP BY TH.TweetID
            HAVING COUNT(TH.HashtagID) > 1)
    BEGIN 
        SET @RET = 1
    END 
RETURN @RET
END
GO

ALTER TABLE tblTWEET 
ADD CONSTRAINT CK_1HashtagPerTweet
CHECK(dbo.FN_1HashtagPerTweet() = 0)
GO

-- Business rule: 1 Attachment can be added per TWEET -- 
CREATE FUNCTION FN_1AttachmentPerTweet()
RETURNS INT 
AS 
BEGIN 
    DECLARE @RET INT = 0
    IF EXISTS(SELECT TweetID, COUNT(AttachmentID)
            FROM tblATTACHMENT
            GROUP BY TweetID
            HAVING COUNT(AttachmentID) > 1)
    BEGIN 
        SET @RET = 1
    END 
RETURN @RET
END
GO

ALTER TABLE tblTWEET 
ADD CONSTRAINT CK_1AttachmentPerTweet
CHECK(dbo.FN_1AttachmentPerTweet() = 0)
GO

-- Business rule: A tweet cannot mention more than 20 users at a time (In order to prevent spamming)-- 
CREATE FUNCTION FN_no20Mentions()
RETURNS INT 
AS 
BEGIN 
    DECLARE @RET INT = 0
    IF EXISTS(SELECT T.TweetID, COUNT(T.TweetID)
            FROM tblTWEET T 
            JOIN tblTWEET_USER_EVENT TUE ON T.TweetID = TUE.TweetID
            JOIN tblTWEET_USER_EVENT_TYPE TUET ON TUE.EventTypeID = TUET.EventTypeID
            WHERE TUET.EventTypeName = 'Mentioned'
            GROUP BY T.TweetID
            HAVING COUNT(T.TweetID) > 20)
    BEGIN 
        SET @RET = 1
    END 
RETURN @RET
END
GO

ALTER TABLE tblTWEET 
ADD CONSTRAINT CK_no20Mentions
CHECK(dbo.FN_no20Mentions() = 0)
GO

-- Business rule: A user cannot mention another user more than 10 times a day --
CREATE FUNCTION FN_NoMention10()
RETURNS INT 
AS
BEGIN 
    DECLARE @RET INT = 0
    IF EXISTS(SELECT TUE.UserID, U.UserID, COUNT(*) AS NumOfMentions, DAY(T.Date_Time) AS EachDay
            FROM tblTWEET T 
            JOIN tblTWEET_USER_EVENT TUE ON T.TweetID = TUE.TweetID
            JOIN tblTWEET_USER_EVENT_TYPE TUET ON TUE.EventTypeID = TUET.EventTypeID
            JOIN tblUSER U ON TUE.UserID = U.UserID 
            WHERE TUET.EventTypeName = 'Mentioned' AND DAY(GetDate()) = DAY(T.Date_Time)
            GROUP BY TUE.UserID, U.UserID, DAY(T.Date_Time)
            HAVING COUNT(*) > 10)
    BEGIN 
        SET @RET = 1
    END 
RETURN @RET
END
GO

ALTER TABLE tblTWEET_USER_EVENT 
ADD CONSTRAINT CK_NoMention10 
CHECK(dbo.FN_NoMention10() = 0)
GO

-- Business rule: No repeating DisplayName in tblUser --
CREATE FUNCTION FN_repeatingDisplayName()
RETURNS INT
AS 
BEGIN 
    DECLARE @RET INT = 0
    IF EXISTS(SELECT U.DisplayName, COUNT(*) 
                FROM tblUSER U
                GROUP BY U.DisplayName 
                HAVING COUNT(*) > 1
              )
    BEGIN 
        SET @RET = 1
    END
RETURN @RET 
END 
GO

ALTER TABLE tblUSER 
ADD CONSTRAINT CK_NoRepeatingDisplayName
CHECK(dbo.FN_repeatingDisplayName() = 0)
GO

-- Business rule: One user cannot follow more than 400 users per day--
CREATE FUNCTION FN_noMore400Follow()
RETURNS INT
AS 
BEGIN 
    DECLARE @RET INT = 0
    IF EXISTS(SELECT U.UserID, COUNT(U.UserID) AS FollowingCount, DAY(UE.Date_Time) AS EachDay
                FROM tblUSER U
                JOIN tblUSER_EVENT UE ON U.UserID = UE.UserID1
                JOIN tblUSER_EVENT_TYPE UET ON UE.UserEventTypeID = UET.UserEventTypeID
                WHERE UET.UserEventTypeName = 'Follow' AND DAY(GetDate()) = DAY(UE.Date_Time)
                GROUP BY U.UserID, DAY(UE.Date_Time)
                HAVING COUNT(U.UserID) > 400
              )
    BEGIN 
        SET @RET = 1
    END
RETURN @RET 
END 
GO

ALTER TABLE tblUSER 
ADD CONSTRAINT CK_noMore400Follow
CHECK(dbo.FN_noMore400Follow() = 0)
GO

--------------------- View Generating Complex Query ----------------------
-- Topic with an increase in the number of tweets in the past month-- 
CREATE VIEW [Topic an Increase in Number of Tweets in the Past Month] AS 
(SELECT TT.TopicName, COUNT(T.TweetID) AS CurrentNumOfTweets, SubQ.LastMonthNumOfTweets
    FROM tblTOPIC TT
    JOIN tblTWEET T ON TT.TopicID = T.TopicID
    JOIN tblTWEET_USER_EVENT TUE ON T.TweetID = TUE.TweetID
    JOIN tblTWEET_USER_EVENT_TYPE TUET ON TUE.EventTypeID = TUET.EventTypeID
    JOIN 
    (
    SELECT TT.TopicName, COUNT(T.TweetID) AS LastMonthNumOfTweets
        FROM tblTOPIC TT
        JOIN tblTWEET T ON TT.TopicID = T.TopicID
        JOIN tblTWEET_USER_EVENT TUE ON T.TweetID = TUE.TweetID
        JOIN tblTWEET_USER_EVENT_TYPE TUET ON TUE.EventTypeID = TUET.EventTypeID
        WHERE TUET.EventTypeName = 'Tweet' AND YEAR(GetDate()) = YEAR(T.Date_Time) AND MONTH(GetDate()) = MONTH(DATEADD(month, -1, GETDATE()))
        GROUP BY TT.TopicName
    ) AS SubQ ON TT.TopicName = SubQ.TopicName

    WHERE TUET.EventTypeName = 'Tweet' AND YEAR(GetDate()) = YEAR(T.Date_Time) AND MONTH(GetDate()) = MONTH(T.Date_Time)  
    GROUP BY TT.TopicName, SubQ.LastMonthNumOfTweets
    HAVING (COUNT(T.TweetID) - SubQ.LastMonthNumOfTweets) > 0
)
GO 

-- Hashtag that has had increase in engagement in the past month -- 
CREATE VIEW [Hashtag with Increase in Engagement in the past month] AS 
(SELECT H.HashtagName, SubQ1.PreviousOne, COUNT(T.TweetID) AS CurrentOne from tblHASHTAG H
    JOIN tblTWEET_HASHTAG TH ON H.HashtagID = TH.HashtagID 
    JOIN tblTWEET T ON TH.TweetID = T.TweetID 
    
    JOIN
    (SELECT H1.HashtagName, T1.TweetID, COUNT(T1.TweetID) AS PreviousOne
        FROM tblHASHTAG H1
        JOIN tblTWEET_HASHTAG TH1 ON H1.HashtagID = TH1.HashtagID 
        JOIN tblTWEET T1 ON TH1.TweetID = T1.TweetID 
        WHERE T1.Date_Time = DATEADD(month, -1, GETDATE())
        GROUP BY H1.HashtagName, T1.TweetID
        HAVING COUNT(T1.TweetID) > 0) 
    AS SubQ1 ON H.HashtagName = SubQ1.HashtagName

    WHERE MONTH(T.Date_Time) = MONTH(GetDate())
    GROUP BY H.HashtagName, SubQ1.PreviousOne
    HAVING COUNT(T.TweetID) > SubQ1.PreviousOne
)
GO

-- Users with an increase in followers in the past year -- 
CREATE VIEW [Users with an increase in followers in the past year] AS 
(SELECT U.UserID, COUNT(U.UserID) AS FollowerNumCurrent, SQ.FollowerNumOld,
    (COUNT(U.UserID) - SQ.FollowerNumOld) AS FollowerIncrease
    FROM tblUSER U
    JOIN tblUSER_EVENT UE ON U.UserID = UE.UserID2
    JOIN tblUSER_EVENT_TYPE UET ON UE.UserEventTypeID = UET.UserEventTypeID
    JOIN 
    (SELECT U1.UserID, COUNT(U1.UserID) AS FollowerNumOld
        FROM tblUSER U1
        JOIN tblUSER_EVENT UE1 ON U1.UserID = UE1.UserID2
        JOIN tblUSER_EVENT_TYPE UET1 ON UE1.UserEventTypeID = UET1.UserEventTypeID
        WHERE UET1.UserEventTypeName = 'Follow' AND (YEAR(GetDate()) - 365) = YEAR(UE1.Date_Time)
        GROUP BY U1.UserID
    ) AS SQ ON U.UserID = SQ.UserID
    WHERE UET.UserEventTypeName = 'Follow' AND YEAR(GetDate()) = YEAR(UE.Date_Time)
    GROUP BY U.UserID, SQ.FollowerNumOld
    HAVING ((COUNT(U.UserID) - SQ.FollowerNumOld) > 0) 
)
GO 

-- Top 10 Tweets with the Most Likes in the Past Year-- 
CREATE VIEW[Tweets with the Most Likes in the Past Year] AS
(SELECT TOP 10 T.TweetID, COUNT(*) AS NumOfLikes
FROM tblTWEET T
JOIN tblTWEET_USER_EVENT TUE ON T.TweetID = TUE.TweetID
JOIN tblTWEET_USER_EVENT_TYPE TUET ON TUE.EventTypeID = TUET.EventTypeID
WHERE TUET.EventTypeName = 'Like'
AND YEAR(GetDate()) = YEAR(T.Date_Time)
GROUP BY T.TweetID 
ORDER BY COUNT(*) DESC)
GO

-- Top 10 Users with an increase in mentions in a month -- 
CREATE VIEW [Users Frequently Mentioned] AS 
(SELECT TOP 10 U.UserID, COUNT(*) AS NumOfMentions, 
    SQ.NumOfMentionsLastMonth,
    (COUNT(*) - SQ.NumOfMentionsLastMonth) AS Mentiondiff
FROM tblUSER U 
    JOIN tblTWEET_USER_EVENT TUE ON U.UserID = TUE.UserID
    JOIN tblTWEET T ON TUE.TweetID = T.TweetID
    JOIN tblTWEET_USER_EVENT_TYPE TUET ON TUE.EventTypeID = TUET.EventTypeID
    JOIN (
        SELECT U1.UserID, COUNT(*) AS NumOfMentionsLastMonth
        FROM tblUSER U1 
            JOIN tblTWEET_USER_EVENT TUE1 ON U1.UserID = TUE1.UserID
            JOIN tblTWEET T1 ON TUE1.TweetID = T1.TweetID
            JOIN tblTWEET_USER_EVENT_TYPE TUET1 ON TUE1.EventTypeID = TUET1.EventTypeID
        WHERE TUET1.EventTypeName = 'Mentioned' AND MONTH(T1.Date_Time) = DATEADD(MONTH, -1, GETDATE())
        GROUP BY U1.UserID
    ) AS SQ on SQ.UserID = U.UserID
WHERE TUET.EventTypeName = 'Mentioned' AND MONTH(T.Date_Time) = MONTH(GETDATE())
GROUP BY U.UserID, SQ.NumOfMentionsLastMonth
ORDER BY (COUNT(*) - SQ.NumOfMentionsLastMonth) DESC)
GO

-- Top 5 hashtags in each location -- 
CREATE VIEW [Most Popular Hashtag in Each Location] AS 
SELECT TOP 5 WITH TIES L.LocationName, H.HashtagName, T.TweetID, COUNT(T.TweetID) AS NumOfTweets
    FROM tblLOCATION L
    JOIN tblTWEET T ON L.LocationID = T.LocationID
    JOIN tblTWEET_HASHTAG TH ON T.TweetID = TH.TweetID 
    JOIN tblHASHTAG H ON TH.HashtagID = H.HashtagID
    GROUP BY L.LocationName, H.HashtagName, T.TweetID
    ORDER BY COUNT(T.TweetID) DESC
GO 



BACKUP DATABASE Proj_B7
TO DISK = 'C:\SQL\Proj_B7.bak'
WITH DIFFERENTIAL