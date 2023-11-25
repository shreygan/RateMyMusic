import { Connection } from 'mysql2';
export declare class SongsService {
    private readonly connection;
    constructor(connection: Connection);
    private readonly query;
    getAllGenres(): Promise<any>;
    filterSongs(filterSongsDto: any): Promise<any>;
    advancedFilterSongs(advancedFilterSongsDto: any): Promise<any>;
    createSongReview(createSongReviewDto: any): Promise<any>;
    createAlbumReview(createAlbumReviewDto: any): Promise<any>;
    getAllAlbumReviews(): Promise<any>;
    getAllSongReviews(): Promise<any>;
    findAllSongs(searchTerm?: string): Promise<any>;
    findAllAlbums(searchTerm?: string): Promise<any>;
}
