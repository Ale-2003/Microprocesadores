/*
 * PWM2.c
 *
 * Created: 17/04/2024 16:12:22
 *  Author: jaidy
 */ 
#include "PWM2.h"

float map1(float x, float in_min, float in_max, float out_min, float out_max){
	return ((x - in_min)*(out_max - out_min)/(in_max - in_min)) + out_min;
}

void initPWM2A(uint8_t inverted, uint16_t prescaler){
	DDRB |= (1 << DDB3); //PD6 COMO SALIDA
	TCCR2A |= (1 << WGM21)|(1 << WGM20); //PWM MODO FAST
	
	if (inverted) {
		TCCR2A |= (1 << COM2A1)|(1 << COM2A0);//PWM INVERTIDO
		} else	 {
		TCCR2A |= (1 << COM2A1);//PWM NO INVERTIDO
	}

	if (prescaler == 1024) {
		TCCR2B |= (1 << CS22)|(1 << CS21)|(1 << CS20);
		} else {
		TCCR2B |= (1 << CS20);
	}
}

void initPWM2B(uint8_t inverted, uint16_t prescaler){
	DDRD |= (1 << DDD3); //PD6 COMO SALIDA
	TCCR2A |= (1 << WGM21)|(1 << WGM20); //PWM MODO FAST
	
	if (inverted) {
		TCCR2A |= (1 << COM2A1)|(1 << COM2A0);//PWM INVERTIDO
		} else	 {
		TCCR2A |= (1 << COM2A1);//PWM NO INVERTIDO
	}

	if (prescaler == 1024) {
		TCCR2B |= (1 << CS22)|(1 << CS21)|(1 << CS20);
		} else {
		TCCR2B |= (1 << CS20);
	}
}

void updateDutyCA2(uint8_t duty){
	OCR2A = duty;
}

void updateDutyCB2(uint8_t duty){
	OCR2B = duty;
}
