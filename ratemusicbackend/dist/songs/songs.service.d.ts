import { Connection } from 'mysql2';
import { FilterSongsDto } from './songs.controller';
export declare class SongsService {
    private readonly connection;
    constructor(connection: Connection);
    private readonly query;
    getAllGenres(): Promise<any>;
    filterSongs(filterSongsDto: FilterSongsDto): Promise<any>;
    advancedFilterSongs(data: any): Promise<any>;
    createSongReview(createSongReviewDto: any): Promise<any>;
    createAlbumReview(createAlbumReviewDto: any): Promise<any>;
    getAllAlbumReviews(): Promise<any>;
    getAllSongReviews(): Promise<any>;
    getSongReviews(songName: string, releaseDate: string): Promise<any>;
    findAllSongs(searchTerm?: string): Promise<any>;
    findAllAlbums(searchTerm?: string): Promise<any>;
}
