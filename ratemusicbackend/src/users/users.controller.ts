import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { UsersService } from './users.service';

export interface User {
  pid: number;
  birthdate: string;
  email: string;
  birthplace: string;
  username: string;
  password: string;
  name: string;
  profile_pic: string;
  age: number
}

export interface ReviewDelete {
  rid: number;
  userpid: any;
}

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  // @Post('getuserbygenre')
  // async getUsersByGenre(@Body() genre){
  //   return await this.usersService.getUsersByGenre(genre);
  // }

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
