#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. ��������� ������ �������, ������� ���� �� ���� ������. ������ ������� ������������� �� ���� ������� � �� ���������. � ������ �������� ������ 10 �������."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * FROM movies where (SELECT COUNT(*) FROM ratings where movie_id == movies.id) > 0 ORDER BY year, title LIMIT 10;"

echo "2. ������� ������ ���� �������������, ������� (�� �����!) ������� ���������� �� ����� 'A'. ���������� ������ ������������� �� ���� �����������. � ������ �������� ������ 5 �������������."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * FROM users WHERE name LIKE '%% A%%' ORDER BY register_date LIMIT 5;"

echo "3. �������� ������, ������������ ���������� � ��������� � ����� �������� �������: ��� � ������� ��������, �������� ������, ��� �������, ������ � ���� ������ � ������� ����-��-��. ������������� ������ �� ����� ��������, ����� �������� ������ � ������. � ������ �������� ������ 50 �������."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT users.name, movies.title, movies.year, rating, DATE(timestamp, 'unixepoch') as date FROM ratings INNER JOIN users ON users.id == user_id INNER JOIN movies ON movies.id == movie_id ORDER BY users.name, movies.title, rating LIMIT 50"

echo "4. ������� ������ ������� � ��������� �����, ������� ���� �� ��������� ��������������. ����������� �� ���� �������, ����� �� �������� ������, ����� �� ����. � ������ �������� ������ 40 �������."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT movies.*, tags.tag FROM movies INNER JOIN tags ON movies.id == movie_id ORDER BY movies.year, movies.title, tags.tag LIMIT 40;"

echo "5. ������� ������ ����� ������ �������. � ������ ������ ����� ��� ������ ���������� ���� �������, ��������� � ���� ������. ������ ������ ���� �������������, �� ��������� �� �������� ������ (������ ��� ������� ������ ������������ � �������, � �� ������ ����������)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * FROM movies WHERE year == (SELECT MAX(year) FROM movies);"

echo "6. ����� ��� �������, ���������� ����� 2000 ����, ������� ����������� �������� (������ �� ���� 4.5). ��� ������� ������ � ���� ������ ������� ��������, ��� ������� � ���������� ����� ������. ��������� ������������� �� ���� ������� � �������� ������."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT movies.title, movies.year, COUNT(DISTINCT ratings.id) FROM movies INNER JOIN ratings ON movies.id == movie_id INNER JOIN users ON ratings.user_id == users.id WHERE movies.year > 2000 AND movies.genres LIKE '%%Comedy%%' AND users.gender == 'male' and ratings.rating >= 4.5 GROUP BY movies.title ORDER BY movies.year, movies.title;"

echo "7. �������� ������ ������� (���������) ������������� - ������� ���������� ������������� ��� ������� ���� �������. ����� ����� ���������������� � ����� ������ ��������� ����������� �����."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT occupation, COUNT(DISTINCT id) as number FROM users GROUP BY occupation;"
sqlite3 movies_rating.db -box -echo "SELECT occupation, max(number) FROM (SELECT occupation, COUNT(DISTINCT id) as number FROM users GROUP BY occupation);"
sqlite3 movies_rating.db -box -echo "SELECT occupation, min(number) FROM (SELECT occupation, COUNT(DISTINCT id) as number FROM users GROUP BY occupation);"