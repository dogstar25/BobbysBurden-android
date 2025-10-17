1  #include <memory>
2  #include <iostream>
3  #include "MobyDick.h"
4  #include "BBGame.h"
5  #include "BBContactHandler.h"
6  #include "BBContactFilter.h"
7  #include "BBComponentFactory.h"
8  #include "triggers/BBTriggerFactory.h"
9  #include "cutScenes/BBCutSceneFactory.h"
10  #include "actions/BBActionFactory.h"
11  #include "IMGui/BB_IMGuiFactory.h"
12  #include "particleEffects/BBParticleEffectsFactory.h"
13  #include "puzzles/BBPuzzleFactory.h"
14  #include "BBContextManager.h"
15  #include "BBGameStateManager.h"
16  #include "BBNavigationManager.h"
17  #include "BBEnumMap.h"
18  #include "BBColorMap.h"
19  #include "EnvironmentEvents/BBEnvironmentEventFactory.h"
20
21  static std::unique_ptr<Game> game;
22
23  extern "C" int SDL_main(int argc, char* argv[])
24  {
25      game = std::make_unique<BBGame>();
26
27      std::cout << "Bobby's Ghost Adventure Begins (Android)\n";
28
29      game->init(
30          std::make_shared<BBContactHandler>(),
31          std::make_shared<BBContactFilter>(),
32          std::make_shared<BBComponentFactory>(),
33          std::make_shared<BBActionFactory>(),
34          std::make_shared<BBParticleEffectsFactory>(),
35          std::make_shared<BBCutSceneFactory>(),
36          std::make_shared<BB_IMGuiFactory>(),
37          std::make_shared<BBTriggerFactory>(),
38          std::make_shared<BBPuzzleFactory>(),
39          std::make_shared<BBEnvironmentEventFactory>(),
40          std::make_shared<BBContextManager>(),
41          std::make_shared<BBGameStateManager>(),
42          std::make_shared<BBNavigationManager>(),
43          std::make_shared<BBEnumMap>(),
44          std::make_shared<BBColorMap>()
45      );
46
47      game->play();
48      return 0;
49  }
