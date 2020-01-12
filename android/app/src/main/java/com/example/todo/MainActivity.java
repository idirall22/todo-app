package com.example.todo;

import android.os.Bundle;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import todo.Task;
import todo.Todo_;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "todo";
  Todo_ todoObj = new todo.Todo_();


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if(methodCall.method.equals("addTask")){
          todoObj.addTask((java.lang.String)methodCall.arguments);
          result.success("Done");
        }else if(methodCall.method.equals("getTasks")){
          List<HashMap<java.lang.String, Object>> tasks = new ArrayList<HashMap<java.lang.String, Object>>();

          while(todoObj.next()){
            HashMap<java.lang.String, Object> obj= new HashMap<java.lang.String, Object>();
            Task task = todoObj.get();

            obj.put("id", task.getID());
            obj.put("content", task.getContent());
            obj.put("done", task.getDone());

            tasks.add(obj);
          }
          result.success(tasks);
        }else if(methodCall.method.equals("deleteTask")){
          todoObj.deleteTask((int)methodCall.arguments);
          result.success("Done");
        }else if(methodCall.method.equals("updateTask")){
          todoObj.updateTask((int)methodCall.arguments, (java.lang.String)methodCall.arguments);
          result.success("Done");
        }else if(methodCall.method.equals("setStatus")){
          todoObj.setTaskStatus((int)methodCall.arguments);
          result.success("Done");
        }
      }
    });
  }
}
