import { SongsService } from './songs.service';
export interface CreateAlbumReviewDto {
    rating: number;
    reviewText: string;
    albumName: string;
    releaseDate: string;
    pid: number;
}
export interface CreateSongReviewDto {
    rating: number;
    reviewText: string;
    songName: string;
    releaseDate: string;
    pid: number;
}
export declare class SongsController {
    private readonly songsService;
    constructor(songsService: SongsService);
    findAllSongs(searchTerm?: string): Promise<any>;
    findAllAlbums(searchTerm?: string): Promise<any>;
    getAllSongReviews(): Promise<any>;
    getAllAlbumReviews(): Promise<any>;
    createAlbumReview(createAlbumReviewDto: CreateAlbumReviewDto): Promise<any>;
    createSongReview(createSongReviewDto: CreateSongReviewDto): Promise<any>;
}
