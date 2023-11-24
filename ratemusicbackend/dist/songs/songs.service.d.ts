import { Connection } from 'mysql2';
export declare class SongsService {
    private readonly connection;
    constructor(connection: Connection);
    private readonly query;
    createAlbumReview(createReviewDto: any): Promise<any>;
    getAllAlbumReviews(): Promise<any>;
    getAllSongReviews(): Promise<any>;
    findAll(searchTerm?: string): Promise<any>;
}
