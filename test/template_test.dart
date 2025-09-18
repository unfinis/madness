import 'package:flutter_test/flutter_test.dart';
import 'package:madness/models/finding_template.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  group('Template Functionality Tests', () {
    test('Template model can parse JSON correctly', () {
      // Test data based on the actual template structure
      final jsonData = {
        'id': 'test-template',
        'title': 'Test Template',
        'category': 'Test Category',
        'baseDescription': 'Test description',
        'subFindings': [
          {
            'id': 'test-finding',
            'title': 'Test Finding',
            'cvssScore': 7.5,
            'cvssVector': 'CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N',
            'severity': 'High',
            'description': 'Test finding description',
            'checkSteps': 'Test steps',
            'recommendation': 'Test recommendation',
            'screenshotPlaceholders': [],
            'links': []
          }
        ]
      };

      final template = FindingTemplate.fromJson(jsonData);
      
      expect(template.id, equals('test-template'));
      expect(template.title, equals('Test Template'));
      expect(template.category, equals('Test Category'));
      expect(template.subFindings.length, equals(1));
      
      final subFinding = template.subFindings.first;
      expect(subFinding.title, equals('Test Finding'));
      expect(subFinding.cvssScore, equals(7.5));
      expect(subFinding.severity, equals('High'));
    });

    test('Template can convert to Finding objects', () {
      final jsonData = {
        'id': 'test-template',
        'title': 'Test Template',
        'category': 'Test Category',
        'baseDescription': 'Test description',
        'subFindings': [
          {
            'id': 'test-finding',
            'title': 'Test Finding',
            'cvssScore': 7.5,
            'cvssVector': 'CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N',
            'severity': 'High',
            'description': 'Test finding description',
            'checkSteps': 'Test steps',
            'recommendation': 'Test recommendation',
            'screenshotPlaceholders': [],
            'links': []
          }
        ]
      };

      final template = FindingTemplate.fromJson(jsonData);
      final findings = template.toFindings();
      
      expect(findings.length, equals(1));
      
      final finding = findings.first;
      expect(finding.title, equals('Test Finding'));
      expect(finding.cvssScore, equals(7.5));
      expect(finding.description, equals('Test finding description'));
      expect(finding.auditSteps, equals('Test steps'));
      expect(finding.furtherReading, equals('Test recommendation'));
    });

    test('Template index can be parsed', () {
      final indexJson = {
        'templates': [
          {
            'id': 'test-1',
            'filename': 'test-1.json',
            'title': 'Test Template 1',
            'category': 'Test Category',
            'findingCount': 2
          },
          {
            'id': 'test-2',
            'filename': 'test-2.json', 
            'title': 'Test Template 2',
            'category': 'Another Category',
            'findingCount': 3
          }
        ],
        'version': '1.0',
        'description': 'Test templates'
      };

      final templateIndex = TemplateIndex.fromJson(indexJson);
      
      expect(templateIndex.templates.length, equals(2));
      expect(templateIndex.version, equals('1.0'));
      
      final firstTemplate = templateIndex.templates.first;
      expect(firstTemplate.id, equals('test-1'));
      expect(firstTemplate.title, equals('Test Template 1'));
      expect(firstTemplate.category, equals('Test Category'));
      expect(firstTemplate.findingCount, equals(2));
    });

    test('Real template files can be loaded', () async {
      // Test loading the actual SQL injection template
      final templateFile = File('/home/kali/madness/devhelp/templates/sql-injection.json');
      
      if (await templateFile.exists()) {
        final content = await templateFile.readAsString();
        final jsonData = json.decode(content) as Map<String, dynamic>;
        
        // This should not throw an exception
        final template = FindingTemplate.fromJson(jsonData);
        
        expect(template.id, equals('sql-injection'));
        expect(template.title, equals('SQL Injection Vulnerability'));
        expect(template.subFindings.isNotEmpty, isTrue);
        
        // Test converting to findings
        final findings = template.toFindings();
        expect(findings.isNotEmpty, isTrue);
        
        // Test that all fields are properly mapped
        final firstFinding = findings.first;
        expect(firstFinding.title.isNotEmpty, isTrue);
        expect(firstFinding.description.isNotEmpty, isTrue);
        expect(firstFinding.cvssScore, greaterThan(0));
      }
    });
  });
}