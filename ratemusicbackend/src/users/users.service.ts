import { Injectable, Inject } from '@nestjs/common';
import { Connection } from 'mysql2';
import { Database } from '../db.module';
import { promisify } from 'util';
import { User } from './users.controller';

@Injectable()
export class UsersService {
  constructor(
    @Inject(Database)
    private readonly connection: Connection,
  ) {}

  private readonly query = promisify(this.connection.query).bind(
    this.connection,
  );

  async getAllUsers() {
    return await this.query('SELECT * FROM User4');
  }

  //CREATE TABLE IF NOT EXISTS User4 (
  // pid INTEGER PRIMARY KEY,
  // birthdate DATE,
  // birthplace VARCHAR(50),
  // username VARCHAR(50) NOT NULL UNIQUE,
  // password VARCHAR(100),
  // profile_pic LONGBLOB

  async addUser(user: User) {
    const pid = Math.floor(Math.random() * 90000) + 10000;
    return await this.query(
      `INSERT INTO User4 (pid, birthdate, birthplace, username, password, profile_pic) VALUES (?, ?, ?, ?, ?, ?);`, [pid, user.birthdate, user.birthplace, user.username, user.password, user.profile_pic]
    );
  }

  async login(user: User) {
    const users = await this.query(
        `SELECT * FROM User4 WHERE username = ? AND password = ?;`, [user.username, user.password]
        );

    return users[0];
  }
}
