import 'package:flutter/material.dart';

import '../models/profile_data.dart';
import '../services/pref_service.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.prefs,
    required this.isDark,
    required this.onThemeChanged,
  });

  final PrefService prefs;
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileData _profile;
  String? _lastEdited;

  @override
  void initState() {
    super.initState();
    _profile = widget.prefs.profile; // baca data tersimpan
    _lastEdited = widget.prefs.lastEdited;
  }

  String _formatDateTime(String isoString) {
    final dt = DateTime.tryParse(isoString);
    if (dt == null) return isoString;
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  Future<void> _edit() async {
    final result = await Navigator.push<ProfileData>(
      context,
      MaterialPageRoute(builder: (_) => EditProfilePage(initial: _profile)),
    );
    if (result == null) return; // pengguna menekan back

    final now = DateTime.now();
    await widget.prefs.saveProfile(result);
    await widget.prefs.setLastEdited(now);

    if (!mounted) return;
    setState(() {
      _profile = result;
      _lastEdited = widget.prefs.lastEdited;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil tersimpan')),
    );
  }

  Future<void> _reset() async {
    await widget.prefs.clearProfile();
    if (!mounted) return;
    setState(() {
      _profile = widget.prefs.profile;
      _lastEdited = widget.prefs.lastEdited;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil dikembalikan ke bawaan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initial =
        _profile.name.isNotEmpty ? _profile.name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Profil Digital'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit profil',
            onPressed: _edit,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colors.primaryContainer,
                    child: Text(initial, style: const TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _profile.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(_profile.title),
                  const SizedBox(height: 12),
                  Text(_profile.bio, textAlign: TextAlign.center),
                  if (_lastEdited != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Terakhir diedit: ${_formatDateTime(_lastEdited!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Mode Gelap'),
            value: widget.isDark,
            onChanged: widget.onThemeChanged,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.restore),
            label: const Text('Reset Profil'),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Kartu ini sudah dibuka ${widget.prefs.openCount} kali',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
