
### Prereqs (Windows)
1) Install Android Studio + SDK; ensure NDK r26.1 is installed.
2) Set user env vars (one-time):
   setx ANDROID_NDK "C:\Users\<YOU>\AppData\Local\Android\Sdk\ndk\26.1.10909125"
   setx ANDROID_NDK_HOME "C:\Users\<YOU>\AppData\Local\Android\Sdk\ndk\26.1.10909125"
   setx ANDROID_NDK_ROOT "C:\Users\<YOU>\AppData\Local\Android\Sdk\ndk\26.1.10909125"
3) Restart Android Studio.
4) Clone repo, update submodules, open the project, and click “Sync Project with Gradle Files”.
5) Build → Make Project; Run on an emulator.

# After cloning
git submodule update --init --recursive
git config --local submodule.recurse true