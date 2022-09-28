// Copyright Epic Games, Inc. All Rights Reserved.

#include "WizardWoes00GameMode.h"
#include "WizardWoes00Character.h"

AWizardWoes00GameMode::AWizardWoes00GameMode()
{
	// Set default pawn class to our character
	DefaultPawnClass = AWizardWoes00Character::StaticClass();	
}
