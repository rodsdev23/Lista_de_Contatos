import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import '../models/Contact_model.dart';

/// Tabela que armazena os contatos no banco de dados.
const String contactTable = "contactTable";
const String idColumn = "idColumn";
const String nameColumn = "nameColumn";
const String emailColumn = "emailColumn";
const String phoneColumn = "phoneColumn";
const String imgColumn = "imgColumn";

/// Classe que fornece métodos para interagir com o banco de dados e realizar operações
/// em contatos.
class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  late Database _db;

  /// Obtém ou cria uma instância do banco de dados e o retorna.
  // Future<Database> get db async {
  //   if (_db != null) {
  //     return _db;
  //   } else {
  //     _db = await initDb();
  //     return _db;
  //   }
  // }

  /// Inicializa o banco de dados e cria a tabela de contatos, se não existir.
  // Future<Database> initDb() async {
  //   final databasesPath = await getDatabasesPath();
  //   final path = join(databasesPath, "contactsnew.db");

  //   return await openDatabase(path, version: 1,
  //       onCreate: (Database db, int newerVersion) async {
  //     await db.execute(
  //         "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, "
  //         "$phoneColumn TEXT, $imgColumn TEXT)");
  //   });
  // }

  /// Salva um contato no banco de dados.
  Future<Contact> saveContact(Contact contact) async {
    //Database dbContact = await db;
    // contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  /// Obtém um contato do banco de dados com base no ID.
  Future<Contact?> getContact(int id) async {
    // Database dbContact = await db;
    // List<Map> maps = await dbContact.query(contactTable,
    //     columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
    //     where: "$idColumn = ?",
    //     whereArgs: [id]);
    // if (maps.isNotEmpty) {
    //   return Contact.fromMap(maps.first);
    // } else {
    //   return null;
    // }
  }

  /// Exclui um contato do banco de dados com base no ID.
  Future<int> deleteContact(int id) async {
    //Database dbContact = await db;
    //return await dbContact
    //  .delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
    return id; // remover depois
  }

  /// Atualiza as informações de um contato no banco de dados.
  Future<int> updateContact(Contact contact) async {
    // Database dbContact = await db;
    // return await dbContact.update(contactTable, contact.toMap(),
    //     where: "$idColumn = ?", whereArgs: [contact.id]);
    return 0;
  }

  /// Obtém uma lista de todos os contatos armazenados no banco de dados.
  // Future<List<Contact>> getAllContacts() async {
  //   Database dbContact = await db;
  //   List<Map> listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
  //   List<Contact> listContact = List<Contact>();
  //   for (Map m in listMap) {
  //     listContact.add(Contact.fromMap(m));
  //   }
  //   return listContact;
  // }

  /// Obtém o número total de contatos armazenados no banco de dados.
  Future<int?> getNumber() async {
    // Database dbContact = await db;
    // return Sqflite.firstIntValue(
    //     await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  /// Fecha a conexão com o banco de dados.
  Future close() async {
    // Database dbContact = await db;
    // dbContact.close();
  }
}
