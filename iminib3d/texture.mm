/*
 *  texture.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "texture.h"

#include "texture_filter.h"
#include "string_helper.h"
#include "file.h"

list<Texture*> Texture::tex_list;

Texture* Texture::LoadTexture(string filename,int flags){
	
	filename=Strip(filename); // get rid of path info

	if(File::ResourceFilePath(filename)==""){
		cout << "Error: Cannot Find Texture: " << filename << endl;
		return NULL;
	}
	
	Texture* tex=new Texture();
	tex->file=filename;

	// set tex.flags before TexInList
	tex->flags=flags;
	tex->FilterFlags();
		
	// check to see if texture with same properties exists already, if so return existing texture
	Texture* old_tex=tex->TexInList();
	if(old_tex){
		return old_tex;
	}else{
		tex_list.push_back(tex);
	}	
		
	string filename_left=Left(filename,Len(filename)-4);
	string filename_right=Right(filename,3);
	
	const char* c_filename_left=filename_left.c_str();
	const char* c_filename_right=filename_right.c_str();
		
	NSString* n_filename_left = [NSString stringWithUTF8String: c_filename_left];
	NSString* n_filename_right = [NSString stringWithUTF8String: c_filename_right];
	
	//tex->texture = [[Texture2D alloc] initWithImage: [UIImage imageNamed:n_filename]]; // ***leak***
	tex->texture = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile :[[NSBundle mainBundle] pathForResource:n_filename_left ofType:n_filename_right]]];
	
	return tex;
	
}

Texture* Texture::CreateTextTexture(string text,int width,int height,int align,string font,int size,int flags){
	
	Texture* tex=new Texture();

	tex->flags=flags;
	tex->FilterFlags();

	const char* c_text=text.c_str();
	NSString* ns_text = [NSString stringWithUTF8String: c_text];
	
	const char* c_font=font.c_str();
	NSString* ns_font = [NSString stringWithUTF8String: c_font];

	tex->texture = [[Texture2D alloc] initWithString:ns_text dimensions:CGSizeMake(width, height) alignment:UITextAlignmentCenter fontName:ns_font fontSize:size];
	
	return tex;
	
}

void Texture::FreeTexture(){

	[texture release];
	
	tex_list.remove(this);
	
	delete this;

}

void Texture::DrawTexture(int x,int y){

	[texture drawAtPoint:CGPointMake(x,y)];

}

void Texture::TextureBlend(int blend_no){
	
	blend=blend_no;
	
}

void Texture::TextureCoords(int coords_no){

	coords=coords_no;

}

void Texture::ScaleTexture(float u_s,float v_s){

	u_scale=1.0/u_s;
	v_scale=1.0/v_s;

}

void Texture::PositionTexture(float u_p,float v_p){

	u_pos=-u_p;
	v_pos=-v_p;

}

void Texture::RotateTexture(float ang){

	angle=ang;

}

/*
Method TextureWidth()

	Return width

End Method

Method TextureHeight()

	Return height

End Method
*/
	
string Texture::TextureName(){

	return file;

}
	
void Texture::ClearTextureFilters(){

	TextureFilter::tex_filter_list.clear();

}

void Texture::AddTextureFilter(string text_match,int flags){

	TextureFilter* filter=new TextureFilter();
	filter->text_match=text_match;
	filter->flags=flags;
	TextureFilter::tex_filter_list.push_back(filter);

}

Texture* Texture::TexInList(){

	// check if tex already exists in list and if so return it
	list<Texture*>::iterator it;
	for(it=tex_list.begin();it!=tex_list.end();it++){
		Texture* tex=*it;
		if(file==tex->file && flags==tex->flags){// && blend==tex->blend){
			//if(u_scale==tex->u_scale && v_scale==tex->v_scale && u_pos==tex->u_pos && v_pos==tex->v_pos && angle==tex->angle){
				return tex;
			//}
		}
	}

	return NULL;

}

void Texture::FilterFlags(){

	// combine specifieds flag with texture filter flags
	list<TextureFilter*>::iterator it;
	for(it=TextureFilter::tex_filter_list.begin();it!=TextureFilter::tex_filter_list.end();it++){
		TextureFilter* filter=*it;
		if(Instr(file,filter->text_match)) flags=flags|filter->flags;
	}

}

// used in LoadTexture, strips path info from filename
string Texture::Strip(string filename){

	string stripped_filename=filename;
	string::size_type idx;
	
	idx=filename.find('/');
	if(idx!=string::npos){
		stripped_filename=filename.substr(filename.rfind('/')+1);
	}
	
	idx=filename.find("\\");
	if(idx!=string::npos){
		stripped_filename=filename.substr(filename.rfind("\\")+1);
	}
	
	return stripped_filename;

}