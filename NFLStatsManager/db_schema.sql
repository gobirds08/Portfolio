
CREATE TABLE team( 
tid INT UNIQUE, 
city VARCHAR(50) NOT NULL, 
name VARCHAR(25) NOT NULL, 
in_nfc BOOLEAN NOT NULL, 
division VARCHAR(5) NOT NULL, 
PRIMARY KEY (tid) 
);

CREATE TABLE player( 
pid INT UNIQUE, 
fname VARCHAR(50) NOT NULL, 
lname VARCHAR(50) NOT NULL, 
birthdate DATE NOT NULL, 
position VARCHAR(2) NOT NULL, 
number INT NOT NULL CHECK (number >= 0 AND number <= 99), 
tid INT, 
retired BOOLEAN NOT NULL DEFAULT FALSE, 
PRIMARY KEY (pid), 
FOREIGN KEY (tid) REFERENCES team (tid) 
);

CREATE INDEX IDX1 ON player(tid); 

CREATE TABLE season( 
year CHAR(9) UNIQUE, 
status VARCHAR(10) DEFAULT 'active', 
PRIMARY KEY (year) 
);

CREATE TABLE game( 
gid INT UNIQUE, 
home_tid INT, 
away_tid INT, 
date DATE NOT NULL, 
season CHAR(9), 
PRIMARY KEY (gid), 
FOREIGN KEY (home_tid) REFERENCES team (tid), 
FOREIGN KEY (away_tid) REFERENCES team (tid), 
FOREIGN KEY (season) REFERENCES season (year) 
); 

CREATE TABLE award( 
award_name VARCHAR(50), 
year CHAR(9), 
pid INT, 
PRIMARY KEY (award_name, year), 
FOREIGN KEY (year) REFERENCES season (year), 
FOREIGN KEY (pid) REFERENCES player (pid),
FOREIGN KEY (tid) REFERENCES team (tid)
); 

CREATE TABLE player_stats ( 
pid INT, 
gid INT, 
pass_yds INT DEFAULT 0, 
rush_yds INT DEFAULT 0, 
rec_yds INT DEFAULT 0, 
receptions INT DEFAULT 0 CHECK (receptions  >= 0), 
ints INT DEFAULT 0 CHECK (ints  >= 0), 
fumbles INT DEFAULT 0 CHECK (fumbles  >= 0), 
ints_thrown INT DEFAULT 0 CHECK (ints_thrown  >= 0), 
rec_tds INT DEFAULT 0 CHECK (rec_tds  >= 0), 
rush_tds INT DEFAULT 0 CHECK (rush_tds  >= 0), 
pass_tds INT DEFAULT 0 CHECK (pass_tds  >= 0), 
tackles INT DEFAULT 0 CHECK (tackles  >= 0), 
sacks INT DEFAULT 0 CHECK (sacks  >= 0), 
PRIMARY KEY (pid, gid), 
FOREIGN KEY (pid) REFERENCES player (pid), 
FOREIGN KEY (gid) REFERENCES game (gid) 
); 

CREATE TABLE team_stats ( 
tid INT, 
gid INT, 
yds INT DEFAULT 0, 
points INT DEFAULT 0 CHECK (points >= 0), 
takeaways INT DEFAULT 0 CHECK (takeaways >= 0), 
PRIMARY KEY (tid, gid), 
FOREIGN KEY (tid) REFERENCES team (tid), 
FOREIGN KEY (gid) REFERENCES game (gid) 
); 

CREATE TABLE transaction( 
transaction_id INT UNIQUE, 
pid INT NOT NULL, 
prev_tid INT, 
new_tid INT NOT NULL, 
type VARCHAR(7), 
date DATE NOT NULL, 
year CHAR(9), 
PRIMARY KEY (transaction_id), 
FOREIGN KEY (prev_tid) REFERENCES team (tid), 
FOREIGN KEY (new_tid) REFERENCES team (tid), 
FOREIGN KEY (year) REFERENCES season (year) 
); 

CREATE INDEX IDX2 ON transaction(new_tid); 