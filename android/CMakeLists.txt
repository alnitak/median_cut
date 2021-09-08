cmake_minimum_required(VERSION 3.4.1)

message(${ANDROID_ABI})

add_library( 
		# Sets the name of the library.
        median_cut

        # Sets the library as a shared library.
        SHARED

        # Provides a relative path to your source file(s).
        cpp/median_cut.cpp
        cpp/algo.cpp
)


# Searches for a specified prebuilt library and stores the path as a
# variable. Because CMake includes system libraries in the search path by
# default, you only need to specify the name of the public NDK library
# you want to add. CMake verifies that the library exists before
# completing its build.

find_library( 
			  # Sets the name of the path variable.
              log-lib

              # Specifies the name of the NDK library that
              # you want CMake to locate.
              log)


# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in this
# build script, prebuilt third-party libraries, or system libraries.

target_link_libraries(
        # Specifies the target library.
        median_cut

       # Links the target library to the log library
       # included in the NDK.
       ${log-lib}

       android
)

