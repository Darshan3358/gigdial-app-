import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final _bookingState = BookingState();
  final _skillController = TextEditingController();
  
  String _selectedCategory = 'Plumber';
  final List<String> _availableCategories = [
    'Plumber',
    'Carpenter',
    'Painter',
    'AC Repair',
    'Cleaner',
    'RO Service',
    'Appliance',
    'Electrician'
  ];

  List<String> _currentCategories = [];
  List<String> _currentSkills = [];

  @override
  void initState() {
    super.initState();
    _loadWorkerInfo();
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  void _loadWorkerInfo() {
    final List<String> categories = [];
    final Set<String> skills = {};

    _bookingState.workersByCategory.forEach((cat, list) {
      for (var worker in list) {
        if (worker.name == 'Ramesh Yadav') {
          categories.add(cat);
          skills.addAll(worker.skills);
        }
      }
    });

    setState(() {
      _currentCategories = categories;
      _currentSkills = skills.toList();
    });
  }

  void _saveCategoryAndSkills() {
    final skillText = _skillController.text.trim();
    final List<String> newSkills = skillText.isNotEmpty
        ? skillText.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
        : [];

    // Add worker to selected category if they aren't already there
    final WorkerModel newWorkerInstance = WorkerModel(
      name: 'Ramesh Yadav',
      profession: _selectedCategory,
      experience: '8 Years Experience',
      rating: 4.8,
      reviews: '120 Reviews',
      location: 'Naroda, Ahmedabad',
      image: 'assets/images/worker_ramesh.png',
      skills: newSkills.isNotEmpty ? newSkills : ['General Maintenance'],
      about: 'I am a professional handyman with 8 years of experience in household services and installations.',
    );

    _bookingState.addWorkerToCategory(_selectedCategory, newWorkerInstance);

    // Also append new skills to the worker overall
    for (var skill in newSkills) {
      _bookingState.addSkillToWorker('Ramesh Yadav', skill);
    }

    _skillController.clear();
    _loadWorkerInfo();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved: Registered in $_selectedCategory category!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manage Categories & Skills',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.teal, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Adding new categories will register you in customer search catalogs for those services.',
                        style: TextStyle(color: Colors.teal[900], fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Current Categories
              const Text(
                'My Active Categories',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _currentCategories.map((cat) {
                  return Chip(
                    label: Text(cat),
                    backgroundColor: Colors.teal[50],
                    labelStyle: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 13),
                    side: const BorderSide(color: Colors.teal, width: 0.5),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Current Skills
              const Text(
                'My Registered Skills',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark),
              ),
              const SizedBox(height: 8),
              _currentSkills.isEmpty
                  ? const Text('No custom skills added yet.', style: TextStyle(color: Colors.grey, fontSize: 13))
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _currentSkills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textDark),
                          ),
                        );
                      }).toList(),
                    ),
              const Divider(height: 48),

              // Add Category form
              const Text(
                'Add Category & Custom Skills',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark),
              ),
              const SizedBox(height: 16),

              const Text('Select Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
                    items: _availableCategories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Add Skills (comma-separated)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: _skillController,
                decoration: InputDecoration(
                  hintText: 'e.g. Pipe Replacement, Drain Cleaning',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _saveCategoryAndSkills,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Register & Save Work', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
