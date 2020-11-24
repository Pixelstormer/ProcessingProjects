class Slider {
  private final PVector startPoint;
  private final PVector endPoint;
  private final float lowValue;
  private final float highValue;
  private final float increment;
  private final String flavourText;
  private float value;

  private Slider(PVector startPoint, PVector endPoint, float lowValue, float highValue, float increment, String flavourText, float initialValue) {
    if (initialValue<lowValue || initialValue>highValue)
      throw new IllegalArgumentException(String.format("Initial value (%s) is outside of possible range (%s, %s).", initialValue, lowValue, highValue));

    if (increment+initialValue > highValue && initialValue-increment < lowValue)
      throw new IllegalArgumentException(String.format("Increment (%s) is too large - slider can only have 1 possible value (%s).", increment, initialValue));

    this.startPoint = startPoint.get();
    this.endPoint = endPoint.get();
    this.lowValue = lowValue;
    this.highValue = highValue;
    this.increment = increment;
    this.flavourText = flavourText;
    value = initialValue;
  }
}

