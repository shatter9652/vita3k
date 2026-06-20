#include "ios_state.h"
#include "interface.h"

#include <app/functions.h>
#include <config/settings.h>
#include <util/log.h>

#include <SDL3/SDL.h>
#include <SDL3/SDL_main.h>

extern "C" {

void* vita3k_create() {
    // TODO: allocate EmuEnvState
    return nullptr;
}

void vita3k_destroy(void* handle) {
    // TODO: delete EmuEnvState
}

bool vita3k_launch(void* handle, const char* path) {
    LOG_INFO("iOS launch requested: {}", path);
    return false;
}

void vita3k_pause(void* handle, bool paused) {}
void vita3k_stop(void* handle) {}

}
