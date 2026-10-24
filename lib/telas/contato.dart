import 'package:flutter/material.dart';

// aba Contato (os contatos são fictícios e o formulário não envia de verdade)
class ContatoTab extends StatefulWidget {
  const ContatoTab({super.key});

  @override
  State<ContatoTab> createState() => _ContatoTabState();
}

class _ContatoTabState extends State<ContatoTab> {
  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _mensagem = TextEditingController();

  @override
  void dispose() {
    _nome.dispose();
    _mensagem.dispose();
    super.dispose();
  }

  void _enviar() {
    if (!_form.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Obrigado, ${_nome.text.trim()}! Responderemos em até 1 dia útil.',
        ),
      ),
    );
    _nome.clear();
    _mensagem.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Fale com a nossa equipe',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('0800 000 0000'),
                subtitle: Text('Seg. a sex., 8h às 18h'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.email_outlined),
                title: Text('contato@exploremundo.example'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.chat_outlined),
                title: Text('WhatsApp'),
                subtitle: Text('Atendimento 24 horas'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nome,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Digite seu nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mensagem,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Mensagem',
                  hintText: 'Conte para onde quer viajar',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().length < 10)
                    ? 'Escreva pelo menos 10 letras'
                    : null,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _enviar,
                icon: const Icon(Icons.send),
                label: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
