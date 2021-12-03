import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderSelectorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ProviderSelector')),
      body: ChangeNotifierProvider(
        create: (_) => GoodsListProvider(),
        child: Selector<GoodsListProvider, GoodsListProvider>(
          shouldRebuild: (pre, next) => false,
          selector: (context, provider) => provider,
          builder: (context, provider, child) {
            return ListView.builder(
              itemCount: provider.total,
              itemBuilder: (context, index) {
                return Selector<GoodsListProvider, Goods>(
                  selector: (context, provider) => provider.goodsList[index],
                  builder: (context, data, child) {
                    print(('No.${index + 1} rebuild'));

                    return ListTile(
                      title: Text(data.goodsName),
                      trailing: GestureDetector(
                        onTap: () => provider.collect(index),
                        child: Icon(
                            data.isCollection ? Icons.star : Icons.star_border),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class GoodsListProvider with ChangeNotifier {
  List<Goods> _goodsList =
  List.generate(10, (index) => Goods(false, 'Goods No. $index'));

  get goodsList => _goodsList;
  get total => _goodsList.length;

  collect(int index) {
    var good = _goodsList[index];
    _goodsList[index] = Goods(!good.isCollection, good.goodsName);
    notifyListeners();
  }
}

class Goods {
  final bool isCollection;
  final String goodsName;

  Goods(this.isCollection, this.goodsName);
}