/*
 *  bank.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef BANK_H
#define BANK_H

#include <iostream>
#include <string>
using namespace std;
 
class Bank{
 
public:
 
	Bank(){
	
		buffer=NULL;
		size=0;
	
	};

	~Bank(){
	}
	
	char* buffer;
	int size;

	static Bank* CreateBank(int size);
	static Bank* LoadBank(string filename);
	static void CopyBank(Bank* src_bank,int src_offset,Bank* des_bank,int des_offset,int count);
	void FreeBank();
	void ResizeBank(int size);
	int BankSize();
	void PokeByte(int offset,char c);
	void PokeShort(int offset,short s);
	void PokeInt(int offset,int i);
	void PokeFloat(int offset,float f);
	void PokeLong(int offset,long l);
	void PokeString(int offset,string s);
	char PeekByte(int offset);
	short PeekShort(int offset);
	int PeekInt(int offset);
	float PeekFloat(int offset);
	long PeekLong(int offset);
	string PeekString(int offset);

};
 
#endif