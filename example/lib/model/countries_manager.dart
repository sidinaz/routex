import 'package:rxdart/rxdart.dart';

import 'country.dart';

class CountriesViewModel {
  CompositeSubscription compositeSubscription = CompositeSubscription();
  final List<CountryPresentation> _allCountries;
  final Observable<List<CountryPresentation>> _filteredCountries;
  final BehaviorSubject<List<CountryPresentation>> _filteredCountriesSubject = BehaviorSubject();
  final SelectionMode selectionMode;
  // ignore: close_sinks
  final BehaviorSubject<bool> hasSelection = BehaviorSubject.seeded(false);
  final BehaviorSubject<List<CountryPresentation>> selectedCountries = BehaviorSubject
    .seeded([]);

  Observable<List<CountryPresentation>> get countries =>
    _filteredCountriesSubject;

  CountriesViewModel(Observable<String> searchTerm,
    List<CountryPresentation> countries,
    this.selectionMode)
    : _allCountries = countries,
      _filteredCountries = searchTerm
        .distinct()
        .map((term) =>
        countries
          .where((c) => c.name.toLowerCase().startsWith(term.toLowerCase()))
          .toList())
        .share();

  void start() {
    var subscription = _filteredCountries
      .listen((items) => _filteredCountriesSubject.value = items);
    var subscription2 = _filteredCountriesSubject
      .map((cts) => cts.where((c) => c.isSelected).toList())
      .listen((hs) => selectedCountries.value = hs);
    var subscription3 = selectedCountries
      .map((cts) => cts.length > 0)
      .listen((hs) => hasSelection.value = hs);
    compositeSubscription.add(subscription);
    compositeSubscription.add(subscription2);
    compositeSubscription.add(subscription3);
  }

  void handleSelection({bool clearAll = false, CountryPresentation model}) {
    if (selectionMode == SelectionMode.single) {
      _allCountries.forEach((c) => c.setIsSelected(false));
      model.setIsSelected(true);
    }
    if (selectionMode == SelectionMode.multiSelect) {
      model.setIsSelected();
    }
    if (clearAll) _allCountries.forEach((c) => c.setIsSelected(false));

    //subject is unaware of in memory changes of data that it is referencing to, so we repush same reference to the stream
    _filteredCountriesSubject.value = _filteredCountriesSubject.value;
  }

  void dispose() {
    compositeSubscription = CompositeSubscription();
  }
}

enum SelectionMode { single, multiSelect }

class CountriesSink {
  // ignore: close_sinks
  final term = BehaviorSubject<String>.seeded("");

  void setTerm(String value) {
    term.sink.add(value);
  }
}

class CountriesManager {
  final CountriesViewModel viewModel;
  final CountriesSink sink;

  CountriesManager(this.sink, this.viewModel);
}
