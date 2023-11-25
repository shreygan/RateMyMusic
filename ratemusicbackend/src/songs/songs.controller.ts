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


@Controller('songs')
export class SongsController {
  constructor(private readonly songsService: SongsService) {}

  @Get('findsongs')
  async findAllSongs(
    @Query('q') searchTerm?: string
  ) {
    return await this.songsService.findAllSongs(searchTerm);
  }

  @Get('findalbums')
  async findAllAlbums(
    @Query('q') searchTerm?: string
  ) {
    return await this.songsService.findAllAlbums(searchTerm);
  }


  @Get('songreviews')
  async getAllSongReviews() {
    return await this.songsService.getAllSongReviews();
  }


  @Get('albumreviews')
  async getAllAlbumReviews() {
    return await this.songsService.getAllAlbumReviews();
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
