#pragma once
#include <string>

struct IOSState {
    std::string documents_path;
    std::string cache_path;
};

extern IOSState g_ios_state;