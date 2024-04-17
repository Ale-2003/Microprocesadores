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
#include "ADC/ADC.h"

uint8_t DutyC1 = 0;
uint8_t DutyC2 = 0;

void setup(void);


int main(void){
	cli();
	
	TCCR0A = 0;
	TCCR0B = 0;
	initADC();
	initPWM0A(no_invertido,1024);
	initPWM0B(no_invertido,1024);
	
	sei();
    while (1) {//6 = 0°  36 = 180°   21 = 90°
		_delay_ms(10);
		DutyC1 = ADC_CONVERT(0);
		
		_delay_ms(10);	
		DutyC2 = ADC_CONVERT(1);			
    }
}

void setup (void){
	UCSR0B = 0;		// DESABILITA TX Y RX
	DDRC = 0;		// PUERTO C COMO ENTRADA
}

ISR (TIMER0_OVF_vect){
	updateDutyCA(DutyC1);
	updateDutyCB(DutyC2);
}

ISR(ADC_vect){
	ADCSRA |= (1 << ADIF);	//LIMPIA LA BANDERA
}

