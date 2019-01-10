--Jeremy Desser A00692027
--1. -- LA Dodgers

SELECT DISTINCT nameFirst as 'First Name', nameLast as 'Last Name'
FROM master as m JOIN teams as t join appearances as a 
WHERE t.teamID = a.teamID AND m.masterID = a.masterID AND t.name = 'Los Angeles Dodgers'
;


--2. --Brooklyn AND/OR LA Dodgers Only

SELECT DISTINCT nameFirst, nameLast
FROM master as m JOIN teams as t join appearances as a 
 (SELECT DISTINCT nameFirst as 'First Name', nameLast as 'Last Name'
FROM master as m JOIN teams as t join appearances as a 
WHERE t.teamID = a.teamID AND m.masterID = a.masterID AND t.name = 'Los Angeles Dodgers' )
UNION
(SELECT DISTINCT nameFirst as 'First Name', nameLast as 'Last Name'
FROM master as m JOIN teams as t join appearances as a 
WHERE t.teamID = a.teamID AND m.masterID = a.masterID AND t.name = 'Brooklyn Dodgers' )
SELECT t.name
FROM teams as t
;


--3.-- Gold Glove Dodgers

SELECT DISTINCT nameFirst as 'First Name', nameLast as 'Last Name' ,notes as position, ap.yearID as 'Year Won'
FROM master as m JOIN teams as t join appearances as a JOIN awardsplayers as ap
WHERE t.teamID = a.teamID AND m.masterID = a.masterID AND t.name = 'Los Angeles Dodgers' AND ap.awardID = 'Gold Glove' AND m.masterID = ap.masterID
;


--4.-- World Series Winners
SELECT t.name,  count(*) as 'WS Wins'
FROM teams as t JOIN teamsfranchises as tf
WHERE t.WSWin = 'Y' AND tf.franchID = t.franchID
GROUP BY t.name
ORDER BY count(t.name)
;


--5.-- USU batters
SELECT DISTINCT nameFirst as 'First Name', NameLast as 'Last Name',yearID as 'Years Played', (h/ab) as Average
FROM master as m JOIN batting as b 
WHERE m.masterID in(
SELECT DISTINCT sp.masterID
FROM  schools as s JOIN schoolsplayers as sp
WHERE schoolName = 'Utah State University' AND s.schoolID = sp.schoolID) 
;


--6.-- Bumper Salary Teams

SELECT  s.salary, t.name, t.yearID
FROM salaries as s JOIN teams as t  JOIN
	(SELECT salary
     FROM salaries
     WHERE yearID = yearID+1) as s2
WHERE s2.salary / s.salary >= 1.5
;


--7.-- Red Sox Four

SELECT DISTINCT nameFirst as 'First', nameLast as 'Last'
FROM master as m JOIN teams as t1 JOIN batting as b ON b.masterID = m.masterID
WHERE t1.name = 'Boston Red Socks' AND 4 = (
		SELECT count(*)
	    FROM teams as t2
        WHERE t1.yearID
        BETWEEN t1.yearID AND (t1.yearID + 4 -1))
		
--8.-- Home Run Kings
SELECT nameFirst, nameLast, HR, yearID
FROM   batting as b JOIN master as m ON b.masterID = m.masterID
WHERE b.HR > 0 AND b.HR >= (
SELECT DISTINCT HR
FROM batting
HAVING max(HR))
ORDER BY yearID
// I could bring up all the information I needed, but couldnt figure out how to pick the max HR from that year.


--9.-- Third best home runs each year

SELECT Master.nameFirst as 'first name', Master.nameLast as 'last name',  Batting.HR, Batting.yearID
FROM Batting INNER JOIN Master ON Batting.masterID = Master.masterID
WHERE batting.HR > 1 AND (((Batting.HR)>= 
	(SELECT HR 
    FROM batting as b1 
    HAVING count(*) >= 0 AND count(b1.HR) AND max(b1.HR))))
HAVING batting.HR < 4
ORDER BY yearID;

--10.-- Triple happy team mates 

SELECT DISTINCT name, bat.yearID as 'Year', nameFirst as 'first', nameLast as 'last', bat.3B as 'Triples'
FROM master as m JOIN teams as t JOIN batting as bat
WHERE bat.teamID = t.teamID AND bat.3b >= 10 AND 
(SELECT 3B
FROM batting as b
having 3B >= 10 
limit 1)


--11.-- Ranking the teams 

SELECT (sum(W) / sum((W+L))) as 'win %', name, sum(W), sum(L)
FROM teams
GROUP BY name
ORDER BY (sum(W) / sum((W+L))) DESC


--12.-- Casey Stengel's Pitchers

SELECT DISTINCT  name ,m.nameFirst as'player first', m.nameLast as'player first', pitching.yearID ,p.nameFirst as'manager first',p.nameLast as 'manager last'
FROM teams JOIN pitching JOIN master as m JOIN (SELECT teamID,nameLast, nameFirst, managers.yearID
FROM managers JOIN master ON managers.masterID = master.masterID
WHERE nameFirst = 'Casey'AND nameLast = 'Stengel') as p
WHERE p.teamID = pitching.teamID AND p.yearID = pitching.yearID



--13.-- Two degrees from Yogi Berra

	SELECT distinct a.masterID
    FROM teams as t JOIN appearances  as a JOIN master JOIN(SELECT master.masterID, teamID
	FROM master JOIN appearances ON master.masterID = appearances.masterID
	WHERE nameFirst='Yogi' AND nameLast = 'Berra') as yt
    WHERE yt.teamID = t.teamID and a.masterID = yt.masterID


--14.-- Rickey's travels
SELECT DISTINCT name
FROM teams JOIN 
	(SELECT master.masterID, teamID
	FROM master JOIN appearances ON master.masterID = appearances.masterID
	WHERE nameFirst='RICKEY' AND nameLast = 'HENDERSON') as rt
WHERE rt.teamID <> teams.teamID 
