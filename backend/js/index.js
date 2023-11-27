const express = require('express');
const cors = require('cors');
const app = express();
app.use(express.json());
app.use(cors());

const professorController = require('../controller/professorController');

app.get('/professores', professorController.importarProfessores);

app.get('/professores/:id', professorController.importarProfessorById);

app.post('/professor/inserir', professorController.cadastrarProfessor);

app.put('/professor/alterar/:id', professorController.alterarProfessor);

app.delete('/professor/deletar/:id', professorController.deletarProfessor);

const PORT = 3002;
app.listen(PORT, () => {
  console.log(`server started`);
});