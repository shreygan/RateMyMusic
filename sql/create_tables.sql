CREATE TABLE User4 (
    pid INTEGER PRIMARY KEY,
    birthdate DATE,
    birthplace VARCHAR(50),
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100),
    profile_pic LONGBLOB
);

CREATE TABLE User3 (
    username VARCHAR(50),
    birthdate DATE,
    age INTEGER,
    PRIMARY KEY (username, birthdate),
    FOREIGN KEY (username) REFERENCES USER4(username)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE User2 (
    username VARCHAR(50) PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    FOREIGN KEY (username) REFERENCES User4(username)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE User1 (
    username VARCHAR(50) PRIMARY KEY,
    email VARCHAR(300) NOT NULL,
    FOREIGN KEY (username) REFERENCES User4(username)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE Follows (
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

CREATE TABLE Artist2 (
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

CREATE TABLE Artist1 (
    name VARCHAR(50),
    birthdate DATE,
    is_dead BOOLEAN,
    age INTEGER,
    PRIMARY KEY (name, birthdate, is_dead),
    FOREIGN KEY (name, birthdate, is_dead) REFERENCES Artist2(name, birthdate, is_dead)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE Review2 (
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

CREATE TABLE Review1 (
    review_date DATETIME,
    likes INTEGER,
    dislikes INTEGER,
    helpfulness INTEGER,
    PRIMARY KEY (review_date, likes, dislikes),
    FOREIGN KEY (review_date, likes, dislikes) REFERENCES Review2(review_date, likes, dislikes)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE Comment2 (
    comment_date DATETIME,
    review_text VARCHAR(5000) NOT NULL,
    likes INTEGER NOT NULL,
    dislikes INTEGER NOT NULL,
    pid INTEGER,
    rid INTEGER,
    UNIQUE (comment_date, likes, dislikes),
    PRIMARY KEY (comment_date, pid, rid),
    FOREIGN KEY (pid) REFERENCES User4(pid)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
    FOREIGN KEY (pid, rid) REFERENCES Review2(pid, rid)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE Comment1 (
    comment_date DATETIME,
    likes INTEGER,
    dislikes INTEGER,
    position INTEGER,
    PRIMARY KEY (comment_date, likes, dislikes),
    FOREIGN KEY (comment_date, likes, dislikes) REFERENCES Comment2(comment_date, likes, dislikes)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE Album (
    album_name VARCHAR(100),
    release_date DATE,
    isSingle BOOLEAN NOT NULL,
    genre VARCHAR(50) NOT NULL,
    duration INTEGER NOT NULL,
    cover LONGBLOB NOT NULL,
    number_of_songs INTEGER NOT NULL,
    PRIMARY KEY (album_name, release_date),
    UNIQUE (album_name, duration),
    UNIQUE (album_name, number_of_songs)
);

CREATE TABLE Song (
    song_name VARCHAR(100),
    release_date DATE,
    duration INTEGER NOT NULL,
    genre VARCHAR(50) NOT NULL,
    PRIMARY KEY (song_name, release_date),
    UNIQUE (song_name, duration)
);

CREATE TABLE AlbumSong (
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

CREATE TABLE ArtistAlbum (
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

CREATE TABLE ArtistSong (
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

CREATE TABLE AlbumReview (
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

CREATE TABLE SongReview (
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

CREATE TABLE Playlist (
    playlist_name VARCHAR(50),
    creation_date DATE,
    image LONGBLOB NOT NULL,
    description VARCHAR(5000),
    PRIMARY KEY (playlist_name, creation_date)
);

CREATE TABLE PlaylistSong (
    playlist_name VARCHAR(50),
    creation_date DATE,
    song_name VARCHAR(100),
    release_date DATE,
    PRIMARY KEY (playlist_name, creation_date, song_name, release_date),
    FOREIGN KEY (playlist_name, creation_date) REFERENCES Playlist(playlist_name, creation_date)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (song_name, release_date) REFERENCES Song(song_name, release_date)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE UserChart (
    ucid INTEGER,
    userchart_name VARCHAR(50) NOT NULL,
    image LONGBLOB,
    pid INTEGER,
    PRIMARY KEY (ucid, pid),
    FOREIGN KEY (pid) REFERENCES User4(pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE UserChartAlbum (
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

CREATE TABLE UserChartReview (
    ucid INTEGER,
    uc_pid INTEGER,
    rv_pid INTEGER,
    rid INTEGER,
    PRIMARY KEY (ucid, uc_pid, rv_pid, rid),
    FOREIGN KEY (ucid, uc_pid) REFERENCES UserChart(ucid, pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (rv_pid, rid) REFERENCES Review2(pid, rid)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);
