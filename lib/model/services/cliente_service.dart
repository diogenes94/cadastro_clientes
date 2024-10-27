import 'dart:convert';
import 'package:cadastro_clientes/configuration/constantes.dart';
import 'package:cadastro_clientes/model/domain/cliente.dart';
import 'package:http/http.dart' as http;

class ClienteService {
  Future<void> adicionar(Cliente cliente) async {
    final response = await http.post(
      Uri.parse("${Constantes.urlBase}clientes.json"),
      body: jsonEncode({"nome": cliente.nome, "cpf": cliente.cpf}),
    );

    if (response.statusCode == 200) {
      print('Salvou');
    } else {
      print('Falhou');
    }
  }

  Future<List<Cliente>> buscarTodosClientes() async {
    final response = await http.get(
      Uri.parse("${Constantes.urlBase}clientes.json"),
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    List<Cliente> clientes = [];
    data.forEach((clienteId, clienteData) => clientes.add(
          Cliente(
            id: clienteId,
            nome: clienteData['nome'],
            cpf: clienteData['cpf'],
          ),
        ));
    return clientes;
  }
}
