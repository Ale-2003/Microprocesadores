/*
 * Ext_Int.c
 *
 * Created: 5/05/2024 12:04:45
 *  Author: jaidy
 */ 
#include "Ext_Int.h"

void initPinChange0(uint8_t edge){
	if (edge){
		EICRA |= (1 << ISC01)|(1<< ISC00);
	}else{
		EICRA |= (1 << ISC01);
	}
	PORTD |= (1 << PORTD2);
	EIMSK |= (1 << INT0);
	DDRD &=~ (1 << DDD2);
}

void initPinChange1(uint8_t edge){
	if (edge){
		EICRA |= (1 << ISC11)|(1<< ISC10);
	}else{
		EICRA |= (1 << ISC11);
	}
	PORTD |= (1 << PORTD3);
	EIMSK |= (1 << INT1);
	DDRD &=~ (1 << DDD3);
}