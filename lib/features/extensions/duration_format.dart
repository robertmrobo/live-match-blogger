extension DurationFormat on Duration {

  String toHHMMSS() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours == 0) {
      return '$minutes:$seconds';
    }

    final hoursStr = hours.toString().padLeft(2, '0');
    return '$hoursStr:$minutes:$seconds';
  }
}
