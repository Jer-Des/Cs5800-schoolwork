-- Constraint 1
--  The default number of ABs is 20.
ALTER TABLE batting
ADD CONSTRAINT defaultAbs DEFAULT 20 FOR AB ;

-- Constraint 2
--  A player cannot have more H than ABs (at bats).
CREATE TRIGGER chkABS BEFORE INSERT on batting
ADD CHECK(AB <> H)

--Constraint 3 
-- In the Teams table, the league can be only one of the values: NL or AL.
ALTER TABLE teams
ADD CHECK(lgID = "NL" || lgID = "AL");



-- Constraint 4
--  When a team loses more than 161 games in a season, the fans want to forget about the team forever, so all batting records for the team for that year should be deleted.
CREATE TRIGGER badTeamTrigger on teams
    FOR DELETE
AS DELETE 
FROM teams
    WHERE L > 160;
	
--Constraint 5
--  If a player wins the MVP, WS MVP, and a Gold Glove in the same season, they are automatically inducted into the Hall of Fame.
CREATE TRIGGER greatPlayerTrigger on awardsplayers JOIN batting, master
if( awardID = "MVP" && awardID = "WS MVP" && awardID = "GOLD GLOVE" && awardsplayers.yearID = batting.yearID)
ADD master.masterID to halloffame;

--Constraint 6
--  All players must have some firstName, i.e., it cannot be null.
ALTER TABLE master
ADD CONSTRAINT needAName CHECK(firstName <> NULL);

--Constraint 7
--  Every player has a unique name (combined first and last names).
ALTER TABLE master
ADD UNIQUE fullNameUnique(nameFirst,nameLast);