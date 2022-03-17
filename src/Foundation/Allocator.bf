using System;
using System.Collections;

namespace TheMachinery.Foundation
{
	static
	{
		const tm_version_t tm_allocator_api_version = .(1, 0, 0);
		public static void* tm_alloc(tm_allocator_i* a, uint64 size, String file = Compiler.CallerFilePath, int lineNum = Compiler.CallerLineNum)
			=> a.[Friend]realloc(a, null, 0, size, file.CStr(), (uint32)lineNum);
		public static void tm_free(tm_allocator_i* a, void* p, uint64 size, String file = Compiler.CallerFilePath, int lineNum = Compiler.CallerLineNum)
			=> a.[Friend]realloc(a, p, size, 0, file.CStr(), (uint32)lineNum);
	}

	/* tm_alloc/tm_free wrapper */
	class TMAllocator
	{
		private tm_allocator_i* _allocator;
		private Dictionary<void*, uint64> _lookup ~ delete _;

		[AllowAppend]
		public this()
		{
			_lookup = new Dictionary<void*, uint64>();
		}

		public void SetInternalAllocator(tm_allocator_i* allocator)
		{
			_allocator = allocator;
		}

		public void* Alloc(int size, int align)
		{
			let ptr = tm_alloc(_allocator, (.)size);
			_lookup.Add(ptr, (.)size);
			return ptr;
		}

		public void Free(void* ptr)
		{
			if (_lookup.GetAndRemove(ptr) case .Ok(let kvp)) {
				tm_free(_allocator, ptr, kvp.value);
			}
		}
	}

	[CRepr]
	struct tm_allocator_o;

	[CRepr]
	struct tm_allocator_statistics_t
	{
		uint64 system_allocation_count;
		uint64 system_allocated_bytes;
		uint64 vm_reserved;
		uint64 vm_committed;
		uint64 system_churn_allocation_count;
		uint64 system_churn_allocated_bytes;
		uint64 vm_churn_committed;
	}

	[CRepr]
	struct tm_allocator_api
	{
		tm_allocator_i* system;
		tm_allocator_i* end_of_page;
		tm_allocator_i* vm;
		tm_allocator_statistics_t* statistics;

		function tm_allocator_i(tm_allocator_i* parent, char8* desc) create_child;
		function void(tm_allocator_i* child) destroy_child;
		function void(tm_allocator_i* child, uint64 max_leaked_bytes) destroy_child_allowing_leaks;
		function tm_allocator_i(tm_allocator_i* parent, char8* desc) create_leaky_root_scope;
		function tm_allocator_i(uint64 reserved_size, uint32 mem_scope) create_fixed_vm;
	}

	[CRepr]
	struct tm_allocator_i
	{
		tm_allocator_o* inst;
		uint32 mem_scope;
		uint8[4] padding;

		function void*(tm_allocator_i* a, void* ptr, uint64 old_size, uint64 new_size, char8* file, uint32 line) realloc;
	}
}