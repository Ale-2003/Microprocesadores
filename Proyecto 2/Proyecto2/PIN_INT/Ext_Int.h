/*
 * Ext_Int.h
 *
 * Created: 5/05/2024 11:59:20
 *  Author: jaidy
 */ 


#ifndef EXT_INT_H_
#define EXT_INT_H_

#include <avr/io.h>
#include <stdint.h>

#define falling_edge 0
#define rising_edge 1

void initPinChange0(uint8_t edge);

void initPinChange1(uint8_t edge);

#endif /* EXT_INT_H_ */