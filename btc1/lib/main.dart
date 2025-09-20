import 'package:flutter/material.dart';

void main() => runApp(const BurjTechApp());

class BurjTechApp extends StatelessWidget {
  const BurjTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BURJ Tech Consultancy',
      theme: ThemeData(
        fontFamily: 'Helvetica',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      appBar:
          isMobile
              ? AppBar(
                backgroundColor: Colors.indigo,
                title: const Text(
                  'BURJ Tech Consultancy',
                  style: TextStyle(color: Colors.white),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              )
              : null,
      drawer: isMobile ? const AppDrawer() : null,
      body: Stack(
        children: [
          const SingleChildScrollView(
            child: Column(
              children: [
                HeroSection(),
                ServicesSection(),
                CapabilitiesSection(),
                IndustriesSection(),
                AboutSection(),
                ContactSection(),
                FooterSection(),
              ],
            ),
          ),
          if (!isMobile) const TopNavigationBar(),
        ],
      ),
    );
  }
}

class TopNavigationBar extends StatelessWidget {
  const TopNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    if (isMobile) return const SizedBox(); // Hide navbar on mobile

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo + Name
                Row(
                  children: [
                    const Icon(Icons.business, color: Colors.indigo, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      'BURJ Tech Consultancy',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.indigo.shade900,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                // Navigation Items
                Row(
                  children: [
                    _navItem(context, 'Home'),
                    _navItem(context, 'Services'),
                    _navItem(context, 'Capabilities'),
                    _navItem(context, 'Industries'),
                    _navItem(context, 'About'),
                    _navItem(context, 'Contact'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Handle navigation here
          debugPrint('Navigated to $label');
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo, Colors.blueAccent],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white24)),
                ),
                child: Row(
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: Icon(Icons.business, color: Colors.indigo),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Burj Tech Consultancy',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Innovate. Secure. Scale.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _drawerItem(Icons.home, 'Home'),
              _drawerItem(Icons.miscellaneous_services, 'Services'),
              _drawerItem(Icons.auto_graph, 'Capabilities'),
              _drawerItem(Icons.domain, 'Industries'),
              _drawerItem(Icons.info_outline, 'About'),
              _drawerItem(Icons.contact_mail, 'Contact'),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '© 2025 Burj Tech',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {},
    );
  }
}

// Sections like HeroSection, ServicesSection, etc. remain unchanged

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final isWebLarge = screenWidth > 1200;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 120,
        horizontal: isMobile ? 20 : 40,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Empowering Your Digital Future',
                style: TextStyle(
                  fontSize:
                      isMobile
                          ? 28
                          : isWebLarge
                          ? 56
                          : 48,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.3,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'At Burj Tech Consultancy, we drive business agility, resilience, and growth through tailored digital transformation. With deep industry expertise, we deliver solutions in software, cybersecurity, AI, and cloud technologies.',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 20,
                  color: Colors.white70,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Our mission is to partner with enterprises, enabling them to scale securely and intelligently—transforming vision into reality through innovative technology.',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 18,
                  color: Colors.white60,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 36),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.handshake_outlined),
                    label: const Text("Partner With Us"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.indigo.shade900,
                      elevation: 5,
                      shadowColor: Colors.black26,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 30,
                        vertical: isMobile ? 14 : 18,
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.visibility_outlined,
                      color: Colors.white,
                    ),
                    label: const Text("Explore Services"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70, width: 1.5),
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 30,
                        vertical: isMobile ? 14 : 18,
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'title': 'Enterprise Software Development',
        'icon': Icons.laptop_mac,
        'desc':
            'Custom, scalable software solutions to streamline your business operations and growth.',
      },
      {
        'title': 'Cybersecurity & Compliance',
        'icon': Icons.lock_outline,
        'desc':
            'Advanced protection and regulatory compliance through modern security practices.',
      },
      {
        'title': 'Data Analytics & AI',
        'icon': Icons.bar_chart,
        'desc':
            'Unleash insights from data using AI, ML, and predictive analytics for smarter decisions.',
      },
      {
        'title': 'Cloud Transformation',
        'icon': Icons.cloud_sync_outlined,
        'desc':
            'Migrate, optimize, and manage cloud infrastructure for agility and efficiency.',
      },
      {
        'title': 'IT Infrastructure & Support',
        'icon': Icons.settings_input_component,
        'desc':
            'Robust infrastructure planning, deployment, and round-the-clock support services.',
      },
      {
        'title': 'High-Tech Engineering',
        'icon': Icons.engineering,
        'desc':
            'From embedded systems to robotics – delivering futuristic engineering solutions.',
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      color: const Color(0xFFF5F8FF),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 20 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Services',
                style: TextStyle(
                  fontSize: isMobile ? 26 : 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'We craft scalable, secure, and innovative IT solutions tailored to your unique challenges. Partner with us to modernize your technology and future-proof your business.',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 18,
                  height: 1.6,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children:
                    services
                        .map((s) => _buildCard(context, s, isMobile))
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    Map<String, dynamic> service,
    bool isMobile,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: isMobile ? double.infinity : 330,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo.withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(14),
              child: Icon(service['icon'], size: 32, color: Colors.indigo),
            ),
            const SizedBox(height: 20),
            Text(
              service['title'],
              style: TextStyle(
                fontSize: isMobile ? 17 : 20,
                fontWeight: FontWeight.w600,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              service['desc'],
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CapabilitiesSection extends StatelessWidget {
  const CapabilitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    final capabilities = [
      {
        'icon': Icons.code,
        'title': 'Full-Stack Engineering',
        'desc':
            'Expertise across frontend, backend, APIs, and databases using modern frameworks and tools.',
      },
      {
        'icon': Icons.insights,
        'title': 'AI / Machine Learning',
        'desc':
            'We build smart systems that learn from data, automate tasks, and offer predictive insights.',
      },
      {
        'icon': Icons.cloud_done,
        'title': 'Cloud & DevOps',
        'desc':
            'Deploy scalable, reliable cloud-native applications using CI/CD, containerization, and automation.',
      },
      {
        'icon': Icons.security,
        'title': 'Cybersecurity',
        'desc':
            'Implement enterprise-grade security, risk management, and compliance frameworks.',
      },
      {
        'icon': Icons.device_hub,
        'title': 'Data Engineering',
        'desc':
            "Build intelligent pipelines, scalable data lakes, and real-time analytics platforms with precision.",
      },
      {
        'icon': Icons.sync_alt,
        'title': 'Agile Delivery',
        'desc':
            "Fast iterations with sprint-based delivery models, focused on value, quality, and measurable business outcomes.",
      },
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F7FA),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 20 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Capabilities',
                style: TextStyle(
                  fontSize: isMobile ? 28 : 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We deliver full-cycle technology services — from strategy to implementation — helping businesses scale, innovate, and transform in the digital world.',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 18,
                  height: 1.6,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 36),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children:
                    capabilities
                        .map((c) => _capabilityCard(c, isMobile))
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _capabilityCard(Map<String, dynamic> capability, bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isMobile ? double.infinity : 360,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.indigo.withOpacity(0.1),
              radius: 30,
              child: Icon(capability['icon'], color: Colors.indigo, size: 30),
            ),
            const SizedBox(height: 20),
            Text(
              capability['title'],
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.w600,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              capability['desc'],
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IndustriesSection extends StatelessWidget {
  const IndustriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    final industries = [
      {
        'icon': Icons.account_balance,
        'title': 'Banking & Finance',
        'desc':
            'Secure, scalable fintech solutions powering digital transformation.',
      },
      {
        'icon': Icons.account_balance_wallet,
        'title': 'Public Sector',
        'desc':
            'Modernizing government services with secure digital infrastructure.',
      },
      {
        'icon': Icons.health_and_safety,
        'title': 'Healthcare',
        'desc':
            'Smart healthcare systems and compliance-driven data platforms.',
      },
      {
        'icon': Icons.precision_manufacturing,
        'title': 'Manufacturing & Automation',
        'desc':
            'Industry 4.0, IoT, robotics, and factory digitization solutions.',
      },
      {
        'icon': Icons.bolt,
        'title': 'Energy & Utilities',
        'desc': 'Reliable tech to optimize operations, assets, and analytics.',
      },
      {
        'icon': Icons.public,
        'title': 'Telecom & Media',
        'desc':
            'Connecting the world through cutting-edge communication platforms.',
      },
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F7FA),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 20 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Industries We Serve',
                style: TextStyle(
                  fontSize: isMobile ? 28 : 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We bring domain-specific expertise and innovation to every industry, enabling digital-first experiences and operational excellence.',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 18,
                  height: 1.6,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 36),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children:
                    industries
                        .map((industry) => _industryCard(industry, isMobile))
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _industryCard(Map<String, dynamic> industry, bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isMobile ? double.infinity : 360,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.indigo.withOpacity(0.1),
              radius: 30,
              child: Icon(industry['icon'], color: Colors.indigo, size: 30),
            ),
            const SizedBox(height: 20),
            Text(
              industry['title'],
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.w600,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              industry['desc'],
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8F9FB),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 20 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: isMobile ? 28 : 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Burj Tech Consultancy is a modern technology solutions provider, built with a passion to solve complex challenges and deliver measurable business outcomes.',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 18,
                  height: 1.7,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Founded with a mission to empower digital transformation, we are a team of experienced engineers, designers, and strategists. We work closely with startups, enterprises, and government organizations to craft scalable, future-ready solutions.',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 18,
                  height: 1.7,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Our culture promotes continuous learning, agile innovation, and technical excellence. We embrace modern tools and emerging technologies — from cloud to AI — to deliver software that truly empowers our clients.',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 18,
                  height: 1.7,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 36),
              _aboutHighlights(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _aboutHighlights(bool isMobile) {
    final highlights = [
      {
        'icon': Icons.lightbulb_outline,
        'title': 'Innovation-Driven',
        'desc':
            'We constantly evolve to adopt the latest technologies and practices.',
      },
      {
        'icon': Icons.people_outline,
        'title': 'Client-Centric',
        'desc':
            'Our success is rooted in long-term relationships with our clients.',
      },
      {
        'icon': Icons.language,
        'title': 'Global Impact',
        'desc':
            'Projects delivered across industries in multiple regions worldwide.',
      },
    ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children:
          highlights.map((item) {
            return Container(
              width: isMobile ? double.infinity : 360,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.indigo.withOpacity(0.1),
                    radius: 28,
                    child: Icon(
                      item['icon'] as IconData,
                      color: Colors.indigo,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontSize: isMobile ? 17 : 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['desc'] as String,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            height: 1.5,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      width: double.infinity,
      color: const Color(0xFFEFEFEF),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 20 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get in Touch',
                style: TextStyle(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'We’re always open to connecting. Whether you have a project in mind or simply want to explore possibilities, we’re just a message away.',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 18,
                  height: 1.6,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 36),
              Wrap(
                spacing: 40,
                runSpacing: 20,
                children: [
                  _contactItem(Icons.phone, 'Phone', '+91 94443 69625'),
                  _contactItem(Icons.email, 'Email', 'support@btcglobal.info'),
                  _contactItem(
                    Icons.location_on,
                    'Address',
                    '469, Pavalamalli St,\nKakkalur, Tiruvallur 602003',
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  // You can link this to a contact form or WhatsApp
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Contact Us Now'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28, color: Colors.indigo),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.indigo,
      alignment: Alignment.center,
      child: const Text(
        '© 2025 Burj Tech Consultancy. All rights reserved.',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
