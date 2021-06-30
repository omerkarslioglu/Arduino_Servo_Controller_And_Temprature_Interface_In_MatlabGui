# Arduino_Servo_Controller_And_Temprature_Interface_In_MatlabGui
This project is an interface communicating with arduino design in Matlab Gui .

Purpose : turning the potentiometer tip with a servo motor from the interface I designed in Matlab GUI , making analog measurements over the circuit we will design from the potentiometer and getting data with the temperature sensor .
One of the main purposes is to design a program that simultaneously displays this information on graphs and records these values .

Ciruit Information : I used NPN type transistor to read analog data from potentiometer. My preferred transistor is BC337. The analog voltage difference path formed by the potentiometer is connected to the base leg of the transistor with a 10KOhm resistor. The Emitter part of the transistor is connected to
the GND line with 10KOhm. It is connected serially to the A1 pin in order to
make analog reading with the arduino from the collector leg. The first leg of the temperature sensor is connected to the +5 volt line and the third leg
is connected to the gnd line . Analog reading was taken from the middle leg
of the temperature sensor lm35 .
