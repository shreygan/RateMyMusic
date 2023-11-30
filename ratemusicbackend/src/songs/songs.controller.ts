import { Controller, Get, Post, Body, Query } from '@nestjs/common';
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

export interface CreateUserchartReviewDto {
  rating: number;
  reviewText: string;
  ucid: number;
  uc_pid: number;
  pid: number;
}

export class FilterSongsDto {
  searchTerm?: string;
  startDate?: string;
  endDate?: string;
  selectedGenre?: string;
  isSingle?: boolean;
  minDuration?: number;
  maxDuration?: number;
}

export class AdvancedFilterSongsDto {
  topValue?: number;
  comparator?: string;
  ratingValue?: number;
}

@Controller('songs')
export class SongsController {
  constructor(private readonly songsService: SongsService) {}

  @Get('getalbumreviews')
  async getAlbumReviews(
    @Query('q') albumName?: string,
    @Query('year') releaseDate?: string,
  ) {
    return await this.songsService.getAlbumReviews(albumName, releaseDate);
  }


  @Get('getalbumsongs')
  async getAlbumSongs(
    @Query('q') albumName?: string,
    @Query('year') releaseDate?: string,
  ) {
    return await this.songsService.getAlbumSongs(albumName, releaseDate);
  }

  @Get('findusercharts')
  async findAllUsercharts(@Query('q') searchTerm?: string) {
    return await this.songsService.findAllUsercharts(searchTerm);
  }

  @Get('getallgenres')
  async getAllGenres() {
    return await this.songsService.getAllGenres();
  }

  @Get('findsongs')
  async findAllSongs(@Query('q') searchTerm?: string) {
    return await this.songsService.findAllSongs(searchTerm);
  }

  @Post('filtersongs')
  async filterSongs(@Body() filterSongsDto: FilterSongsDto) {
    return await this.songsService.filterSongs(filterSongsDto);
  }

  @Post('advancedfiltersongs')
  async advancedFilterSongs(@Body() data) {
    return await this.songsService.advancedFilterSongs(data);
  }

  @Get('findalbums')
  async findAllAlbums(@Query('q') searchTerm?: string) {
    return await this.songsService.findAllAlbums(searchTerm);
  }

  @Get('songreviews')
  async getAllSongReviews() {
    return await this.songsService.getAllSongReviews();
  }

  @Get('getsongreviews')
  async getSongReviews(
    @Query('q') songName?: string,
    @Query('year') releaseDate?: string,
  ) {
    return await this.songsService.getSongReviews(songName, releaseDate);
  }

  @Get('albumreviews')
  async getAllAlbumReviews() {
    return await this.songsService.getAllAlbumReviews();
  }

  @Post('createuserchartreviews')
  async createUserChartReview(
    @Body() createUserchartReviewDto: CreateUserchartReviewDto,
  ) {
    return await this.songsService.createUserChartReview(
      createUserchartReviewDto,
    );
  }

  @Post('createalbumreviews')
  async createAlbumReview(@Body() createAlbumReviewDto: CreateAlbumReviewDto) {
    return await this.songsService.createAlbumReview(createAlbumReviewDto);
  }

  @Post('createsongreviews')
  async createSongReview(@Body() createSongReviewDto: CreateSongReviewDto) {
    return await this.songsService.createSongReview(createSongReviewDto);
  }
}
