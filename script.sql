DROP TABLE RateMyMusic.UserChartReview;
DROP TABLE RateMyMusic.UserChartAlbum;
DROP TABLE RateMyMusic.UserChart;
DROP TABLE RateMyMusic.PlaylistSong;
DROP TABLE RateMyMusic.Playlist;
DROP TABLE RateMyMusic.SongReview;
DROP TABLE RateMyMusic.AlbumReview;
DROP TABLE RateMyMusic.ArtistSong;
DROP TABLE RateMyMusic.ArtistAlbum;
DROP TABLE RateMyMusic.AlbumSong;
DROP TABLE RateMyMusic.Song;
DROP TABLE RateMyMusic.Album;
DROP TABLE RateMyMusic.Comment1;
DROP TABLE RateMyMusic.Comment2;
DROP TABLE RateMyMusic.Review1;
DROP TABLE RateMyMusic.Review2;
DROP TABLE RateMyMusic.Artist1;
DROP TABLE RateMyMusic.Artist2;
DROP TABLE RateMyMusic.Follows;
DROP TABLE RateMyMusic.User1;
DROP TABLE RateMyMusic.User2;
DROP TABLE RateMyMusic.User3;
DROP TABLE RateMyMusic.User4;


CREATE TABLE IF NOT EXISTS RateMyMusic.User4 (
    pid INTEGER PRIMARY KEY,
    birthdate DATE,
    birthplace VARCHAR(50),
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100),
    profile_pic LONGBLOB
);

CREATE TABLE IF NOT EXISTS RateMyMusic.User3 (
    username VARCHAR(50),
    birthdate DATE,
    age INTEGER,
    PRIMARY KEY (username, birthdate),
    FOREIGN KEY (username) REFERENCES User4(username)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.User2 (
    username VARCHAR(50) PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    FOREIGN KEY (username) REFERENCES User4(username)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.User1 (
    username VARCHAR(50) PRIMARY KEY,
    email VARCHAR(300) NOT NULL,
    FOREIGN KEY (username) REFERENCES User4(username)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.Follows (
    followerid INTEGER,
    followeeid INTEGER,
    follow_date DATE NOT NULL,
    PRIMARY KEY (followerid, followeeid),
    FOREIGN KEY (followerid) REFERENCES User4(pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (followeeid) REFERENCES User4(pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.Artist2 (
    pid INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    birthdate DATE,
    birthplace VARCHAR(50),
    genre VARCHAR(50) NOT NULL,
    description VARCHAR(1000),
    label VARCHAR(50),
    is_dead BOOLEAN,
    artist_pic LONGBLOB,
    UNIQUE (name, birthdate, is_dead)
);

CREATE TABLE IF NOT EXISTS RateMyMusic.Artist1 (
    name VARCHAR(50),
    birthdate DATE,
    is_dead BOOLEAN,
    age INTEGER,
    PRIMARY KEY (name, birthdate, is_dead),
    FOREIGN KEY (name, birthdate, is_dead) REFERENCES Artist2(name, birthdate, is_dead)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.Review2 (
    rid INTEGER,
    pid INTEGER,
    review_date DATETIME,
    review_text VARCHAR(5000) NOT NULL,
    likes INTEGER NOT NULL,
    dislikes INTEGER NOT NULL,
    UNIQUE (review_date, likes, dislikes),
    PRIMARY KEY (rid, pid),
    FOREIGN KEY (pid) REFERENCES User4(pid)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS RateMyMusic.Review1 (
    review_date DATETIME,
    likes INTEGER,
    dislikes INTEGER,
    helpfulness INTEGER,
    PRIMARY KEY (review_date, likes, dislikes),
    FOREIGN KEY (review_date, likes, dislikes) REFERENCES Review2(review_date, likes, dislikes)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.Comment2 (
    comment_date DATETIME,
    comment_text VARCHAR(5000) NOT NULL,
    likes INTEGER NOT NULL,
    dislikes INTEGER NOT NULL,
    rid INTEGER,
    review_pid INTEGER,
    comment_pid INTEGER,
    UNIQUE (comment_date, likes, dislikes),
    PRIMARY KEY (comment_date, review_pid, rid),
    FOREIGN KEY (review_pid) REFERENCES User4(pid)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
    FOREIGN KEY (comment_pid) REFERENCES User4(pid)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
    FOREIGN KEY (review_pid, rid) REFERENCES Review2(pid, rid)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.Comment1 (
    comment_date DATETIME,
    likes INTEGER,
    dislikes INTEGER,
    position INTEGER,
    PRIMARY KEY (comment_date, likes, dislikes),
    FOREIGN KEY (comment_date, likes, dislikes) REFERENCES Comment2(comment_date, likes, dislikes)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.Album (
    album_name VARCHAR(100),
    release_date DATE,
    isSingle BOOLEAN NOT NULL,
    genre VARCHAR(50) NOT NULL,
    duration INTEGER NOT NULL,
    cover LONGBLOB NULL,
    number_of_songs INTEGER NOT NULL,
    PRIMARY KEY (album_name, release_date),
    UNIQUE (album_name, duration),
    UNIQUE (album_name, number_of_songs)
);

CREATE TABLE IF NOT EXISTS RateMyMusic.Song (
    song_name VARCHAR(100),
    release_date DATE,
    duration INTEGER NOT NULL,
    genre VARCHAR(50) NOT NULL,
    PRIMARY KEY (song_name, release_date),
    UNIQUE (song_name, duration)
);

ALTER TABLE Song ADD FULLTEXT INDEX index_table_on_song_name (song_name);

CREATE TABLE IF NOT EXISTS RateMyMusic.AlbumSong (
    album_name VARCHAR(100),
    album_release_date DATE,
    song_name VARCHAR(100),
    song_release_date DATE,
    PRIMARY KEY (album_name, album_release_date, song_name, song_release_date),
    FOREIGN KEY (album_name, album_release_date) REFERENCES Album(album_name, release_date)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (song_name, song_release_date) REFERENCES Song(song_name, release_date)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.ArtistAlbum (
    pid INTEGER,
    album_name VARCHAR(100),
    release_date DATE,
    PRIMARY KEY (pid, album_name, release_date),
    FOREIGN KEY (pid) REFERENCES Artist2(pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (album_name, release_date) REFERENCES Album(album_name, release_date)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.ArtistSong (
    pid INTEGER,
    song_name VARCHAR(100),
    release_date DATE,
    PRIMARY KEY (pid, song_name, release_date),
    FOREIGN KEY (pid) REFERENCES Artist2(pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (song_name, release_date) REFERENCES Song(song_name, release_date)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.AlbumReview (
    pid INTEGER,
    rid INTEGER,
    album_name VARCHAR(100),
    release_date DATE,
    rating INTEGER NOT NULL,
    PRIMARY KEY (pid, rid, album_name, release_date),
    FOREIGN KEY (pid, rid) REFERENCES Review2(pid, rid)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (album_name, release_date) REFERENCES Album(album_name, release_date)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.SongReview (
    pid INTEGER,
    rid INTEGER,
    song_name VARCHAR(100),
    release_date DATE,
    rating INTEGER NOT NULL,
    PRIMARY KEY (pid, rid, song_name, release_date),
    FOREIGN KEY (pid, rid) REFERENCES Review2(pid, rid)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (song_name, release_date) REFERENCES Song(song_name, release_date)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.Playlist (
    pid INTEGER,
    playlist_name VARCHAR(50),
    creation_date DATE,
    image LONGBLOB NULL,
    description VARCHAR(5000),
    PRIMARY KEY (pid, playlist_name, creation_date),
    FOREIGN KEY (pid) REFERENCES User4(pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.PlaylistSong (
    pid INTEGER,
    playlist_name VARCHAR(50),
    creation_date DATE,
    song_name VARCHAR(100),
    release_date DATE,
    PRIMARY KEY (pid, playlist_name, creation_date, song_name, release_date),
    FOREIGN KEY (pid, playlist_name, creation_date) REFERENCES Playlist(pid, playlist_name, creation_date)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (song_name, release_date) REFERENCES Song(song_name, release_date)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.UserChart (
    ucid INTEGER,
    userchart_name VARCHAR(50) NOT NULL,
    image LONGBLOB,
    pid INTEGER,
    PRIMARY KEY (ucid, pid),
    FOREIGN KEY (pid) REFERENCES User4(pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.UserChartAlbum (
    ucid INTEGER,
    pid INTEGER,
    album_name VARCHAR(100),
    release_date DATE,
    ranking INTEGER,
    PRIMARY KEY (ucid, pid, album_name, release_date),
    FOREIGN KEY (ucid, pid) REFERENCES UserChart(ucid, pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (album_name, release_date) REFERENCES Album(album_name, release_date)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS RateMyMusic.UserChartReview (
    ucid INTEGER,
    uc_pid INTEGER,
    rv_pid INTEGER,
    rid INTEGER,
    rating INTEGER NOT NULL,
    PRIMARY KEY (ucid, uc_pid, rv_pid, rid),
    FOREIGN KEY (ucid, uc_pid) REFERENCES UserChart(ucid, pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (rv_pid, rid) REFERENCES Review2(pid, rid)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

insert into RateMyMusic.User4 (pid, birthdate, birthplace, username, password, profile_pic)
values  (10727, '2013-11-11', 'Iran', 'mercurylover', 'x', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/Nerd.jpeg')),
        (34049, '2003-05-05', 'Sydney, Australia', 'ardster', 'a', null),
        (44550, '1110-12-31', 'yash', 'yash', 'yash', null),
        (58708, '2023-11-10', 'n', 'n', 'n', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/Scenery.jpg')),
        (70527, '2003-05-05', '9', '9', '7', null),
        (76138, '2023-11-07', 'russia', 'Gangwar', 'greg', null),
        (76981, '1110-12-31', 'a', 'a', 'a', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/ALL-AMERIKKKAN BADA$$.jpg')),
        (29384756, '2000-06-27', 'Texas, USA', 'squaresalad', 'Egalitarianism', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/Worker.jpg')),
        (41902873, '1968-11-02', 'Indiana, USA', 'twocoffeeonemommy', 'ilovemygrandkids123', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/Future.jpg')),
        (62519038, '2014-09-19', 'Ontario, Canada', 'PORK_MAN', 'Fortnite@123', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/Pigman.jpg')),
        (80172634, '1945-12-12', 'New Jersey, USA', 'tillyfumpy', 'ChickenButt', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/Farmer.jpg')),
        (83726415, '2003-05-28', 'Manitoba, Canada', 'AngelPretty', 'makeup1', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/Ice.jpg'));

insert into RateMyMusic.User3 (username, birthdate, age)
values  ('9', '2003-05-05', 20),
        ('a', '1110-12-31', 10),
        ('AngelPretty', '2003-05-28', 20),
        ('ardster', '2003-05-05', 10),
        ('Gangwar', '2023-11-07', 10),
        ('mercurylover', '2013-11-11', 10),
        ('n', '2023-11-10', 10),
        ('PORK_MAN', '2014-09-19', 9),
        ('squaresalad', '2000-06-27', 23),
        ('tillyfumpy', '1945-12-12', 77),
        ('twocoffeeonemommy', '1968-11-02', 55),
        ('yash', '1110-12-31', 912);

insert into RateMyMusic.User2 (username, name)
values  ('9', '7'),
        ('a', 'a'),
        ('AngelPretty', 'Sofia Cavalry'),
        ('ardster', 'Ardi'),
        ('Gangwar', 'Gregory'),
        ('mercurylover', 'Amin'),
        ('n', 'n'),
        ('PORK_MAN', 'Hunter McKinnon'),
        ('squaresalad', 'James Diaz'),
        ('tillyfumpy', 'Howard Buggs'),
        ('twocoffeeonemommy', 'Brenda Hepburn'),
        ('yash', 'yash');

insert into RateMyMusic.User1 (username, email)
values  ('9', '7'),
        ('a', 'a'),
        ('AngelPretty', 'pretty_angel458@hotmial.com'),
        ('ardster', 'ardi@ardi.com'),
        ('Gangwar', 'greg@gmal.com'),
        ('mercurylover', 'ramlover@aol.com'),
        ('n', 'n'),
        ('PORK_MAN', 'zapbran7777@gmail.com'),
        ('squaresalad', 'diaz.minecraft@gmail.com'),
        ('tillyfumpy', 'Howard.S.Buggs1945@gmail.com'),
        ('twocoffeeonemommy', 'brenda.hepburn1968@gmail.com'),
        ('yash', 'yash@yash.yash');

insert into RateMyMusic.Follows (followerid, followeeid, follow_date)
values  (10727, 80172634, '2023-11-28'),
        (10727, 83726415, '2023-11-28'),
        (58708, 70527, '2023-11-30'),
        (58708, 76981, '2023-11-29'),
        (58708, 83726415, '2023-11-29'),
        (62519038, 29384756, '2023-05-05'),
        (62519038, 41902873, '2023-05-05'),
        (62519038, 62519038, '2023-05-05'),
        (62519038, 80172634, '2023-05-05'),
        (62519038, 83726415, '2023-05-05');

INSERT
INTO Artist2(pid, name, birthdate, birthplace, genre, description, label, is_dead, artist_pic)
VALUES (52033688, 'Ryo Fukui', '1948-06-01', 'Biratori, Hokkaido, Japan', 'Jazz',
        'Ryo Fukui was a Japanese jazz pianist, he regularly played at his own "Slowboat" jazz club in Sapporo. His work has seen a spike in popularity after his death, around the year 2010. ',
        'Independent', 1, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/artists/Ryo Fukui.jpeg')),
       (62043498, 'NAV', '1989-11-03', 'Toronto, Canada', 'Hip-Hop',
        'Navraj Singh Goraya, known professionally as Nav, is a Canadian rapper, singer, songwriter, and record producer.',
        'XO', 0, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/artists/NAV.jpg')),
       (32512674, 'Drake', '1986-10-24', 'Toronto, Canada', 'Hip-Hop',
        'Aubrey Drake Graham, known professionally as Drake, is a Canadian rapper, singer, songwriter, and actor. He first gained major recognition as a rapper following the release of his mixtape "Room for Improvement" in 2006.',
        'OVO Sound', 0, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/artists/Drake.jpg')),
       (89320472, 'Kanye West', '1977-06-08', 'Atlanta, Georgia, USA', 'Hip-Hop',
        'Kanye Omari West is an American rapper, singer, songwriter, record producer, and fashion designer. He is widely regarded as one of the most influential musicians of his generation.',
        'GOOD Music', 0, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/artists/Kanye.jpg')),
       (48297392, 'Kendrick Lamar', '1987-06-17', 'Compton, California, USA', 'Hip-Hop',
        'Kendrick Lamar Duckworth, known as Kendrick Lamar, is an American rapper, songwriter, and record producer. He is regarded as one of the most skillful and successful hip-hop artists of his generation.',
        'Top Dawg Entertainment', 0, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/artists/Kendrick.jpg'));

INSERT
INTO Artist1(name, birthdate, is_dead, age)
VALUES ('Ryo Fukui', '1948-06-01', 1, 67),
       ('NAV', '1989-11-03', 0, 34),
       ('Drake', '1986-10-24', 0, 36),
       ('Kanye West', '1977-06-08', 0, 46),
       ('Kendrick Lamar', '1987-06-17', 0, 36);

insert into RateMyMusic.Review2 (rid, pid, review_date, review_text, likes, dislikes)
values  (10031, 58708, '2023-11-29 15:23:13', 'Nice song wow', 0, 0),
        (10153, 58708, '2023-11-29 15:48:16', 'meh', 0, 0),
        (10164, 44550, '2023-11-29 19:57:10', 'mid', 0, 0),
        (10471, 58708, '2023-11-30 00:51:07', 'great chart howard!!!', 0, 0),
        (10484, 58708, '2023-11-30 01:14:04', 'tttt', 0, 0),
        (10502, 41902873, '2023-11-25 00:00:00', 'THIS IS GREAT', 0, 0),
        (10555, 83726415, '2023-11-28 18:21:08', '10 bands heck yeah', 0, 0),
        (10604, 83726415, '2023-11-29 15:37:44', 'drake yip yip', 0, 0),
        (12345, 62519038, '2023-11-24 12:00:00', 'Testing division!', 0, 0),
        (28249, 58708, '2023-12-01 00:28:23', 'pretty decent actually', 0, 0),
        (39374, 58708, '2023-12-01 00:27:37', 'sooooooo overrated', 0, 0),
        (39527, 58708, '2023-12-01 00:27:00', 'alright i guess', 0, 0),
        (44873, 58708, '2023-11-29 15:23:38', 'i hate shrey', 0, 0),
        (46653, 58708, '2023-12-01 00:27:07', 'LOVE IT', 0, 0),
        (57874, 58708, '2023-12-01 00:27:25', 'I think that it could be better', 0, 0),
        (65383, 58708, '2023-12-01 00:27:47', 'sooooooo amazing!', 0, 0),
        (66620, 58708, '2023-12-01 00:28:40', 'horrible', 0, 0),
        (12312312, 83726415, '2023-09-11 00:00:00', 'This is an amazing!', 20, 345),
        (23423423, 41902873, '2023-09-12 00:00:00', 'I really enjoyed.', 30, 0),
        (34534534, 62519038, '2023-09-13 00:00:00', 'Not my cup of tea.', 5, 3),
        (45645645, 29384756, '2023-09-14 00:00:00', 'Decent effort.', 19, 5),
        (56756756, 80172634, '2023-09-15 00:00:00', 'Could have been better.', 27, 18),
        (67867867, 83726415, '2023-09-16 00:00:00', 'Absolutely breathtaking!', 25, 10),
        (67867868, 41902873, '2023-09-17 00:00:00', 'This track is fire.', 35, 0),
        (67867869, 62519038, '2023-09-18 00:00:00', 'A decent song but not my taste.', 15, 7),
        (67867870, 29384756, '2023-09-19 00:00:00', 'A classic, never gets old.', 29, 6),
        (67867871, 80172634, '2023-09-20 00:00:00', 'This song speaks volumes.', 37, 9),
        (67867872, 41902873, '2023-09-21 00:00:00', 'This user chart has a great selection of albums!', 40, 4),
        (67867873, 83726415, '2023-09-21 00:00:00', 'WOW!', 40, 7),
        (67867874, 83726415, '2023-09-22 00:00:00', 'This kind of sucks ngl', 20, 400),
        (67867875, 83726415, '2023-09-24 00:00:00', 'Great!', 47, 1),
        (67867876, 83726415, '2023-09-26 00:00:00', 'Sucks!', 15, 45);

insert into RateMyMusic.Review1 (review_date, likes, dislikes, helpfulness)
values  ('2023-09-11 00:00:00', 20, 345, 0),
        ('2023-09-12 00:00:00', 30, 0, 5),
        ('2023-09-13 00:00:00', 5, 3, 3),
        ('2023-09-14 00:00:00', 19, 5, 4),
        ('2023-09-15 00:00:00', 27, 18, 2),
        ('2023-09-16 00:00:00', 25, 10, 5),
        ('2023-09-17 00:00:00', 35, 0, 10),
        ('2023-09-18 00:00:00', 15, 7, 7),
        ('2023-09-19 00:00:00', 29, 6, 9),
        ('2023-09-20 00:00:00', 37, 9, 8),
        ('2023-09-21 00:00:00', 40, 4, 10),
        ('2023-11-24 12:00:00', 0, 0, 0),
        ('2023-11-28 18:21:08', 0, 0, 0),
        ('2023-11-29 15:23:13', 0, 0, 0),
        ('2023-11-29 15:23:38', 0, 0, 0),
        ('2023-11-29 15:37:44', 0, 0, 0),
        ('2023-11-29 15:48:16', 0, 0, 0),
        ('2023-11-29 19:57:10', 0, 0, 0),
        ('2023-11-30 00:51:07', 0, 0, 0),
        ('2023-11-30 01:14:04', 0, 0, 0),
        ('2023-12-01 00:27:00', 0, 0, 0),
        ('2023-12-01 00:27:07', 0, 0, 0),
        ('2023-12-01 00:27:25', 0, 0, 0),
        ('2023-12-01 00:27:37', 0, 0, 0),
        ('2023-12-01 00:27:47', 0, 0, 0),
        ('2023-12-01 00:28:23', 0, 0, 0),
        ('2023-12-01 00:28:40', 0, 0, 0);

insert into RateMyMusic.Comment2 (comment_date, comment_text, likes, dislikes, rid, review_pid, comment_pid)
values  ('2023-10-19 10:00:00', 'Loved this!', 45, 2, 12312312, 83726415, 58708),
        ('2023-10-19 11:00:00', 'Absolutely agree.', 50, 1, 23423423, 41902873, 58708),
        ('2023-10-19 12:30:00', 'I have mixed feelings.', 38, 10, 34534534, 62519038, 58708),
        ('2023-10-19 13:45:00', 'Nice perspective!', 24, 4, 45645645, 29384756, 58708),
        ('2023-10-19 15:00:00', 'Found this insightful.', 60, 5, 56756756, 80172634, 58708),
        ('2023-11-28 19:44:43', 'sodia you weirdo', 0, 0, 10555, 83726415, 58708),
        ('2023-11-28 19:45:20', 'i am not weird.', 0, 0, 10555, 83726415, 83726415),
        ('2023-11-28 19:46:13', 'ur prety weird buddy jus sayin', 0, 0, 10555, 83726415, 58708),
        ('2023-11-28 20:05:28', '12', 0, 0, 10555, 83726415, 58708),
        ('2023-11-29 02:37:09', '34', 0, 0, 10555, 83726415, 58708),
        ('2023-11-29 02:49:49', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 0, 0, 10555, 83726415, 58708),
        ('2023-11-29 15:34:04', 'branda you did it again', 0, 0, 67867868, 41902873, 41902873),
        ('2023-11-29 16:02:16', 'mid', 0, 0, 10031, 58708, 70527),
        ('2023-11-29 16:02:25', 'i love you', 0, 0, 10031, 58708, 70527),
        ('2023-11-29 16:09:09', 'I love you', 0, 0, 10031, 58708, 70527),
        ('2023-11-29 16:09:31', 'why', 0, 0, 10031, 58708, 70527),
        ('2023-11-29 16:11:01', 'you great', 0, 0, 10031, 58708, 76981),
        ('2023-11-29 16:11:49', 'you great', 0, 0, 10031, 58708, 76981),
        ('2023-11-29 16:13:04', 'man screw u', 0, 0, 10031, 58708, 76981),
        ('2023-11-29 16:14:51', 'lolllllll', 0, 0, 10031, 58708, 76981),
        ('2023-11-29 16:15:22', 'lolllllll', 0, 0, 10031, 58708, 76981),
        ('2023-11-29 16:15:50', 'yoooo', 0, 0, 10031, 58708, 76981),
        ('2023-11-29 16:15:59', 'yoooo', 0, 0, 10031, 58708, 76981),
        ('2023-11-29 16:31:38', 'pls work', 0, 0, 10031, 58708, 76981),
        ('2023-11-29 16:31:42', 'pls work', 0, 0, 10031, 58708, 76981),
        ('2023-11-29 16:31:52', 'oml', 0, 0, 10031, 58708, 76981),
        ('2023-11-29 19:57:53', 'yy', 0, 0, 10031, 58708, 44550),
        ('2023-11-29 20:40:58', 'etst', 0, 0, 10555, 83726415, 58708),
        ('2023-11-29 20:41:15', 'etst', 0, 0, 10555, 83726415, 58708),
        ('2023-11-29 20:41:16', 'etst', 0, 0, 10555, 83726415, 58708),
        ('2023-11-29 20:41:17', 'etst', 0, 0, 10555, 83726415, 58708),
        ('2023-11-30 02:33:59', 'a', 0, 0, 10031, 58708, 58708),
        ('2023-11-30 03:19:25', 'bad review man i hate this', 0, 0, 10484, 58708, 76981);

insert into RateMyMusic.Comment1 (comment_date, likes, dislikes, position)
values  ('2023-10-19 10:00:00', 45, 2, 1),
        ('2023-10-19 11:00:00', 50, 1, 2),
        ('2023-10-19 12:30:00', 38, 10, 3),
        ('2023-10-19 13:45:00', 24, 4, 4),
        ('2023-10-19 15:00:00', 60, 5, 5),
        ('2023-11-28 19:44:43', 0, 0, 0),
        ('2023-11-28 19:45:20', 0, 0, 0),
        ('2023-11-28 19:46:13', 0, 0, 0),
        ('2023-11-28 20:05:28', 0, 0, 0),
        ('2023-11-29 02:37:09', 0, 0, 0),
        ('2023-11-29 02:49:49', 0, 0, 0),
        ('2023-11-29 15:34:04', 0, 0, 0),
        ('2023-11-29 16:02:16', 0, 0, 0),
        ('2023-11-29 16:02:25', 0, 0, 0),
        ('2023-11-29 16:09:09', 0, 0, 0),
        ('2023-11-29 16:09:31', 0, 0, 0),
        ('2023-11-29 16:11:01', 0, 0, 0),
        ('2023-11-29 16:11:49', 0, 0, 0),
        ('2023-11-29 16:13:04', 0, 0, 0),
        ('2023-11-29 16:14:51', 0, 0, 0),
        ('2023-11-29 16:15:22', 0, 0, 0),
        ('2023-11-29 16:15:50', 0, 0, 0),
        ('2023-11-29 16:15:59', 0, 0, 0),
        ('2023-11-29 16:31:38', 0, 0, 0),
        ('2023-11-29 16:31:42', 0, 0, 0),
        ('2023-11-29 16:31:52', 0, 0, 0),
        ('2023-11-29 19:57:53', 0, 0, 0),
        ('2023-11-29 20:40:58', 0, 0, 0),
        ('2023-11-29 20:41:15', 0, 0, 0),
        ('2023-11-29 20:41:16', 0, 0, 0),
        ('2023-11-29 20:41:17', 0, 0, 0),
        ('2023-11-30 02:33:59', 0, 0, 0),
        ('2023-11-30 03:19:25', 0, 0, 0);

insert into RateMyMusic.Album (album_name, release_date, isSingle, genre, duration, cover, number_of_songs)
values ('Scenery', '1976-02-01', false, 'Jazz', 644, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/albums/Scenery.jpg'), 6),
       ('Good Intentions', '2020-05-08', false, 'Rap', 179, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/albums/Good Intentions.jpg'), 12),
       ('If You''re Reading This It''s Too Late', '2015-02-13', false, 'Rap', 299, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/albums/If You''re Reading This It''s Too Late.jpg'), 17),
       ('The College Dropout', '2003-09-30', false, 'Hip hop/UK R&B', 226, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/albums/College Dropout.jpg'), 15),
       ('To Pimp a Butterfly', '2015-03-15', false, 'Hip hop/Rap', 275, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/albums/To Pimp a Butterfly.jpg'), 16),
       ('good kid, m.A.A.d city', '2012-10-22', 0, 'Hip-Hop', 5745, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/good kid, m.A.A.d city.jpg'), 17),
       ('Late Registration', '2005-08-30', 0, 'Rap', 2443, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/Late Registration.jpg'), 21),
       ('Section 80', '2011-07-02', 0, 'Rap', 2333 ,LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/Section.80.jpg'), 15),
       ('Scorpion', '2018-06-29', 0, 'Rap', 2344, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/Scorpion.jpg'), 25),
       ('DAMN', '2017-04-17', 0, 'Rap', 4355, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/DAMN..jpg'),  14),
       ('Mr. Morale & the Big Steppers', '2022-05-13', 0, 'Rap', 23424, LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/Mr. Morale & The Big Steppers.jpg'), 18);

insert into RateMyMusic.Song (song_name, release_date, duration, genre)
values  ('10 Bands', '2015-02-13', 178, 'Rap'),
        ('6 God', '2015-02-13', 181, 'Rap'),
        ('6 Man', '2015-02-13', 168, 'Rap'),
        ('6PM In New York', '2015-02-13', 283, 'Rap'),
        ('All Falls Down (ft. Syleena Johnson)', '2003-09-30', 224, 'Hip hop/UK R&B'),
        ('Backseat Freestyle', '2012-10-22', 210, 'Hip-Hop'),
        ('Bitch, Don’t Kill My Vibe', '2012-10-22', 314, 'Hip-Hop'),
        ('Black Boy Fly', '2012-10-22', 295, 'Hip-Hop'),
        ('Breathe In Breathe Out (ft. Ludacris)', '2003-09-30', 246, 'Hip hop/UK R&B'),
        ('Company (ft. Travi$ Scott)', '2015-02-13', 253, 'Rap'),
        ('Compton (ft. Dr. Dre)', '2012-10-22', 284, 'Hip-Hop'),
        ('Did You Wrong', '2020-05-08', 179, 'Rap'),
        ('Energy', '2015-02-13', 182, 'Rap'),
        ('Family Business', '2003-09-30', 278, 'Hip hop/UK R&B'),
        ('Get Em High (feat. Talib Kweli & Common)', '2003-09-30', 289, 'Hip hop/UK R&B'),
        ('good kid', '2012-10-22', 228, 'Hip-Hop'),
        ('Graduation Day', '2003-09-30', 82, 'Hip hop/UK R&B'),
        ('I''l Fly Away', '2003-09-30', 70, 'Hip hop/UK R&B'),
        ('Intro', '2003-09-30', 19, 'Hip hop/UK R&B'),
        ('Jesus Walks', '2003-09-30', 193, 'Hip hop/UK R&B'),
        ('Jungle', '2015-02-13', 320, 'Rap'),
        ('Know Yourself', '2015-02-13', 100, 'Rap'),
        ('Last Call', '2003-09-30', 760, 'Hip hop/UK R&B'),
        ('Legend', '2015-02-13', 242, 'Rap'),
        ('Lil Jimmy Skit', '2003-09-30', 53, 'Hip hop/UK R&B'),
        ('m.A.A.d city (ft. MC Eiht)', '2012-10-22', 330, 'Hip-Hop'),
        ('Madonna', '2015-02-13', 178, 'Rap'),
        ('Money Trees (ft. Jay Rock)', '2012-10-22', 397, 'Hip-Hop'),
        ('Never Let Me Down (ft. JAY-Z & J. Ivy)', '2003-09-30', 324, 'Hip hop/UK R&B'),
        ('No Tellin''', '2015-02-13', 311, 'Rap'),
        ('Now & Forever', '2015-02-13', 281, 'Rap'),
        ('Now or Never (ft. Mary J. Blige)', '2012-10-22', 353, 'Hip-Hop'),
        ('Poetic Justice (ft. Drake)', '2012-10-22', 311, 'Hip-Hop'),
        ('Preach (ft. PARTYNEXTDOOR)', '2015-02-13', 237, 'Rap'),
        ('Real (ft. Anna Wise)', '2012-10-22', 335, 'Hip-Hop'),
        ('School Spirit', '2003-09-30', 182, 'Hip hop/UK R&B'),
        ('School Spirit Skit 1', '2003-09-30', 43, 'Hip hop/UK R&B'),
        ('School Spirit Skit 2', '2003-09-30', 26, 'Hip hop/UK R&B'),
        ('Sherane a.k.a Master Splinter’s Daughter', '2012-10-22', 342, 'Hip-Hop'),
        ('Sing About Me, I’m Dying of Thirst', '2012-10-22', 808, 'Hip-Hop'),
        ('Slow Jamz', '2003-09-30', 316, 'Hip hop/UK R&B'),
        ('Spaceship (ft. GLC & Consequence)', '2003-09-30', 324, 'Hip hop/UK R&B'),
        ('Star67', '2015-02-13', 295, 'Rap'),
        ('Swimming Pools (Drank)', '2012-10-22', 319, 'Hip-Hop'),
        ('The Art of Peer Pressure', '2012-10-22', 331, 'Hip-Hop'),
        ('The New Workout Plan', '2003-09-30', 322, 'Hip hop/UK R&B'),
        ('The Recipe (ft. Dr. Dre)', '2012-10-22', 320, 'Hip-Hop'),
        ('Through the Wire', '2003-09-30', 100, 'Hip hop/UK R&B'),
        ('Two Words (ft. Mos Def, Freeway & The Boys Choir of Harlem)', '2003-09-30', 265, 'Hip hop/UK R&B'),
        ('Used To (ft. Lil Wayne)', '2015-02-13', 268, 'Rap'),
        ('We Don''t Care', '2003-09-30', 240, 'Hip hop/UK R&B'),
        ('Wednesday Night Interlude (ft. PARTYNEXTDOOR)', '2015-02-13', 212, 'Rap'),
        ('Wesley’s Theory', '2015-03-15', 100, 'Hip hop/Rap'),
        ('Workout Plan', '2003-09-30', 46, 'Hip hop/UK R&B'),
        ('You & The 6', '2015-02-13', 265, 'Rap'),
        ('Roses', '2005-08-30', 244, 'Rap'),
        ('A.D.H,D.', '2011-07-02', 215, 'Rap'),
        ('Survival', '2018-06-29', 232, 'Rap'),
        ('DUCKWORTH', '2018-06-29', 232, 'Rap'),
        ('N95', '2022-05-13', 232, 'Rap');

insert into RateMyMusic.AlbumSong (album_name, album_release_date, song_name, song_release_date)
values  ('If You''re Reading This It''s Too Late', '2015-02-13', '10 Bands', '2015-02-13'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', '6 God', '2015-02-13'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', '6 Man', '2015-02-13'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', '6PM In New York', '2015-02-13'),
        ('The College Dropout', '2003-09-30', 'All Falls Down (ft. Syleena Johnson)', '2003-09-30'),
        ('good kid, m.A.A.d city', '2012-10-22', 'Backseat Freestyle', '2012-10-22'),
        ('good kid, m.A.A.d city', '2012-10-22', 'Bitch, Don’t Kill My Vibe', '2012-10-22'),
        ('good kid, m.A.A.d city', '2012-10-22', 'Black Boy Fly', '2012-10-22'),
        ('The College Dropout', '2003-09-30', 'Breathe In Breathe Out (ft. Ludacris)', '2003-09-30'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'Company (ft. Travi$ Scott)', '2015-02-13'),
        ('good kid, m.A.A.d city', '2012-10-22', 'Compton (ft. Dr. Dre)', '2012-10-22'),
        ('Good Intentions', '2020-05-08', 'Did You Wrong', '2020-05-08'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'Energy', '2015-02-13'),
        ('The College Dropout', '2003-09-30', 'Family Business', '2003-09-30'),
        ('The College Dropout', '2003-09-30', 'Get Em High (feat. Talib Kweli & Common)', '2003-09-30'),
        ('good kid, m.A.A.d city', '2012-10-22', 'good kid', '2012-10-22'),
        ('The College Dropout', '2003-09-30', 'Graduation Day', '2003-09-30'),
        ('The College Dropout', '2003-09-30', 'I''l Fly Away', '2003-09-30'),
        ('The College Dropout', '2003-09-30', 'Intro', '2003-09-30'),
        ('The College Dropout', '2003-09-30', 'Jesus Walks', '2003-09-30'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'Jungle', '2015-02-13'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'Know Yourself', '2015-02-13'),
        ('The College Dropout', '2003-09-30', 'Last Call', '2003-09-30'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'Legend', '2015-02-13'),
        ('The College Dropout', '2003-09-30', 'Lil Jimmy Skit', '2003-09-30'),
        ('good kid, m.A.A.d city', '2012-10-22', 'm.A.A.d city (ft. MC Eiht)', '2012-10-22'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'Madonna', '2015-02-13'),
        ('good kid, m.A.A.d city', '2012-10-22', 'Money Trees (ft. Jay Rock)', '2012-10-22'),
        ('The College Dropout', '2003-09-30', 'Never Let Me Down (ft. JAY-Z & J. Ivy)', '2003-09-30'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'No Tellin''', '2015-02-13'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'Now & Forever', '2015-02-13'),
        ('good kid, m.A.A.d city', '2012-10-22', 'Now or Never (ft. Mary J. Blige)', '2012-10-22'),
        ('good kid, m.A.A.d city', '2012-10-22', 'Poetic Justice (ft. Drake)', '2012-10-22'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'Preach (ft. PARTYNEXTDOOR)', '2015-02-13'),
        ('good kid, m.A.A.d city', '2012-10-22', 'Real (ft. Anna Wise)', '2012-10-22'),
        ('The College Dropout', '2003-09-30', 'School Spirit', '2003-09-30'),
        ('The College Dropout', '2003-09-30', 'School Spirit Skit 1', '2003-09-30'),
        ('The College Dropout', '2003-09-30', 'School Spirit Skit 2', '2003-09-30'),
        ('good kid, m.A.A.d city', '2012-10-22', 'Sherane a.k.a Master Splinter’s Daughter', '2012-10-22'),
        ('good kid, m.A.A.d city', '2012-10-22', 'Sing About Me, I’m Dying of Thirst', '2012-10-22'),
        ('The College Dropout', '2003-09-30', 'Slow Jamz', '2003-09-30'),
        ('The College Dropout', '2003-09-30', 'Spaceship (ft. GLC & Consequence)', '2003-09-30'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'Star67', '2015-02-13'),
        ('good kid, m.A.A.d city', '2012-10-22', 'Swimming Pools (Drank)', '2012-10-22'),
        ('good kid, m.A.A.d city', '2012-10-22', 'The Art of Peer Pressure', '2012-10-22'),
        ('The College Dropout', '2003-09-30', 'The New Workout Plan', '2003-09-30'),
        ('good kid, m.A.A.d city', '2012-10-22', 'The Recipe (ft. Dr. Dre)', '2012-10-22'),
        ('The College Dropout', '2003-09-30', 'Through the Wire', '2003-09-30'),
        ('The College Dropout', '2003-09-30', 'Two Words (ft. Mos Def, Freeway & The Boys Choir of Harlem)', '2003-09-30'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'Used To (ft. Lil Wayne)', '2015-02-13'),
        ('The College Dropout', '2003-09-30', 'We Don''t Care', '2003-09-30'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'Wednesday Night Interlude (ft. PARTYNEXTDOOR)', '2015-02-13'),
        ('To Pimp a Butterfly', '2015-03-15', 'Wesley’s Theory', '2015-03-15'),
        ('The College Dropout', '2003-09-30', 'Workout Plan', '2003-09-30'),
        ('If You''re Reading This It''s Too Late', '2015-02-13', 'You & The 6', '2015-02-13'),
        ('Late Registration', '2005-08-30', 'Roses', '2005-08-30'),
        ('Section 80', '2011-07-02', 'A.D.H,D.', '2011-07-02'),
        ('Scorpion', '2018-06-29', 'Survival', '2018-06-29'),
        ('DAMN', '2017-04-17', 'DUCKWORTH', '2018-06-29'),
        ('Mr. Morale & the Big Steppers', '2022-05-13', 'N95', '2022-05-13');

insert into RateMyMusic.ArtistSong (pid, song_name, release_date)
values  (32512674, '10 Bands', '2015-02-13'),
        (32512674, '6 God', '2015-02-13'),
        (32512674, '6 Man', '2015-02-13'),
        (32512674, '6PM In New York', '2015-02-13'),
        (89320472, 'All Falls Down (ft. Syleena Johnson)', '2003-09-30'),
        (48297392, 'Backseat Freestyle', '2012-10-22'),
        (48297392, 'Bitch, Don’t Kill My Vibe', '2012-10-22'),
        (48297392, 'Black Boy Fly', '2012-10-22'),
        (89320472, 'Breathe In Breathe Out (ft. Ludacris)', '2003-09-30'),
        (32512674, 'Company (ft. Travi$ Scott)', '2015-02-13'),
        (48297392, 'Compton (ft. Dr. Dre)', '2012-10-22'),
        (62043498, 'Did You Wrong', '2020-05-08'),
        (32512674, 'Energy', '2015-02-13'),
        (89320472, 'Family Business', '2003-09-30'),
        (89320472, 'Get Em High (feat. Talib Kweli & Common)', '2003-09-30'),
        (48297392, 'good kid', '2012-10-22'),
        (89320472, 'Graduation Day', '2003-09-30'),
        (89320472, 'I''l Fly Away', '2003-09-30'),
        (89320472, 'Intro', '2003-09-30'),
        (89320472, 'Jesus Walks', '2003-09-30'),
        (32512674, 'Jungle', '2015-02-13'),
        (32512674, 'Know Yourself', '2015-02-13'),
        (89320472, 'Last Call', '2003-09-30'),
        (32512674, 'Legend', '2015-02-13'),
        (89320472, 'Lil Jimmy Skit', '2003-09-30'),
        (48297392, 'm.A.A.d city (ft. MC Eiht)', '2012-10-22'),
        (32512674, 'Madonna', '2015-02-13'),
        (48297392, 'Money Trees (ft. Jay Rock)', '2012-10-22'),
        (89320472, 'Never Let Me Down (ft. JAY-Z & J. Ivy)', '2003-09-30'),
        (32512674, 'No Tellin''', '2015-02-13'),
        (32512674, 'Now & Forever', '2015-02-13'),
        (48297392, 'Now or Never (ft. Mary J. Blige)', '2012-10-22'),
        (48297392, 'Poetic Justice (ft. Drake)', '2012-10-22'),
        (32512674, 'Preach (ft. PARTYNEXTDOOR)', '2015-02-13'),
        (48297392, 'Real (ft. Anna Wise)', '2012-10-22'),
        (89320472, 'School Spirit', '2003-09-30'),
        (89320472, 'School Spirit Skit 1', '2003-09-30'),
        (89320472, 'School Spirit Skit 2', '2003-09-30'),
        (48297392, 'Sherane a.k.a Master Splinter’s Daughter', '2012-10-22'),
        (48297392, 'Sing About Me, I’m Dying of Thirst', '2012-10-22'),
        (89320472, 'Slow Jamz', '2003-09-30'),
        (89320472, 'Spaceship (ft. GLC & Consequence)', '2003-09-30'),
        (32512674, 'Star67', '2015-02-13'),
        (48297392, 'Swimming Pools (Drank)', '2012-10-22'),
        (48297392, 'The Art of Peer Pressure', '2012-10-22'),
        (89320472, 'The New Workout Plan', '2003-09-30'),
        (48297392, 'The Recipe (ft. Dr. Dre)', '2012-10-22'),
        (89320472, 'Through the Wire', '2003-09-30'),
        (89320472, 'Two Words (ft. Mos Def, Freeway & The Boys Choir of Harlem)', '2003-09-30'),
        (32512674, 'Used To (ft. Lil Wayne)', '2015-02-13'),
        (89320472, 'We Don''t Care', '2003-09-30'),
        (32512674, 'Wednesday Night Interlude (ft. PARTYNEXTDOOR)', '2015-02-13'),
        (48297392, 'Wesley’s Theory', '2015-03-15'),
        (89320472, 'Workout Plan', '2003-09-30'),
        (32512674, 'You & The 6', '2015-02-13'),
        (89320472, 'Roses', '2005-08-30'),
        (48297392, 'A.D.H,D.', '2011-07-02'),
        (32512674, 'Survival', '2018-06-29'),
        (48297392, 'DUCKWORTH', '2018-06-29'),
        (48297392, 'N95', '2022-05-13');


insert into RateMyMusic.ArtistAlbum (pid, album_name, release_date)
values  (52033688, 'Scenery', '1976-02-01'),
        (62043498, 'Good Intentions', '2020-05-08'),
        (48297392, 'good kid, m.A.A.d city', '2012-10-22'),
        (32512674, 'If You''re Reading This It''s Too Late', '2015-02-13'),
        (89320472, 'The College Dropout', '2003-09-30'),
        (48297392, 'To Pimp a Butterfly', '2015-03-15'),
        (89320472, 'Late Registration', '2005-08-30'),
        (48297392, 'Section 80', '2011-07-02'),
        (32512674, 'Scorpion', '2018-06-29'),
        (48297392, 'DAMN', '2017-04-17'),
        (48297392, 'Mr. Morale & the Big Steppers', '2022-05-13');

insert into RateMyMusic.AlbumReview (pid, rid, album_name, release_date, rating)
values  (58708, 28249, 'Late Registration', '2005-08-30', 4),
        (58708, 39374, 'To Pimp a Butterfly', '2015-03-15', 0),
        (58708, 39527, 'Mr. Morale & the Big Steppers', '2022-05-13', 1),
        (58708, 44873, 'The College Dropout', '2003-09-30', 5),
        (58708, 46653, 'DAMN', '2017-04-17', 5),
        (58708, 57874, 'Section 80', '2011-07-02', 3),
        (58708, 65383, 'good kid, m.A.A.d city', '2012-10-22', 5),
        (58708, 66620, 'Scorpion', '2018-06-29', 0),
        (29384756, 45645645, 'The College Dropout', '2003-09-30', 5),
        (41902873, 23423423, 'Good Intentions', '2020-05-08', 4),
        (62519038, 12345, 'Good Intentions', '2020-05-08', 1),
        (62519038, 34534534, 'If You''re Reading This It''s Too Late', '2015-02-13', 5),
        (80172634, 56756756, 'To Pimp a Butterfly', '2015-03-15', 5);

insert into RateMyMusic.SongReview (pid, rid, song_name, release_date, rating)
values  (44550, 10164, '10 Bands', '2015-02-13', 1),
        (58708, 10031, 'good kid', '2012-10-22', 5),
        (58708, 10153, '10 Bands', '2015-02-13', 1),
        (29384756, 67867870, 'Through the Wire', '2003-09-30', 5),
        (41902873, 10502, 'Did You Wrong', '2020-05-08', 0),
        (41902873, 67867868, 'Did You Wrong', '2020-05-08', 4),
        (62519038, 67867869, 'Know Yourself', '2015-02-13', 5),
        (80172634, 67867871, 'Wesley’s Theory', '2015-03-15', 5),
        (83726415, 10555, '10 Bands', '2015-02-13', 5),
        (83726415, 10604, '6 God', '2015-02-13', 4);

insert into RateMyMusic.Playlist (pid, playlist_name, creation_date, image, description)
values  (58708, 'Drake and Other Cool Rappers', '2023-11-28', null, 'my goats!'),
        (58708, 'gbgbngbngbnbnbn', '2023-11-29', null, ''),
        (58708, 'hh', '2023-11-29', null, 'hh'),
        (58708, 'NAME', '2023-11-28', null, 'DESC'),
        (58708, 'Nice playlist', '2023-11-29', null, ''),
        (58708, 'super rap playlist', '2023-11-28', null, 'my rap songs i like a lot.'),
        (58708, 'Jazz Vibes', '2023-09-20', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/playlists/Jazz.jpg'), 'Relax with some smooth jazz tunes.'),
        (58708, 'Rap Essentials', '2023-09-21', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/playlists/Rap.jpg'), 'The hottest rap tracks right now.'),
        (58708, 'Hip Hop Classics', '2023-09-22', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/playlists/Hip Hop Classics.jpeg'),
         'Take a trip down memory lane with these hip hop classics.'),
        (58708, 'R&B Soul', '2023-09-23', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/playlists/R&B.jpg'), 'Soothing R&B for the soul.'),
        (58708, 'Top Hits', '2023-09-24', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/src/assets/playlists/Top Hits.jpg'), 'The chart-topping hits everyone is listening to.');

insert into RateMyMusic.PlaylistSong (pid, playlist_name, creation_date, song_name, release_date)
values  (58708, 'gbgbngbngbnbnbn', '2023-11-29', '10 Bands', '2015-02-13'),
        (58708, 'Nice playlist', '2023-11-29', '10 Bands', '2015-02-13'),
        (58708, 'hh', '2023-11-29', '6 God', '2015-02-13'),
        (58708, 'Drake and Other Cool Rappers', '2023-11-28', 'Did You Wrong', '2020-05-08'),
        (58708, 'NAME', '2023-11-28', 'Did You Wrong', '2020-05-08'),
        (58708, 'Rap Essentials', '2023-09-21', 'Did You Wrong', '2020-05-08'),
        (58708, 'super rap playlist', '2023-11-28', 'Did You Wrong', '2020-05-08'),
        (58708, 'Drake and Other Cool Rappers', '2023-11-28', 'Energy', '2015-02-13'),
        (58708, 'Nice playlist', '2023-11-29', 'Family Business', '2003-09-30'),
        (58708, 'Nice playlist', '2023-11-29', 'Get Em High (feat. Talib Kweli & Common)', '2003-09-30'),
        (58708, 'Nice playlist', '2023-11-29', 'good kid', '2012-10-22'),
        (58708, 'Nice playlist', '2023-11-29', 'Graduation Day', '2003-09-30'),
        (58708, 'Nice playlist', '2023-11-29', 'I''l Fly Away', '2003-09-30'),
        (58708, 'Nice playlist', '2023-11-29', 'Intro', '2003-09-30'),
        (58708, 'R&B Soul', '2023-09-23', 'Know Yourself', '2015-02-13'),
        (58708, 'super rap playlist', '2023-11-28', 'Know Yourself', '2015-02-13'),
        (58708, 'Nice playlist', '2023-11-29', 'Money Trees (ft. Jay Rock)', '2012-10-22'),
        (58708, 'Drake and Other Cool Rappers', '2023-11-28', 'Preach (ft. PARTYNEXTDOOR)', '2015-02-13'),
        (58708, 'Nice playlist', '2023-11-29', 'The Art of Peer Pressure', '2012-10-22'),
        (58708, 'Drake and Other Cool Rappers', '2023-11-28', 'Through the Wire', '2003-09-30'),
        (58708, 'Hip Hop Classics', '2023-09-22', 'Through the Wire', '2003-09-30'),
        (58708, 'super rap playlist', '2023-11-28', 'Through the Wire', '2003-09-30'),
        (58708, 'Jazz Vibes', '2023-09-20', 'Wesley’s Theory', '2015-03-15'),
        (58708, 'NAME', '2023-11-28', 'Wesley’s Theory', '2015-03-15'),
        (58708, 'super rap playlist', '2023-11-28', 'Wesley’s Theory', '2015-03-15'),
        (58708, 'Top Hits', '2023-09-24', 'Wesley’s Theory', '2015-03-15'),
        (58708, 'Drake and Other Cool Rappers', '2023-11-28', 'You & The 6', '2015-02-13');

insert into RateMyMusic.UserChart (ucid, userchart_name, image, pid)
values  (11680, 'AllKendrick', null, 58708),
        (42359, 'AllDrakeAllKanye', null, 58708),
        (45211, '4Kendrick', null, 58708),
        (55223, 'BFRH', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/4 Your Eyez Only.jpg'), 58708),
        (73355, 'AllKendrickAllDrake1Kanye', null, 58708),
        (666666, 'N''s TOP 5 ALBUMS OAT', LOAD_FILE('/Users/shrey/Documents/Stuff/Code/RateMyMusic/assets/TESTING.jpg'), 58708),
        (10626411, 'Howard''s Top 5 Albums', null, 80172634),
        (10626412, 'James''s Top 5 Albums', null, 29384756),
        (10626413, 'Hunter''s Top 5 Albums', null, 62519038),
        (10626414, 'Brenda''s Top 5 Albums', null, 41902873),
        (10626415, 'My Favorite Albums', null, 83726415);

insert into RateMyMusic.UserChartAlbum (ucid, pid, album_name, release_date, ranking)
values  (11680, 58708, 'DAMN', '2017-04-17', 1),
        (11680, 58708, 'good kid, m.A.A.d city', '2012-10-22', 2),
        (11680, 58708, 'Mr. Morale & the Big Steppers', '2022-05-13', 3),
        (11680, 58708, 'Section 80', '2011-07-02', 4),
        (11680, 58708, 'To Pimp a Butterfly', '2015-03-15', 5),
        (42359, 58708, 'If You''re Reading This It''s Too Late', '2015-02-13', 1),
        (42359, 58708, 'Late Registration', '2005-08-30', 3),
        (42359, 58708, 'Scorpion', '2018-06-29', 2),
        (42359, 58708, 'The College Dropout', '2003-09-30', 4),
        (45211, 58708, 'DAMN', '2017-04-17', 1),
        (45211, 58708, 'good kid, m.A.A.d city', '2012-10-22', 2),
        (45211, 58708, 'Mr. Morale & the Big Steppers', '2022-05-13', 3),
        (45211, 58708, 'Section 80', '2011-07-02', 4),
        (55223, 58708, 'Good Intentions', '2020-05-08', 1),
        (55223, 58708, 'good kid, m.A.A.d city', '2012-10-22', 2),
        (55223, 58708, 'If You''re Reading This It''s Too Late', '2015-02-13', 4),
        (55223, 58708, 'The College Dropout', '2003-09-30', 5),
        (55223, 58708, 'To Pimp a Butterfly', '2015-03-15', 3),
        (73355, 58708, 'DAMN', '2017-04-17', 3),
        (73355, 58708, 'good kid, m.A.A.d city', '2012-10-22', 5),
        (73355, 58708, 'If You''re Reading This It''s Too Late', '2015-02-13', 1),
        (73355, 58708, 'Mr. Morale & the Big Steppers', '2022-05-13', 6),
        (73355, 58708, 'Scorpion', '2018-06-29', 2),
        (73355, 58708, 'Section 80', '2011-07-02', 7),
        (73355, 58708, 'The College Dropout', '2003-09-30', 4),
        (73355, 58708, 'To Pimp a Butterfly', '2015-03-15', 8),
        (666666, 58708, 'Good Intentions', '2020-05-08', 5),
        (666666, 58708, 'good kid, m.A.A.d city', '2012-10-22', 1),
        (666666, 58708, 'If You''re Reading This It''s Too Late', '2015-02-13', 2),
        (666666, 58708, 'The College Dropout', '2003-09-30', 4),
        (666666, 58708, 'To Pimp a Butterfly', '2015-03-15', 3),
        (10626411, 80172634, 'Good Intentions', '2020-05-08', 5),
        (10626411, 80172634, 'If You''re Reading This It''s Too Late', '2015-02-13', 4),
        (10626411, 80172634, 'The College Dropout', '2003-09-30', 2),
        (10626411, 80172634, 'To Pimp a Butterfly', '2015-03-15', 1),
        (10626412, 29384756, 'Good Intentions', '2020-05-08', 4),
        (10626412, 29384756, 'If You''re Reading This It''s Too Late', '2015-02-13', 1),
        (10626412, 29384756, 'The College Dropout', '2003-09-30', 2),
        (10626412, 29384756, 'To Pimp a Butterfly', '2015-03-15', 3),
        (10626413, 62519038, 'Good Intentions', '2020-05-08', 4),
        (10626413, 62519038, 'If You''re Reading This It''s Too Late', '2015-02-13', 5),
        (10626413, 62519038, 'The College Dropout', '2003-09-30', 1),
        (10626413, 62519038, 'To Pimp a Butterfly', '2015-03-15', 2),
        (10626414, 41902873, 'Good Intentions', '2020-05-08', 2),
        (10626414, 41902873, 'If You''re Reading This It''s Too Late', '2015-02-13', 3),
        (10626414, 41902873, 'The College Dropout', '2003-09-30', 4),
        (10626414, 41902873, 'To Pimp a Butterfly', '2015-03-15', 5),
        (10626415, 83726415, 'Good Intentions', '2020-05-08', 2),
        (10626415, 83726415, 'If You''re Reading This It''s Too Late', '2015-02-13', 3),
        (10626415, 83726415, 'The College Dropout', '2003-09-30', 4),
        (10626415, 83726415, 'To Pimp a Butterfly', '2015-03-15', 5);

insert into RateMyMusic.UserChartReview (ucid, uc_pid, rv_pid, rid, rating)
values  (55223, 58708, 58708, 10484, 1),
        (10626411, 80172634, 58708, 10471, 4),
        (10626411, 80172634, 83726415, 67867876, 0),
        (10626412, 29384756, 83726415, 67867875, 2),
        (10626413, 62519038, 83726415, 67867874, 5),
        (10626414, 41902873, 83726415, 67867873, 3),
        (10626415, 83726415, 41902873, 67867872, 4);