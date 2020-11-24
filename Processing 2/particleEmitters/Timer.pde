class Timer {
  //Class for timing things

  //A value associated with time until expiry
  private float lifeTimer;

  //How should the lifeTimer be treated
  //XXXX_MILLIS: Measured in milliseconds
  //XXXX_FRAMES: Measured in frames

  //COUNTDOWN_XXXX: The timer is continually decremented and expires when it reaches 0
  private final int COUNTDOWN_MILLIS = 0;
  private final int COUNTDOWN_FRAMES = 1;
  //STATIC_TIME_XXXX: Expires when a global timer reaches this amount
  private final int STATIC_TIME_MILLIS = 2;
  private final int STATIC_TIME_FRAMES = 3;
}

