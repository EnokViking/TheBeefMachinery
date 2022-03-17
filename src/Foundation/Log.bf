using System;

namespace TheMachinery.Foundation
{
	static
	{
		public const tm_version_t TM_LOGGER_API_VERSION = .(1, 0, 0);
	}

	public enum LogType : uint32
	{
		Info,
		Debug,
		Error
	}

	[CRepr]
	public struct tm_logger_api_o;

	[CRepr]
	struct tm_logger_api_i
	{
		public tm_logger_api_o* inst;
		public function void(tm_logger_api_o* inst, LogType type, char8* msg) log;
	}

	[CRepr]
	public struct tm_logger_api
	{
		public function void(tm_logger_api_i* logger) add_logger;
		public function void(tm_logger_api_i* logger) remove_logger;
		public function void(LogType type, char8* msg) print;
		public function void(LogType type, char8* format, ...) printf;
		public tm_logger_api_i* default_logger;
	}
	
}
