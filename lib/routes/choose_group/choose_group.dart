import 'package:favourone/bloc/grouppagebloc/group_page_state.dart';
import 'package:favourone/bloc/grouppagebloc/group_page_bloc.dart';
import 'package:favourone/bloc/grouppagebloc/group_page_event.dart';
import 'package:favourone/routes/choose_group/create_group_page.dart';
import 'package:favourone/routes/choose_group/my_group_page.dart';
import 'package:favourone/routes/choose_group/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseGroup extends StatefulWidget {
  const ChooseGroup({Key? key}) : super(key: key);

  @override
  State<ChooseGroup> createState() => _ChooseGroupState();
}

class _ChooseGroupState extends State<ChooseGroup> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Attendance group overview")),
      bottomNavigationBar: BlocBuilder<GroupPageBloc, GroupPageState>(
        builder: (context, state) {
          int index = 0;
          if (state is GroupPageSearchState){
            index = 0;
          }
          else if (state is GroupPageMyGroupState){
            index = 1;
          }
          else if (state is GroupPageCreateGroupState){
            index = 2;
          }
          else {
            index = 0;
          }
          return BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                currentIndex: index,
                onTap: (int index) => context.read<GroupPageBloc>().add(GroupPageChangeIndexEvent(index)),
                selectedItemColor: Colors.limeAccent,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    backgroundColor: Colors.red,
                    label: "Search for groups",
                  ),

                  BottomNavigationBarItem(
                      icon: Icon(Icons.my_library_books),
                      backgroundColor: Colors.blueAccent,
                      label: "My groups"
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    backgroundColor: Colors.green,
                    label: "Create group",
                  )
                ]);
        }
      ),

      body: BlocBuilder<GroupPageBloc, GroupPageState>(
        builder: (context, state){
          if (state is GroupPageSearchState){
            return const SearchPage();
          }
          else if (state is GroupPageMyGroupState){
            return const MyGroup();
          }
          else if (state is GroupPageCreateGroupState){
            return const CreateGroupPage();
          }
          else {
            return const SearchPage();
          }
        },
      ),
    );
  }
}

