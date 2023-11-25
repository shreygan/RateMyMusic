CREATE TABLE IF NOT EXISTS User4 (
    pid INTEGER PRIMARY KEY,
    birthdate DATE,
    birthplace VARCHAR(50),
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100),
    profile_pic LONGBLOB
);

CREATE TABLE IF NOT EXISTS User3 (
    username VARCHAR(50),
    birthdate DATE,
    age INTEGER,
    PRIMARY KEY (username, birthdate),
    FOREIGN KEY (username) REFERENCES User4(username)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS User2 (
    username VARCHAR(50) PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    FOREIGN KEY (username) REFERENCES User4(username)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS User1 (
    username VARCHAR(50) PRIMARY KEY,
    email VARCHAR(300) NOT NULL,
    FOREIGN KEY (username) REFERENCES User4(username)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Follows (
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

CREATE TABLE IF NOT EXISTS Artist2 (
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

CREATE TABLE IF NOT EXISTS Artist1 (
    name VARCHAR(50),
    birthdate DATE,
    is_dead BOOLEAN,
    age INTEGER,
    PRIMARY KEY (name, birthdate, is_dead),
    FOREIGN KEY (name, birthdate, is_dead) REFERENCES Artist2(name, birthdate, is_dead)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Review2 (
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

CREATE TABLE IF NOT EXISTS Review1 (
    review_date DATETIME,
    likes INTEGER,
    dislikes INTEGER,
    helpfulness INTEGER,
    PRIMARY KEY (review_date, likes, dislikes),
    FOREIGN KEY (review_date, likes, dislikes) REFERENCES Review2(review_date, likes, dislikes)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS UserReviewLikes (
    user_pid INTEGER,
    review_pid INTEGER,
    rid INTEGER,
    liked BOOLEAN,
    disliked BOOLEAN,
    PRIMARY KEY (user_pid, review_pid, rid),
    FOREIGN KEY (user_pid) REFERENCES User4(pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (review_pid, rid) REFERENCES Review2(rid, pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS UserCommentLikes (
    user_pid INTEGER,
    comment_pid INTEGER,
    comment_date DATETIME,
    rid INTEGER,
    liked BOOLEAN,
    disliked BOOLEAN,
    PRIMARY KEY (user_pid, comment_date, comment_pid, rid),
    FOREIGN KEY (user_pid) REFERENCES User4(pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (comment_date, comment_pid, rid) REFERENCES Comment2(comment_date, pid, rid)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Comment2 (
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

CREATE TABLE IF NOT EXISTS Comment1 (
    comment_date DATETIME,
    likes INTEGER,
    dislikes INTEGER,
    position INTEGER,
    PRIMARY KEY (comment_date, likes, dislikes),
    FOREIGN KEY (comment_date, likes, dislikes) REFERENCES Comment2(comment_date, likes, dislikes)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Album (
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

CREATE TABLE IF NOT EXISTS Song (
    song_name VARCHAR(100),
    release_date DATE,
    duration INTEGER NOT NULL,
    genre VARCHAR(50) NOT NULL,
    PRIMARY KEY (song_name, release_date),
    UNIQUE (song_name, duration)
);

ALTER TABLE Song ADD FULLTEXT INDEX index_table_on_song_name (song_name);

CREATE TABLE IF NOT EXISTS AlbumSong (
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

CREATE TABLE IF NOT EXISTS ArtistAlbum (
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

CREATE TABLE IF NOT EXISTS ArtistSong (
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

CREATE TABLE IF NOT EXISTS AlbumReview (
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

CREATE TABLE IF NOT EXISTS SongReview (
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

CREATE TABLE IF NOT EXISTS Playlist (
    playlist_name VARCHAR(50),
    creation_date DATE,
    image LONGBLOB NULL,
    description VARCHAR(5000),
    PRIMARY KEY (playlist_name, creation_date)
);

CREATE TABLE IF NOT EXISTS PlaylistSong (
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

CREATE TABLE IF NOT EXISTS UserChart (
    ucid INTEGER,
    userchart_name VARCHAR(50) NOT NULL,
    image LONGBLOB,
    pid INTEGER,
    PRIMARY KEY (ucid, pid),
    FOREIGN KEY (pid) REFERENCES User4(pid)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS UserChartAlbum (
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

CREATE TABLE IF NOT EXISTS UserChartReview (
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
