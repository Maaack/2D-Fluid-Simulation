class_name CommonBase
extends Node

enum BrushTypes{
	SOFTEST,
	SOFT,
	HARD,
	HARDEST,
	BRISTLES
}
enum Resolutions{
	_64,
	_128,
	_256,
	_512
}
enum Scenes{
	MINIMAL,
	MULTI_PASS,
	SINGLE_PASS
}
const MIN_RESOLUTION : int = 64;
const MAX_RESOLUTION : int = 512;

