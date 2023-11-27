import { Body, Controller, Get, Post } from '@nestjs/common';
import { UsersService } from './users.service';

export interface User {
  pid: number;
  birthdate: string;
  birthplace: string;
  username: string;
  password: string;
  profile_pic: string;
}

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('getallusers')
  async getAllUsers() {
    return await this.usersService.getAllUsers();
  }

  @Post('createuser')
  async addUser(@Body() user) {
    return await this.usersService.addUser(user);
  }

  @Post('login')
  async login(@Body() user) {
    return await this.usersService.login(user);
  }
}
