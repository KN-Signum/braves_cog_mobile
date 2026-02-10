import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:braves_cog/core/theme/app_theme.dart';
import 'package:braves_cog/features/health/health_module_screen.dart';
import 'package:braves_cog/features/health/presentation/providers/health_history_provider.dart';

class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  @override
  void initState() {
    super.initState();
    // Load history when screen initializes
    Future.microtask(() => ref.read(healthHistoryProvider.notifier).loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthHistoryProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Twoje zdrowie',
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text('Błąd: ${state.error}'))
              : state.history.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.monitor_heart_outlined, 
                               size: 64, color: AppTheme.primaryColor.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text(
                            'Brak wpisów w historii',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppTheme.primaryColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.history.length,
                      itemBuilder: (context, index) {
                        final entry = state.history[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: AppTheme.lightBackgroundColor,
                              width: 1,
                            ),
                          ),
                          elevation: 0,
                          child: InkWell(
                            onTap: () {
                              // TODO: Show details
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        entry.submittedAt != null
                                            ? DateFormat('dd.MM.yyyy HH:mm').format(entry.submittedAt!)
                                            : 'Brak daty',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.primaryColor.withOpacity(0.6),
                                        ),
                                      ),
                                      if (entry.doctorVisited)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.accentColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Wizyta u lekarza',
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.primaryColor,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Samopoczucie: ${entry.symptoms?.isNotEmpty == true ? entry.symptoms : "Brak objawów"}',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HealthModuleScreen(
                onBack: () => Navigator.pop(context),
              ),
            ),
          );
          // Refresh history after returning
          ref.read(healthHistoryProvider.notifier).loadHistory();
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Dodaj wpis',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
