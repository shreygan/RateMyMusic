import { Controller, Get, Post, Body, Query } from '@nestjs/common';
import { SongsService } from './songs.service';


export class CreateReviewDto {
  readonly rating: number;
  readonly reviewText: string;
  readonly albumName: string;
  readonly releaseDate: string;
  readonly pid: string;
}



@Controller('songs')
export class SongsController {
  constructor(private readonly songsService: SongsService) {}

  @Get('findsongs')
  async findAll(
    @Query('q') searchTerm?: string
  ) {
    return await this.songsService.findAll(searchTerm);
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
  async createAlbumReview(@Body() createReviewDto: CreateReviewDto) {
    return await this.songsService.createAlbumReview(createReviewDto);
  }

 
}
