/*
 * EEPROM.h
 *
 * Created: 7/05/2024 19:10:46
 *  Author: jaidy
 */ 


#ifndef EEPROM_H_
#define EEPROM_H_

#include <avr/io.h>
#include <stdint.h>

void EEPROM_write(unsigned int uiAddress, unsigned char ucData);

unsigned char EEPROM_read(unsigned int uiAddress);

#endif /* EEPROM_H_ */