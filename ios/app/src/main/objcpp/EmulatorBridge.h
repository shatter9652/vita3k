#pragma once
#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

void* vita3k_create();
void vita3k_destroy(void* handle);
bool vita3k_launch(void* handle, const char* path);
void vita3k_pause(void* handle, bool paused);
void vita3k_stop(void* handle);

#ifdef __cplusplus
}
#endif
