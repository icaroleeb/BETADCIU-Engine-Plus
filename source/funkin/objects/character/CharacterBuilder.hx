package funkin.objects.character;

import haxe.Json;

import funkin.objects.character.Character.AnimArray;

using StringTools;

typedef CharacterFile =
{
	var animations:Array<AnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;
	
	var position:Array<Float>;
	@:optional var player_position:Array<Float>; // New preferred field
	@:optional var playerposition:Array<Float>; // Legacy fallback
	var camera_position:Array<Float>;
	var player_camera_position:Array<Float>;
	
	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;
	var vocals_file:String;
	@:optional var is_player_char:Bool; // New preferred field
	@:optional var isPlayerChar:Bool; // Legacy fallback
	
	@:optional var _editor_isPlayer:Null<Bool>;
}

/**
 * Helper class to handle different character types
 */
class CharacterBuilder
{
	/**
	 * default char. used in case a character is missing
	 */
	public static final DEFAULT_CHARACTER:String = 'bf';
	
	public static function fromName(x:Float = 0, y:Float = 0, charName:String, isPlayer:Bool = false):Character
	{
		// temp we shouldnt be doing this twice
		final file = getCharacterFile(charName);
		
		switch (charName)
		{
			default:
				if (FunkinAssets.exists(Paths.textureAtlas(file.image + '/Animation.json')))
				{
					return new AnimateCharacter(x, y, charName, isPlayer);
				}
				else
				{
					return new Character(x, y, charName, isPlayer);
				}
		}
	}
	
	public static function getCharacterFile(character:String):CharacterFile
	{
		var charPath:String = Paths.getPath('characters/' + character + '.json', TEXT, null, true);
		
		if (!FunkinAssets.exists(charPath))
		{
			charPath = Paths.getPrimaryPath('characters/' + DEFAULT_CHARACTER + '.json');
		}
		
		return cast Json.parse(FunkinAssets.getContent(charPath));
	}
	
	public static function changeTypeReload(info:Array<Dynamic>, type:String, file:String)
	{
		trace('changing type to $type');
		var character:Dynamic;
		
		switch (type)
		{
			case 'atlas':
				character = new AnimateCharacter(info[0], info[1], info[2], info[3]);
				character.loadGraphicFromType(file, 'atlas');
			default:
				character = new Character(info[0], info[1], info[2], info[3], true);
				character.skipJsonStuff = true;
				character.imageFile = file;
				character.createNow();
		}
		
		return character;
	}
}
