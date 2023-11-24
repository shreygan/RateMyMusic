import { SongsService } from './songs.service';
export declare class CreateReviewDto {
    readonly rating: number;
    readonly reviewText: string;
    readonly albumName: string;
    readonly releaseDate: string;
    readonly pid: string;
}
export declare class SongsController {
    private readonly songsService;
    constructor(songsService: SongsService);
    findAll(searchTerm?: string): Promise<any>;
    getAllSongReviews(): Promise<any>;
    getAllAlbumReviews(): Promise<any>;
    createAlbumReview(createReviewDto: CreateReviewDto): Promise<any>;
}
