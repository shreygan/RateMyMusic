"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SongsService = void 0;
const common_1 = require("@nestjs/common");
const db_module_1 = require("../db.module");
const util_1 = require("util");
let SongsService = class SongsService {
    constructor(connection) {
        this.connection = connection;
        this.query = (0, util_1.promisify)(this.connection.query).bind(this.connection);
    }
    async createAlbumReview(createReviewDto) {
        const { rating, reviewText, albumName, releaseDate, pid } = createReviewDto;
        const reviewDate = new Date().toISOString().slice(0, 10);
        const rid = Math.floor(Math.random() * 90000) + 10000;
        const likes = 0;
        const dislikes = 0;
        const helpfulness = 0;
        await this.query(`
      INSERT INTO Review2 (rid, pid, review_date, review_text, likes, dislikes)
      VALUES (?, ?, ?, ?, ?, ?);
      INSERT INTO Review1 (review_date, likes, dislikes, helpfulness)
      VALUES (?, ?, ?, ?);
      INSERT INTO AlbumReview (pid, rid, album_name, release_date, rating)
      VALUES (?, ?, ?, ?, ?);
      `, [
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
        ]);
        return createReviewDto;
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
    async findAll(searchTerm) {
        if (searchTerm) {
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
      WHERE MATCH(s.song_name) AGAINST(?)`, [searchTerm]);
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
};
exports.SongsService = SongsService;
exports.SongsService = SongsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, common_1.Inject)(db_module_1.Database)),
    __metadata("design:paramtypes", [Object])
], SongsService);
//# sourceMappingURL=songs.service.js.map