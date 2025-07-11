package lt.backend;

import lt.backend.Lyrics;
import lt.backend.MapData.MapAsset;
import openfl.display3D.textures.RectangleTexture;
import flixel.graphics.FlxGraphic;
import lt.backend.MapData.LineMap;
import lime.graphics.Image;
import openfl.display.BitmapData;
import openfl.media.Sound;
import sys.FileSystem;
import sys.io.File;

/**
 * Helper class for this game's assets.
 */
class Assets
{
	/** Path to asset folders, modify only if necessary. **/
	@:noCompletion inline public static var _ASSET_PATH:String = "./assets";

	@:noCompletion inline public static var _DATA_PATH:String = '$_ASSET_PATH/data';
	@:noCompletion inline public static var _SHADER_PATH:String  = '$_DATA_PATH/shaders';
	@:noCompletion inline public static var _FONT_PATH:String = '$_DATA_PATH/fonts';
	@:noCompletion inline public static var _MAP_PATH:String = '$_DATA_PATH/maps';

	@:noCompletion inline public static var _IMAGE_PATH:String = '$_ASSET_PATH/images';
	@:noCompletion inline public static var _SOUND_PATH:String = '$_ASSET_PATH/sounds';

	/** Trackers for loaded assets. **/
	public static var loaded_images:Map<String, Bool> = new Map();

	public static var loaded_sounds:Map<String, Sound> = new Map();

	/**
	 * Unloads all loaded images.
	 */
	public static function unloadImages()
	{
		for (key in loaded_images.keys())
		{
			var graphic:FlxGraphic = FlxG.bitmap.get(key);
			if (graphic == null)
				continue;

			if (graphic.bitmap != null)
				graphic.bitmap.dispose();

			graphic.destroy();
			FlxG.bitmap.removeByKey(key);
		}

		loaded_images.clear();
		openfl.utils.Assets.cache.clear();
	}

	/**
	 * Loads a font file.
	 * @param name Your font's file name (without .ttf extension)
	 * @return Font
	 */
	public static function font(name:String)
	{
		var path:String = '$_FONT_PATH/$name.ttf';

		// try ttf
		if (!FileSystem.exists(path)) {
			//try otf
			path = '$_FONT_PATH/$name.otf';
			if (!FileSystem.exists(path))
				return null;
			else
				return path;
		}


		return path;
	}

	/**
	 * Returns video file from a map.
	 * @param name the map's name.
	 * @return String Path.
	 */
	public static function video(name:String):String {
		var path:String = '$_MAP_PATH/$name/video.mp4';
		if (!FileSystem.exists(path)) return "";

		return path;
	}

	/**
	 * Returns an image file from `./assets/images/`, Returns null if the `path` does not exist.
	 * @param file Image file name
	 * @return FlxGraphic (Warning: might return null)
	 */
	public static function image(file:String):FlxGraphic
	{
		var path:String = '$_IMAGE_PATH/$file';

		if (FileSystem.exists(path+'-'+PhraseManager.languageList.asset_suffix + '.png'))
		{
			path += '-'+PhraseManager.languageList.asset_suffix;
		} else {
			// Debugging purposes only
			// trace('Failed to load '+path+'-'+PhraseManager.languageList.asset_suffix);
		}

		path += '.png';

		if (!FileSystem.exists(path))
			return null;

		if (loaded_images.exists(file))
			return FlxG.bitmap.get(file);

		var data:Image = Image.fromFile(path);
		var newBitmap:BitmapData = BitmapData.fromImage(data);

		// Send to GPU

		var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(newBitmap, false, file);
		newGraphic.persist = true;

		var n:FlxGraphic = FlxG.bitmap.addGraphic(newGraphic);
		loaded_images.set(file, true);

		return n;
	}

	/**
	 * Returns MapAsset containing audio and map data.
	 * Returns null if the map folder does not exist.
	 * @param song Song's name.
	 * @return MapAsset (Warning: might return null)
	 */
	public static function map(song:String):MapAsset
	{
		var path:String = '$_MAP_PATH/$song';

		if (!FileSystem.exists(path))
			return null;

		var soundPath:String = '$path/audio';

		var mapPath:String = '$path/map.json';

		var lyricsPath:String = '$path/lyrics';

		if (FileSystem.exists(lyricsPath+'-'+PhraseManager.languageList.asset_suffix + '.txt'))
			lyricsPath += '-'+PhraseManager.languageList.asset_suffix;

		lyricsPath += '.txt';

		var mAsset:MapAsset = {
			audio: null,
			map: null,
			lyrics: null
		};

		mAsset.audio = _sound_file(soundPath);

		if (FileSystem.exists(mapPath))
			mAsset.map = MapData.loadMap(File.getContent(mapPath));

		if (FileSystem.exists(lyricsPath))
			mAsset.lyrics = new Lyrics(File.getContent(lyricsPath));

		return mAsset;
	}

	/**
	 * Returns .frag shader file.
	 * @param name Shader filename.
	 */
	 public static function frag(name:String) {
		var path:String = '$_SHADER_PATH/$name.frag';
		if (!FileSystem.exists(path)) {
			trace("does not exist: " + path);
			return "";
		} 
		trace("shader exists");
		return File.getContent(path);
	}

	/**
	 * Returns a sound file
	 * @param path Sound's file name (without extension)
	 * @return Sound
	 */
	inline public static function sound(name:String):Sound
		return _sound_file('$_SOUND_PATH/$name');

	/**
	 * [INTERNAL] Loads a sound file
	 * @param path Path to the sound file
	 * @return Sound
	 */
	public static function _sound_file(path:String):Sound
	{
		if (FileSystem.exists(path+'-'+PhraseManager.languageList.asset_suffix + '.ogg'))
			path += '-'+PhraseManager.languageList.asset_suffix;

		path += '.ogg';

		if (!FileSystem.exists(path))
			return null;

		if (!loaded_sounds.exists(path))
			loaded_sounds.set(path, Sound.fromFile(path));

		return loaded_sounds.get(path);
	}
}