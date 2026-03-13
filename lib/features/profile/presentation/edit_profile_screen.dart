import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/common_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _bioController = TextEditingController(text: "Loves hiking and coffee. Looking for someone to explore the city with.");
  final _jobController = TextEditingController(text: "Product Designer");
  final _companyController = TextEditingController(text: "Tech Corp");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photos Grid
            Text('Photos', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                if (index < 3) {
                  return Stack(
                    children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                    image: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=60'),
                                    fit: BoxFit.cover,
                                )
                            ),
                        ),
                        Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 16, color: Color(0xFFE94057)),
                            ),
                        )
                    ],
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.grey),
                );
              },
            ),

            const SizedBox(height: 24),
            
            // About Me
            Text('About Me', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _bioController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write something about yourself...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Job & Company', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomTextField(controller: _jobController, hintText: 'Job Title'),
            const SizedBox(height: 8),
            CustomTextField(controller: _companyController, hintText: 'Company'),

            const SizedBox(height: 24),
            Text('Interests', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Coffee', 'Hiking', 'Art', 'Music', 'Travel'].map((interest) {
                return Chip(
                  label: Text(interest),
                  backgroundColor: const Color(0xFFE94057).withOpacity(0.1),
                  labelStyle: const TextStyle(color: Color(0xFFE94057)),
                  deleteIcon: const Icon(Icons.close, size: 16, color: Color(0xFFE94057)),
                  onDeleted: () {},
                );
              }).toList(),
            ),
             const SizedBox(height: 8),
            OutlinedButton.icon(
                onPressed: (){}, 
                icon: const Icon(Icons.add), 
                label: const Text('Add Interest'),
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: const BorderSide(color: Colors.grey)
                ),
            )
          ],
        ),
      ),
    );
  }
}
