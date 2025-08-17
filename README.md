# Public Project Management System (PPMS)

A comprehensive project management platform for Sierra Leone's local councils with role-based access control, real-time validation workflows, and integrated Sierra Leone Leones (SLL) currency support.

## 🎯 Overview

The PPMS is designed to promote transparency, accountability, and efficient resource management across Sierra Leone's local councils. The system provides different interfaces tailored to specific user roles while maintaining a unified data structure and workflow.

## 🚀 Quick Start

1. **Access the system**: Navigate to `login.html` to authenticate
2. **Login with credentials**: Use demo accounts or real user credentials
3. **Automatic redirection**: System redirects to appropriate role dashboard
4. **Manage projects**: Use the features available to your role

## 🔐 Authentication System

The PPMS features a comprehensive authentication and user management system:

### Login Process
- **Entry Point**: `login.html` - Beautiful login interface with demo accounts
- **Authentication**: Supabase Auth integration with email/password
- **Role-based Redirection**: Automatic redirect to appropriate dashboard
- **Session Management**: Secure localStorage session handling
- **Password Reset**: Forgot password functionality via email

### Demo Accounts
For testing and demonstration purposes, the following accounts are available:

| Role | Email | Password | Access Level |
|------|--------|-----------|-------------|
| Admin | admin@ppms.sl | admin123 | Full system access |
| Council User | council@ppms.sl | council123 | Council-specific features |
| Supervisor | supervisor@ppms.sl | super123 | Validation workflows |
| Auditor | auditor@ppms.sl | audit123 | Read-only system access |

### User Management
- **Admin Interface**: `admin-users.html` - Full user creation and management
- **Role Assignment**: Admins can create users and assign roles
- **Council Assignment**: Council users can be assigned to specific councils
- **User Status**: Active/inactive status management
- **Password Generation**: Automatic secure password generation
- **Real-time Validation**: Email uniqueness and role validation

## 📁 System Architecture

```
council-system-deploy/
├── login.html              # Authentication login page with role-based redirection
├── index.html              # Main landing page (redirects to login)
├── admin-enhanced.html     # Admin dashboard with full system access
├── admin-users.html        # User management interface for admin
├── council-user.html       # Council user interface for project updates
├── supervisor.html         # Supervisor dashboard for validation workflows
├── auditor.html           # Auditor interface with read-only access
├── notifications.html      # Notification center with workflow automation
├── reports.html           # Advanced reporting with PDF/Excel export
├── admin.html             # Original admin interface (SLL currency integration)
├── user-management-schema.sql  # Complete database schema
└── README.md              # This documentation
```

## 👥 User Roles

### 🛡️ Admin / National Coordinator
- **File**: `admin-enhanced.html`
- **Access**: Full system administration
- **Features**:
  - User management and role assignment
  - Complete project oversight across all councils
  - System configuration and settings
  - Comprehensive analytics and reporting
  - Audit trail monitoring

### 🏛️ Council User
- **File**: `council-user.html`
- **Access**: Council-specific project management
- **Features**:
  - Update project status and progress
  - Track and create project milestones
  - Upload supporting documents
  - Submit updates for validation
  - Monitor validation status

### ⚖️ Supervisor / Judge
- **File**: `supervisor.html`
- **Access**: Validation and approval workflows
- **Features**:
  - Review and validate project updates
  - Approve or reject milestone submissions
  - Ensure compliance with standards
  - Quality assurance processes
  - Validation workflow management

### 🔍 Auditor
- **File**: `auditor.html`
- **Access**: Read-only comprehensive data access
- **Features**:
  - View all project data and statistics
  - Access complete audit trail
  - Generate financial and compliance reports
  - Export data for analysis
  - Monitor system-wide activities

## 💰 Currency Integration

The system natively supports Sierra Leone Leones (SLL) as the primary currency with automatic USD conversion:

- **Primary Currency**: Sierra Leone Leones (SLL)
- **Exchange Rate**: Live API integration with fallback rates
- **Display Format**: SLL amounts with USD equivalents
- **Budget Tracking**: Full SLL integration across all financial data
- **Reporting**: Dual currency display for transparency

## 🗄️ Database Schema

The system uses a comprehensive PostgreSQL schema via Supabase:

### Core Tables
- **councils**: Local council information
- **projects**: Project data with SLL budget integration
- **system_users**: User management with role assignments
- **user_roles**: Role definitions and permissions

### Workflow Tables
- **project_validations**: Validation request and approval workflow
- **project_milestones**: Milestone tracking with validation status
- **project_documents**: Document management with validation
- **audit_logs**: Comprehensive audit trail

### Features
- Row-level security (RLS) policies
- Automatic audit logging triggers
- Foreign key relationships and constraints
- Indexed columns for performance

## 🔧 Technical Implementation

### Frontend Technologies
- **React 18**: Modern functional components with hooks
- **TailwindCSS**: Responsive design framework
- **JavaScript ES6+**: Modern language features
- **Real-time Updates**: Live data synchronization

### Backend Infrastructure
- **Supabase**: PostgreSQL database with real-time capabilities
- **RESTful API**: Comprehensive data access layer
- **Row-Level Security**: Granular access control
- **File Storage**: Secure document management

### Security Features
- **Role-Based Access Control (RBAC)**: Granular permissions
- **Data Encryption**: At rest and in transit
- **Audit Logging**: Complete activity tracking
- **Input Validation**: Comprehensive data sanitization

### Integration Capabilities
- **Exchange Rate API**: Live currency conversion
- **CSV Export**: Data export functionality
- **REST Endpoints**: External system integration
- **Webhook Support**: Real-time notifications

## 🛠️ Setup Instructions

### Prerequisites
- Modern web browser (Chrome, Firefox, Safari, Edge)
- Internet connection for CDN resources and API calls
- Supabase project with provided credentials

### Database Setup
1. Execute the SQL schema from `user-management-schema.sql`
2. Configure Row-Level Security policies
3. Set up storage buckets for file uploads
4. Verify API keys and permissions

### Deployment
1. Upload all HTML files to your web server
2. Ensure proper MIME types for HTML files
3. Configure HTTPS for security
4. Test all role-based interfaces

## 📊 System Features

### Project Management
- **Real-time Tracking**: Live project status updates
- **Budget Management**: SLL-based financial tracking
- **Milestone Monitoring**: Progress tracking with validation
- **Document Management**: Secure file storage and validation
- **KPI Tracking**: Performance indicators and metrics

### Validation Workflows
- **Multi-tier Approval**: Council → Supervisor → Implementation
- **Status Tracking**: Real-time validation progress
- **Rejection Handling**: Notes and resubmission process
- **Audit Trail**: Complete workflow history

### Notifications & Workflow Automation
- **Real-time Alerts**: Instant notifications for project changes and updates
- **Automated Reminders**: System-generated alerts for overdue updates and milestones
- **Workflow Visualization**: Visual tracking of project workflow progress
- **Priority Management**: Color-coded priority levels for overdue items
- **Auto-refresh**: Configurable automatic data refresh for live monitoring

### Advanced Reporting System
- **Multi-format Export**: Generate PDF and Excel reports with professional layouts
- **Report Types**: National overview, council performance, project details, financial analysis, compliance, and performance analytics
- **Scheduled Reports**: Automated report generation and delivery via email
- **Custom Filters**: Date range, status, budget range, and council-specific filtering
- **Interactive Previews**: Real-time report preview before generation
- **Data Visualization**: Charts and graphs for enhanced data presentation

### Reporting & Analytics
- **Dashboard Analytics**: Real-time statistics and charts
- **Financial Reports**: Budget utilization and spending
- **Compliance Monitoring**: Audit trail and validation status
- **Export Capabilities**: PDF, Excel, and CSV export for comprehensive analysis

## 🔒 Security Considerations

### Data Protection
- All sensitive data encrypted at rest and in transit
- Regular security updates and patches
- Comprehensive input validation and sanitization
- Secure file upload with type restrictions

### Access Control
- Role-based permissions strictly enforced
- Session management and timeout controls
- Audit logging for all user activities
- Regular permission review and updates

### Compliance
- Complete audit trail for all system changes
- Data retention policies and procedures
- Regular backup and disaster recovery testing
- Compliance reporting capabilities

## 🚀 Future Enhancements

### Planned Features
- Mobile application development
- Advanced analytics and machine learning
- Integration with external financial systems
- Multi-language support (Krio, Temne, Mende)
- Automated notification systems

### Scalability
- Database optimization for increased load
- CDN integration for improved performance
- Microservices architecture migration
- Real-time collaboration features

## 📞 Support

For technical support or questions about the PPMS system:

1. **Documentation**: Refer to this README and inline code comments
2. **Database Issues**: Check `user-management-schema.sql` for structure
3. **Role Access**: Verify user roles and permissions in database
4. **API Issues**: Confirm Supabase connection and credentials

## 📄 License

This is a demo implementation of the Public Project Management System. The system is designed for Sierra Leone's local councils and includes comprehensive project management, validation workflows, and audit capabilities.

## 🤝 Contributing

The PPMS system is designed to be extensible and maintainable:

1. **Code Structure**: Well-organized React components with clear separation
2. **Documentation**: Comprehensive inline comments and documentation
3. **Database Design**: Normalized schema with proper relationships
4. **Testing**: Built-in error handling and validation

---

*Public Project Management System (PPMS) - Promoting transparency and accountability in Sierra Leone's local government project management.*
# Last updated: Sun Aug 17 14:05:36 GMT 2025
