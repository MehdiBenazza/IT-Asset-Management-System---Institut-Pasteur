# IT Asset Management System - Institut Pasteur

A Flutter application to manage the IT inventory and maintenance operations (preventive & corrective) across departments at Institut Pasteur. The app supports multiple user roles and integrates with Supabase as the backend.

## 🚀 Features

- 📦 **Asset Tracking**: Track computers, printers, and other IT equipment by department, office, and user.
- 👥 **Role-based Access**: Admin, Super Admin, Department Secretary, and Employee.
- 🔁 **Maintenance Logging**: Record preventive and corrective interventions.
- 📄 **PDF Reports**: Generate intervention reports signed by the department and sent to IT management.
- 🖥️ **Real-time Data**: Supabase backend for syncing users, assets, and interventions.

## 🛠️ Tech Stack

- **Flutter**: UI framework for building cross-platform mobile apps.
- **Dart**: Programming language.
- **Supabase**: Backend-as-a-Service (PostgreSQL + Auth + Realtime).
- **PostgreSQL**: Relational database.
- **Flutter PDF**: For generating intervention documents.

## 🗃️ Database Schema (Simplified)

- **User**: `id`, `name`, `email`, `role`, `date_of_birth`, `recruitment_date`, `department_id`, `office_id`
- **Material**: `id`, `type`, `model`, `status`, `available`, `warranty_expiration`
- **Appartenance**: `user_id`, `material_id`, `assigned_date`
- **Department**: `id`, `name`
- **Office**: `id`, `name`, `department_id`
- **Intervention**: `id`, `material_id`, `type`, `date`, `duration`

## 🔐 Roles & Permissions

| Role            | Abilities                                                |
|-----------------|-----------------------------------------------------------|
| Super Admin     | Full control over all assets and departments              |
| Admin           | Manages users and interventions within a department       |
| Secretary       | Manages asset allocation and intervention requests        |
| Employee        | Views and reports issues with assigned materials          |

## 📦 Setup Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/it-asset-management.git
   cd it-asset-management

