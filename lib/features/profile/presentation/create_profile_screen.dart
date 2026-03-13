import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../../core/widgets/common_widgets.dart';
import '../data/profile_repository.dart';
import '../../auth/data/auth_repository.dart';

class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  ConsumerState<CreateProfileScreen> createState() =>
      _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _dobController = TextEditingController();
  String _gender = 'Male';
  final List<XFile> _imageFiles = [];
  final List<Uint8List> _webImageBytesList = [];
  bool _isLoading = false;

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final bytesList = await Future.wait(pickedFiles.map((f) => f.readAsBytes()));
        setState(() {
          _imageFiles
            ..clear()
            ..addAll(pickedFiles);
          _webImageBytesList
            ..clear()
            ..addAll(bytesList);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _imageFiles.removeAt(index);
      _webImageBytesList.removeAt(index);
    });
  }

  final List<String> _allInterests = [
    'Travel',
    'Music',
    'Movies',
    'Fitness',
    'Food',
    'Gaming',
    'Art',
    'Tech',
    'Reading',
    'Photography',
  ];
  final Set<String> _selectedInterests = {};

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = DateTime(now.year - 20, now.month, now.day);
    final first = DateTime(now.year - 80);
    final last = DateTime(now.year - 18);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) {
      _dobController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty || _imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and upload a photo'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Show progress
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving profile... Please wait.')),
    );

    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      final uid = user?.uid ?? 'mock_user_123';
      final repo = ref.read(profileRepositoryProvider);

      final uploadedUrls = <String>[];
      int count = 0;
      for (final img in _imageFiles.take(6)) {
        count++;
        debugPrint('Uploading image $count...');
        // Optional: Update UI with specific status if we had a status state variable
        try {
            final url = await repo.uploadImage(uid, img).timeout(
                const Duration(seconds: 10),
                onTimeout: () => throw Exception('Image upload timed out. Check Firebase Storage.'),
            );
            uploadedUrls.add(url);
        } catch (e) {
            debugPrint('Image upload failed: $e');
            // If upload fails, maybe skip or use a placeholder? 
            // For now, let's rethrow to alert the user
            throw Exception('Failed to upload image $count: $e. Make sure Firebase Storage is enabled.');
        }
      }

      debugPrint('Saving to Firestore...');
      await repo.createProfile(uid, {
        'uid': uid,
        'displayName': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'gender': _gender,
        'dob': _dobController.text.trim(),
        'photos': uploadedUrls,
        'interests': _selectedInterests.toList(),
      }).timeout(
        const Duration(seconds: 10), 
        onTimeout: () => throw Exception('Firestore save timed out. Check Firestore Database.'),
      );

      debugPrint('Profile saved successfully.');
      if (mounted) context.go('/');
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 5),
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            final gridCount = constraints.maxWidth > 900 ? 4 : constraints.maxWidth > 600 ? 3 : 2;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Photos',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: (_webImageBytesList.length + 1).clamp(0, 6),
                  itemBuilder: (context, index) {
                    if (index < _webImageBytesList.length && index < 6) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              _webImageBytesList[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: InkWell(
                              onTap: () => _removePhoto(index),
                              child: const CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.black54,
                                child: Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return InkWell(
                      onTap: _pickImages,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.grey, size: 32),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                isWide
                    ? Row(
                        children: [
                          Expanded(
                            child: CustomTextField(controller: _nameController, hintText: 'Full Name'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _gender,
                              items: ['Male', 'Female', 'Other']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (val) => setState(() => _gender = val ?? _gender),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          CustomTextField(controller: _nameController, hintText: 'Full Name'),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _gender,
                            items: ['Male', 'Female', 'Other']
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) => setState(() => _gender = val ?? _gender),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Date of Birth',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: _pickDob,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Bio',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Interests',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allInterests
                      .map(
                        (i) => ChoiceChip(
                          label: Text(i),
                          selected: _selectedInterests.contains(i),
                          onSelected: (sel) {
                            setState(() {
                              if (sel) {
                                _selectedInterests.add(i);
                              } else {
                                _selectedInterests.remove(i);
                              }
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  onPressed: _saveProfile,
                  text: 'Complete Profile',
                  isLoading: _isLoading,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
