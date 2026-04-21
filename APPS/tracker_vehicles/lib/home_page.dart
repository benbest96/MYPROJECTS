import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'vehicle.dart';

// ─────────────────────────────────────────────
//  Couleurs de l'app
// ─────────────────────────────────────────────
class _C {
  static const primary      = Color(0xFF4F46E5);
  static const primaryLight = Color(0xFFEEF2FF);
  static const bg           = Color(0xFFF8FAFC);
  static const surface      = Colors.white;
  static const surfaceAlt   = Color(0xFFF1F5F9);
  static const textMain     = Color(0xFF1E293B);
  static const textSub      = Color(0xFF64748B);
  static const red          = Color(0xFFEF4444);
  static const orange       = Color(0xFFF97316);
  static const green        = Color(0xFF22C55E);
  static const teal         = Color(0xFF14B8A6);
}

// ─────────────────────────────────────────────
//  HomePage
// ─────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Vehicle> _vehicles = [];
  final _fmt = DateFormat('dd/MM/yyyy');

  String _fd(DateTime d) => _fmt.format(d);

  Color _delayColor(int days) {
    if (days < 0) return _C.red;
    if (days <= 7) return _C.orange;
    return _C.green;
  }

  // ── Sélecteur de date ─────────────────────
  Future<DateTime?> _pickDate(BuildContext ctx, {DateTime? initial}) =>
      showDatePicker(
        context: ctx,
        initialDate: initial ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (c, child) => Theme(
          data: Theme.of(c).copyWith(
            colorScheme: const ColorScheme.light(primary: _C.primary),
          ),
          child: child!,
        ),
      );

  // ── Widgets utilitaires ───────────────────
  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _C.textSub,
                letterSpacing: 0.4)),
      );

  Widget _field(TextEditingController c, String hint,
          {String? Function(String?)? validator}) =>
      TextFormField(
        controller: c,
        validator: validator,
        style: const TextStyle(color: _C.textMain, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _C.textSub, fontSize: 14),
          filled: true,
          fillColor: _C.bg,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _C.red)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _C.red, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _C.primary, width: 1.5)),
        ),
      );

  Widget _datePicker(String label, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
              color: _C.bg, borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            const Icon(Icons.calendar_today, size: 16, color: _C.textSub),
            const SizedBox(width: 10),
            Text(label,
                style: TextStyle(
                    color: label == 'Sélectionner' ? _C.textSub : _C.textMain,
                    fontSize: 14)),
          ]),
        ),
      );

  // ── Dialog : Ajouter ─────────────────────
  Future<void> _showAddDialog() async {
    String type = 'Moto';
    final driverCtrl = TextEditingController();
    final regCtrl    = TextEditingController();
    DateTime? purchaseDate, startDate, endDate;
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Dialog(
          backgroundColor: _C.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: _C.primaryLight,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.directions_car,
                            color: _C.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text('Ajouter un véhicule',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: _C.textMain)),
                    ]),
                    const SizedBox(height: 20),

                    // Type
                    _label('Type de véhicule'),
                    Row(
                      children: ['Moto', 'Car'].map((t) {
                        final sel = type == t;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => ss(() => type = t),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              margin: EdgeInsets.only(right: t == 'Moto' ? 8 : 0),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: sel ? _C.primary : _C.bg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: _C.primary,
                                    width: sel ? 0 : 1.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    t == 'Moto'
                                        ? Icons.two_wheeler
                                        : Icons.directions_car,
                                    color: sel ? Colors.white : _C.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(t,
                                      style: TextStyle(
                                          color: sel
                                              ? Colors.white
                                              : _C.primary,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Nom du chauffeur
                    _label('Nom du chauffeur'),
                    _field(driverCtrl, 'Ex: Jean Dupont',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Requis' : null),
                    const SizedBox(height: 16),

                    // Immatriculation
                    _label('Immatriculation'),
                    _field(regCtrl, 'Ex: AB-123-CD',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Requis' : null),
                    const SizedBox(height: 16),

                    // Date d'achat
                    _label("Date d'achat"),
                    _datePicker(
                      purchaseDate != null ? _fd(purchaseDate!) : 'Sélectionner',
                      () async {
                        final d = await _pickDate(ctx, initial: purchaseDate);
                        if (d != null) ss(() => purchaseDate = d);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Début d'activité
                    _label("Début d'activité"),
                    _datePicker(
                      startDate != null ? _fd(startDate!) : 'Sélectionner',
                      () async {
                        final d = await _pickDate(ctx, initial: startDate);
                        if (d != null) ss(() => startDate = d);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Fin d'activité
                    _label("Fin d'activité"),
                    _datePicker(
                      endDate != null ? _fd(endDate!) : 'Sélectionner',
                      () async {
                        final d = await _pickDate(ctx, initial: endDate);
                        if (d != null) ss(() => endDate = d);
                      },
                    ),

                    // Aperçu délai
                    if (startDate != null && endDate != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: _C.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(children: [
                          const Icon(Icons.timer_outlined,
                              size: 16, color: _C.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Délai : ${endDate!.difference(startDate!).inDays} jours',
                            style: const TextStyle(
                                color: _C.primary,
                                fontWeight: FontWeight.w700),
                          ),
                        ]),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Actions
                    Row(children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _C.textSub,
                            side: const BorderSide(color: _C.surfaceAlt),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Annuler'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _C.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            if (purchaseDate == null ||
                                startDate == null ||
                                endDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Veuillez remplir toutes les dates.')),
                              );
                              return;
                            }
                            setState(() {
                              _vehicles.add(Vehicle(
                                type: type,
                                driverName: driverCtrl.text.trim(),
                                registration: regCtrl.text.trim(),
                                purchaseDate: purchaseDate!,
                                startDate: startDate!,
                                endDate: endDate!,
                              ));
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text('Ajouter',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Dialog : Recherche ────────────────────
  Future<void> _showSearchDialog() async {
    final ctrl     = TextEditingController();
    List<Vehicle> results = [];
    bool searched = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Dialog(
          backgroundColor: _C.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Titre
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: _C.primaryLight,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.search,
                        color: _C.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('Rechercher',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _C.textMain)),
                ]),
                const SizedBox(height: 16),

                // Champ de recherche
                TextField(
                  controller: ctrl,
                  autofocus: true,
                  style: const TextStyle(color: _C.textMain),
                  decoration: InputDecoration(
                    hintText: 'Nom, immatriculation, type...',
                    hintStyle: const TextStyle(color: _C.textSub),
                    filled: true,
                    fillColor: _C.bg,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 11),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: _C.primary, width: 1.5)),
                    prefixIcon:
                        const Icon(Icons.search, color: _C.textSub, size: 20),
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.arrow_forward, color: _C.primary),
                      onPressed: () {
                        final q = ctrl.text.trim().toLowerCase();
                        ss(() {
                          searched = true;
                          results = _vehicles.where((v) =>
                              v.driverName.toLowerCase().contains(q) ||
                              v.registration.toLowerCase().contains(q) ||
                              v.type.toLowerCase().contains(q) ||
                              _fd(v.purchaseDate).contains(q) ||
                              _fd(v.startDate).contains(q) ||
                              _fd(v.endDate).contains(q)).toList();
                        });
                      },
                    ),
                  ),
                  onSubmitted: (val) {
                    final q = val.trim().toLowerCase();
                    ss(() {
                      searched = true;
                      results = _vehicles.where((v) =>
                          v.driverName.toLowerCase().contains(q) ||
                          v.registration.toLowerCase().contains(q) ||
                          v.type.toLowerCase().contains(q) ||
                          _fd(v.purchaseDate).contains(q) ||
                          _fd(v.startDate).contains(q) ||
                          _fd(v.endDate).contains(q)).toList();
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Résultats
                if (searched)
                  results.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('Aucun résultat.',
                              style: TextStyle(color: _C.textSub)),
                        )
                      : ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 220),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: results.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1, color: _C.surfaceAlt),
                            itemBuilder: (_, i) {
                              final v = results[i];
                              return ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: _C.primaryLight,
                                  child: Icon(
                                    v.type == 'Moto'
                                        ? Icons.two_wheeler
                                        : Icons.directions_car,
                                    size: 18,
                                    color: _C.primary,
                                  ),
                                ),
                                title: Text(v.driverName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: _C.textMain,
                                        fontSize: 14)),
                                subtitle: Text(v.registration,
                                    style: const TextStyle(
                                        color: _C.textSub, fontSize: 12)),
                                trailing: Text('${v.delay}j',
                                    style: TextStyle(
                                        color: _delayColor(v.delay),
                                        fontWeight: FontWeight.bold)),
                              );
                            },
                          ),
                        ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Fermer'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Tableau ───────────────────────────────
  static const _colW = [80.0, 130.0, 110.0, 95.0, 95.0, 95.0, 65.0];
  static const _headers = [
    'Type', 'Chauffeur', 'Immat.', 'Achat', 'Début', 'Fin', 'Délai'
  ];

  Widget _headerCell(String t, double w) => Container(
        width: w,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        color: _C.primary,
        child: Text(t,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12)),
      );

  Widget _dataCell(String t, double w, Color bg, {Color? color, bool bold = false}) =>
      Container(
        width: w,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        color: bg,
        child: Text(t,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: color ?? _C.textMain,
                fontSize: 12,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      );

  // Largeur totale fixe du tableau (somme de toutes les colonnes)
  static double get _tableWidth => _colW.fold(0, (sum, w) => sum + w);

  Widget _buildTable() {
    // Un seul ScrollController horizontal partagé entre header et lignes
    final hScroll = ScrollController();

    return Expanded(
      child: Column(
        children: [
          // ── En-tête (scroll horizontal synchronisé) ──
          Scrollbar(
            controller: hScroll,
            thumbVisibility: false,
            child: SingleChildScrollView(
              controller: hScroll,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _tableWidth,
                child: Row(
                  children: [
                    for (int i = 0; i < _headers.length; i++)
                      _headerCell(_headers[i], _colW[i])
                  ],
                ),
              ),
            ),
          ),

          // ── Lignes ────────────────────────────────────
          Expanded(
            child: _vehicles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_car_outlined,
                            size: 72,
                            color: _C.textSub.withOpacity(0.3)),
                        const SizedBox(height: 14),
                        const Text('Aucun véhicule enregistré',
                            style: TextStyle(
                                color: _C.textSub,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        const Text('Appuyez sur + pour en ajouter un',
                            style: TextStyle(color: _C.textSub, fontSize: 12)),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    // Scroll horizontal des lignes lié au même controller
                    controller: hScroll,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: _tableWidth,
                      child: ListView.builder(
                        // Scroll vertical indépendant
                        scrollDirection: Axis.vertical,
                        itemCount: _vehicles.length,
                        itemBuilder: (ctx, i) {
                          final v  = _vehicles[i];
                          final bg = i % 2 == 0 ? _C.surface : _C.surfaceAlt;
                          final dc = _delayColor(v.delay);

                          return GestureDetector(
                            onLongPress: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (c) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text('Supprimer ?'),
                                  content: Text(
                                      'Supprimer le véhicule de ${v.driverName} ?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(c, false),
                                        child: const Text('Non')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(c, true),
                                        child: const Text('Oui',
                                            style: TextStyle(color: _C.red))),
                                  ],
                                ),
                              );
                              if (ok == true) {
                                setState(() => _vehicles.removeAt(i));
                              }
                            },
                            child: Row(children: [
                              // Type avec icône
                              Container(
                                width: _colW[0],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 11),
                                color: bg,
                                child: Row(children: [
                                  Icon(
                                    v.type == 'Moto'
                                        ? Icons.two_wheeler
                                        : Icons.directions_car,
                                    size: 15,
                                    color: _C.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(v.type,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: _C.textMain)),
                                ]),
                              ),
                              _dataCell(v.driverName,        _colW[1], bg),
                              _dataCell(v.registration,      _colW[2], bg),
                              _dataCell(_fd(v.purchaseDate), _colW[3], bg),
                              _dataCell(_fd(v.startDate),    _colW[4], bg),
                              _dataCell(_fd(v.endDate),      _colW[5], bg),
                              _dataCell('${v.delay}j',       _colW[6], bg,
                                  color: dc, bold: true),
                            ]),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Barre du bas ──────────────────────────
  Widget _buildBottomBar() {
    final total = _vehicles.length;
    final motos = _vehicles.where((v) => v.type == 'Moto').length;
    final cars  = _vehicles.where((v) => v.type == 'Car').length;

    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, -4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Totaux
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _chip(Icons.directions_car, 'Total',    total, _C.primary),
                _chip(Icons.two_wheeler,    'Motos',    motos, _C.orange),
                _chip(Icons.directions_car_filled, 'Voitures', cars, _C.teal),
              ],
            ),
          ),
          const Divider(height: 1, color: _C.surfaceAlt),

          // Boutons
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Recherche
                _actionBtn(
                  icon: Icons.search,
                  label: 'Recherche',
                  color: _C.primary,
                  onTap: _showSearchDialog,
                ),

                // Bouton + (central et proéminent)
                GestureDetector(
                  onTap: _showAddDialog,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _C.primary,
                          boxShadow: [
                            BoxShadow(
                              color: _C.primary.withOpacity(0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 34),
                      ),
                      const SizedBox(height: 4),
                      const Text('Ajouter',
                          style:
                              TextStyle(fontSize: 11, color: _C.textSub)),
                    ],
                  ),
                ),

                // Autres
                _actionBtn(
                  icon: Icons.more_horiz,
                  label: 'Autres',
                  color: _C.textSub,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Fonctionnalité à venir...')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, int count, Color color) => Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$count',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: _C.textMain)),
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: _C.textSub)),
          ]),
        ],
      );

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 4),
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: _C.textSub)),
          ],
        ),
      );

  // ── Build ─────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.primary,
        elevation: 2,
        title: Row(children: [
          const Icon(Icons.directions_car, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          const Text('Tracker des Véhicules',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold)),
        ]),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${_vehicles.length} véh.',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Légende délai
            Container(
              color: _C.surface,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(children: [
                const Text('Délai : ',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _C.textSub)),
                _dot(_C.red, '< 0j'),
                const SizedBox(width: 10),
                _dot(_C.orange, '≤ 7j'),
                const SizedBox(width: 10),
                _dot(_C.green, '> 7j'),
                const Spacer(),
                const Text('Appui long = supprimer',
                    style: TextStyle(fontSize: 10, color: _C.textSub)),
              ]),
            ),
            const Divider(height: 1, color: _C.surfaceAlt),

            // Tableau
            _buildTable(),

            // Barre du bas
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _dot(Color c, String label) => Row(children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, color: c)),
      ]);
}
