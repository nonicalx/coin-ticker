import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'services/request_processor.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  RequestProcessor processor = new RequestProcessor();
  String selectedCurrency = currenciesList[0];
  @override
  void initState() {
    super.initState();
    getExchangeRates(selectedCurrency);
  }

  Map exchangeRates;
  void getExchangeRates(String currency) async {
    var btcRate = await processor.getData(
        url:
            'https://rest.coinapi.io/v1/exchangerate/BTC/$currency?apikey=DE8F6301-EC24-433B-8725-88F860B7364D');
    var ethRate = await processor.getData(
        url:
            'https://rest.coinapi.io/v1/exchangerate/ETH/$currency?apikey=DE8F6301-EC24-433B-8725-88F860B7364D');
    var ltcRate = await processor.getData(
        url:
            'https://rest.coinapi.io/v1/exchangerate/LTC/$currency?apikey=DE8F6301-EC24-433B-8725-88F860B7364D');
    print(btcRate);
    setState(() {
      exchangeRates = {
        'btcRate': btcRate['rate'] ?? '?',
        'ethRate': ethRate['rate'] ?? '?',
        'ltcRate': ltcRate['rate'] ?? '?'
      };
    });

    print('exchange $exchangeRates');
  }

  List<DropdownMenuItem> getAllCurrency() {
    List<DropdownMenuItem<String>> currencies = [];
    for (var currency in currenciesList) {
      if (currency != null) {
        currencies
            .add(DropdownMenuItem(child: Text(currency), value: currency));
      }
    }
    return currencies;
  }

  List<Widget> getAllCurrenciesForCupertino() {
    List<Widget> currencies = [];
    for (var currency in currenciesList) {
      currencies.add(Text(currency, style: TextStyle(color: Colors.white)));
    }
    return currencies;
  }

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> currencies = [];
    for (var currency in currenciesList) {
      if (currency != null) {
        currencies
            .add(DropdownMenuItem(child: Text(currency), value: currency));
      }
    }
    return DropdownButton<String>(
      items: currencies,
      onChanged: (value) {
        setState(() {
          getExchangeRates(value);
          selectedCurrency = value;
        });
      },
      value: selectedCurrency,
    );
  }

  Widget getCupertinoPicker() {
    List<Widget> currencies = [];
    for (var currency in currenciesList) {
      currencies.add(Text(currency, style: TextStyle(color: Colors.white)));
    }
    return CupertinoPicker(
      children: currencies,
      itemExtent: 40,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (value) {
        print(value);
      },
    );
  }

  Widget getPicker() {
    if (Platform.isAndroid) {
      return getDropdownButton();
    } else if (Platform.isIOS) {
      return getCupertinoPicker();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RateCapsule(
                  coin: 'BTC',
                  exchangeRates: exchangeRates['btcRate'],
                  selectedCurrency: selectedCurrency),
              RateCapsule(
                  coin: "ETH",
                  exchangeRates: exchangeRates['ethRate'],
                  selectedCurrency: selectedCurrency),
              RateCapsule(
                  coin: "LTC",
                  exchangeRates: exchangeRates['ltcRate'],
                  selectedCurrency: selectedCurrency),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class RateCapsule extends StatelessWidget {
  const RateCapsule(
      {@required this.exchangeRates,
      @required this.selectedCurrency,
      @required this.coin});

  final double exchangeRates;
  final String selectedCurrency;
  final String coin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coin = ${exchangeRates.toStringAsFixed(2)} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
