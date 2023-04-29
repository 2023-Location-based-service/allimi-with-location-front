import 'package:flutter/material.dart';

class PeopleManagementPage extends StatefulWidget {
  const PeopleManagementPage({Key? key}) : super(key: key);

  @override
  State<PeopleManagementPage> createState() => _PeopleManagementPageState();
}

class _PeopleManagementPageState extends State<PeopleManagementPage> with TickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,  //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('직원 관리')),
      body: TabTab()
    );
  }
  Widget TabTab() {
    return Column(
      children: [
        Container(
          child: TabBar(
            tabs: [
              Container(
                height: 65,
                alignment: Alignment.center,
                child: Text(
                  '승인 완료',
                ),
              ),
              Container(
                height: 65,
                alignment: Alignment.center,
                child: Text(
                  '승인 대기',
                ),
              ),
            ],
            labelColor: Colors.green,
            labelStyle: TextStyle(
              fontSize: 16,
            ),
            indicatorColor: Colors.green,
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: TextStyle(
              fontSize: 16
            ),
            controller: _tabController,
            indicatorWeight: 5,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                color: Colors.white,
                child: approveComplete()
              ),
              Container(
                color: Colors.white,
                child: approveWaiting()
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  //승인완료
  Widget approveComplete(){
    return ListView(
      children: [
        peopleInfomation(),
        peopleInfomation(),
        peopleInfomation(),
        peopleInfomation(),
        peopleInfomation(),
        peopleInfomation(),
        peopleInfomation(),
        peopleInfomation(),
        peopleInfomation(),
        peopleInfomation(),
        peopleInfomation(),
        peopleInfomation(),
      ],
    );
  }
  Widget peopleInfomation(){
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10),
      child: ListTile(
          title: Text('직원들'),
          leading: Icon(Icons.person_rounded, color: Colors.grey),
          onTap: () {
            //pageAnimation(context, myProfile());
          }
      ),
    );
  }
  
  //승인대기
  Widget approveWaiting(){
    return ListView(
      children: [
        peopleApprove(),
        peopleApprove(),
        peopleApprove(),
        peopleApprove(),
        peopleApprove(),
        peopleApprove(),
        peopleApprove(),
        peopleApprove(),
        peopleApprove(),
        peopleApprove(),
      ],
    );
  }
  Widget peopleApprove(){
    return Container(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Row(
        children: [
          Icon(Icons.person_rounded, color: Colors.grey),
          SizedBox(width: 30,),
          Text(
              '직원들',
              style: TextStyle(
                  fontSize: 16
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(3),
            child: OutlinedButton(
                onPressed: (){
                  //승인
                },
                child: Text('승인')
            ),
          ),
          Container(
            padding: EdgeInsets.all(3),
            child: OutlinedButton(
                onPressed: (){
                  //거부
                },
                child: Text('거부')
            ),
          ),
        ],
      ),
    );
  }
  
}