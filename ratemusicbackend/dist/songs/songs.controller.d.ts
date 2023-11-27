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
export declare class FilterSongsDto {
    searchTerm?: string;
    startDate?: string;
    endDate?: string;
    selectedGenre?: string;
    isSingle?: boolean;
    minDuration?: number;
    maxDuration?: number;
}
export declare class AdvancedFilterSongsDto {
    topValue?: number;
    comparator?: string;
    ratingValue?: number;
}
export declare class SongsController {
    private readonly songsService;
    constructor(songsService: SongsService);
    getAllGenres(): Promise<any>;
    findAllSongs(searchTerm?: string): Promise<any>;
    filterSongs(filterSongsDto: FilterSongsDto): Promise<any>;
    advancedFilterSongs(advancedFilterSongsDto: AdvancedFilterSongsDto): Promise<any>;
    findAllAlbums(searchTerm?: string): Promise<any>;
    getAllSongReviews(): Promise<any>;
    getSongReviews(songName?: string, releaseDate?: string): Promise<any>;
    getAllAlbumReviews(): Promise<any>;
    createAlbumReview(createAlbumReviewDto: CreateAlbumReviewDto): Promise<any>;
    createSongReview(createSongReviewDto: CreateSongReviewDto): Promise<any>;
}
