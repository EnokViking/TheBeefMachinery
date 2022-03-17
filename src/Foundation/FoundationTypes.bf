using System;

namespace TheMachinery.Foundation
{
	[CRepr]
	public struct tm_version_t : this(uint32 major, uint32 minor, uint32 patch);

	[CRepr]
	public struct tm_rect_t : this(float x, float y, float w, float h);

	[CRepr, Union]
	public struct tm_tt_id_t
	{
		uint64 u64;
		Value val;

		[CRepr]
		private struct Value
		{
			uint64 type;
			uint64 generation;
			uint64 index;
		}
	}

	[CRepr]
	struct tm_str_t
	{
		char8* data;
		uint32 size;
		uint32 null_terminated;
	}
}