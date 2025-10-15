#include "MobyDick.h"
#include "BBGame.h"
#include "BBContactHandler.h"
#include "BBContactFilter.h"
#include "BBComponentFactory.h"
#include "triggers/BBTriggerFactory.h"
#include "cutScenes/BBCutSceneFactory.h"
#include "actions/BBActionFactory.h"
#include "IMGui/BB_IMGuiFactory.h"
#include "particleEffects/BBParticleEffectsFactory.h"
#include "puzzles/BBPuzzleFactory.h"
#include "BBContextManager.h"
#include "BBGameStateManager.h"
#include "BBNavigationManager.h"
#include "BBEnumMap.h"
#include "BBColorMap.h"
#include <wtypes.h>
#include "EnvironmentEvents/BBEnvironmentEventFactory.h"

std::unique_ptr<Game> game;

//int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, char*, int nShowCmd)
int main(int argc, char* argv[])
{

	game = std::make_unique<BBGame>();

	std::cout << "Bobby's Ghost Adventure Begins\n";

	game->init(
		std::make_shared<BBContactHandler>(), 
		std::make_shared<BBContactFilter>(),
		std::make_shared<BBComponentFactory>(),
		std::make_shared<BBActionFactory>(),
		std::make_shared<BBParticleEffectsFactory>(),
		std::make_shared<BBCutSceneFactory>(),
		std::make_shared<BB_IMGuiFactory>(),
		std::make_shared<BBTriggerFactory>(),
		std::make_shared<BBPuzzleFactory>(),
		std::make_shared<BBEnvironmentEventFactory>(),
		std::make_shared<BBContextManager>(),
		std::make_shared<BBGameStateManager>(),
		std::make_shared<BBNavigationManager>(),
		std::make_shared<BBEnumMap>(),
		std::make_shared<BBColorMap>()
	);

	game->play();

	return 0;
}