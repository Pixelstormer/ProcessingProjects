class SliderBuilder{
  private PVector startPoint;
  private PVector endPoint;
  private float lowValue;
  private float highValue;
  private float increment = 0;
  private String flavourText = "";
  private float initialValue;
  
  SliderBuilder(PVector startPoint, PVector endPoint, float lowValue, float highValue){
    this.startPoint = startPoint.get();
    this.endPoint = endPoint.get();
    this.lowValue = lowValue;
    this.highValue = highValue;
    initialValue = lowValue;
  }
  
  SliderBuilder setIncrement(float increment){
    this.increment = increment;
    return this;
  }
  
  SliderBuilder setFlavourText(String flavourText){
    this.flavourText = flavourText;
    return this;
  }
  
  SliderBuilder setInitialValue(float initialValue){
    this.initialValue = initialValue;
    return this;
  }
  
  Slider build(){
    return new Slider(startPoint, endPoint, lowValue, highValue, increment, flavourText, initialValue);
  }
}

