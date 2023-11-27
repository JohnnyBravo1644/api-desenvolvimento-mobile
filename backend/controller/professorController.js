const { request, response } = require('express');
const database = require('../js/database');

function importarProfessores(request, response) {
    database.query(`SELECT * FROM professores`, (err, rows, fields) => {
        if (err) {
    
          console.error(err);
          return response.status(500).send('Erro ao obter os dados dos professores');
        }
    
        return response.status(200).json(rows);
      });
}

function importarProfessorById(request, response) {
  const id = request.params.id;

  database.query('SELECT * FROM professores WHERE id = $1', [id], (err, result) => {
    if (err) {
      console.error('Erro ao executar a consulta:', err);
      return response.status(500).send('Erro no servidor');
    }

    const professor = result.rows[0];

    if (!professor) {
      return response.status(404).send('Professor não encontrado');
    }

    return response.status(200).send(professor);
  });
};

function cadastrarProfessor(request, response) {
  const { nomeProfessor, formacaoProfessor, emailProfessor } = request.body;

  if (!nomeProfessor || !formacaoProfessor || !emailProfessor) {
    return response.status(400).send('Campos obrigatórios não foram fornecidos');
  }

  database.query('INSERT INTO professores (nome, email, formacao) VALUES ($1, $2, $3)', [nomeProfessor, emailProfessor, formacaoProfessor], (err, result) => {
    if (err) {
      console.error(err);
      return response.status(500).send('Erro no servidor');
    }

    response.status(201).send('Professor cadastrado com sucesso');
  });
};

function alterarProfessor(request, response) {
  const id = request.params.id;
  if (!id) {
    return response.status(400).send('Dados invalidos!');
  }
  const { nomeProfessor, formacaoProfessor, emailProfessor } = request.body;

  database.query(`UPDATE professores SET nome='${nomeProfessor}', formacao='${formacaoProfessor}', email='${emailProfessor}' WHERE id='${id}';`, (err, result) => {
    if (err) {
      console.error(err);
      return response.status(500).send("Ocorreu um erro ao atualizar o professor");
    }

    return response.status(200).send("Professor alterado com sucesso");
  });
};

function deletarProfessor(request, response) {
  const id = request.params.id;
  if (!id) {
    return response.status(400).send('Dados invalidos!');
  }
  database.query(`DELETE FROM professores WHERE id = ${id}`, (err, result) => {
    if (err) {
      console.error('Erro ao executar a consulta:', err);
      return response.status(500).send('Erro no servidor');
    }

    return response.status(200).send("professor deletado com sucesso");
  });
};

module.exports = {
  importarProfessores, importarProfessorById, cadastrarProfessor, alterarProfessor, deletarProfessor
}