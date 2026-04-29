import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'product.dart';

class RoomItemsScreen extends StatefulWidget {
  final Box appBox;
  final String roomName;

  const RoomItemsScreen({
    super.key,
    required this.appBox,
    required this.roomName,
  });

  @override
  State<RoomItemsScreen> createState() => _RoomItemsScreenState();
}

class _RoomItemsScreenState extends State<RoomItemsScreen> {
  late List<Product> items;

  String get _key => 'items:${widget.roomName}';

  @override
  void initState() {
    super.initState();
    final saved = widget.appBox.get(_key);
    if (saved is List) {
      items = saved
          .map((e) => Product.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      items = [];
      widget.appBox.put(_key, []);
    }
  }

  void _persist() {
    widget.appBox.put(_key, items.map((e) => e.toMap()).toList());
  }

  void _showAddItemDialog() {
    String name = '';
    int qty = 1;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (v) {
                final n = int.tryParse(v);
                if (n != null && n > 0) qty = n;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (name.trim().isNotEmpty) {
                setState(() {
                  items.add(Product(name: name.trim(), qty: qty));
                });
                _persist();
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    _persist();
  }

  void _incQty(int index) {
    setState(() {
      items[index] = items[index].copyWith(qty: items[index].qty + 1);
    });
    _persist();
  }

  void _decQty(int index) {
    setState(() {
      if (items[index].qty > 1) {
        items[index] = items[index].copyWith(qty: items[index].qty - 1);
      }
    });
    _persist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // רקע
          SizedBox.expand(
            child: Image.asset(
              'assets/images/login_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(color: const Color.fromRGBO(0, 0, 0, 0.5)),

          // תוכן
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.roomName,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'No items yet',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: items.length,
                          itemBuilder: (_, i) {
                            final it = items[i];
                            return Card(
                              color: Colors.white70,
                              child: ListTile(
                                title: Text(it.name),
                                subtitle: Text('Qty: ${it.qty}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () => _decQty(i),
                                      icon: const Icon(Icons.remove),
                                    ),
                                    IconButton(
                                      onPressed: () => _incQty(i),
                                      icon: const Icon(Icons.add),
                                    ),
                                    IconButton(
                                      onPressed: () => _removeItem(i),
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
