DROP USER IF EXISTS 'franxk_elsax' @'localhost';
CREATE USER 'franxk_elsax' @'localhost' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO 'franxk_elsax' @'localhost';
ALTER USER 'franxk_elsax' @'localhost' IDENTIFIED WITH mysql_native_password BY '';
FLUSH PRIVILEGES;
DROP DATABASE IF EXISTS caqueter;
CREATE DATABASE caqueter;
USE caqueter;
CREATE TABLE user (
  id_user INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  pseudo VARCHAR(15) UNIQUE,
  mail VARCHAR (64) UNIQUE,
  mdp TEXT,
  photo VARCHAR(255) DEFAULT "pictures/default.png"
);
CREATE TABLE caque (
  id_caque INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  id_user INT,
  caque VARCHAR(140),
  `date` DATETIME DEFAULT NOW(),
  CONSTRAINT FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON UPDATE CASCADE
);
CREATE TABLE abonnements(
  id_user INT,
  id_abonnement INT,
  do_delete TINYINT DEFAULT 0,
  PRIMARY KEY (`id_user`, `id_abonnement`),
  CONSTRAINT FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY (`id_abonnement`) REFERENCES `user` (`id_user`) ON UPDATE CASCADE
);
CREATE TABLE reaction (
  id_user INT,
  id_caque INT,
  ronron BOOLEAN DEFAULT false,
  PRIMARY KEY (`id_user`, `id_caque`),
  CONSTRAINT FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY (`id_caque`) REFERENCES `caque` (`id_caque`) ON UPDATE CASCADE
);
INSERT INTO
  user (pseudo, mail, mdp)
VALUES
  ('lskr', 'lskr@gmail.com', 'lskr'),
  ('lua', 'lua@jardinerie.com', 'lua'),
  ('bamy', 'bamy@gmail.com', 'bamy'),
  ('aaron', 'aaron@jsp.com', 'aaron'),
  ('tchdu94', 'tchdu94@gmail.com', 'tchdu94'),
  ('asta', 'asta@gmail.com', 'asta');
INSERT INTO
  caque (id_user, caque)
VALUES
  (1, "Nouveau sur caqueter #caquette #nouveau"),
  (
    1,
    "IT’S OUT EVERYWHERE https://songwhip.com/lskr/youre-mine"
  ),
  (1, "petite game d'Apex pre-exam"),
  (
    1,
    "qqn peut jouer à KurtzPel avec oim svp y en a marre là @everyone"
  ),
  (1, "salut ça va bg ? @bamy"),
  (1, "Super aprem avec @asta @bamy"),
  (
    2,
    "Wsh la glace carotte-orange c'est validé #viveLaGlace"
  ),
  (
    2,
    "Tout plaquer et devenir une star du jour fkkf #jePleure"
  ),
  (
    2,
    "Le prof de neuro il avait déconné là : ""maintenant on a le bac sans savoir lire et écrire"""
  ),
  (
    2,
    "Nan mais c’est trop demandé de DORMIR ???????????????"
  ),
  (2, "Hier j'ai retouché à... Skyrim #gaming"),
  (
    2,
    "Je relate à 2h près, les mangas creusent mon tombeau"
  ),
  (
    3,
    "The teacher explaining it vs. the guy on YouTube #comprendraQuiPourra"
  ),
  (
    3,
    "Baudelaire main dans la main avec moi essayant de convaincre ma mère de m’acheter des Nike : LA VIRGULE COMPTE"
  ),
  (3, "Je meurs pour elle je vous jure"),
  (
    4,
    "Querer-te nunca é demais, é ter o coração do lado certo #DiogoPiçarra"
  ),
  (
    4,
    "Oh les glaces, comment ça manque #viveLaGlace"
  ),
  (
    4,
    "Morangos com Açucar n’était qu’un dessert à cette époque là… rendez-vous compte @lua"
  ),
  (
    4,
    "Une fois j’ai fais balard maison alfort j’ai cru j’allais en Martinique"
  ),
  (4, "En plus passe d de Marchesin #foot"),
  (4, "João Mário polalala le buuut #foot"),
  (
    4,
    "L’équipe revit sans Marega ou c’est comment ?? #foot"
  ),
  (
    4,
    "4-0 ? Marega aurait dû annoncer son départ avant hein"
  ),
  (4, "Incroyable les sac Chanel"),
  (
    5,
    "30 degrés hier à Bordeaux, c’était incroyable"
  ),
  (5, ":( #sad"),
  (
    6,
    "Francés como idioma, fotos de Paris, anécdotas y vainas sobre mi vida algo innecesarias. I'm all about cheap memes with no sense."
  ),
  (
    6,
    "A mí me pasó en la primera cita so sí sjakwkdjdj @bamy"
  ),
  (
    6,
    "est ce que j’ai séché le travaille? totalement, vive apex #gaming"
  ),
  (6, "viré de chez moi #sad"),
  (
    6,
    "eh t'es chaud tu m'accueilles chez toi ? @lskr"
  ),
  (6, "alors c’est vraiment fini snk #sad"),
  (
    6,
    "trop bon aprem aujourd'hui avec @lskr et @lua"
  ),
  (6, "ssshheeeeeeshhh"),
  (6, "vive jujutsu");
INSERT INTO
  reaction(id_user, id_caque, ronron)
VALUES
  (1, 5, TRUE),
  (1, 21, TRUE),
  (1, 32, FALSE),
  (1, 9, FALSE),
  (1, 15, TRUE),
  (1, 20, TRUE),
  (1, 35, FALSE),
  (1, 4, FALSE),
  (1, 17, TRUE),
  (1, 6, TRUE),
  (1, 29, FALSE),
  (2, 18, TRUE),
  (2, 13, TRUE),
  (2, 6, FALSE),
  (2, 27, TRUE),
  (3, 16, FALSE),
  (3, 26, FALSE),
  (3, 4, FALSE),
  (3, 21, FALSE),
  (3, 34, FALSE),
  (4, 1, TRUE),
  (4, 18, TRUE),
  (4, 2, TRUE),
  (4, 22, TRUE),
  (4, 33, TRUE),
  (4, 8, TRUE),
  (4, 14, TRUE),
  (4, 5, FALSE),
  (4, 17, FALSE),
  (4, 7, FALSE),
  (5, 17, TRUE),
  (5, 28, TRUE),
  (5, 22, FALSE),
  (5, 24, TRUE),
  (5, 4, FALSE),
  (5, 20, FALSE),
  (5, 2, TRUE),
  (5, 19, FALSE),
  (5, 9, FALSE),
  (5, 7, TRUE),
  (5, 31, TRUE),
  (5, 10, FALSE),
  (5, 14, TRUE),
  (5, 26, TRUE),
  (5, 16, FALSE),
  (5, 34, FALSE),
  (5, 1, TRUE),
  (5, 3, FALSE),
  (5, 27, FALSE),
  (5, 30, TRUE),
  (6, 25, TRUE),
  (6, 21, TRUE),
  (6, 7, TRUE),
  (6, 12, TRUE),
  (6, 9, FALSE),
  (6, 24, TRUE),
  (6, 3, TRUE),
  (6, 20, TRUE),
  (6, 5, TRUE),
  (6, 30, FALSE),
  (6, 22, TRUE),
  (6, 14, FALSE),
  (6, 16, FALSE),
  (6, 34, FALSE),
  (6, 10, TRUE),
  (6, 19, FALSE),
  (6, 2, FALSE),
  (6, 1, FALSE),
  (6, 15, TRUE),
  (6, 8, TRUE);
INSERT INTO
  abonnements (id_user, id_abonnement)
VALUES
  (1, 2),
  (1, 3),
  (1, 4),
  (1, 5),
  (3, 5),
  (3, 1),
  (3, 2),
  (4, 2),
  (4, 1),
  (4, 6),
  (5, 2),
  (5, 3),
  (5, 4),
  (5, 1),
  (6, 1),
  (6, 2),
  (6, 3),
  (6, 4),
  (6, 5);
DROP VIEW IF EXISTS full_caque;
CREATE VIEW full_caque (
    id_user,
    username,
    id_caque,
    caque,
    `date`,
    nb_ronron,
    photo
  ) as (
    SELECT
      c.id_user,
      u.pseudo,
      c.id_caque,
      c.caque,
      c.date,
      (
        SELECT
          COUNT(*)
        FROM
          reaction r
        WHERE
          r.id_caque = c.id_caque
          AND ronron = true
      ) AS ronron,
      u.photo
    FROM
      caque c
      JOIN user u ON u.id_user = c.id_user
  );