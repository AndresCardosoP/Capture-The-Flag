import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCheckingAdmin = false;
  String _adminError = '';

  Future<void> _tryAccessAdmin() async {
    setState(() {
      _isCheckingAdmin = true;
      _adminError = '';
    });

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.checkAdmin();

      if (authService.adminResponse.contains('flag') ||
          authService.adminResponse.contains('success')) {
        Navigator.pushNamed(context, '/admin');
      } else {
        setState(() {
          _adminError = 'Access denied: Insufficient privileges';
        });
      }
    } catch (e) {
      setState(() {
        _adminError = 'Error checking admin access: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isCheckingAdmin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('SecureApp Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: _isCheckingAdmin ? null : _tryAccessAdmin,
            tooltip: 'Admin Panel',
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${authService.username}',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    'User Role: Standard',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help Center'),
              onTap: () => Navigator.pop(context),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Challenge: Find a way to access the admin panel!',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body:
          _isCheckingAdmin
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome card
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.waving_hand, color: Colors.amber),
                                  SizedBox(width: 8),
                                  Text(
                                    'Welcome back, ${authService.username}!',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Your last login was today at ${DateTime.now().hour}:${DateTime.now().minute}',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Error message if present
                      if (_adminError.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[900],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error, color: Colors.white),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _adminError,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Dashboard section
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Dashboard cards
                      GridView.count(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          _buildDashboardItem(
                            icon: Icons.article,
                            title: 'My Documents',
                            subtitle: '12 files',
                            color: Colors.blue,
                          ),
                          _buildDashboardItem(
                            icon: Icons.people,
                            title: 'Team Members',
                            subtitle: '5 online',
                            color: Colors.green,
                          ),
                          _buildDashboardItem(
                            icon: Icons.task_alt,
                            title: 'Projects',
                            subtitle: '3 active',
                            color: Colors.purple,
                          ),
                          _buildDashboardItem(
                            icon: Icons.notifications,
                            title: 'Notifications',
                            subtitle: '2 unread',
                            color: Colors.orange,
                          ),
                        ],
                      ),

                      SizedBox(height: 24),

                      // Recent activity section
                      Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.withOpacity(0.2),
                                child: Icon(
                                  Icons.upload_file,
                                  color: Colors.blue,
                                ),
                              ),
                              title: Text('Project report uploaded'),
                              subtitle: Text('Today, 09:32 AM'),
                            ),
                            Divider(),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green.withOpacity(0.2),
                                child: Icon(Icons.comment, color: Colors.green),
                              ),
                              title: Text('New comment on Task #45'),
                              subtitle: Text('Yesterday, 14:20 PM'),
                            ),
                            Divider(),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber.withOpacity(0.2),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.amber,
                                ),
                              ),
                              title: Text('Team meeting scheduled'),
                              subtitle: Text('Yesterday, 10:00 AM'),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32),

                      // Small reminder about the challenge at the bottom
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '🔒 Find a way to access the admin panel!',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildDashboardItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
