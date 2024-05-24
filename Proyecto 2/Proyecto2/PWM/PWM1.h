/*
 * PWM1.h
 *
 * Created: 17/04/2024 10:53:30
 *  Author: jaidy
 */ 


#ifndef PWM1_H_
#define PWM1_H_

#include <avr/io.h>
#include <stdint.h>

#define invertido 1
#define no_invertido 0

float map(float, float, float, float, float);

void initPWM1A(uint8_t inverted, uint16_t prescaler, uint16_t top);

void initPWM1B(uint8_t inverted, uint16_t prescaler, uint16_t top);

void updateDutyCA1(uint16_t duty);

void updateDutyCB1(uint16_t duty);

#endif /* PWM1_H_ */