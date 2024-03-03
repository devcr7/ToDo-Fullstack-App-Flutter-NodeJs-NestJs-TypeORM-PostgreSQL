import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/global_data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _todoTitle = TextEditingController();
  final TextEditingController _todoDesc = TextEditingController();
  List<dynamic> items = [];
  List<bool> isSelected = [true, false, false];
  String sortOrder = 'Last Updated';
  String filterValue = 'All';

  @override
  void initState() {
    super.initState();
    initToDo();
  }

  Future<void> initToDo() async {
    items = await GlobalData.toDoRepository.getTodoList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    const Text(
                      'ToDo App',
                      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${items.length} tasks',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
                _buildUserIcon(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildFilterToggleButtons(),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSortOrderDropdown(),
                      ],
                    ),
                    Expanded(
                      child: _buildTodoList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context: context),
        tooltip: 'Add-ToDo',
        child: const Icon(Icons.add),
      ),
      endDrawer: Drawer(
        child: Container(
          color: Colors.blue,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
               UserAccountsDrawerHeader(
                accountName: Text(
                  GlobalData.currentUserName,
                  style: const TextStyle(fontSize: 18),
                ),
                accountEmail: Text(
                  GlobalData.currentUserEmail,
                  style: const TextStyle(fontSize: 14),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.account_circle,
                    size: 48,
                    color: Colors.blue,
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: const Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.dashboard,
                  color: Colors.white,
                ),
                onTap: () {
                  // Handle dashboard navigation
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onTap: () {
                  // Handle settings navigation
                  Navigator.of(context).pop();
                },
              ),
              const Divider(
                color: Colors.white,
              ),
              ListTile(
                title: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildFilterToggleButtons() {
    return ToggleButtons(
      onPressed: (int index) async {
        setState(() {
          for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
            if (buttonIndex == index) {
              isSelected[buttonIndex] = !isSelected[buttonIndex];
            } else {
              isSelected[buttonIndex] = false;
            }
          }
        });

         filterValue = isSelected[0]
            ? 'All'
            : isSelected[1]
            ? 'Completed'
            : 'Not Completed';

        if (filterValue == 'All') {
          items = await GlobalData.toDoRepository.getTodoList(
            order: sortOrder,
          );
        } else {
          items = await GlobalData.toDoRepository.getTodoList(
            isCompleted: filterValue == 'Completed',
            order: sortOrder,
          );
        }

        setState(() {});
      },
      isSelected: isSelected,
      children: [
        _buildFilterButton('All'),
        _buildFilterButton('Completed'),
        _buildFilterButton('Not Completed'),
      ],
    );
  }

  Widget _buildFilterButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        label,
        style: const TextStyle(color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildSortOrderDropdown() {
    return DropdownButton<String>(
      value: sortOrder,
      onChanged: (String? value) async {
        sortOrder = value!;
        items = await GlobalData.toDoRepository.getTodoList(
          order: sortOrder == 'Last Updated' ? 'DESC' : 'ASC',
        );
        setState(() {});
      },
      items: ['Last Updated', 'First Updated'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.blueAccent),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Slidable(
            key: Key(items[index]['id'].toString()),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(
                onDismissed: () async {
                  await deleteItem(itemId: items[index]['id']);
                  setState(() {});
                },
              ),
              children: [
                SlidableAction(
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: (context) async {
                    await deleteItem(itemId: items[index]['id']);
                    setState(() {});
                  },
                ),
              ],
            ),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const Icon(Icons.task),
                title: Text(
                  items[index]['title'],
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    Text(
                      'Description: ${items[index]['description']}',
                      style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Last Updated: ${items[index]['date']}',
                      style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: items[index]['completed'],
                      onChanged: (value) async {
                        print(items[index]['completed']);
                        await updateItem(
                          reqBody: {"title": items[index]['title'], "description": items[index]['description'], "completed": value},
                          itemId: items[index]['id'],
                        );
                        setState(() {
                          items[index]['completed'] = value;
                        });
                      },
                    ),
                    InkWell(
                      onTap: () {
                        _displayTextInputDialog(context: context, isUpdate: true, item: items[index]);
                        setState(() {});
                      },
                      child: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _displayTextInputDialog({required BuildContext context, bool isUpdate = false, var item}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add To-Do'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: _todoTitle,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: _todoDesc,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (isUpdate) {
                    var reqBody = {"title": _todoTitle.text, "description": _todoDesc.text, "completed": item['completed']};
                    await updateItem(reqBody: reqBody, itemId: item['id']);
                  } else {
                    await addTodo();
                  }
                  setState(() {
                    _todoTitle.text = '';
                    _todoDesc.text = '';
                  });
                  Navigator.of(context).pop();
                },
                child: Text(isUpdate ? "Update" : "Add"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserIcon() {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).openEndDrawer();
        setState(() {

        });
      },
      child: const Icon(
        Icons.account_circle,
        size: 30.0,
        color: Colors.white,
      ),
    );
  }


  Future<void> addTodo() async {
    if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
      var reqBody = {"title": _todoTitle.text, "description": _todoDesc.text};

      bool success = await GlobalData.toDoRepository.addTodo(reqBody);
      if (success) {
        items = await GlobalData.toDoRepository.getTodoList(order: sortOrder == 'Last Updated' ? 'DESC' : 'ASC');
      } else {
        if (kDebugMode) {
          print("Something went wrong!");
        }
      }
    }
  }

  Future<void> deleteItem({int? itemId}) async {
    bool success = await GlobalData.toDoRepository.deleteItem(itemId: itemId);
    if (success) {
      items = await GlobalData.toDoRepository.getTodoList(order: sortOrder == 'Last Updated' ? 'DESC' : 'ASC');
    }
  }

  Future<void> updateItem({var reqBody, int? itemId}) async {
    bool success = await GlobalData.toDoRepository.updateItem(itemId: itemId, reqBody: reqBody);
    if (success) {
      items = await GlobalData.toDoRepository.getTodoList(order: sortOrder == 'Last Updated' ? 'DESC' : 'ASC', isCompleted: filterValue == 'All'? null: filterValue == 'Completed');
    } else {
      if (kDebugMode) {
        print("Something went wrong!");
      }
    }
  }
}
