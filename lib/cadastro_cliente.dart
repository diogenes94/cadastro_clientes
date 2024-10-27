// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cadastro_clientes/model/domain/cliente.dart';
import 'package:flutter/material.dart';

class CadastroCliente extends StatelessWidget {
  CadastroCliente({
    super.key,
    required this.salvarCliente,
    this.cliente,
  });

  final void Function(Cliente cliente) salvarCliente;

  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();

  Cliente? cliente;

  @override
  Widget build(BuildContext context) {
    if (cliente != null) {
      _nomeController.text = cliente!.nome;
      _cpfController.text = cliente!.cpf;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Cadastro de Cliente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira um nome.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cpfController,
                    decoration: const InputDecoration(
                      labelText: "CPF",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira um CPF.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (cliente == null) {
                          cliente = Cliente(
                            id: "0",
                            nome: _nomeController.text,
                            cpf: _cpfController.text,
                          );
                        } else {
                          cliente!.nome = _nomeController.text;
                          cliente!.cpf = _cpfController.text;
                        }
                        salvarCliente(cliente!);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
