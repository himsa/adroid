import 'package:adroid/features/historical/presentation/bloc/historical_bloc.dart';
import 'package:adroid/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoricalPage extends StatelessWidget {
  const HistoricalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historical')),
      body: buildBody(),
    );
  }

  BlocProvider<HistoricalBloc> buildBody() {
    return BlocProvider(
      create: (_) => sl<HistoricalBloc>()..add(GetHistoricalEvent()),
      child: BlocBuilder<HistoricalBloc, HistoricalState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case HistoricalLoading:
              return const Center(child: CircularProgressIndicator());
            case HistoricalLoaded:
              var item = state as HistoricalLoaded;
              var list = item.historical.historicalData ?? [];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.historical.symbol ?? '',
                      style: const TextStyle(fontSize: 30),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          var itemList = list[index];
                          return ListTile(
                            title: Text(itemList.label ?? ''),
                            subtitle: Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                Text('open: ${itemList.open}'),
                                Text('high: ${itemList.high}'),
                                Text('low: ${itemList.low}'),
                                Text('close: ${itemList.close}'),
                                Text('adjClose: ${itemList.adjClose}'),
                                Text('volume: ${itemList.volume}'),
                                Text(
                                    'unadjustedVolume: ${itemList.unadjustedVolume}'),
                                Text('change: ${itemList.change}'),
                                Text(
                                    'changePercent: ${itemList.changePercent}%'),
                                Text('vwap: ${itemList.vwap}'),
                                Text(
                                    'changeOverTime: ${itemList.changeOverTime}'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}
