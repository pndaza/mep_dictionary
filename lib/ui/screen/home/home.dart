import 'package:flutter/material.dart';
import 'package:mep_dictionary/business_logic/view_models/definition_list_view_model.dart';
import 'package:mep_dictionary/ui/screen/home/widgets/definition_list_view.dart';
import 'package:mep_dictionary/ui/screen/home/widgets/search_bar.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var vm;

  @override
  void initState() {
    super.initState();
    Provider.of<DefinitionListViewModel>(context, listen: false)
        .fetchAllDefinitions();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DefinitionListViewModel>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('ဦးဟုတ်စိန် အဘိဓာန်')),
          actions: [
            CycleThemeIconButton(),
            infoButton(),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _buildMainUI(vm)),
            SearchBar(
                onChanged: (filterWord, searchAtStart) =>
                    vm.filterDefinitions(filterWord, searchAtStart)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainUI(DefinitionListViewModel vm) {
    if (vm.definitions == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (vm.definitions.isEmpty) {
      return Center(
        child: Text('ပုဒ်မရှိပါ'),
      );
    } else {
      return DefinitionListView(definitions: vm.definitions);
    }
  }

  Widget infoButton() {
    return IconButton(icon: Icon(Icons.info), onPressed: _showInfoDialog);
  }

  Future<void> _showInfoDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('သိမှတ်ဖွယ်')),
          content: SingleChildScrollView(child: Text('''
            ဦးဟုတ်စိန် ရေးသားပြုစုသော အများသုံး မြန်မာ-အင်္ဂလိပ်-ပါဠိ အဘိဓာန်ကို အလွယ်တကူ ကြည့်ရှုနိုင်ရန်အတွက် ရေးသားထားပါသည်။
            ဒစ်ဂျစ်တယ်စနစ်သို့ ပြောင်းထားသော (စာစီထားသော) အချက်အလက်များကို စိန်ရတနာမှ ထုတ်ဝေသော ၎င်း IOS App မှ ရယူထားပါသည်။ (ခွင့်ပြုရန် ဤနေရာမှပင် တောင်းပန်ပါသည်။)
            ဤအဘိဓာန်ကျမ်းသည် စာမျက်အားဖြင့် (၁၀၀၀) ကျော်ရှိပြီး တည်ပုဒ်အရေအတွက် (၇၀၀၀၀) ကျော်ရှိပါသည်။
            ယခု App ၌ကား အချက်အလက်များ မစုံသေးပါ။ စာမျက်နှာ ၃၀၀ ကျော်ရှိ အချက်အလက်များ ထည့်သွင်းဖို့ ကျန်နေပါသေးသည်။ 
            မြန်မာ-အင်္ဂလိပ်-ပါဠိ ရှာလိုရာဖြင့် ရှာနိုင်ပါသည် (ယူနီကုဒ်သာ)။
            “အစတူ“ ဟူသောခလုပ်လေးကို အပြန်အလှန် နှိပ်ကာ ‘အစတူသောပုဒ်တို့ကိုသာရှာမည်‘ ‘နေရာမရွေးရှာမည်‘ ဟူ၍ ရွေးချယ်နိုင်ပါသည်။
            ''')),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
