# Security Finding Builder - Template System

This folder contains individual security finding templates used by the Security Finding Builder application.

## 📁 Folder Structure

```
templates/
├── index.json                           # Template manifest/index
├── azure-keyvault-misconfig.json        # Azure Key Vault (10 findings)
├── azure-function-app-misconfig.json    # Azure Function App (8 findings) 
├── azure-storage-account-misconfig.json # Azure Storage Account (10 findings)
├── azure-web-app-misconfig.json         # Azure Web App (12 findings)
├── azure-sql-database-misconfig.json    # Azure SQL Database (7 findings)
├── azure-service-bus-misconfig.json     # Azure Service Bus (6 findings)
├── azure-repository-misconfig.json      # Azure Repository (6 findings)
├── azure-data-factory-misconfig.json    # Azure Data Factory V2 (6 findings)
├── sql-injection.json                   # SQL Injection (2 findings)
└── README.md                            # This file
```

## 🚀 Template Loading System

The application uses a **two-tier loading system** for maximum flexibility:

### 1. **Folder-Based Loading (Primary)**
- Loads `templates/index.json` to get template manifest
- Dynamically loads individual template files from `templates/` folder
- **Benefits**: Modular, maintainable, better performance

### 2. **Legacy Loading (Fallback)**
- Falls back to `templates.json` for backward compatibility
- Single-file loading for existing deployments

### 3. **Built-in Templates (Last Resort)**
- Hard-coded fallback templates in JavaScript
- Ensures application always functions

## 📋 Template Structure

Each template file contains:

```json
{
  "id": "unique-template-id",
  "title": "Template Display Name", 
  "category": "Security Category",
  "baseDescription": "High-level description",
  "subFindings": [
    {
      "id": "unique-finding-id",
      "title": "Finding Title",
      "cvssScore": 7.5,
      "cvssVector": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N",
      "severity": "High|Medium|Low|Critical",
      "description": "Detailed description",
      "checkSteps": "Manual verification steps",
      "recommendation": "Remediation guidance",
      "verificationProcedure": "Post-fix validation",
      "screenshotPlaceholders": [...],
      "links": [...]
    }
  ],
  "automatedScript": "PowerShell/script for automation"
}
```

## 🔧 Index.json Manifest

The `index.json` file provides template metadata:

```json
{
  "templates": [
    {
      "id": "template-id",
      "filename": "template-file.json",
      "title": "Display Name",
      "category": "Category",
      "findingCount": 10
    }
  ],
  "version": "1.0",
  "description": "Security Finding Builder Template Index"
}
```

## ✅ Benefits of Folder Structure

### **Maintainability**
- ✅ Edit individual templates without affecting others
- ✅ Cleaner version control and diffs
- ✅ Parallel development on different templates

### **Performance** 
- ✅ Load templates on-demand
- ✅ Smaller individual file sizes
- ✅ Better browser caching

### **Organization**
- ✅ Logical file separation by security domain
- ✅ Easy template discovery and management
- ✅ Template-specific validation

### **Scalability**
- ✅ Easy to add new templates
- ✅ Template categories and filtering
- ✅ Modular template sharing

## 🆕 Adding New Templates

1. **Create template file**: `templates/new-template.json`
2. **Update index**: Add entry to `templates/index.json`
3. **Test loading**: Verify template loads correctly
4. **Validate structure**: Ensure all required fields present

## 🔄 Migration from Legacy

The system maintains **full backward compatibility**:
- Existing `templates.json` still works as fallback
- No breaking changes to template structure
- Gradual migration path available

## 📊 Current Template Coverage

- **Azure Services**: 8 comprehensive templates
- **Web Applications**: SQL injection coverage
- **Total Findings**: 67 security checks
- **Categories**: Cloud Security, Database, DevOps, Web Applications

---

*This folder-based template system provides enhanced maintainability, performance, and scalability for the Security Finding Builder application.*