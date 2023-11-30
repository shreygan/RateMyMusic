INSERT
INTO User4(pid, birthdate, birthplace, username, password)
VALUES (83726415, '2003-05-28', 'Manitoba, Canada', 'AngelPretty', 'makeup1'),
       (41902873, '1968-11-02', 'Indiana, USA', 'twocoffeeonemommy', 'ilovemygrandkids123'),
       (62519038, '2014-09-19', 'Ontario, Canada', 'PORK_MAN', 'Fortnite@123'),
       (29384756, '2000-06-27', 'Texas, USA', 'squaresalad', 'Egalitarianism'),
       (80172634, '1945-12-12', 'New Jersey, USA', 'tillyfumpy', 'ChickenButt');

INSERT
INTO User3(username, birthdate, age)
VALUES ('AngelPretty', '2003-05-28', 20),
       ('twocoffeeonemommy', '1968-11-02', 55),
       ('PORK_MAN', '2014-09-19', 9),
       ('squaresalad', '2000-06-27', 23),
       ('tillyfumpy', '1945-12-12', 77);

INSERT
INTO User2(username, name)
VALUES ('AngelPretty', 'Sofia Cavalry'),
       ('twocoffeeonemommy', 'Brenda Hepburn'),
       ('PORK_MAN', 'Hunter McKinnon'),
       ('squaresalad', 'James Diaz'),
       ('tillyfumpy', 'Howard Buggs');

INSERT
INTO User1(username, email)
VALUES ('AngelPretty', 'pretty_angel458@hotmial.com'),
       ('twocoffeeonemommy', 'brenda.hepburn1968@gmail.com'),
       ('PORK_MAN', 'zapbran7777@gmail.com'),
       ('squaresalad', 'diaz.minecraft@gmail.com'),
       ('tillyfumpy', 'Howard.S.Buggs1945@gmail.com');

INSERT
INTO Follows(followerid, followeeid, follow_date)
VALUES (62519038, 83726415, '2023-05-05'),
       (62519038, 41902873, '2023-05-05'),
       (62519038, 62519038, '2023-05-05'),
       (62519038, 29384756, '2023-05-05'),
       (62519038, 80172634, '2023-05-05');

INSERT
INTO Artist2(pid, name, birthdate, birthplace, genre, description, label, is_dead, artist_pic)
VALUES (52033688, 'Ryo Fukui', '1948-06-01', 'Biratori, Hokkaido, Japan', 'Jazz',
        'Ryo Fukui was a Japanese jazz pianist, he regularly played at his own "Slowboat" jazz club in Sapporo. His work has seen a spike in popularity after his death, around the year 2010. ',
        'Independent', 1, LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/artists/Ryo Fukui.jpeg')),
       (62043498, 'NAV', '1989-11-03', 'Toronto, Canada', 'Hip-Hop',
        'Navraj Singh Goraya, known professionally as Nav, is a Canadian rapper, singer, songwriter, and record producer.',
        'XO', 0, LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/artists/NAV.jpg')),
       (32512674, 'Drake', '1986-10-24', 'Toronto, Canada', 'Hip-Hop',
        'Aubrey Drake Graham, known professionally as Drake, is a Canadian rapper, singer, songwriter, and actor. He first gained major recognition as a rapper following the release of his mixtape "Room for Improvement" in 2006.',
        'OVO Sound', 0, LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/artists/Drake.jpg')),
       (89320472, 'Kanye West', '1977-06-08', 'Atlanta, Georgia, USA', 'Hip-Hop',
        'Kanye Omari West is an American rapper, singer, songwriter, record producer, and fashion designer. He is widely regarded as one of the most influential musicians of his generation.',
        'GOOD Music', 0, LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/artists/Kanye.jpg')),
       (48297392, 'Kendrick Lamar', '1987-06-17', 'Compton, California, USA', 'Hip-Hop',
        'Kendrick Lamar Duckworth, known as Kendrick Lamar, is an American rapper, songwriter, and record producer. He is regarded as one of the most skillful and successful hip-hop artists of his generation.',
        'Top Dawg Entertainment', 0, LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/artists/Kendrick.jpg'));

INSERT
INTO Artist1(name, birthdate, is_dead, age)
VALUES ('Ryo Fukui', '1948-06-01', 1, 67),
       ('NAV', '1989-11-03', 0, 34),
       ('Drake', '1986-10-24', 0, 36),
       ('Kanye West', '1977-06-08', 0, 46),
       ('Kendrick Lamar', '1987-06-17', 0, 36);

INSERT
INTO Review2(rid, pid, review_date, review_text, likes, dislikes)
VALUES (12312312, 83726415, '2023-09-11', 'This is an amazing!', 20, 345),
       (23423423, 41902873, '2023-09-12', 'I really enjoyed.', 30, 0),
       (34534534, 62519038, '2023-09-13', 'Not my cup of tea.', 5, 3),
       (45645645, 29384756, '2023-09-14', 'Decent effort.', 19, 5),
       (56756756, 80172634, '2023-09-15', 'Could have been better.', 27, 18),
       (67867867, 83726415, '2023-09-16', 'Absolutely breathtaking!', 25, 10),
       (67867868, 41902873, '2023-09-17', 'This track is fire.', 35, 0),
       (67867869, 62519038, '2023-09-18', 'A decent song but not my taste.', 15, 7),
       (67867870, 29384756, '2023-09-19', 'A classic, never gets old.', 29, 6),
       (67867871, 80172634, '2023-09-20', 'This song speaks volumes.', 37, 9),
       (67867872, 41902873, '2023-09-21', 'This user chart has a great selection of albums!', 40, 4),
       (67867873, 83726415, '2023-09-21', 'WOW!', 40, 7),
       (67867874, 83726415, '2023-09-22', 'This kind of sucks ngl', 20, 400),
       (67867875, 83726415, '2023-09-24', 'Great!', 47, 1),
       (67867876, 83726415, '2023-09-26', 'Sucks!', 15, 45);

INSERT
INTO Review1(review_date, likes, dislikes, helpfulness)
VALUES ('2023-09-11', 20, 345, 0),
       ('2023-09-12', 30, 0, 5),
       ('2023-09-13', 5, 3, 3),
       ('2023-09-14', 19, 5, 4),
       ('2023-09-15', 27, 18, 2),
       ('2023-09-16', 25, 10, 5),
       ('2023-09-17', 35, 0, 10),
       ('2023-09-18', 15, 7, 7),
       ('2023-09-19', 29, 6, 9),
       ('2023-09-20', 37, 9, 8),
       ('2023-09-21', 40, 4, 10);

INSERT
INTO Comment2(comment_date, comment_text, likes, dislikes, review_pid, rid, comment_pid)
VALUES ('2023-10-19 10:00:00', 'Loved this!', 45, 2, 83726415, 12312312, 58708),
       ('2023-10-19 11:00:00', 'Absolutely agree.', 50, 1, 41902873, 23423423, 58708),
       ('2023-10-19 12:30:00', 'I have mixed feelings.', 38, 10, 62519038, 34534534, 58708),
       ('2023-10-19 13:45:00', 'Nice perspective!', 24, 4, 29384756, 45645645, 58708),
       ('2023-10-19 15:00:00', 'Found this insightful.', 60, 5, 80172634, 56756756, 58708);

INSERT
INTO Comment1(comment_date, likes, dislikes, position)
VALUES ('2023-10-19 10:00:00', 45, 2, 1),
       ('2023-10-19 11:00:00', 50, 1, 2),
       ('2023-10-19 12:30:00', 38, 10, 3),
       ('2023-10-19 13:45:00', 24, 4, 4),
       ('2023-10-19 15:00:00', 60, 5, 5);

INSERT
INTO Album(album_name, release_date, isSingle, genre, duration, cover, number_of_songs)
VALUES ('Scenery', '1976-02-01', false, 'Jazz', 644, LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/albums/Scenery.jpg'), 6),
       ('Good Intentions', '2020-05-08', false, 'Rap', 179, LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/albums/Good Intentions.jpg'), 12),
       ('If You''re Reading This It''s Too Late', '2015-02-13', false, 'Rap', 299, LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/albums/IYRTITL.jpg'), 17),
       ('The College Dropout', '2003-09-30', false, 'Hip hop/UK R&B', 226, LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/albums/College Dropout.jpg'), 15),
       ('To Pimp a Butterfly', '2015-03-15', false, 'Hip hop/Rap', 275, LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/albums/To Pimp a Butterfly.jpg'), 16);

INSERT
INTO Song(song_name, release_date, duration, genre)
VALUES ('Early Summer', '1976-06-07', '644', 'Jazz'),
       ('Did You Wrong', '2020-05-08', '179', 'Rap'),
       ('Know Yourself', '2015-02-13', 100, 'Rap'),
       ('Through the Wire', '2003-09-30', 100, 'Hip hop/UK R&B'),
       ('Wesley’s Theory', '2015-03-15', 100, 'Hip hop/Rap');

INSERT
INTO AlbumSong(album_name, album_release_date, song_name, song_release_date)
VALUES ('Scenery', '1976-02-01', 'Early Summer', '1976-06-07'),
       ('Good Intentions', '2020-05-08', 'Did You Wrong', '2020-05-08'),
       ('If You''re Reading This It''s Too Late', '2015-02-13', 'Know Yourself', '2015-02-13'),
       ('The College Dropout', '2003-09-30', 'Through the Wire', '2003-09-30'),
       ('To Pimp a Butterfly', '2015-03-15', 'Wesley’s Theory', '2015-03-15');

INSERT
INTO ArtistAlbum(pid, album_name, release_date)
VALUES (52033688, 'Scenery', '1976-02-01'),
       (62043498, 'Good Intentions', '2020-05-08'),
       (32512674, 'If You''re Reading This It''s Too Late', '2015-02-13'),
       (89320472, 'The College Dropout', '2003-09-30'),
       (48297392, 'To Pimp a Butterfly', '2015-03-15');

INSERT
INTO ArtistSong(pid, song_name, release_date)
VALUES (52033688, 'Early Summer', '1976-06-07'),
       (62043498, 'Did You Wrong', '2020-05-08'),
       (32512674, 'Know Yourself', '2015-02-13'),
       (89320472, 'Through the Wire', '2003-09-30'),
       (48297392, 'Wesley’s Theory', '2015-03-15');

INSERT
INTO AlbumReview(rid, pid, album_name, release_date, rating)
VALUES (12312312, 83726415, 'Scenery', '1976-02-01', 5),
       (23423423, 41902873, 'Good Intentions', '2020-05-08', 4),
       (34534534, 62519038, 'If You''re Reading This It''s Too Late', '2015-02-13', 5),
       (45645645, 29384756, 'The College Dropout', '2003-09-30', 5),
       (56756756, 80172634, 'To Pimp a Butterfly', '2015-03-15', 5);

INSERT
INTO SongReview(rid, pid, song_name, release_date, rating)
VALUES (67867867, 83726415, 'Early Summer', '1976-06-07', 5),
       (67867868, 41902873, 'Did You Wrong', '2020-05-08', 4),
       (67867869, 62519038, 'Know Yourself', '2015-02-13', 5),
       (67867870, 29384756, 'Through the Wire', '2003-09-30', 5),
       (67867871, 80172634, 'Wesley’s Theory', '2015-03-15', 5);

INSERT
INTO Playlist(pid, playlist_name, creation_date, image, description)
VALUES (58708, 'Jazz Vibes', '2023-09-20', LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/playlists/Jazz.jpg'), 'Relax with some smooth jazz tunes.'),
       (58708, 'Rap Essentials', '2023-09-21', LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/playlists/Rap.jpg'), 'The hottest rap tracks right now.'),
       (58708, 'Hip Hop Classics', '2023-09-22', LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/playlists/Hip Hop Classics.jpeg'),
        'Take a trip down memory lane with these hip hop classics.'),
       (58708, 'R&B Soul', '2023-09-23', LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/playlists/R&B.jpg'), 'Soothing R&B for the soul.'),
       (58708, 'Top Hits', '2023-09-24', LOAD_FILE('/Users/shrey/Documents/Stuff/UBC/1 - CPSC304/rym/src/assets/playlists/Top Hits.jpg'), 'The chart-topping hits everyone is listening to.');

INSERT
INTO PlaylistSong(pid, playlist_name, creation_date, song_name, release_date)
VALUES (58708, 'Rap Essentials', '2023-09-21', 'Did You Wrong', '2020-05-08'),
       (58708, 'Hip Hop Classics', '2023-09-22', 'Through the Wire', '2003-09-30'),
       (58708, 'R&B Soul', '2023-09-23', 'Know Yourself', '2015-02-13'),
       (58708, 'Top Hits', '2023-09-24', 'Wesley’s Theory', '2015-03-15'),
       (58708, 'Jazz Vibes', '2023-09-20', 'Wesley’s Theory', '2015-03-15');

INSERT
INTO UserChart(ucid, userchart_name, image, pid)
VALUES (10626415, 'My Favorite Albums', null,  83726415),
       (10626414, 'Brenda''s Top 5 Albums', null,  41902873),
       (10626413, 'Hunter''s Top 5 Albums', null,  62519038),
       (10626412, 'James''s Top 5 Albums', null,  29384756),
       (10626411, 'Howard''s Top 5 Albums', null, 80172634);

INSERT
INTO UserChartAlbum(ucid, pid, album_name, release_date, ranking)
VALUES (10626415, 83726415, 'Scenery', '1976-02-01', 1),
       (10626415, 83726415, 'Good Intentions', '2020-05-08', 2),
       (10626415, 83726415, 'If You''re Reading This It''s Too Late', '2015-02-13', 3),
       (10626415, 83726415, 'The College Dropout', '2003-09-30', 4),
       (10626415, 83726415, 'To Pimp a Butterfly', '2015-03-15', 5),
       (10626414, 41902873, 'Scenery', '1976-02-01', 1),
       (10626414, 41902873, 'Good Intentions', '2020-05-08', 2),
       (10626414, 41902873, 'If You''re Reading This It''s Too Late', '2015-02-13', 3),
       (10626414, 41902873, 'The College Dropout', '2003-09-30', 4),
       (10626414, 41902873, 'To Pimp a Butterfly', '2015-03-15', 5),
       (10626413, 62519038, 'The College Dropout', '2003-09-30', 1),
       (10626413, 62519038, 'To Pimp a Butterfly', '2015-03-15', 2),
       (10626413, 62519038, 'Scenery', '1976-02-01', 3),
       (10626413, 62519038, 'Good Intentions', '2020-05-08', 4),
       (10626413, 62519038, 'If You''re Reading This It''s Too Late', '2015-02-13', 5),
       (10626412, 29384756, 'If You''re Reading This It''s Too Late', '2015-02-13', 1),
       (10626412, 29384756, 'The College Dropout', '2003-09-30', 2),
       (10626412, 29384756, 'To Pimp a Butterfly', '2015-03-15', 3),
       (10626412, 29384756, 'Good Intentions', '2020-05-08', 4),
       (10626412, 29384756, 'Scenery', '1976-02-01', 5),
       (10626411, 80172634, 'To Pimp a Butterfly', '2015-03-15', 1),
       (10626411, 80172634, 'The College Dropout', '2003-09-30', 2),
       (10626411, 80172634, 'Scenery', '1976-02-01', 3),
       (10626411, 80172634, 'If You''re Reading This It''s Too Late', '2015-02-13', 4),
       (10626411, 80172634, 'Good Intentions', '2020-05-08', 5);

INSERT
INTO UserChartReview(ucid, uc_pid, rv_pid, rid, rating)
VALUES (10626415, 83726415, 41902873, 67867872, 4),
       (10626414, 41902873, 83726415, 67867873, 3),
       (10626413, 62519038, 83726415, 67867874, 5),
       (10626412, 29384756, 83726415, 67867875, 2),
       (10626411, 80172634, 83726415, 67867876, 0);