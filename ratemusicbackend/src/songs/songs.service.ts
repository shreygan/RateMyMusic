import { Injectable, Inject } from '@nestjs/common';
import { Connection } from 'mysql2';
import { Database } from '../db.module';
import { promisify } from 'util';
import { relative } from 'path';

@Injectable()
export class SongsService {
  constructor(
    @Inject(Database)
    private readonly connection: Connection,
  ) {}

  private readonly query = promisify(this.connection.query).bind(
    this.connection,
  );

  async createSongReview(createSongReviewDto) {
    const { rating, reviewText, songName, releaseDate, pid } =
      createSongReviewDto._value;
    // const reviewDate = "2023-11-24 12:00:00";
    const reviewDate = new Date().toISOString().slice(0, 10);
    const rid = Math.floor(Math.random() * 900) + 10000;
    const likes = 0;
    const dislikes = 0;
    const helpfulness = 0;

    console.log('pid: ' + pid);
    console.log('rating: ' + rating);
    console.log('reviewText: ' + reviewText);
    console.log('songName: ' + songName);
    console.log('releaseDate: ' + releaseDate);
    console.log(createSongReviewDto);
    // Unique for review 2 ----> review_date, likes, dislikes
    await this.query(
      `
    INSERT INTO Review2 (rid, pid, review_date, review_text, likes, dislikes)
    VALUES (?, ?, ?, ?, ?, ?);
    `,
      [rid, pid, reviewDate, reviewText, likes, dislikes],
    );

    await this.query(
      `
    INSERT INTO Review1 (review_date, likes, dislikes, helpfulness)
    VALUES (?, ?, ?, ?);
    `,
      [reviewDate, likes, dislikes, helpfulness],
    );

    await this.query(
      `
    INSERT INTO SongReview (pid, rid, song_name, release_date, rating)
    VALUES (?, ?, ?, ?, ?);
    `,
      [pid, rid, songName, releaseDate, rating],
    );

    return createSongReviewDto;
  }

  async createAlbumReview(createAlbumReviewDto) {
    const { rating, reviewText, albumName, releaseDate, pid } =
      createAlbumReviewDto;
    const reviewDate = new Date().toISOString().slice(0, 10);
    const rid = Math.floor(Math.random() * 90000) + 10000;
    const likes = 0;
    const dislikes = 0;
    const helpfulness = 0;

    // Unique for review 2 ----> review_date, likes, dislikes
    await this.query(
      `
      INSERT INTO Review2 (rid, pid, review_date, review_text, likes, dislikes)
      VALUES (?, ?, ?, ?, ?, ?);
      INSERT INTO Review1 (review_date, likes, dislikes, helpfulness)
      VALUES (?, ?, ?, ?);
      INSERT INTO AlbumReview (pid, rid, album_name, release_date, rating)
      VALUES (?, ?, ?, ?, ?);
      `,
      [
        rid,
        pid,
        reviewDate,
        reviewText,
        likes,
        dislikes,
        reviewDate,
        likes,
        dislikes,
        helpfulness,
        pid,
        rid,
        albumName,
        releaseDate,
        rating,
      ],
    );

    return createAlbumReviewDto;
  }

  async getAllAlbumReviews() {
    return await this.query(`
    SELECT
    r2.rid,
    r2.pid,
    r2.review_date,
    r2.review_text,
    r2.likes,
    r2.dislikes,
    r1.helpfulness,
    ar.album_name,
    ar.release_date,
    ar.rating,
    a.genre,
    a.duration,
    a.cover,
    a.number_of_songs
  FROM Review1 r1, Review2 r2, AlbumReview ar, Album a
  WHERE r1.review_date = r2.review_date AND r1.likes = r2.likes
        AND r1.dislikes = r2.dislikes AND r2.rid = ar.rid
        AND r2.pid = ar.pid AND ar.album_name = a.album_name
        AND ar.release_date = a.release_date
  ORDER BY r1.helpfulness DESC;
    `);
  }

  async getAllSongReviews() {
    return await this.query(`
    SELECT
    r2.rid,
    r2.pid,
    r2.review_date,
    r2.review_text,
    r2.likes,
    r2.dislikes,
    r1.helpfulness,
    sr.song_name,
    sr.release_date,
    sr.rating,
    s.duration,
    s.genre,
    als.album_name,
    als.album_release_date,
    a.cover
  FROM Review1 r1, Review2 r2, SongReview sr, Song s, AlbumSong als, Album a
  WHERE r1.review_date = r2.review_date AND r1.likes = r2.likes
        AND r1.dislikes = r2.dislikes AND r2.rid = sr.rid
        AND r2.pid = sr.pid AND sr.song_name = s.song_name
        AND sr.release_date = s.release_date AND s.song_name = als.song_name
        AND s.release_date = als.song_release_date AND als.album_name = a.album_name
        AND als.album_release_date = a.release_date
  ORDER BY r1.helpfulness DESC;
    `);
  }

  async findAllSongs(searchTerm?: string) {
    // if(searchTerm) {
    //   return await this.query('SELECT * FROM Song WHERE MATCH(song_name) AGAINST(?)', [searchTerm]);
    // }

    if (searchTerm) {
      return await this.query(
        `
      SELECT 
        s.song_name,
        s.release_date AS song_release_date,
        s.duration,
        s.genre,
        a.album_name,
        a.release_date AS album_release_date
      FROM Song s
      LEFT JOIN AlbumSong als ON s.song_name = als.song_name AND s.release_date = als.song_release_date
      LEFT JOIN Album a ON als.album_name = a.album_name AND als.album_release_date = a.release_date
      WHERE s.song_name LIKE CONCAT('%', ?, '%');`,
        [searchTerm],
      );
    }

    return await this.query(`
    SELECT 
      s.song_name,
      s.release_date AS song_release_date,
      s.duration,
      s.genre,
      a.album_name,
      a.release_date AS album_release_date
    FROM Song s
    LEFT JOIN AlbumSong als ON s.song_name = als.song_name AND s.release_date = als.song_release_date
    LEFT JOIN Album a ON als.album_name = a.album_name AND als.album_release_date = a.release_date
    `);
  }

  async findAllAlbums(searchTerm?: string) {
    if (searchTerm) {
      return await this.query(
        `
      SELECT
        a.album_name,
        a.release_date,
        a.isSingle,
        a.genre,
        a.duration,
        a.cover,
        a.number_of_songs,
        aa.pid,
        at2.name,
        at2.birthdate,
        at2.birthplace
        FROM Album a, Artist1 at1, Artist2 at2, ArtistAlbum aa
        WHERE a.album_name = aa.album_name AND a.release_date = aa.release_date
              AND aa.pid = at2.pid AND at1.name = at2.name AND at1.birthdate = at2.birthdate
              AND at1.is_dead = at2.is_dead AND a.album_name LIKE CONCAT('%', ?, '%');
      `,
        [searchTerm],
      );
    }

    return await this.query(`
    SELECT
    a.album_name,
    a.release_date,
    a.isSingle,
    a.genre,
    a.duration,
    a.cover,
    a.number_of_songs,
    aa.pid,
    at2.name,
    at2.birthdate,
    at2.birthplace
    FROM Album a, Artist1 at1, Artist2 at2, ArtistAlbum aa
    WHERE a.album_name = aa.album_name AND a.release_date = aa.release_date
          AND aa.pid = at2.pid AND at1.name = at2.name AND at1.birthdate = at2.birthdate
          AND at1.is_dead = at2.is_dead;
    `);
  }
}
