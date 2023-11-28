import { Injectable, Inject } from '@nestjs/common';
import { Connection } from 'mysql2';
import { Database } from '../db.module';
import { promisify } from 'util';
import { User, ReviewDelete, UCData } from './users.controller';

@Injectable()
export class UsersService {
  constructor(
    @Inject(Database)
    private readonly connection: Connection,
  ) {}

  private readonly query = promisify(this.connection.query).bind(
    this.connection,
  );

  async getUserReview(data: any){

  }

  async getPlaylistSongs(data: any) {
    return await this.query(
        `SELECT
            p.pid,
            p.playlist_name,
            p.creation_date,
            p.description,
            u4.username,
            p.image,
            ats.song_name,
            ats.release_date,
            at2.name AS artist_name,
            a.album_name,
            a.cover
        FROM
            User4 u4, Playlist p, PlaylistSong ps, ArtistSong ats, Artist2 at2, AlbumSong als, Album a
        WHERE
            u4.pid = ? AND p.pid = u4.pid AND p.playlist_name = ? AND p.creation_date = ?
            AND ps.pid = p.pid AND ps.playlist_name = p.playlist_name
            AND ps.creation_date = p.creation_date AND ats.song_name = ps.song_name
            AND ats.release_date = ps.release_date AND at2.pid = ats.pid
            AND als.song_name = ps.song_name AND als.song_release_date = ps.release_date
            AND als.album_name = a.album_name AND als.album_release_date = a.release_date;`,
        [data.pid, data.playlist_name, data.creation_date.substring(0, 10)]
    );
  }

  async getAllPlaylists(searchTerm?: string) {
    if (searchTerm) {
        return await this.query(
          `SELECT
                p.pid,
                p.playlist_name,
                p.creation_date,
                u4.username,
                p.image
            FROM
                User4 u4, Playlist p
            WHERE
                p.pid = u4.pid AND p.playlist_name LIKE CONCAT('%', ?, '%');`,
          [searchTerm],
        );
    }

    return await this.query(
        `SELECT
            p.pid,
            p.playlist_name,
            p.creation_date,
            u4.username,
            p.image
        FROM
            User4 u4, Playlist p
        WHERE
            p.pid = u4.pid;`
    );

  }

  async createPlaylist(playlist: any) {
    const reviewDate = new Date();

    await this.query(
      `INSERT
         INTO Playlist(pid, playlist_name, creation_date, image, description)
         VALUES (?, ?, ?, ?, ?);`,
      [
        playlist.pid,
        playlist.playlist_name,
        reviewDate,
        playlist.image,
        playlist.description,
      ],
    );

    for (let index = 0; index < playlist.songs.length; index++) {
      const song = playlist.songs[index];

      await this.query(
        `INSERT
             INTO PlaylistSong(pid, playlist_name, creation_date, song_name, release_date)
             VALUES (?, ?, ?, ?, ?);`,
        [
          playlist.pid,
          playlist.playlist_name,
          reviewDate,
          song.song_name,
          song.song_release_date.substring(0, 10),
        ],
      );
    }
  }

  async getAvgRatingPerUserChartAlbum(data: any) {
    return await this.query(
      `SELECT
            ar.album_name,
            ar.release_date,
            AVG(ar.rating)
        FROM
            AlbumReview ar
        WHERE
            (ar.album_name, ar.release_date) IN (SELECT
                                                    ua.album_name,
                                                    ua.release_date
                                                FROM
                                                    UserChart uc, UserChartAlbum ua
                                                WHERE
                                                    uc.pid = ? AND ua.ucid = ?
                                                    AND uc.ucid = ua.ucid AND uc.pid = ua.pid)
        GROUP BY ar.album_name, ar.release_date;`,
      [data.pid, data.ucid],
    );
  }

  async getUserChartAlbums(data: any) {
    return await this.query(
      `SELECT
            u4.username,
            uc.userchart_name,
            uc.image,
            uca.album_name,
            uca.release_date,
            uca.ranking,
            a.cover,
            at2.name AS artist_name
        FROM
            User4 u4, UserChart uc, UserChartAlbum uca, Album a, ArtistAlbum aa, Artist2 at2
        WHERE
            u4.pid = ? AND uc.ucid = ? AND u4.pid = uc.pid
            AND uc.ucid = uca.ucid AND uc.pid = uca.pid
            AND uca.album_name = a.album_name AND uca.release_date = a.release_date
            AND a.album_name = aa.album_name AND a.release_date = aa.release_date
            AND aa.pid = at2.pid
        ORDER BY uca.ranking;`,
      [data.pid, data.ucid],
    );
  }

  async getAllUserCharts(searchTerm?: string) {
    if (searchTerm) {
      return await this.query(
        `SELECT
                u4.pid,
                uc.ucid,
                uc.userchart_name,
                uc.image,
                u4.username,
                u4.profile_pic
            FROM
                User4 u4, UserChart uc
            WHERE
                u4.pid = uc.pid AND uc.userchart_name LIKE CONCAT('%', ?, '%');`,
        [searchTerm],
      );
    }

    return await this.query(
      `SELECT
                u4.pid,
                uc.ucid,
                uc.userchart_name,
                uc.image,
                u4.username,
                u4.profile_pic
            FROM
                User4 u4, UserChart uc
            WHERE
                u4.pid = uc.pid;`,
    );
  }

  async getPersonalUserCharts(userpid?: string) {
    return await this.query(
      `SELECT
            uc.ucid,
            uc.userchart_name,
            uc.image,
            u4.username,
            u4.profile_pic
        FROM
            User4 u4, UserChart uc
        WHERE
            u4.pid = ? AND u4.pid = uc.pid;`,
      [userpid],
    );
  }

  async insertUserChart(data: UCData) {
    const { albums, image, pid, title } = data;

    const ucid = Math.floor(Math.random() * 90000) + 10000;

    await this.query(
      `INSERT
       INTO UserChart(ucid, userchart_name, image, pid)
       VALUE (?, ?, ?, ?);`,
      [ucid, title, image, pid],
    );

    for (let index = 0; index < albums.length; index++) {
      const date = albums[index].release_date.substring(0, 10);
      const album = albums[index];
      const ranking = index + 1;

      await this.query(
        `INSERT
         INTO UserChartAlbum(ucid, pid, album_name, release_date, ranking)
         VALUE (?, ?, ?, ?, ?);`,
        [ucid, pid, album.album_name, date, ranking],
      );
    }
  }

  async avgRatingPerUser(data: any) {
    const { aggChoice, pid } = data;

    return await this.query(
      `SELECT
           r2.pid,
           a2.name,
           a2.artist_pic,
           a2.description,
           CASE
               WHEN ? = 'COUNT' THEN COUNT(ar.rating)
               WHEN ? = 'SUM' THEN SUM(ar.rating)
               WHEN ? = 'AVG' THEN AVG(ar.rating)
               WHEN ? = 'MIN' THEN MIN(ar.rating)
               WHEN ? = 'MAX' THEN MAX(ar.rating)
           END AS agg_value
       FROM
           Review2 r2, Review1 r1, AlbumReview ar, ArtistAlbum aa, Artist2 a2
       WHERE
           r2.pid = ? AND r2.review_date = r1.review_date AND r2.likes = r1.likes AND r2.dislikes = r1.dislikes
           AND ar.pid = r2.pid AND ar.rid = r2.rid AND ar.album_name = aa.album_name
       AND aa.release_date = ar.release_date AND a2.pid = aa.pid
       GROUP BY a2.pid;`,
      [aggChoice, aggChoice, aggChoice, aggChoice, aggChoice, pid],
    );
  }

  async getUserById(userpid?: string) {
    return await this.query(
      `SELECT
           u4.pid,
           u4.birthdate,
           u4.birthplace,
           u4.username,
           u4.password,
           u4.profile_pic,
           u3.age,
           u2.name,
           u1.email
       FROM
           User4 u4,
           User3 u3,
           User2 u2,
           User1 u1
       WHERE
           u4.pid = ? AND u4.username = u3.username AND u4.birthdate = u3.birthdate
           AND u4.username = u2.username AND u4.username = u1.username;`,

      [userpid],
    );
  }

  async deleteReview(data: ReviewDelete) {
    const { rid, userpid } = data;

    return await this.query(
      `DELETE FROM Review2
         WHERE rid = ? AND pid = ?;`,
      [rid, userpid],
    );
  }

  async getUserSongReviews(userpid?: string) {
    return await this.query(
      `SELECT
            r2.rid,
            r2.review_text,
            r2.review_date,
            r2.likes,
            r2.dislikes,
            r1.helpfulness,
            sr.rating,
            s.song_name,
            s.release_date,
            s.genre,
            s.duration,
            a.cover,
            a.album_name,
            a.release_date
        FROM
            User4 u4, Review2 r2, Review1 r1, SongReview sr, Song s, AlbumSong als, Album a
        WHERE
            u4.pid = ? AND u4.pid = r2.pid AND r2.review_date = r1.review_date
            AND r2.likes = r1.likes AND r2.dislikes = r1.dislikes
            AND sr.pid = u4.pid AND sr.rid = r2.rid AND s.song_name = sr.song_name
            AND s.release_date = sr.release_date AND als.song_name = s.song_name
            AND als.song_release_date = s.release_date AND als.album_name = a.album_name
            AND als.album_release_date = a.release_date;`,
      [userpid],
    );
  }

  async getUserAlbumReviews(userpid?: string) {
    return await this.query(
      `SELECT
            r2.rid,
            r2.review_text,
            r2.review_date,
            r2.likes,
            r2.dislikes,
            r1.helpfulness,
            ar.rating,
            a.album_name,
            a.release_date,
            a.isSingle,
            a.genre,
            a.duration,
            a.cover,
            a.number_of_songs
        FROM
            User4 u4, Review2 r2, Review1 r1, AlbumReview ar, Album a
        WHERE
            u4.pid = ? AND u4.pid = r2.pid AND r2.review_date = r1.review_date
            AND r2.likes = r1.likes AND r2.dislikes = r1.dislikes
            AND ar.pid = u4.pid AND ar.rid = r2.rid AND a.album_name = ar.album_name
            AND a.release_date = ar.release_date;`,
      [userpid],
    );
  }

  async updateUser(user: User) {
    return await this.query(
      `START TRANSACTION;
            UPDATE User4
            SET birthdate = ?,
                birthplace = ?,
                username = ?,
                password = ?,
                profile_pic = ?
            WHERE pid = ?;

            UPDATE User3
            SET birthdate = ?,
                age = ?
            WHERE username = ?;

            UPDATE User2
            SET name = ?
            WHERE username = ?;

            UPDATE User1
            SET email = ?
            WHERE username = ?;

        COMMIT;`,
      [
        user.birthdate,
        user.birthplace,
        user.username,
        user.password,
        user.profile_pic,
        user.pid,
        user.birthdate,
        user.age,
        user.username,
        user.name,
        user.username,
        user.email,
        user.username,
      ],
    );

    // return await this.query(
    //     `UPDATE User4
    //      SET birthdate = ?,
    //          birthplace = ?,
    //          username = ?,
    //          password = ?,
    //          profile_pic = ?
    //      WHERE pid = ?;`,
    //         [user.birthdate,
    //          user.birthplace,
    //          user.username,
    //          user.password,
    //          user.profile_pic,
    //          user.pid]
    // );

    // await this.query(
    //     `UPDATE User3
    //      SET age = ?
    //      WHERE username = ? AND birthdate = ?;`,
    //         [user.age,
    //          user.username,
    //          user.birthdate]
    // );

    // await this.query(
    //     `UPDATE User2
    //      SET name = ?
    //      WHERE username = ?;`,
    //         [user.name,
    //          user.username]
    // );

    // return await this.query(
    //     `UPDATE User1
    //      SET email = ?
    //      WHERE username = ?;`,
    //         [user.email,
    //          user.username]
    // );
  }

  async getAllUsers() {
    return await this.query(
      `SELECT 
            u4.pid,
            u4.birthdate,
            u4.birthplace,
            u4.username,
            u4.password,
            u4.profile_pic,
            u3.age,
            u2.name,
            u1.email
       FROM 
            User4 u4, 
            User3 u3,
            User2 u2,
            User1 u1
       WHERE
            u4.username = u3.username AND u4.birthdate = u3.birthdate 
            AND u4.username = u2.username
            AND u4.username = u1.username;`,
    );
  }

  //CREATE TABLE IF NOT EXISTS User4 (
  // pid INTEGER PRIMARY KEY,
  // birthdate DATE,
  // birthplace VARCHAR(50),
  // username VARCHAR(50) NOT NULL UNIQUE,
  // password VARCHAR(100),
  // profile_pic LONGBLOB

  async addUser(user: User) {
    const pid = Math.floor(Math.random() * 90000) + 10000;
    const age = 10; // CALCULATE AGE PROPERLY
    const newDate = new Date(user.birthdate);

    user.profile_pic = null;

    await this.query(
      `INSERT INTO User4 (pid, 
                          birthdate, 
                          birthplace, 
                          username, 
                          password, 
                          profile_pic) 
        VALUES (?, ?, ?, ?, ?, ?);`,
      [
        pid,
        newDate,
        user.birthplace,
        user.username,
        user.password,
        user.profile_pic,
      ],
    );

    await this.query(
      `INSERT INTO User3 (username, 
                          birthdate, 
                          age) 
        VALUES (?, ?, ?);`,
      [user.username, newDate, age],
    );

    await this.query(
      `INSERT INTO User2 (username,
                          name) 
        VALUES (?, ?);`,
      [user.username, user.name],
    );

    return await this.query(
      `INSERT INTO User1 (username,
                          email) 
        VALUES (?, ?);`,
      [user.username, user.email],
    );
  }

  async login(user: User) {
    const users = await this.query(
      `SELECT
            u4.pid,
            u4.birthdate,
            u4.birthplace,
            u4.username,
            u4.password,
            u4.profile_pic,
            u3.age,
            u2.name,
            u1.email
        FROM
            User4 u4,
            User3 u3,
            User2 u2,
            User1 u1
        WHERE
            u4.username = u3.username AND u4.birthdate = u3.birthdate
            AND u4.username = u2.username
            AND u4.username = u1.username
            AND u4.username = ? AND u4.password = ?;`,
      [user.username, user.password],
    );

    return users[0];
  }
}
