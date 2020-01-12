import 'package:flutter/material.dart';

class ListTodo extends StatelessWidget {
  final _controller = TextEditingController();
  final id;
  final content;
  final done;
  final delete;
  final setState;
  final update;
  ListTodo(this.id, this.content, this.done, this.setState, this.update,
      this.delete);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0),
      child: new Card(
        color: Colors.blue[100],
        child: ListTile(
          leading: FlatButton(
              onPressed: () => this.setState(this.id),
              child: this.getIcon(this.done)),
          title: Text(
            this.content,
            style: TextStyle(fontSize: 22),
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      this.content,
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    content: Container(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          TextField(
                            controller: _controller..text = this.content,
                          ),
                          FlatButton.icon(
                              onPressed: () async {
                                final content = _controller.text;
                                await this.update(this.id, content);
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.edit),
                              label: Text(
                                "Edit",
                                style: TextStyle(fontSize: 22),
                              ))
                        ],
                      ),
                    ),
                  );
                });
          },
          trailing: FlatButton(
              onPressed: () => this.delete(this.id),
              child: Icon(Icons.delete_forever)),
        ),
      ),
    );
  }

  getIcon(bool status) {
    if (status) {
      return Icon(Icons.done);
    }
    return Icon(Icons.crop_din);
  }
}
