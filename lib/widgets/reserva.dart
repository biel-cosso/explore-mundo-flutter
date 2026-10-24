import 'package:flutter/material.dart';

import '../dados.dart';

// Formulário de reserva que abre de baixo pra cima.
// Não tem servidor, então ele só mostra a confirmação.
Future<void> mostrarReserva(BuildContext context, Pacote pacote) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: FormularioReserva(pacote: pacote),
    ),
  );
}

class FormularioReserva extends StatefulWidget {
  final Pacote pacote;
  const FormularioReserva({super.key, required this.pacote});

  @override
  State<FormularioReserva> createState() => _FormularioReservaState();
}

class _FormularioReservaState extends State<FormularioReserva> {
  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  DateTime? _data;
  int _pessoas = 2;

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final hoje = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: hoje.add(const Duration(days: 30)),
      firstDate: hoje,
      lastDate: hoje.add(const Duration(days: 365)),
      helpText: 'Data de ida',
    );
    if (d != null) setState(() => _data = d);
  }

  void _confirmar() {
    if (!_form.currentState!.validate()) return;
    if (_data == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Escolha a data de ida.')));
      return;
    }
    final total = widget.pacote.precoPorPessoa * _pessoas;
    final nav = Navigator.of(context);
    nav.pop();
    showDialog(
      context: nav.context,
      builder: (_) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: Theme.of(nav.context).colorScheme.primary,
          size: 48,
        ),
        title: const Text('Reserva solicitada!'),
        content: Text(
          '${_nome.text.trim()}, recebemos seu pedido para o pacote '
          '"${widget.pacote.titulo}" em ${_formatarData(_data!)}, ${plural(_pessoas, 'pessoa', 'pessoas')}.\n\n'
          'Total estimado: ${formatarReais(total)}.\n'
          'Nossa equipe entrará em contato para confirmar.',
        ),
        actions: [
          TextButton(onPressed: () => nav.pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  String _formatarData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final p = widget.pacote;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Reservar: ${p.titulo}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${p.noites} noites · ${formatarReais(p.precoPorPessoa)} por pessoa',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nome,
              decoration: const InputDecoration(
                labelText: 'Seu nome',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().length < 3) ? 'Digite seu nome' : null,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _escolherData,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                _data == null
                    ? 'Escolher data de ida'
                    : 'Ida em ${_formatarData(_data!)}',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Pessoas'),
                const Spacer(),
                IconButton.outlined(
                  onPressed: _pessoas > 1
                      ? () => setState(() => _pessoas--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                SizedBox(
                  width: 36,
                  child: Text('$_pessoas', textAlign: TextAlign.center),
                ),
                IconButton.outlined(
                  onPressed: _pessoas < 10
                      ? () => setState(() => _pessoas++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total estimado: ${formatarReais(p.precoPorPessoa * _pessoas)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _confirmar,
              child: const Text('Confirmar reserva'),
            ),
          ],
        ),
      ),
    );
  }
}
