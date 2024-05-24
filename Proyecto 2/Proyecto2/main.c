/*
 * Proyecto2.c
 *
 * Created: 5/05/2024 10:37:56
 * Author : jaidy
 */ 
// LIBRERIAS
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include "ADC/ADC.h"
#include "PWM/PWM0.h"
#include "PWM/PWM1.h"
#include "PWM/PWM2.h"
#include "UART/UART.h"
#include "EEPROM/EEPROM.h"
#include "PIN_INT/Ext_Int.h"

// VARIABLES
uint8_t WRITE = 0;
uint8_t STATE = 0;
uint8_t NEXT_STATE = 0;
uint8_t READ = 0;
uint8_t NEXT_READ = 0;
int flag = 1;
float V1 = 0;
float V2 = 0;
float V3 = 0;
float V4 = 0;
unsigned char D1 = 0;
unsigned char D2 = 0;
unsigned char D3 = 0;
unsigned char D4 = 0;
volatile char bufferRX;


//FUNCIONES
void Manual(void);
void Cominucacion(void);
void Escritura(void);
void Lectura(void);

int main(void)
{
	cli();
	DDRB = 255;
	DDRD |= (1 << DDD4)|(1 << DDD7);
	initPinChange0(rising_edge);
	initPinChange1(rising_edge);
	initPWM0A(no_invertido, 1024);
	updateDutyCA(22);
	initPWM0B(no_invertido, 1024);
	updateDutyCB(22);
	initPWM1A(no_invertido,8,39999);
	updateDutyCA1(2800);
	initPWM1B(no_invertido,8,39999);
	updateDutyCB1(2800);
	initADC();
	initUART(fast, 9600);
	EEPROM_write(1, (5));
	EEPROM_write(2, (0));
	EEPROM_write(3, (5));
	EEPROM_write(4, (0));
	
	EEPROM_write(5, (0));
	EEPROM_write(6, (5));
	EEPROM_write(7, (5));
	EEPROM_write(8, (0));
	
	EEPROM_write(11, (0));
	EEPROM_write(12, (0));
	EEPROM_write(13, (0));
	EEPROM_write(14, (5));
	READ = 0;
	STATE = 0;
	sei();
    while (1) {	
		//STATE = STATE;	
		switch (STATE){
			case 0: Manual(); NEXT_STATE = 1; break;
			case 1: Cominucacion(); NEXT_STATE = 2; break;
			case 2: Escritura(); NEXT_STATE = 3; break;
			case 3: Lectura(); NEXT_STATE = 0; break;
			default: STATE = 0; break;
		}
			
    }
}

void Manual(void){
	PORTD &=~ (1<< PORTD4);
	PORTD &=~ (1<< PORTD7);
	PORTB &=~ (1<< PORTB0);
	V1 = (ADC_CONVERT(0)/1023.00)*5.00;
	V2 = (ADC_CONVERT(1)/1023.00)*5.00;
	V4 = (ADC_CONVERT(2)/1023.00)*5.00;
	V3 = (ADC_CONVERT(3)/1023.00)*5.00;	
}

void Cominucacion(void){
	PORTD |= (1<< PORTD4);
	PORTD &=~ (1<< PORTD7);
	PORTB &=~ (1<< PORTB0);
	txt_write_UART("\n¿Que deseas hacer?\n");
	/*txt_write_UART("1. Ojos Arriba\n2. Ojos Abajo\n3. Ojos Izquierda\n4. Ojos Derecha\n");
	txt_write_UART("5. Ceja Izquierda Arriba\n6. Ceja Izquierda Abajo\n7. Ceja Derecha Arriba\n8. Ceja Derecha Abajo\n");*/
	while (flag == 0);
	
	switch (bufferRX){
		case '1': updateDutyCA(26); flag = 0; break;
		case '2': updateDutyCA(18); flag = 0; break;
		case '3': updateDutyCB(28); flag = 0; break;
		case '4': updateDutyCB(15); flag = 0; break;
		case '5': updateDutyCA1(3400); flag = 0; break;
		case '6': updateDutyCA1(2200); flag = 0; break;
		case '7': updateDutyCB1(2200); flag = 0; break;
		case '8': updateDutyCB1(3400); flag = 0; break;
		case '9': updateDutyCA(22); updateDutyCB(22); flag = 0; break;
		case 'A': updateDutyCA1(2800); updateDutyCB1(2800); flag = 0; break;
		
		case 'B': READ = 0; Lectura(); flag = 0; break;
		case 'C': READ = 1; Lectura(); flag = 0; break;
		case 'D': READ = 2; Lectura(); flag = 0; break;
		case 'E': READ = 3; Lectura(); flag = 0; break;
		default: flag = 0; break;
	}
}

void Escritura(void){
	PORTD &=~ (1<< PORTD4);
	PORTD |= (1<< PORTD7);
	PORTB &=~ (1<< PORTB0);
	V1 = (ADC_CONVERT(0)/1023.00)*5.00;
	V2 = (ADC_CONVERT(1)/1023.00)*5.00;
	V4 = (ADC_CONVERT(2)/1023.00)*5.00;
	V3 = (ADC_CONVERT(3)/1023.00)*5.00;
}

void Lectura (void){
	PORTD &=~ (1<< PORTD4);
	PORTD &=~ (1<< PORTD7);
	PORTB |= (1<< PORTB0);
	
	if (READ == 0){
		D1 = (EEPROM_read(10));
		D2 = (EEPROM_read(20));
		D3 = (EEPROM_read(30));
		D4 = (EEPROM_read(40));
		NEXT_READ = 1;
	} else if (READ == 1){
		D1 = (EEPROM_read(1));
		D2 = (EEPROM_read(2));
		D3 = (EEPROM_read(3));
		D4 = (EEPROM_read(4));
		NEXT_READ = 2;
	} else if (READ == 2){
		D1 = (EEPROM_read(5));
		D2 = (EEPROM_read(6));
		D3 = (EEPROM_read(7));
		D4 = (EEPROM_read(8));
		NEXT_READ = 3;
	} else if (READ == 3){
		D1 = (EEPROM_read(11));
		D2 = (EEPROM_read(12));
		D3 = (EEPROM_read(13));
		D4 = (EEPROM_read(14));
		NEXT_READ = 0;
	}
	
	///////////////////////////////////////////
	if (D1 > 3.00){
		updateDutyCA(26);
	}else if (D1 < 2.00){//2.3
		updateDutyCA(18);
	}else {updateDutyCA(22);}//21
			
	if (D2 > 3.00){
		updateDutyCB(28);
	}else if (D2 < 2.00){//2.3
		updateDutyCB(15);
	}else {updateDutyCB(22);}
	///////////////////////////////////////////
	if (D3 > 3.00){
		updateDutyCA1(2200);
	}else if (D3 < 2.00){//2.3
		updateDutyCA1(3400);
	}else {updateDutyCA1(2800);}//21
					
	if (D4 > 3.00){
		updateDutyCB1(2200);
	}else if (D4 < 2.00){//2.3
		updateDutyCB1(3400);
	}else {updateDutyCB1(2800);}
	///////////////////////////////////////////*/
}

ISR (ADC_vect){
	///////////////////////////////////////////		
	if (V1 > 2.60){
		updateDutyCA(26);
	}else if (V1 < 2.30){//2.3
		updateDutyCA(18);
	}else {updateDutyCA(22);}//21
	
	if (V2 > 2.60){
		updateDutyCB(28);
	}else if (V2 < 2.30){//2.3
		updateDutyCB(15);
	}else {updateDutyCB(22);}
	///////////////////////////////////////////
	if (V3 > 2.60){
		updateDutyCA1(2200);
	}else if (V3 < 2.30){//2.3
		updateDutyCA1(3400);
	}else {updateDutyCA1(2800);}//21
		
	if (V4 > 2.60){
		updateDutyCB1(2200);
	}else if (V4 < 2.30){//2.3
		updateDutyCB1(3400);
	}else {updateDutyCB1(2800);}
	///////////////////////////////////////////			
	ADCSRA |= (1 << ADIF);	//LIMPIA LA BANDERA
}


ISR (INT0_vect){
	_delay_ms(200);
	if (STATE == 1) {
		flag = 1;
	}
	
	STATE = NEXT_STATE;
}

ISR (INT1_vect){
	_delay_ms(100);
	if (STATE == 2){
		PORTB |= (1<< PORTB3);
		EEPROM_write(10, (V1));
		EEPROM_write(20, (V2));
		EEPROM_write(30, (V3));
		EEPROM_write(40, (V4));
		PORTB &=~ (1<< PORTB3);
	}
	if (STATE == 3)	{
		READ = NEXT_READ; 
	}
}


ISR (USART_RX_vect){
	flag = 1;
	bufferRX = UDR0;	
}