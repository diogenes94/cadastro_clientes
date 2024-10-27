import 'package:cadastro_clientes/cadastro_cliente.dart';
import 'package:cadastro_clientes/model/domain/cliente.dart';
import 'package:cadastro_clientes/model/services/cliente_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Clientes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ClientesApp(),
    );
  }
}

class ClientesApp extends StatefulWidget {
  const ClientesApp({super.key});

  @override
  State<ClientesApp> createState() => _ClientesAppState();
}

class _ClientesAppState extends State<ClientesApp> {
  List<Cliente> clientes = [];
  ClienteService clienteService = ClienteService();

  @override
  void initState() {
    carregarClientes();
    super.initState();
  }

  void carregarClientes() async {
    clientes = await clienteService.buscarTodosClientes();
    setState(() {});
  }

  void salvarCliente(Cliente cliente) {
    setState(() {
      if (cliente.id == "0") {
        clienteService.adicionar(cliente);
        cliente.id = (clientes.length + 1) as String;
        clientes.add(cliente);
      }
    });
  }

  _removeCliente(Cliente cliente) {
    setState(() {
      clientes.remove(cliente);
    });
  }

  _confirmaExclusao(Cliente cliente, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmar exclusão"),
            content: Text(
                "Tem certeza que deseja excluir o cliente ${cliente.nome}?"),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("Não"),
              ),
              TextButton(
                onPressed: () {
                  _removeCliente(cliente);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Cliente ${cliente.nome} removido!"),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text("Sim"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Clientes Cadastrados"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroCliente(
                      salvarCliente: salvarCliente,
                    ),
                  ),
                );
              },
              child: const Text("Cadastrar Cliente"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: clientes.length,
                itemBuilder: (context, index) {
                  final cliente = clientes[index];
                  return ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    tileColor: Colors.black12,
                    title: Column(
                      children: [
                        Row(
                          children: [
                            const Text("Nome: "),
                            Text(cliente.nome),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("CPF: "),
                            Text(cliente.cpf),
                          ],
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CadastroCliente(
                            salvarCliente: salvarCliente,
                            cliente: cliente,
                          ),
                        ),
                      );
                    },
                    trailing: IconButton(
                      onPressed: () => _confirmaExclusao(cliente, index),
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
