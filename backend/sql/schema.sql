CREATE TABLE professores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    formacao VARCHAR(100) NOT NULL,
    CONSTRAINT professores_unique_key UNIQUE (id, email)
);

INSERT INTO professores (nome, email, formacao)
VALUES ('Ismael Mazzuco', 'ismaelmz@gmail.com', 'Mestrado em Tecnologias da Informação e Comunicação');

INSERT INTO professores (nome, email, formacao)
VALUES ('Welquer Esser', 'welquerka@gmail.com', 'Pós Graduação em Sistemas de Informação');

INSERT INTO professores (nome, email, formacao)
VALUES ('Ricardo Alexandre Vargas Barbosa', 'rbfigura@gmail.com', 'Mestrado em Engenharia de Softwere');

INSERT INTO professores (nome, email, formacao)
VALUES ('Clavison Zapelini', 'clavison@gmail.com', 'Doutorado em Engenharia de Softwere');