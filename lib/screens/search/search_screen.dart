import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/search/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/constants/constants.dart';
import 'package:ecommerce_app/screens/search/search_bar.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchControler = TextEditingController();


  @override
  void dispose() {
    searchControler.dispose();
    super.dispose();
  }

  @override
  void initState() {
    AppBloc.searchBloc.add(OpenScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchBar(searchController: searchControler),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  _buildContent() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is Searching) {
          return Loading();
        }
        if (state is SuggestionLoaded) {
          return _buildSuggestion(state);
        }
        if (state is ResultsLoaded) {
          return _buildResults(state);
        }
        if (state is SearchFailure) {
          return Center(child: Text("Load Failure"));
        }
        return Center(child: Text("Something went wrongs."));
      },
    );
  }

  _buildSuggestion(SuggestionLoaded state) {
    Widget recentSearchWidget = Container();
    Widget hotKeywordsWidget = Container();
    if (state.recentKeywords.length > 0) {
      recentSearchWidget = Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  Translate.of(context)!.translate("recent_search"),
                  style: Theme.of(context).textTheme.headline5,
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<SearchBloc>(context).add(OnClearHistory());
                    },
                    child: Text(
                      Translate.of(context)!.translate("clear"),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).primaryColor
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Wrap(
              children: List.generate(state.recentKeywords.length, (index) {
                return _buildRecentSearchItem(state.recentKeywords[index]);
              }),
            ),
          ],
        ),
      );
    }
    if (state.hotKeywords.length > 0) {
      hotKeywordsWidget = Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Translate.of(context)!.translate("hot_keywords"),
              style: Theme.of(context).textTheme.headline5,
            ),
            Wrap(
              children: List.generate(state.hotKeywords.length, (index) {
                return _buildSuggestionItem(state.hotKeywords[index]);
              }),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [recentSearchWidget, hotKeywordsWidget],
      ),
    );
  }

  _buildResults(ResultsLoaded state) {
    var results = state.results;
    if (results.isNotEmpty) {
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: results.length,
        itemBuilder: (context, index) {
          return AppProductItem(
            product: results[index],
            type: ProductViewType.list,
            onPressed: (item) {
              Navigator.pushNamed(
                context,
                Routes.productDetail,
                arguments: item.id,
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: Theme.of(context).dividerColor,);
        },
      );
    } else {
      return Center(
        child: Image.asset(
          IMAGE_CONST.NOT_FOUND,
          width: 180,
          height: 180,
        ),
      );
    }
  }

  _buildRecentSearchItem(String keyword) {
    return GestureDetector(
      onTap: () {
        searchControler.text = keyword;
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: InputChip(
          label: Text(keyword),
          onDeleted: () {
            BlocProvider.of<SearchBloc>(context).add(OnClearHistory(keyword: keyword));
          },
        ),
      )
    );
  }

  _buildSuggestionItem(String keyword) {
    return GestureDetector(
      onTap: () {
        searchControler.text = keyword;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        margin: EdgeInsets.only(
          top: 8,
          right: 8,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          keyword,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
