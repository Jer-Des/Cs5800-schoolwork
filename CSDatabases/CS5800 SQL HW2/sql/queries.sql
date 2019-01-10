-- 1.

    SELECT 
        max(HR)
    FROM   
        batting
	WHERE HR > 0
;



-- 2.
    
SELECT DISTINCT teams.yearID as year, master.nameFirst as first, master.nameLast as last
FROM master JOIN teams,
(	SELECT distinct teams.teamID, teams.yearID, master.masterID
	FROM master, teams, appearances,
	  ( SELECT DISTINCT teams.teamID, teams.yearID
		FROM master , appearances , teams
		WHERE nameLast ='Jeter' && nameFirst ='Derek' && appearances.masterID = master.masterID && teams.yearID = appearances.yearID
        ) as p
	WHERE p.yearID = teams.yearID && appearances.masterID = master.masterID && p.teamID = teams.teamID && teams.yearID > 1990
) as q
  WHERE teams.teamID = q.teamID && q.yearID = teams.yearID && appearances.masterID = q.masterID
  ;



-- 3. 
    SELECT name, x.yearID, hrs 
    FROM teams t, (
		SELECT distinct teamID, yearID, max(HR) as hrs 
		FROM batting 
		WHERE 2*AB > 300
		GROUP BY teamID , yearID) x
    WHERE t.teamID = x.teamID AND t.yearID = x.yearID && hrs >0
;



-- 4. 		
SELECT DISTINCT nameFirst, nameLast, teams.name
FROM master JOIN pitching JOIN teams
WHERE master.masterID = pitching.masterID &&  name = 'Boston Red Sox'
;

           
           
-- 5. 
SELECT distinct masterID
FROM master M
WHERE EXISTS
    (SELECT distinct masterID
	 FROM  batting B
	 WHERE M.masterID = B.masterID)
;



-- 6.
SELECT DISTINCT  master.nameFirst, master.nameLast, b1.yearID, b1.H
FROM  batting AS b1  LEFT JOIN   master ON b1.masterID = master.masterID
WHERE b1.teamID = 
    (SELECT DISTINCT  t.teamID
	 FROM  teams t
	 WHERE  t.name = 'Boston Red Sox')  AND b1.HR = 
        (SELECT MAX(b2.H)
         FROM  batting as b2
         WHERE b2.yearID = b1.yearID)
ORDER BY b1.yearID
;


