import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { UsersService } from './users.service';
import { pid } from 'process';

export interface User {
  pid: number;
  birthdate: string;
  email: string;
  birthplace: string;
  username: string;
  password: string;
  name: string;
  profile_pic: string;
  age: number;
}

export interface UCData {
  pid: number;
  title: string;
  image: string;
  albums: any[];
}

export interface ReviewDelete {
  rid: number;
  userpid: any;
}

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post('insertreviewcomment')
  async insertReviewComment(@Body() data) {
    return await this.usersService.insertReviewComment(data);
  }

  @Post('getreviewcomments')
  async getReviewComments(@Body() data) {
    return await this.usersService.getReviewComments(data);
  }

  @Get('getalluserchartsfiltered')
  async getAllUserchartsFiltered(@Query('q') artist_pid?: string) {
    return await this.usersService.getAllUserChartsFiltered(artist_pid);
  }

  @Post('getuserreviews')
  async getUserReview(@Body() data) {
    return await this.usersService.getUserReview(data);
  }

  @Post('getplaylistsongs')
  async getPlaylistSongs(@Body() data) {
    return await this.usersService.getPlaylistSongs(data);
  }

  @Get('getallplaylists')
  async getAllPlaylists(@Query('q') searchTerm) {
    return await this.usersService.getAllPlaylists(searchTerm);
  }

  @Post('createplaylist')
  async createPlaylist(@Body() playlist) {
    return await this.usersService.createPlaylist(playlist);
  }

  @Post('getavgratingperuserchartalbum')
  async getAvgRatingPerUserChartAlbum(@Body() data) {
    return await this.usersService.getAvgRatingPerUserChartAlbum(data);
  }

  @Post('getuserchartalbums')
  async getUserChartAlbums(@Body() data) {
    return await this.usersService.getUserChartAlbums(data);
  }

  @Get('getallusercharts')
  async getAllUserCharts(@Query('q') searchTerm?: string) {
    return await this.usersService.getAllUserCharts(searchTerm);
  }

  @Get('getpersonalusercharts')
  async getPersonalUserCharts(@Query('q') userpid?: string) {
    return await this.usersService.getPersonalUserCharts(userpid);
  }

  @Post('insertuserchart')
  async insertUserChart(@Body() data) {
    return await this.usersService.insertUserChart(data);
  }

  @Post('avgratingperuser')
  async avgRatingPerUser(@Body() data) {
    return await this.usersService.avgRatingPerUser(data);
  }

  @Get('getuserbyid')
  async getUserById(@Query('q') userpid?: string) {
    return await this.usersService.getUserById(userpid);
  }

  @Get('getuseralbumreviews')
  async getUserAlbumReviews(@Query('q') userpid?: string) {
    return await this.usersService.getUserAlbumReviews(userpid);
  }

  @Get('getusersongreviews')
  async getUserSongReviews(@Query('q') userpid?: string) {
    return await this.usersService.getUserSongReviews(userpid);
  }

  @Get('getallusers')
  async getAllUsers() {
    return await this.usersService.getAllUsers();
  }

  @Post('deletereview')
  async deleteReview(@Body() data) {
    return await this.usersService.deleteReview(data);
  }

  @Post('createuser')
  async addUser(@Body() user) {
    return await this.usersService.addUser(user);
  }

  @Post('updateuser')
  async updateUser(@Body() user) {
    return await this.usersService.updateUser(user);
  }

  @Post('login')
  async login(@Body() user) {
    return await this.usersService.login(user);
  }
}
