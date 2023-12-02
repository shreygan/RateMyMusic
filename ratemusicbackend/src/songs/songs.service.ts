import { Injectable, Inject } from '@nestjs/common';
import { Connection } from 'mysql2';
import { Database } from '../db.module';
import { promisify } from 'util';
import { relative } from 'path';
import { FilterSongsDto } from './songs.controller';

@Injectable()
export class SongsService {
  constructor(
    @Inject(Database)
    private readonly connection: Connection,
  ) {}

  private readonly query = promisify(this.connection.query).bind(
    this.connection,
  );

  async getAlbumReviews(albumName: string, releaseDate: string) {
    return await this.query(
       `SELECT
            a.album_name,
            a.release_date,
            ar.pid,
            ar.rid,
            ar.rating,
            r2.review_text,
            r2.review_date,
            u4.username,
            u4.profile_pic
        FROM
            Album a, AlbumReview ar, Review2 r2, User4 u4
        WHERE
            a.album_name = ? AND a.release_date = ? AND r2.pid = u4.pid
            AND ar.album_name = a.album_name AND ar.release_date = a.release_date
            AND r2.rid = ar.rid AND r2.pid = ar.pid;`,
        [albumName, releaseDate]
    );
  }

  async getAlbumSongs(albumName: string, releaseDate: string) {
    return await this.query(
      `SELECT
            a.album_name,
            a.release_date AS album_release_date,
            a.cover,
            s.song_name,
            s.release_date AS song_release_date,
            s.duration
        FROM
            Album a, AlbumSong als, Song s
        WHERE
            a.album_name = ? AND a.release_date = ?
            AND als.album_name = a.album_name AND als.album_release_date = a.release_date
            AND s.song_name = als.song_name AND s.release_date = als.song_release_date;`,
      [albumName, releaseDate],
    );
  }

  async getAllGenres() {
    return await this.query(`
    SELECT Genre FROM Song
    UNION
    SELECT Genre FROM Album
    UNION
    SELECT Genre FROM Artist2;
`);
  }

  async filterSongs(filterSongsDto: FilterSongsDto) {
    const {
      searchTerm,
      startDate,
      endDate,
      selectedGenre,
      isSingle,
      minDuration,
      maxDuration,
    } = filterSongsDto;

    console.log(filterSongsDto);

    return await this.query(
      `
        SELECT
            s.song_name,
            s.release_date AS song_release_date,
            s.duration,
            s.genre,
            a.album_name,
            a.cover,
            at2.name
        FROM
            Song s, AlbumSong als, Album a, ArtistAlbum aa, Artist2 at2
        WHERE 
            s.song_name = als.song_name AND s.release_date = als.song_release_date
            AND als.album_name = a.album_name AND als.album_release_date = a.release_date
            AND a.album_name = aa.album_name AND a.release_date = aa.release_date
            AND aa.pid = at2.pid

            AND s.song_name LIKE CONCAT('%', ?, '%')
            AND s.release_date BETWEEN ? AND ?
            AND s.genre = COALESCE(?, s.genre)
            AND a.isSingle = ?
            AND s.duration BETWEEN ? AND ?;
        `,
      [
        searchTerm ? searchTerm : '',
        startDate ? startDate : '1500-01-01',
        endDate ? endDate : new Date().toISOString().slice(0, 10),
        selectedGenre != 'All' ? selectedGenre : null,
        isSingle,
        Number(minDuration) * 60,
        Number(maxDuration) * 60,
      ],
    );
  }

  async advancedFilterSongs(data: any) {
    const { topSongsNumber, ratingComparison, ratingValue } = data;

    const combinedString = `${ratingComparison} ${ratingValue}`;

    console.log(data);

    await this.query(
      `CREATE OR REPLACE VIEW AverageRatings AS SELECT
         sr.song_name,
         sr.release_date,
         s.genre,
         AVG(rating) AS average_rating
     FROM
         SongReview sr, Song s, AlbumSong als, Album a
     WHERE
         s.song_name = sr.song_name AND s.release_date = sr.release_date
         AND als.song_name = s.song_name AND als.song_release_date = s.release_date
     GROUP BY
         song_name, release_date
     HAVING
        CASE
            WHEN ? = '>' THEN  average_rating > ?
            WHEN ? = '>=' THEN average_rating >= ?
            WHEN ? = '<' THEN  average_rating < ?
            WHEN ? = '<=' THEN average_rating <= ?
        END;`,
      [
        ratingComparison,
        ratingValue,
        ratingComparison,
        ratingValue,
        ratingComparison,
        ratingValue,
        ratingComparison,
        ratingValue,
      ],
    );

    return await this.query(
      `SELECT
        r.song_name,
        r.release_date AS song_release_date,
        r.genre,
        r.average_rating,
        s.duration,
        a.album_name,
        a.cover,
        at2.name
    FROM (
        SELECT
            ar.genre,
            ar.song_name,
            ar.release_date,
            ar.average_rating,
            ROW_NUMBER() OVER (PARTITION BY ar.genre ORDER BY ar.average_rating DESC) AS genre_rank
        FROM
            AverageRatings ar
    ) r, Song s, AlbumSong als, Album a, ArtistAlbum aa, Artist2 at2
    WHERE
        s.song_name = r.song_name AND s.release_date = r.release_date
        AND s.song_name = als.song_name AND s.release_date = als.song_release_date
        AND als.album_name = a.album_name AND als.album_release_date = a.release_date
        AND a.album_name = aa.album_name AND a.release_date = aa.release_date
        AND aa.pid = at2.pid
        AND genre_rank <= ?;`,
      [topSongsNumber],
    );
    
  }

  async createUserChartReview(CreateUserchartReviewDto) {
    const { rating, reviewText, ucid, uc_pid, pid } = CreateUserchartReviewDto._value;

    const reviewDate = new Date();

    const rid = Math.floor(Math.random() * 900) + 10000;
    const likes = 0;
    const dislikes = 0;
    const helpfulness = 0;

    await this.query(
        `INSERT INTO Review2 (rid, pid, review_date, review_text, likes, dislikes)
         VALUES (?, ?, ?, ?, ?, ?);`,
         [rid, pid, reviewDate, reviewText, likes, dislikes],
    );

    await this.query(
        `INSERT INTO Review1 (review_date, likes, dislikes, helpfulness)
         VALUES (?, ?, ?, ?);`,
         [reviewDate, likes, dislikes, helpfulness],
    );

    return await this.query(
        `INSERT INTO UserChartReview
         VALUE (?, ?, ?, ?, ?);`,
        [ucid, uc_pid, pid, rid, rating],
    );
  }

  async createSongReview(createSongReviewDto) {
    const { rating, reviewText, songName, releaseDate, pid } =
      createSongReviewDto._value;


    const reviewDate = new Date();

    const rid = Math.floor(Math.random() * 900) + 10000;
    const likes = 0;
    const dislikes = 0;
    const helpfulness = 0;

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
      createAlbumReviewDto._value;

    const reviewDate = new Date();

    const year = reviewDate.getFullYear();
    const month = String(reviewDate.getMonth() + 1).padStart(2, '0');
    const day = String(reviewDate.getDate()).padStart(2, '0');
    const hour = String(reviewDate.getHours()).padStart(2, '0');
    const minute = String(reviewDate.getMinutes()).padStart(2, '0');
    const second = String(reviewDate.getSeconds()).padStart(2, '0');

    const formattedDate = `${year}-${month}-${day} ${hour}:${minute}:${second}`;
    const rid = Math.floor(Math.random() * 90000) + 10000;
    const likes = 0;
    const dislikes = 0;
    const helpfulness = 0;

    
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
        formattedDate,
        reviewText,
        likes,
        dislikes,
        formattedDate,
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
    a.number_of_songs,
    u.username
  FROM Review1 r1, Review2 r2, AlbumReview ar, Album a, User4 u
  WHERE r1.review_date = r2.review_date AND r1.likes = r2.likes
        AND r1.dislikes = r2.dislikes AND r2.rid = ar.rid
        AND r2.pid = ar.pid AND ar.album_name = a.album_name
        AND ar.release_date = a.release_date AND r2.pid = u.pid
  ORDER BY r2.review_date DESC;
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
    a.cover,
    u.username
  FROM Review1 r1, Review2 r2, SongReview sr, Song s, AlbumSong als, Album a, User4 u
  WHERE r1.review_date = r2.review_date AND r1.likes = r2.likes
        AND r1.dislikes = r2.dislikes AND r2.rid = sr.rid
        AND r2.pid = sr.pid AND sr.song_name = s.song_name
        AND sr.release_date = s.release_date AND s.song_name = als.song_name
        AND s.release_date = als.song_release_date AND als.album_name = a.album_name
        AND als.album_release_date = a.release_date AND r2.pid = u.pid
  ORDER BY r1.review_date DESC;
    `);
  }

  async getSongReviews(songName: string, releaseDate: string) {
    return await this.query(
      `
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
    a.cover,
    u.username
  FROM Review1 r1, Review2 r2, SongReview sr, Song s, AlbumSong als, Album a, User4 u
  WHERE r1.review_date = r2.review_date AND r1.likes = r2.likes
        AND r1.dislikes = r2.dislikes AND r2.rid = sr.rid
        AND r2.pid = sr.pid AND sr.song_name = s.song_name
        AND sr.release_date = s.release_date AND s.song_name = als.song_name
        AND s.release_date = als.song_release_date AND als.album_name = a.album_name
        AND als.album_release_date = a.release_date AND r2.pid = u.pid AND sr.song_name = ? AND sr.release_date = ?
  ORDER BY r1.helpfulness DESC;
    `,
      [songName, releaseDate],
    );
  }

  async findAllUsercharts(searchTerm?: string) {
    if (searchTerm) {
      return await this.query(
        `SELECT
             uc.image,
             uc.userchart_name,
             uc.ucid,
             uc.pid AS uc_pid,
             u4.username
         FROM
             UserChart uc, User4 u4
         WHERE
             uc.pid = u4.pid AND
             uc.userchart_name LIKE CONCAT('%', ?, '%');
      `,
        [searchTerm],
      );
    }

    return await this.query(
      `SELECT
             uc.image,
             uc.userchart_name,
             uc.ucid,
             uc.pid AS uc_pid,
             u4.username
         FROM
             UserChart uc, User4 u4
         WHERE uc.pid = u4.pid;`,
    );
  }

  async findAllSongs(searchTerm?: string) {
    if (searchTerm) {
      return await this.query(
        `
      SELECT 
        s.song_name,
        s.release_date AS song_release_date,
        s.duration,
        s.genre,
        a.album_name,
        a.cover,
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
      a.cover,
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
