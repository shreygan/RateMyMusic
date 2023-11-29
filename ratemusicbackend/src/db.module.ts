import { Module, Global } from '@nestjs/common';
import { createPool } from 'mysql2';

const connectionPool = createPool({
  host: '127.0.0.1',
  user: 'super-user',
  password: 'password',
  database: 'rymdb',
  waitForConnections: true,
  connectionLimit: 10,
  maxIdle: 10, 
  idleTimeout: 60000,
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,
  multipleStatements: true
})

export const Database = 'DATABASE_CONNECTION'

@Global()
@Module({
  providers: [
    {
      provide: Database,
      useValue: connectionPool,
    },
  ],
  exports: [Database],
})
export class DatabaseModule {}