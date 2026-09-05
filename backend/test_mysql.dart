import 'package:mysql1/mysql1.dart';

void main() async {
  print('Testing MySQL connection to 127.0.0.1:3306...');
  
  try {
    final settings = ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'root',
    );

    final conn = await MySqlConnection.connect(settings);
    print('====================================================');
    print('✅ Connected successfully to MySQL server on 127.0.0.1:3306!');

    await conn.query('CREATE DATABASE IF NOT EXISTS krushi_mithra;');
    print('✅ Database `krushi_mithra` created or verified successfully in phpMyAdmin!');
    print('====================================================');

    await conn.close();
  } catch (e) {
    print('❌ Connection with 127.0.0.1 failed: $e');

    try {
      final settings = ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
      );
      final conn = await MySqlConnection.connect(settings);
      print('✅ Connected successfully to localhost!');
      await conn.query('CREATE DATABASE IF NOT EXISTS krushi_mithra;');
      print('✅ Database `krushi_mithra` created or verified successfully!');
      await conn.close();
    } catch (e2) {
      print('❌ Connection with localhost failed: $e2');
    }
  }
}
