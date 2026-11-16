-- =============================================================
-- Affiliate KPI — Modelo físico (MySQL 8.4)
-- Projeto Integrador — Senac
-- =============================================================

DROP DATABASE IF EXISTS affiliate_kpi;
CREATE DATABASE affiliate_kpi
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE affiliate_kpi;

-- -------------------------------------------------------------
-- USUARIO: afiliados e lojistas usam a mesma tabela (campo tipo)
-- -------------------------------------------------------------
CREATE TABLE usuario (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome        VARCHAR(100) NOT NULL,
  email       VARCHAR(150) NOT NULL,
  senha_hash  VARCHAR(255) NOT NULL,
  tipo        ENUM('AFILIADO', 'LOJA') NOT NULL,
  criado_em   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_usuario_email UNIQUE (email)
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- LOJA: vendedora do produto. Quando o usuário for do tipo LOJA,
-- obrigatoriamente precisa ter um loja.id associado
-- -------------------------------------------------------------
CREATE TABLE loja (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  usuario_id  INT UNSIGNED NOT NULL,
  nome        VARCHAR(120) NOT NULL,
  CONSTRAINT uq_loja_nome UNIQUE (nome),
  CONSTRAINT fk_loja_usuario FOREIGN KEY (usuario_id)
    REFERENCES usuario (id) ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE categoria (
  id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome  VARCHAR(80) NOT NULL,
  CONSTRAINT uq_categoria_nome UNIQUE (nome)
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- PRODUTO: o item à venda, compartilhado entre afiliados
-- -------------------------------------------------------------
CREATE TABLE produto (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  loja_id       INT UNSIGNED NOT NULL,
  categoria_id  INT UNSIGNED NOT NULL,
  nome          VARCHAR(150) NOT NULL,
  fabricante    VARCHAR(100) NULL,
  imagem_url    VARCHAR(500) NULL,
  preco         DECIMAL(10,2) NOT NULL,
  criado_em     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_produto_loja FOREIGN KEY (loja_id)
    REFERENCES loja (id),
  CONSTRAINT fk_produto_categoria FOREIGN KEY (categoria_id)
    REFERENCES categoria (id),
  CONSTRAINT ck_produto_preco CHECK (preco >= 0)
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- AFILIACAO: liga um afiliado a um produto que ele divulga (N:N).
-- É o que permite à loja ver o desempenho de vários afiliados.
-- -------------------------------------------------------------
CREATE TABLE afiliacao (
  id                   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  usuario_id           INT UNSIGNED NOT NULL,
  produto_id           INT UNSIGNED NOT NULL,
  link_afiliado        VARCHAR(500) NOT NULL,
  comissao_percentual  DECIMAL(5,2) NOT NULL,
  ativo                BOOLEAN NOT NULL DEFAULT TRUE,
  criado_em            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_afiliacao UNIQUE (usuario_id, produto_id),
  CONSTRAINT fk_afiliacao_usuario FOREIGN KEY (usuario_id)
    REFERENCES usuario (id) ON DELETE CASCADE,
  CONSTRAINT fk_afiliacao_produto FOREIGN KEY (produto_id)
    REFERENCES produto (id) ON DELETE CASCADE,
  CONSTRAINT ck_afiliacao_pct CHECK (comissao_percentual BETWEEN 0 AND 100)
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- METRICA_DIARIA: um registro por afiliação por dia
-- -------------------------------------------------------------
CREATE TABLE metrica_diaria (
  id               BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  afiliacao_id     INT UNSIGNED NOT NULL,
  data             DATE NOT NULL,
  visualizacoes    INT UNSIGNED NOT NULL DEFAULT 0,
  cliques          INT UNSIGNED NOT NULL DEFAULT 0,
  vendas           INT UNSIGNED NOT NULL DEFAULT 0,
  comissao_gerada  DECIMAL(10,2) NOT NULL DEFAULT 0,
  CONSTRAINT uq_metrica_dia UNIQUE (afiliacao_id, data),
  CONSTRAINT fk_metrica_afiliacao FOREIGN KEY (afiliacao_id)
    REFERENCES afiliacao (id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- NOTIFICACAO: visto_em NULL = não lida
-- -------------------------------------------------------------
CREATE TABLE notificacao (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  usuario_id  INT UNSIGNED NOT NULL,
  mensagem    VARCHAR(255) NOT NULL,
  criado_em   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  visto_em    DATETIME NULL,
  CONSTRAINT fk_notificacao_usuario FOREIGN KEY (usuario_id)
    REFERENCES usuario (id) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE INDEX ix_notificacao_nao_lida ON notificacao (usuario_id, visto_em);

-- =============================================================
-- DADOS MOCKADOS, com base no protótipo
-- =============================================================
INSERT INTO usuario (nome, email, senha_hash, tipo) VALUES
  ('Lucas Souza', 'lucas@exemplo.com', '$2y$10$TesteMock10', 'AFILIADO'),
  ('Camila Alves', 'camila@exemplo.com', '$4y$10$TesteMock20', 'LOJA'),
  ('Ana Ribeiro', 'ana@exemplo.com', '$5y$10$TesteMock30', 'AFILIADO'),
  ('Maria Luiza', 'maria@exemplo.com', '$7y$10$TesteMock60', 'LOJA');

INSERT INTO loja (usuario_id, nome) VALUES
  (2, 'Casa da Camila'),
  (4, 'Loja da Maria');

INSERT INTO categoria (nome) VALUES
  ('Casa e Cozinha'), ('Eletrônicos'), ('Beleza');

INSERT INTO produto (loja_id, categoria_id, nome, fabricante, imagem_url, preco) VALUES
  (1, 1, 'Copo Térmico Stanley com Tampa', 'Stanley', 'https://placehold.co/400?text=Stanley', 179.90),
  (2, 2, 'Relógio Apple Watch Ultra Azul', 'Apple', 'https://placehold.co/400?text=Apple', 7999.00),
  (1, 3, 'Kit de Pincéis Eudora', 'Eudora', 'https://placehold.co/400?text=Eudora', 89.90),
  (2, 1, 'Organizador de Gaveta 6 Divisórias', 'Casa da Camila', 'https://placehold.co/400?text=Organizador', 59.90);

INSERT INTO afiliacao (usuario_id, produto_id, link_afiliado, comissao_percentual) VALUES
  (1, 1, 'https://vt.tiktok.com/exemplo-lucas-stanley', 12.00),
  (1, 2, 'https://vt.tiktok.com/exemplo-lucas-watch', 3.00),
  (1, 3, 'https://vt.tiktok.com/exemplo-lucas-pinceis', 15.00),
  (1, 4, 'https://vt.tiktok.com/exemplo-lucas-organizador', 18.00),
  (3, 4, 'https://vt.tiktok.com/exemplo-ana-organizador', 18.00);

INSERT INTO metrica_diaria (afiliacao_id, data, visualizacoes, cliques, vendas, comissao_gerada) VALUES
(1, '2026-08-03', 12980, 1507, 10, 215.88),
(1, '2026-08-04', 16520, 1918, 13, 280.64),
(1, '2026-08-05', 14160, 1644, 11, 237.47),
(1, '2026-08-06', 18880, 2192, 14, 302.23),
(1, '2026-08-07', 15340, 1781, 12, 259.06),
(1, '2026-08-08', 18880, 2192, 14, 302.23),
(1, '2026-08-09', 21240, 2466, 19, 410.17),
(1, '2026-08-10', 16753, 1914, 11, 237.47),
(1, '2026-08-11', 21322, 2436, 14, 302.23),
(1, '2026-08-12', 18276, 2088, 12, 259.06),
(1, '2026-08-13', 24368, 2784, 16, 345.41),
(1, '2026-08-14', 19799, 2262, 13, 280.64),
(1, '2026-08-15', 24368, 2784, 16, 345.41),
(1, '2026-08-16', 27414, 3132, 20, 431.76),
(2, '2026-08-03', 67100, 9724, 21, 5039.37),
(2, '2026-08-04', 85400, 12376, 27, 6479.19),
(2, '2026-08-05', 73200, 10608, 23, 5519.31),
(2, '2026-08-06', 97600, 14144, 31, 7439.07),
(2, '2026-08-07', 79300, 11492, 25, 5999.25),
(2, '2026-08-08', 97600, 14144, 31, 7439.07),
(2, '2026-08-09', 109800, 15912, 38, 9118.86),
(2, '2026-08-10', 75240, 11011, 22, 5279.34),
(2, '2026-08-11', 95760, 14014, 29, 6959.13),
(2, '2026-08-12', 82080, 12012, 25, 5999.25),
(2, '2026-08-13', 109440, 16016, 33, 7919.01),
(2, '2026-08-14', 88920, 13013, 27, 6479.19),
(2, '2026-08-15', 109440, 16016, 33, 7919.01),
(2, '2026-08-16', 123120, 18018, 40, 9598.80),
(3, '2026-08-03', 7810, 979, 2, 26.97),
(3, '2026-08-04', 9940, 1246, 3, 40.46),
(3, '2026-08-05', 8520, 1068, 3, 40.46),
(3, '2026-08-06', 11360, 1424, 4, 53.94),
(3, '2026-08-07', 9230, 1157, 3, 40.46),
(3, '2026-08-08', 11360, 1424, 4, 53.94),
(3, '2026-08-09', 12780, 1602, 8, 107.88),
(3, '2026-08-10', 8415, 1067, 2, 26.97),
(3, '2026-08-11', 10710, 1358, 3, 40.46),
(3, '2026-08-12', 9180, 1164, 3, 40.46),
(3, '2026-08-13', 12240, 1552, 4, 53.94),
(3, '2026-08-14', 9945, 1261, 3, 40.46),
(3, '2026-08-15', 12240, 1552, 4, 53.94),
(3, '2026-08-16', 13770, 1746, 6, 80.91),
(4, '2026-08-03', 4422, 341, 5, 53.91),
(4, '2026-08-04', 5628, 434, 6, 64.69),
(4, '2026-08-05', 4824, 372, 5, 53.91),
(4, '2026-08-06', 6432, 496, 7, 75.47),
(4, '2026-08-07', 5226, 403, 6, 64.69),
(4, '2026-08-08', 6432, 496, 7, 75.47),
(4, '2026-08-09', 7236, 558, 12, 129.38),
(4, '2026-08-10', 5148, 401, 6, 64.69),
(4, '2026-08-11', 6552, 511, 7, 75.47),
(4, '2026-08-12', 5616, 438, 6, 64.69),
(4, '2026-08-13', 7488, 584, 9, 97.04),
(4, '2026-08-14', 6084, 474, 7, 75.47),
(4, '2026-08-15', 7488, 584, 9, 97.04),
(4, '2026-08-16', 8424, 658, 13, 140.17),
(5, '2026-08-03', 2475, 165, 2, 21.56),
(5, '2026-08-04', 3150, 210, 2, 21.56),
(5, '2026-08-05', 2700, 180, 2, 21.56),
(5, '2026-08-06', 3600, 240, 3, 32.35),
(5, '2026-08-07', 2925, 195, 2, 21.56),
(5, '2026-08-08', 3600, 240, 3, 32.35),
(5, '2026-08-09', 4050, 270, 5, 53.91),
(5, '2026-08-10', 2310, 151, 1, 10.78),
(5, '2026-08-11', 2940, 193, 2, 21.56),
(5, '2026-08-12', 2520, 165, 2, 21.56),
(5, '2026-08-13', 3360, 220, 2, 21.56),
(5, '2026-08-14', 2730, 179, 2, 21.56),
(5, '2026-08-15', 3360, 220, 2, 21.56),
(5, '2026-08-16', 3780, 252, 6, 64.69);

INSERT INTO notificacao (usuario_id, mensagem, visto_em) VALUES
  (1, 'Copo Térmico Stanley teve alta de 27% nos cliques esta semana.', NULL),
  (1, 'Kit de Pincéis Eudora teve queda nas vendas esta semana.', NULL),
  (2, 'Novo afiliado divulgando Organizador de Gaveta 6 Divisórias.', '2026-08-12 09:30:00');

-- =============================================================
-- CONSULTAS DE EXEMPLO (indicadores calculados, não armazenados)
-- =============================================================

-- 1) Tela "Meus Produtos" do afiliado (últimos 7 dias), ordenada por vendas
SELECT p.nome, l.nome AS loja, p.imagem_url,
       SUM(m.comissao_gerada) AS comissao,
       SUM(m.cliques)         AS cliques,
       SUM(m.vendas)          AS vendas
FROM afiliacao a
JOIN produto p        ON p.id = a.produto_id
JOIN loja l           ON l.id = p.loja_id
JOIN metrica_diaria m ON m.afiliacao_id = a.id
WHERE a.usuario_id = 1
  AND m.data BETWEEN '2026-08-10' AND '2026-08-16'
GROUP BY a.id, p.nome, l.nome, p.imagem_url
ORDER BY vendas DESC;   -- "Melhor Comissão": comissao DESC | "Mais visualizados": SUM(visualizacoes) DESC

-- 2) Cards de "Detalhes do Produto" com tendência (semana atual x anterior)
SELECT
  SUM(CASE WHEN m.data >= '2026-08-10' THEN m.cliques END)         AS cliques,
  ROUND(100 * (SUM(CASE WHEN m.data >= '2026-08-10' THEN m.cliques END)
             / SUM(CASE WHEN m.data <  '2026-08-10' THEN m.cliques END) - 1)) AS cliques_var_pct,
  SUM(CASE WHEN m.data >= '2026-08-10' THEN m.vendas END)          AS vendas,
  ROUND(100 * (SUM(CASE WHEN m.data >= '2026-08-10' THEN m.vendas END)
             / SUM(CASE WHEN m.data <  '2026-08-10' THEN m.vendas END) - 1)) AS vendas_var_pct,
  SUM(CASE WHEN m.data >= '2026-08-10' THEN m.comissao_gerada END) AS comissao,
  ROUND(100 * (SUM(CASE WHEN m.data >= '2026-08-10' THEN m.comissao_gerada END)
             / SUM(CASE WHEN m.data <  '2026-08-10' THEN m.comissao_gerada END) - 1)) AS comissao_var_pct,
  ROUND(100 * SUM(CASE WHEN m.data >= '2026-08-10' THEN m.vendas END)
            / SUM(CASE WHEN m.data >= '2026-08-10' THEN m.cliques END), 2) AS taxa_conversao_pct
FROM metrica_diaria m
WHERE m.afiliacao_id = 1
  AND m.data BETWEEN '2026-08-03' AND '2026-08-16';

-- 3) Gráfico "Desempenho ao longo do tempo"
SELECT data, visualizacoes, cliques, vendas
FROM metrica_diaria
WHERE afiliacao_id = 1 AND data BETWEEN '2026-08-10' AND '2026-08-16'
ORDER BY data;

-- 4) Visão mensal (agregação a partir do diário)
SELECT DATE_FORMAT(m.data, '%Y-%m') AS mes,
       SUM(m.visualizacoes) AS visualizacoes, SUM(m.cliques) AS cliques,
       SUM(m.vendas) AS vendas, SUM(m.comissao_gerada) AS comissao
FROM metrica_diaria m
WHERE m.afiliacao_id = 1
GROUP BY mes;

-- 5) Persona Loja: desempenho de cada afiliado nos produtos da Camila
SELECT p.nome AS produto, u.nome AS afiliado,
       SUM(m.cliques) AS cliques, SUM(m.vendas) AS vendas,
       ROUND(100 * SUM(m.vendas) / NULLIF(SUM(m.cliques), 0), 2) AS taxa_conversao_pct
FROM loja l
JOIN produto p        ON p.loja_id = l.id
JOIN afiliacao a      ON a.produto_id = p.id
JOIN usuario u        ON u.id = a.usuario_id
JOIN metrica_diaria m ON m.afiliacao_id = a.id
WHERE l.usuario_id = 2
  AND m.data BETWEEN '2026-08-10' AND '2026-08-16'
GROUP BY p.id, p.nome, u.id, u.nome
ORDER BY vendas DESC;

-- 6) Contador do sino (notificações não lidas)
SELECT COUNT(*) AS nao_lidas FROM notificacao WHERE usuario_id = 1 AND visto_em IS NULL;