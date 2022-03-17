// The Machinery uses  [MurmurHash64A](https://en.wikipedia.org/wiki/MurmurHash) as its default
// hash function.
// see murmurhash64a.inl in TheMachinery headers

using System;
namespace TheMachinery.Foundation
{
	static
	{
		[CRepr]
		public struct tm_strhash_t : this(uint64 Underlying);

		private static uint64 tm_murmur_hash_64a(void* key, uint32 len, uint64 seed)
		{
			const uint64 m = 0xc6a4a7935bd1e995UL;
			const int32 r = 47;
		
			uint64 h = seed ^ (len * m);
		
			uint64* data = (uint64*)key;
			uint64* end = data + (len / 8);
		
			uint64 k = ?;
			while (data != end) {
			    Internal.MemCpy(&k, data++, sizeof(uint64));
		
			    k *= m;
			    k ^= (k >> r);
			    k *= m;
		
			    h ^= k;
			    h *= m;
			}
		
			uint8* data2 = (uint8*)data;
		
			switch (len & 7) {
				case 7:
					    h ^= (uint64)(data2[6]) << 48;
						fallthrough;
				case 6:
					    h ^= (uint64)(data2[5]) << 40;
						fallthrough;
				case 5:
					    h ^= (uint64)(data2[4]) << 32;
						fallthrough;
				case 4:
					    h ^= (uint64)(data2[3]) << 24;
						fallthrough;
				case 3:
					    h ^= (uint64)(data2[2]) << 16;
						fallthrough;
				case 2:
					    h ^= (uint64)(data2[1]) << 8;
						fallthrough;
				case 1:
					    h ^= (uint64)(data2[0]);
					    h *= m;
			}
		
			h ^= (h >> r);
			h *= m;
			h ^= (h >> r);
		
			return h;
		}

		[Comptime(ConstEval=true)]
		public static tm_strhash_t TM_STATIC_HASH(String str)
		{
			return tm_strhash_t(tm_murmur_hash_64a(str.CStr(), (uint32)str.Length, 0));
		}
	}
}
