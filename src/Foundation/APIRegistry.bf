using System;
using System.Interop;
using System.IO;

namespace TheMachinery.Foundation
{

	[CRepr]
	public struct tm_api_registry_listener_i
	{
		public void* ud;
		public function void(void* ud, char8* name, tm_version_t version, void* implementation) add_implementation;
	}

	[CRepr]
	public struct tm_api_registry_api
	{
		public function tm_version_t() api_registry_version;
		public function void(char8* name, tm_version_t version) set;
		public function void(void* api) Remove;
		public function void*(char8* name, tm_version_t version) get;
		public function void(void** api, char8* name, tm_version_t version) get_optional;
		public function tm_version_t(void* api) Version;
		public function void(char8* name, tm_version_t version, void* implementation) add_implementation;
		public function void(char8* name, tm_version_t version, void* implementation) remove_implementation;
		public function void**(char8* name, tm_version_t version) implementations;
		public function uint32() num_implementations;
		public function void*(char8* name, tm_version_t version) first_implementation;
		public function void*(char8* name, tm_version_t version) single_implementation;
		public function void(tm_api_registry_listener_i* listener) add_listener;
		public function void*(tm_strhash_t id, uint32 size, char8* file, uint32 line) static_variables;
		public function void(char8* name) begin_context;
		public function void(char8* name) end_context;
		public function void() disable_apis_missing_dependencies;
		public function tm_version_t*(char8* name, tm_temp_allocator_i* ta) available_versions;
	}

	static
	{
		[Comptime(ConstEval = true)]
		private static String GetName(Type type)
		{
			let name = scope String();
			type.GetName(name);
			return name;
		}

		public static T* TM_GET_API<T>(tm_api_registry_api* reg, tm_version_t version)
		{
			const String str = GetName(typeof(T));
			return (T*)reg.get(str.CStr(), version);
		}
	}
}
