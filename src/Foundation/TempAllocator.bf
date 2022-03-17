using System;

namespace TheMachinery.Foundation
{
	[CRepr]
	public struct tm_temp_allocator_o;

	[CRepr]
	public struct tm_temp_allocator_statistics
	{
		public uint64 temp_allocated_blocks;
		public uint64 temp_allocated_bytes;
		public uint64 frame_allocation_block;
		public uint64 frame_allocation_bytes;
	}

	[CRepr]
	public struct tm_temp_allocator_1024_o
	{
		public char8[1024] buffer;
	}

	[CRepr]
	public struct tm_temp_allocator_i
	{
		public tm_temp_allocator_o* inst;
		public function void*(tm_temp_allocator_o* inst, void* ptr, uint64 old_size, uint64 new_size) realloc;
	}
}
