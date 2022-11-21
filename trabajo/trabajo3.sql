--1 Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido

CREATE DATABASE desafio_yonathan_cordero_150;
CREATE TABLE users(
  id SERIAL,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  rol VARCHAR
  );

INSERT INTO users(email, name, last_name, rol) VALUES 
('gon@mail.com', 'gon', 'freccs', 'administrador'),
('killua@mail.com', 'killua', 'zoldick', 'usuario'),
('kurapica@mail.com', 'kurapica', 'blond', 'usuario'),
('leorio@mail.com','leorio', 'paladinight', 'usuario'),
('hizoka@mail.com', 'hizoka', 'clown', 'usuario');

CREATE TABLE posts(
  id SERIAL,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  outstanding BOOLEAN NOT NULL DEFAULT FALSE,
  user_id BIGINT
);

INSERT INTO posts (title, content, created_at,
updated_at, outstanding, user_id) VALUES 
('prueba', 'contenido prueba', '01/01/2021', '01/02/2021', true, 1),
('prueba2', 'contenido prueba2', '01/03/2021', '01/03/2021', true, 1),
('ejercicios', 'contenido ejercicios', '02/05/2021', '03/04/2021', true, 2),
('ejercicios2', 'contenido ejercicios2', '03/05/2021', '04/04/2021', false, 2),
('random', 'contenido random', '03/06/2021', '04/05/2021', false, null);

CREATE TABLE comments(
  id SERIAL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  user_id BIGINT,
  post_id BIGINT
);

INSERT INTO comments (content, created_at, user_id,
post_id) VALUES 
('comentario 1', '03/06/2021', 1, 1),
('comentario 2', '03/06/2021', 2, 1),
('comentario 3', '04/06/2021', 3, 1),
('comentario 4', '04/06/2021', 1, 2);

-- 2-Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas.
-- nombre e email del usuario junto al título y contenido del post

SELECT users.name, users.email, posts.title, posts.content FROM users INNER JOIN posts ON users.id = posts.user_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores. El administrador
-- puede ser cualquier id y debe ser seleccionado dinámicamente. 

SELECT posts.id, posts.title, posts.content FROM posts INNER JOIN users ON posts.user_id = users.id WHERE users.rol = 'administrador';  

-- 4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id y
-- email del usuario junto con la cantidad de posts de cada usuario

SELECT COUNT(posts), users.id, users.email FROM posts RIGHT JOIN users ON posts.user_id = users.id GROUP BY users.id, users.email ORDER BY users.id ASC;

-- 5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene
-- un único registro y muestra solo el email.

SELECT users.email FROM posts JOIN users ON posts.user_id = users.id GROUP BY users.id, users.email ORDER BY COUNT(posts.id) DESC;

-- 6. Muestra la fecha del último post de cada usuario.

SELECT users.id, users.name, MAX(posts.created_at) FROM posts JOIN users ON posts.user_id = users.id GROUP BY users.id, users.name ORDER BY users.id ASC;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios

SELECT posts.title,posts.content FROM comments INNER JOIN posts ON comments.post_id = posts.id GROUP BY comments.post_id, posts.title, posts.content order by post_id ASC limit 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
-- de cada comentario asociado a los posts mostrados, junto con el email del usuario
-- que lo escribió.

SELECT posts.title,posts.content,comments.content AS comment_content ,users.email FROM posts INNER JOIN comments ON posts.id = comments.post_id INNER JOIN users ON comments.user_id = users.id;

-- 9. Muestra el contenido del último comentario de cada usuario. 

SELECT comments.created_at, comments.content, comments.user_id FROM comments INNER JOIN (SELECT max(comments.id) AS id_max FROM comments GROUP BY user_id) AS tb_max ON comments.id = tb_max.id_max ORDER BY comments.user_id;

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario

SELECT users.email FROM users LEFT JOIN comments ON users.id = comments.user_id WHERE comments.content IS NULL;