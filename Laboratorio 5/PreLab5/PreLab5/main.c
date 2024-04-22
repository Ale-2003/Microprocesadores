/* Universidad del Valle de Guatemala
 * IE2023: Programacion de microcontroladores
 * Autor: Alejandra Marcos
 * PreLab5.c
 *
 * Created: 15/04/2024 22:47:45
 * Author : jaidy
 */ 

#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include "PWM/PWM0.h"
#include "PWM/PWM1.h"
#include "PWM/PWM2.h"
#include "ADC/ADC.h"

uint8_t DutyC1 = 0;
uint8_t DutyC2 = 0;
uint8_t DutyC3 = 0;

void setup(void);

int main(void){
	cli();
	TCCR0A = 0;
	TCCR0B = 0;
	TCCR1A = 0;
	TCCR1B = 0;
	TCCR2A = 0;
	TCCR2B = 0;
	initADC();
	initPWM0A(no_invertido,1024);
	initPWM1A(no_invertido,8,39999);
	initPWM2A(no_invertido,1024);
	sei();
    while (1) {//6 = 0°  36 = 180°   21 = 90°
		//_delay_ms(10);
		DutyC1 = ADC_CONVERT(0);
		updateDutyCA1(DutyC1);	
		//_delay_ms(10);	
		DutyC2 = ADC_CONVERT(1);	
		updateDutyCA2(DutyC2);	
		//_delay_ms(10);
		DutyC3 = ADC_CONVERT(2);
		updateDutyCA(DutyC3);
    }
}

void setup (void){
	UCSR0B = 0;		// DESABILITA TX Y RX
	DDRC = 0;		// PUERTO C COMO ENTRADA
}

ISR(ADC_vect){
	ADCSRA |= (1 << ADIF);	//LIMPIA LA BANDERA
}
