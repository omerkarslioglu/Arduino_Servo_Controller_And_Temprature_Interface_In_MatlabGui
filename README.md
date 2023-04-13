# Arduino Servo Controller And Temprature Interface In MatlabGui
This project is an interface communicating with arduino design in Matlab Gui .

![image](https://user-images.githubusercontent.com/67158049/123934325-d9abb800-d99b-11eb-91c7-fe60f2e652a6.png)

Purpose : turning the potentiometer tip with a servo motor from the interface I designed in Matlab GUI , making analog measurements over the circuit we will design from the potentiometer and getting data with the temperature sensor .
One of the main purposes is to design a program that simultaneously displays this information on graphs and records these values .

Ciruit Information : I used NPN type transistor to read analog data from potentiometer. My preferred transistor is BC337. The analog voltage difference path formed by the potentiometer is connected to the base leg of the transistor with a 10KOhm resistor. The Emitter part of the transistor is connected to
the GND line with 10KOhm. It is connected serially to the A1 pin in order to
make analog reading with the arduino from the collector leg. The first leg of the temperature sensor is connected to the +5 volt line and the third leg
is connected to the gnd line . Analog reading was taken from the middle leg
of the temperature sensor lm35 .

![image](https://user-images.githubusercontent.com/67158049/123934429-f1833c00-d99b-11eb-9729-4e6c39213436.png)

Component List :

![image](https://user-images.githubusercontent.com/67158049/123934507-05c73900-d99c-11eb-86da-cab1c0b9d651.png)

Thank you for reading ...
Ömer Karslıoğlu
omerkarsliogluu@gmail.com
