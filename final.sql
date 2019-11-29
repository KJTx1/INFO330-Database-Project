CREATE DATABASE Proj_B7
GO

USE Proj_B7
GO

----- Create Tables -----
CREATE TABLE tblUSER
(UserID INT IDENTITY(1,1) primary key NOT NULL, 
DisplayName VARCHAR(20) NOT NULL,
Bio VARCHAR(140),
Banner VARCHAR(100),
Icon VARCHAR(100) NOT NULL,
DateJoined DATE DEFAULT GetDate() NOT NULL
)
GO

CREATE TABLE tblEVENT_TYPE
(EventTypeID INT IDENTITY(1,1) primary key NOT NULL,
EventTypeName VARCHAR(20) NOT NULL,
EventTypeDescr VARCHAR(100)
)
GO

CREATE TABLE tblLOCATION
(LocationID INT IDENTITY(1,1) primary key NOT NULL,
LocationName VARCHAR(100) NOT NULL
)
GO

CREATE TABLE tblTOPIC
(TopicID INT IDENTITY(1,1) primary key NOT NULL,
TopicName VARCHAR(50) NOT NULL
)
GO

CREATE TABLE tblCONTENT_TYPE
(ContentTypeID INT IDENTITY(1,1) primary key NOT NULL,
ContentTypeName VARCHAR(100)
)
GO

CREATE TABLE tblCONTENT
(ContentID INT IDENTITY(1,1) primary key NOT NULL,
ContentInfo VARCHAR(140), -- twitter has a 140 character limit -- 
ContentTypeID INT FOREIGN KEY REFERENCES tblCONTENT_TYPE(ContentTypeID) NOT NULL
)
GO

CREATE TABLE tblEVENT 
(EventID INT IDENTITY(1,1) primary key NOT NULL,
EventTypeID INT FOREIGN KEY REFERENCES tblEVENT_TYPE(EventTypeID) NOT NULL,
LocationID INT FOREIGN KEY REFERENCES tblLOCATION(LocationID) NOT NULL,
Date_Time DATE DEFAULT GetDate() NOT NULL
) 
GO

ALTER TABLE tblEVENT ADD CONSTRAINT FK_Event
FOREIGN KEY (PrevEventID) REFERENCES tblEVENT(EventID);

CREATE TABLE tblUSER_EVENT 
(UserEventID INT IDENTITY(1,1) primary key NOT NULL,
EventID INT FOREIGN KEY REFERENCES tblEVENT(EventID) NOT NULL,
UserID1 INT FOREIGN KEY REFERENCES tblUSER(UserID) NOT NULL,
UserID2 INT FOREIGN KEY REFERENCES tblUSER(UserID) NOT NULL,
Date_Time DATE DEFAULT GetDate() NOT NULL
)
GO

CREATE TABLE tblEVENT_CONTENT 
(EventContentID INT IDENTITY(1,1) primary key NOT NULL,
EventID INT FOREIGN KEY REFERENCES tblEVENT(EventID) NOT NULL,
ContentID INT FOREIGN KEY REFERENCES tblCONTENT(ContentID) NOT NULL,
TopicID INT FOREIGN KEY REFERENCES tblTOPIC(TopicID) NOT NULL)
GO

----- Populate Tables -----
INSERT INTO tblLOCATION(LocationName) VALUES 
('Alabama'), ('Alaska'), ('Arizona'), ('Arkansas'), ('California'), ('Colorado'), ('Connecticut'),
('Delaware'), ('Florida'), ('Georgia'), ('Hawaii'), ('Idaho'), ('Illinois'), ('Indiana'), ('Iowa'),
('Kansas'), ('Kentucky'), ('Louisiana'), ('Maine'), ('Maryland'), ('Massachusetts'), ('Michigan'), 
('Minnesota'), ('Mississippi'), ('Missouri'), ('Montana'), ('Nebraska'), ('Nevada'), ('New Hampshire'), 
('New Jersey'), ('New Mexico'), ('New York'), ('North Carolina'), ('North Dakota'), ('Ohio'), ('Oklahoma'), 
('Oregon'), ('Pennsylvania'), ('Rhode Island'), ('South Carolina'), ('South Dakota'), ('Tennessee'), ('Texas'), 
('Utah'), ('Vermont'), ('Virginia'), ('Washington'), ('West Virginia'), ('Wisconsin'), ('Wyoming')
GO

INSERT INTO tblCONTENT_TYPE(ContentTypeName) VALUES 
('Video'), ('Image'), ('GIF'), ('Hashtag'), ('Link'), ('Text'), ('Reply')
GO


INSERT INTO tblEVENT_TYPE(EventTypeName, EventTypeDescr) VALUES 
('Follow', 'The user are subscribing to their Tweets as a follower.'),
('Block', 'Blocking helps people in restricting specific accounts from contacting them.'),
('Unfollow', 'People unfollow other accounts when they no longer wish to see its Tweets in its home timeline.'),
('Unblock', 'When you unblock someone, they will be able to see all of their activties.'),
('Mention', 'A Tweet that contains another person’s username anywhere in the body of the Tweet.'),
('Reply', 'A response to another person’s Tweet.'),
('Retweet', 'A Tweet that you share publicly with your followers.')
GO

INSERT INTO tblTOPIC(TopicName) VALUES ('Entertainment'), ('News'), ('Sports'), ('Fun')
GO


----- Stored Procedures -----
CREATE PROCEDURE populate_user
@DisplayName varchar(20),
@Bio VARCHAR(140),
@Banner varchar(100),
@Icon VARCHAR(100),
@DateJoined DATE
AS
    BEGIN TRANSACTION T1
        INSERT INTO tblUSER(DisplayName, Bio, Banner, Icon)
        VALUES(@DisplayName, @Bio, @Banner, @Icon)
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

CREATE PROCEDURE populate_content
@ContentInfo VARCHAR(140),
@ContentTypeName VARCHAR(100)
AS
    DECLARE @CT_ID INT
    SET @CT_ID = (SELECT C.ContentTypeID FROM tblCONTENT_TYPE C WHERE C.ContentTypeName = @ContentTypeName)
    BEGIN TRANSACTION T1
        INSERT INTO tblCONTENT(ContentTypeID, ContentInfo)
        VALUES (@CT_ID, @ContentInfo)
    COMMIT TRANSACTION T1
GO

EXEC populate_content
@ContentInfo = 'https://images.app.goo.gl/3PrEb1ZAYazFkwubA',
@ContentTypeName = 'GIF'
GO

EXEC populate_content
@ContentInfo = 'https://youtu.be/7C2z4GqqS5E',
@ContentTypeName = 'Video'
GO

EXEC populate_content
@ContentInfo = 'https://images.app.goo.gl/PaH4RJqXgmua9vvR9',
@ContentTypeName = 'Image'
GO

EXEC populate_content
@ContentInfo = 'https://www.microsoft.com/en-us/visitorcenter/default',
@ContentTypeName = 'Image'
GO

EXEC populate_content
@ContentInfo = 'https://images.app.goo.gl/jxeo5NLf1T8triiHA',
@ContentTypeName = 'Image'
GO

CREATE PROCEDURE populate_event_content 
@ContentInfo VARCHAR(140),
@TopicName VARCHAR(50),
@EventTypeName VARCHAR(20),
@LocationName VARCHAR(100),
@Date_Time DATE
AS
DECLARE @ET_ID INT, @L_ID INT, @E_ID INT, @C_ID INT, @T_ID INT
SET @ET_ID = (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = @EventTypeName)
SET @L_ID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)
SET @E_ID = (SELECT EventID FROM tblEVENT WHERE EventTypeID = @ET_ID 
            AND LocationID = @L_ID AND Date_Time = @Date_Time)
SET @T_ID = (SELECT TopicID FROM tblTOPIC WHERE TopicName = @TopicNamew)
SET @C_ID = (SELECT ContentID WHERE ContentInfo = @ContentInfo)
BEGIN TRANSACTION T1
    INSERT INTO tblEVENT_CONTENT(EventID, ContentID, TopicID)
    VALUES(@E_ID, @C_ID, @T_ID)
COMMIT TRANSACTION T1
GO

EXEC populate_event_content
@ContentInfo = 'BTS is legend',
@TopicName = 'Entertainment',
@EventTypeName = 'Mention',
@LocationName = 'California',
@Date_Time = 'November 27, 2019'
GO

EXEC populate_event_content
@ContentInfo = 'Greg holds the key to a vault of Cliff Bars.',
@TopicName = 'News',
@EventTypeName = 'Retweet',
@LocationName = 'Washington',
@Date_Time = 'November 27, 2019'
GO

EXEC populate_event_content
@ContentInfo = 'UW is the 2019 Pac 12 Champs',
@TopicName = 'Sports',
@EventTypeName = 'Reply',
@LocationName = 'Florida',
@Date_Time = 'November 27, 2019'
GO

EXEC populate_event_content
@ContentInfo = 'Kenny the Cat wants to become a youtube vlogger. Kenny first got 37 subscribers from INFO 330 B section.',
@TopicName = 'Fun',
@EventTypeName = 'Retweet',
@LocationName = 'Utah',
@Date_Time = 'November 27, 2019'
GO

EXEC populate_event_content
@ContentInfo = 'Greg feeds cats, raises plants, and does ASMR in Zoom meetings.',
@TopicName = 'Entertainment',
@EventTypeName = 'Reply',
@LocationName = 'Vermont',
@Date_Time = 'November 27, 2019'
GO

CREATE PROCEDURE populate_event_user_interaction
    @EventTypeName VARCHAR(20),
    @LocationName varchar(100)
    AS
    DECLARE @EventTypeID INT, @LocationID INT
    SET @EventTypeID = (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = @EventTypeName)
    SET @LocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)
    BEGIN TRANSACTION T1
        INSERT INTO tblEVENT(EventTypeID, LocationID, PrevEventID, Date_Time)
        VALUES(@EventTypeID, @LocationID, null, GetDate())
    COMMIT TRANSACTION T1
GO

EXEC populate_event_user_interaction
@EventTypeName = 'Follow',
@LocationName = 'California'
GO

EXEC populate_event_user_interaction
@EventTypeName = 'Block',
@LocationName = 'California'
GO

CREATE PROCEDURE populate_event_tweet_interaction
    @EventTypeName VARCHAR(20),
    @LocationName varchar(100),
    @PrevEventTypeName VARCHAR(20),
    @PrevLocationName varchar(100)
    AS
    DECLARE @EventTypeID INT, @LocationID INT, @PrevEventTypeID INT, @PrevLocationID INT, @PrevEventID INT
    SET @EventTypeID = (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = @EventTypeName)
    SET @LocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)
    SET @PrevEventTypeID = (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = @PrevEventTypeName)
    SET @PrevLocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @PrevLocationName)
    SET @PrevEventID = (SELECT EventID FROM tblEVENT WHERE LocationID = @PrevLocationID 
                        AND EventTypeID = @PrevEventTypeID)
    BEGIN TRANSACTION T1
        INSERT INTO tblEVENT(EventTypeID, LocationID, PrevEventID, Date_Time)
        VALUES(@EventTypeID, @LocationID, null, GetDate())
    COMMIT TRANSACTION T1
GO





EXEC populate_event
@EventTypeName = 'Retweet',
@LocationName = 'Washington'
GO

EXEC populate_event
@EventTypeName = 'Follow',
@LocationName = 'Illinois'
GO

EXEC populate_event
@EventTypeName = 'Mention',
@LocationName = 'Hawaii'
GO

EXEC populate_event
@EventTypeName = 'Block',
@LocationName = 'Montana'
GO

EXEC populate_event
@EventTypeName = 'Unblock',
@LocationName = 'New York'
GO

EXEC populate_event
@EventTypeName = 'Reply',
@LocationName = 'Ohio'
GO

CREATE PROCEDURE populate_user_event
    @EventTypeName VARCHAR(20),
    @LocationName varchar(100),
    @User1Name VARCHAR(20),
    @User2Name VARCHAR(20),
    
    AS
    DECLARE @EventTypeID INT, @LocationID INT
    SET @EventTypeID = (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = @EventTypeName)
    SET @LocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)

    BEGIN TRANSACTION T1
        INSERT INTO tblEVENT(EventTypeID, LocationID, Date_Time)
        VALUES(@EventTypeID, @LocationID, GetDate())
    COMMIT TRANSACTION T1
GO

-------- Computed Columns ---------




BACKUP DATABASE Proj_B7
TO DISK = 'C:\SQL\Proj_B7.bak'
WITH DIFFERENTIAL 

