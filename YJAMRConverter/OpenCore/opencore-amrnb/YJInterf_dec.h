//
//  YJInterf_dec.h
//  YJAMRConverter
//
//  Created by 杨警 on 2020/10/15.
//

#ifndef YJInterf_dec_h
#define YJInterf_dec_h

#ifdef __cplusplus
extern "C" {
#endif

void* Decoder_Interface_init(void);
void Decoder_Interface_exit(void* state);
void Decoder_Interface_Decode(void* state, const unsigned char* in, short* out, int bfi);

#ifdef __cplusplus
}
#endif

#endif /* YJInterf_dec_h */
