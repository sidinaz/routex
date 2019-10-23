class AtomicInteger {
  int _value = 0;

  int getAndIncrement() => _value++;

  int incrementAndGet() => ++_value;

  int intValue() {
    return _value;
  }

  void set(int newValue) {
    _value = newValue;
  }
}
