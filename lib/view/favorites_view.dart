// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:weatherreport/model/city_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {
  final List<CityModel> listOfFavoriteCities;
  final ValueSetter<CityModel> updateSelectedCityCallback;
  final ValueSetter<int> changeScreenCallback;

  const FavoritesView(
      {super.key,
      required this.listOfFavoriteCities,
      required this.changeScreenCallback,
      required this.updateSelectedCityCallback});

  @override
  Widget build(BuildContext context) {
    int millisecondsTime = DateTime.now().toUtc().millisecondsSinceEpoch;
    return Container(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: listOfFavoriteCities.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          int millisecondsPlusTimezone = millisecondsTime +
              (listOfFavoriteCities[index].timezone * 1000) as int;
          return InkWell(
            onTap: () {
              setSelectedCityAndChangeScreen(index);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              listOfFavoriteCities[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              "" +
                                  (listOfFavoriteCities[index].state != null
                                      ? (listOfFavoriteCities[index].state)
                                      : ("")) +
                                  listOfFavoriteCities[index].country,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    formatDate(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            millisecondsPlusTimezone),
                                        [HH, ':', nn]),
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    formatDate(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            millisecondsPlusTimezone),
                                        [dd, '/', mm, '/', yyyy]),
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 2),
              ],
            ),
          );
        },
      ),
    );
  }

  setSelectedCityAndChangeScreen(int index) {
    updateSelectedCityCallback(listOfFavoriteCities[index]);
    changeScreenCallback(0);
  }
}
