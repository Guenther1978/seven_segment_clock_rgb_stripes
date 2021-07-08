/**
   @file
   @brief DCF polling
*/

int dcf77 = A2;
int pulse_prev;
unsigned long time_falling;
unsigned long time_rising;
String bits;
int seconds;
int minutes;
int hours;
int day;
int day_of_week;
int month;
int year;

boolean paraty(String str, char parity_bit)
{
  unsigned int i;
  int sum = 0;
  for (i = 0; i < str.length(); i++)
  {
    if (str[i] == '1')
    {
      sum += 1;
    }
  }
  return ((sum & 1) + 0x30 == parity_bit);
}

boolean verify(String str)
{
  if (str.length() != 59)
  {
    return false;
  }
  if (str[20] != '1')
  {
    return false;
  }
  if (paraty(str.substring(21, 28), str[28]) == false)
  {
    return false;
  }
  if (paraty(str.substring(29, 35), str[35]) == false)
  {
    return false;
  }
  if (paraty(str.substring(36, 58), str[58]) == false)
  {
    return false;
  }
  return true;
}

int decode_bcd(String str)
{
  unsigned int i;
  int power_of_two;
  int result = 0;
  int power_of_ten = 1;
  for (i = 0; i < str.length(); i ++)
  {
    power_of_two = 1 << (i & 0x3);
    result += (str[i] - '0') * power_of_two * power_of_ten;
    if (power_of_two == 8)
    {
      power_of_ten *= 10;
    }
  }
  return result;
}

boolean decode_time(String &str)
{
  if (verify(str) == false)
  {
    return false;
  }
  minutes = decode_bcd(bits.substring(21, 28));
  hours = decode_bcd(bits.substring(29, 35));
  day = decode_bcd(bits.substring(36, 42));
  day_of_week = decode_bcd(bits.substring(42, 45));
  month = decode_bcd(bits.substring(45, 50));
  year = decode_bcd(bits.substring(51, 58));
  return true;
}

void setup()
{
  Serial.begin(9600);
  pinMode(dcf77, INPUT_PULLUP);
  pulse_prev = digitalRead(dcf77);
  time_falling = millis();
  time_rising = millis();
}

void loop()
{
  unsigned long time = millis();
  unsigned long dt = 0;
  int pulse = digitalRead(dcf77);

  if (pulse == 1 && pulse_prev == 0)
  {
    time_rising = time;
    dt = time_rising - time_falling;
  }
  else if (pulse == 0 && pulse_prev == 1)
  {
    time_falling = time;
    dt = time_falling - time_rising;
  }
  pulse_prev = pulse;

  if (dt > 80)
  {
    if (dt < 120)
    {
      bits += '0';
    }
    else if (dt >= 120 && dt < 250)
    {
      bits += '1';
    }
    else if (dt > 1000)
    {
      Serial.println();
      if (decode_time(bits) == true)
      {
        Serial.print(hours);
        Serial.print(':');
        if (minutes < 10)
        {
          Serial.print('0');
        }
        Serial.print(minutes);
        Serial.println();
        Serial.println("minutes_one");
        Serial.println(bits[21]);
        Serial.println(bits[22]);
        Serial.println(bits[23]);
        Serial.println(bits[24]);
        Serial.println("minutes_ten");
        Serial.println(bits[25]);
        Serial.println(bits[26]);
        Serial.println(bits[27]);
        Serial.println("hours_one");
        Serial.println(bits[29]);
        Serial.println(bits[30]);
        Serial.println(bits[31]);
        Serial.println(bits[32]);
        Serial.println("hours_ten");
        Serial.println(bits[33]);
        Serial.println(bits[34]);
      }
      bits = "";
      seconds = 0;
    }
  }
}
