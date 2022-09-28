// Copyright Epic Games, Inc. All Rights Reserved.
/*===========================================================================
	Generated code exported from UnrealHeaderTool.
	DO NOT modify this manually! Edit the corresponding .h files instead!
===========================================================================*/

#include "UObject/GeneratedCppIncludes.h"
#include "WizardWoes00/WizardWoes00GameMode.h"
#ifdef _MSC_VER
#pragma warning (push)
#pragma warning (disable : 4883)
#endif
PRAGMA_DISABLE_DEPRECATION_WARNINGS
void EmptyLinkFunctionForGeneratedCodeWizardWoes00GameMode() {}
// Cross Module References
	WIZARDWOES00_API UClass* Z_Construct_UClass_AWizardWoes00GameMode_NoRegister();
	WIZARDWOES00_API UClass* Z_Construct_UClass_AWizardWoes00GameMode();
	ENGINE_API UClass* Z_Construct_UClass_AGameModeBase();
	UPackage* Z_Construct_UPackage__Script_WizardWoes00();
// End Cross Module References
	void AWizardWoes00GameMode::StaticRegisterNativesAWizardWoes00GameMode()
	{
	}
	UClass* Z_Construct_UClass_AWizardWoes00GameMode_NoRegister()
	{
		return AWizardWoes00GameMode::StaticClass();
	}
	struct Z_Construct_UClass_AWizardWoes00GameMode_Statics
	{
		static UObject* (*const DependentSingletons[])();
#if WITH_METADATA
		static const UE4CodeGen_Private::FMetaDataPairParam Class_MetaDataParams[];
#endif
		static const FCppClassTypeInfoStatic StaticCppClassTypeInfo;
		static const UE4CodeGen_Private::FClassParams ClassParams;
	};
	UObject* (*const Z_Construct_UClass_AWizardWoes00GameMode_Statics::DependentSingletons[])() = {
		(UObject* (*)())Z_Construct_UClass_AGameModeBase,
		(UObject* (*)())Z_Construct_UPackage__Script_WizardWoes00,
	};
#if WITH_METADATA
	const UE4CodeGen_Private::FMetaDataPairParam Z_Construct_UClass_AWizardWoes00GameMode_Statics::Class_MetaDataParams[] = {
		{ "Comment", "/**\n * The GameMode defines the game being played. It governs the game rules, scoring, what actors\n * are allowed to exist in this game type, and who may enter the game.\n *\n * This game mode just sets the default pawn to be the MyCharacter asset, which is a subclass of WizardWoes00Character\n */" },
		{ "HideCategories", "Info Rendering MovementReplication Replication Actor Input Movement Collision Rendering Utilities|Transformation" },
		{ "IncludePath", "WizardWoes00GameMode.h" },
		{ "ModuleRelativePath", "WizardWoes00GameMode.h" },
		{ "ShowCategories", "Input|MouseInput Input|TouchInput" },
		{ "ToolTip", "The GameMode defines the game being played. It governs the game rules, scoring, what actors\nare allowed to exist in this game type, and who may enter the game.\n\nThis game mode just sets the default pawn to be the MyCharacter asset, which is a subclass of WizardWoes00Character" },
	};
#endif
	const FCppClassTypeInfoStatic Z_Construct_UClass_AWizardWoes00GameMode_Statics::StaticCppClassTypeInfo = {
		TCppClassTypeTraits<AWizardWoes00GameMode>::IsAbstract,
	};
	const UE4CodeGen_Private::FClassParams Z_Construct_UClass_AWizardWoes00GameMode_Statics::ClassParams = {
		&AWizardWoes00GameMode::StaticClass,
		"Game",
		&StaticCppClassTypeInfo,
		DependentSingletons,
		nullptr,
		nullptr,
		nullptr,
		UE_ARRAY_COUNT(DependentSingletons),
		0,
		0,
		0,
		0x008802ACu,
		METADATA_PARAMS(Z_Construct_UClass_AWizardWoes00GameMode_Statics::Class_MetaDataParams, UE_ARRAY_COUNT(Z_Construct_UClass_AWizardWoes00GameMode_Statics::Class_MetaDataParams))
	};
	UClass* Z_Construct_UClass_AWizardWoes00GameMode()
	{
		static UClass* OuterClass = nullptr;
		if (!OuterClass)
		{
			UE4CodeGen_Private::ConstructUClass(OuterClass, Z_Construct_UClass_AWizardWoes00GameMode_Statics::ClassParams);
		}
		return OuterClass;
	}
	IMPLEMENT_CLASS(AWizardWoes00GameMode, 3505755138);
	template<> WIZARDWOES00_API UClass* StaticClass<AWizardWoes00GameMode>()
	{
		return AWizardWoes00GameMode::StaticClass();
	}
	static FCompiledInDefer Z_CompiledInDefer_UClass_AWizardWoes00GameMode(Z_Construct_UClass_AWizardWoes00GameMode, &AWizardWoes00GameMode::StaticClass, TEXT("/Script/WizardWoes00"), TEXT("AWizardWoes00GameMode"), false, nullptr, nullptr, nullptr);
	DEFINE_VTABLE_PTR_HELPER_CTOR(AWizardWoes00GameMode);
PRAGMA_ENABLE_DEPRECATION_WARNINGS
#ifdef _MSC_VER
#pragma warning (pop)
#endif
