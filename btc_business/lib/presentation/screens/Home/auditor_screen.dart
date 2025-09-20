import 'package:flutter/material.dart';

class AuditorScreen extends StatefulWidget {
  const AuditorScreen({super.key});

  @override
  State<AuditorScreen> createState() => _AuditorScreenState();
}

class _AuditorScreenState extends State<AuditorScreen> {
  final List<AuditType> auditTypes = [
    AuditType(
      title: "Internal Audit",
      icon: Icons.business_center,
      shortDesc:
          "Operational efficiency, internal controls, compliance with policies.",
      longDesc:
          "Conducted by your own staff or internal audit team. Helps identify risks and improve processes by reviewing operations and controls.",
      color: Colors.blue.shade700,
    ),
    AuditType(
      title: "External Audit",
      icon: Icons.account_balance,
      shortDesc: "Verify financial statements for accuracy and compliance.",
      longDesc:
          "Conducted by independent third-party auditors. Often required for regulatory or investor confidence, verifying financial statements and compliance.",
      color: Colors.deepPurple.shade700,
    ),
    AuditType(
      title: "Government Audit",
      icon: Icons.gavel,
      shortDesc:
          "Compliance with laws, tax regulations, and government grants.",
      longDesc:
          "Performed by government agencies. Includes inspections and investigations to ensure regulatory compliance and proper use of grants.",
      color: Colors.green.shade700,
    ),
    AuditType(
      title: "Forensic Audit",
      icon: Icons.search,
      shortDesc: "Investigate fraud, embezzlement, and financial crimes.",
      longDesc:
          "Specialized audit for detailed transaction analysis, tracing funds, and evidence gathering used in legal proceedings.",
      color: Colors.red.shade700,
    ),
    AuditType(
      title: "Tax Audit",
      icon: Icons.receipt_long,
      shortDesc: "Review tax returns and compliance with tax laws.",
      longDesc:
          "Focused on tax filings and related documents, ensuring correct compliance. Can be initiated voluntarily or by tax authorities.",
      color: Colors.orange.shade700,
    ),
  ];

  String searchQuery = '';
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final filteredList =
        auditTypes.where((audit) {
          final query = searchQuery.toLowerCase();
          return audit.title.toLowerCase().contains(query) ||
              audit.shortDesc.toLowerCase().contains(query);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Audit Type"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search audit types...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                  expandedIndex = null; // collapse all on search
                });
              },
            ),
          ),

          Expanded(
            child:
                filteredList.isEmpty
                    ? const Center(child: Text("No audit types found"))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final audit = filteredList[index];
                        final isExpanded = expandedIndex == index;
                        return _AuditTypeCard(
                          auditType: audit,
                          isExpanded: isExpanded,
                          onTap: () {
                            setState(() {
                              if (isExpanded) {
                                expandedIndex = null;
                              } else {
                                expandedIndex = index;
                              }
                            });
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class AuditType {
  final String title;
  final IconData icon;
  final String shortDesc;
  final String longDesc;
  final Color color;

  AuditType({
    required this.title,
    required this.icon,
    required this.shortDesc,
    required this.longDesc,
    required this.color,
  });
}

class _AuditTypeCard extends StatelessWidget {
  final AuditType auditType;
  final bool isExpanded;
  final VoidCallback onTap;

  const _AuditTypeCard({
    required this.auditType,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: auditType.color.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(2, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: auditType.color,
                  radius: 26,
                  child: Icon(auditType.icon, size: 28, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    auditType.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade600,
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              auditType.shortDesc,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  auditType.longDesc,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),
              ),
              crossFadeState:
                  isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }
}
