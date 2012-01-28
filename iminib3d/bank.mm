/*
 *  bank.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "bank.h"

#include "string_helper.h"
#include "file.h"

#include <iostream>
#include <string>
using namespace std;

Bank* Bank::CreateBank(int size){

	Bank* bank=new Bank;
	bank->buffer=(char*)malloc(size);
	
	bank->size=size;

	return bank;
	
}

Bank* Bank::LoadBank(string filename){

	FILE * pFile;
	long lSize;
	size_t result;

	string filename2=File::ResourceFilePath(filename);

	const char* c_filename=filename2.c_str();

	pFile = fopen ( c_filename , "rb" );
	if (pFile==NULL) {fputs ("File error",stderr); exit (1);}

	// obtain file size:
	fseek (pFile , 0 , SEEK_END);
	lSize = ftell (pFile);
	rewind (pFile);

	Bank* bank=new Bank;

	// allocate memory to contain the whole file:
	bank->buffer = (char*) malloc (sizeof(char)*lSize);
	if (bank->buffer == NULL) {fputs ("Memory error",stderr); exit (2);}

	bank->size=int(lSize);

	// copy the file into the buffer:
	result = fread (bank->buffer,1,lSize,pFile);
	if (result != lSize) {fputs ("Reading error",stderr); exit (3);}

	/* the whole file is now loaded in the memory buffer. */

	// terminate
	fclose (pFile);

	return bank;

}

void Bank::CopyBank(Bank* src_bank,int src_offset,Bank* des_bank,int des_offset,int count){

	memmove((char*)des_bank->buffer+des_offset,(char*)src_bank->buffer+src_offset,count);

}

void Bank::FreeBank(){

	free(buffer);
	delete this;
	return;

}

void Bank::ResizeBank(int size){

	buffer=(char*)realloc(buffer,size);
	
	size=size;

}

int Bank::BankSize(){

	return size;
	
}

void Bank::PokeByte(int offset,char c){

	if(offset>=0 && offset<size){

	buffer[offset]=c;
	
	}
	
	return;

}

void Bank::PokeShort(int offset,short s){

	if(offset>=0 && offset<size-1){

	*(reinterpret_cast<short*>(&buffer[offset])) = s;
	
	}
	
	return;

}

void Bank::PokeInt(int offset,int i){

	if(offset>=0 && offset<size-3){

	*(reinterpret_cast<int*>(&buffer[offset])) = i;
	
	}
	
	return;

}

void Bank::PokeFloat(int offset,float f){

	if(offset>=0 && offset<size-3){

	*(reinterpret_cast<float*>(&buffer[offset])) = f;
	
	}
	
	return;

}

void Bank::PokeLong(int offset,long l){

	if(offset>=0 && offset<size-7){

	*(reinterpret_cast<long*>(&buffer[offset])) = l;
	
	}
	
	return;

}

void Bank::PokeString(int offset,string s){
	
	int l=s.length();
	
	if(l>4000) l=4000;

	PokeInt(offset,l);

	for(int i=1;i<=l;i++){
		buffer[offset+3+i]=Asc(Mid(s,i,1));
	}

}

char Bank::PeekByte(int offset){

	if(offset>=0 && offset<size){

	return buffer[offset];
	
	}
	
	return 0;

}

short Bank::PeekShort(int offset){

	if(offset>=0 && offset<size-1){

	return *(reinterpret_cast<short*>(&buffer[offset]));

	}
	
	return 0;

}

int Bank::PeekInt(int offset){

	if(offset>=0 && offset<size-3){

	return *(reinterpret_cast<int*>(&buffer[offset]));
	
	}
	
	return 0;

}

/*
float Bank::PeekFloat(int offset){

	if(offset>=0 && offset<size-3){

	return *(reinterpret_cast<float*>(&buffer[offset]));
	
	}
	
	return 0;

}
*/

float Bank::PeekFloat(int offset){
    if(offset>=0 && offset<size-3){
        float f; char * fb = (char *)&f;
        fb[0] = buffer[offset];
        fb[1] = buffer[offset + 1];
        fb[2] = buffer[offset + 2];
        fb[3] = buffer[offset + 3];
        return f;
        //return *(reinterpret_cast<float*>(&buffer[offset]));
    }
    return 0;
}
 
long Bank::PeekLong(int offset){

	if(offset>=0 && offset<size-7){

	return *(reinterpret_cast<long*>(&buffer[offset]));
	
	}
	
	return 0;

}

string Bank::PeekString(int offset){
	
	string s="";
	
	int l=PeekInt(offset);

	for(int i=1;i<=l;i++){
		s=s+Chr(buffer[offset+3+i]);
	}
	
	return s;

}