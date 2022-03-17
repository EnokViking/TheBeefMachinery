using System;

namespace IDEExtensions
{
	class CStructGenerator : Compiler.Generator
	{
		public override String Name
		{
			get => "Struct";
		}

		public override void InitUI()
		{
			AddEdit("name", "Struct Name", "");
			AddCheckbox("crepr", "C Compatible", false);
			AddCheckbox("ordered", "Explicitly Ordered", false);
		}

		public override void Generate(String outFileName, String outText, ref Flags generateFlags)
		{
			var name = mParams["name"];
			if (name.EndsWith(".bf", .OrdinalIgnoreCase))
				name.RemoveFromEnd(3);
			outFileName.Append(name);

			String attributes = scope .("");

			if (bool.Parse(mParams["crepr"]) case .Ok(let crepr))
			if (bool.Parse(mParams["ordered"]) case .Ok(let ordered))

			switch ((crepr, ordered))
			{
				case (true, true): 	attributes.AppendF($"[CRepr, Ordered]");
				case (true, false): attributes.AppendF($"[CRepr]");
				case (false, true): attributes.AppendF($"[Ordered]");
			}

			outText.AppendF
			($"""
			using System;

			namespace {Namespace}
			{{
				{attributes}
				struct {name}
				{{

				}}
			}}
			""");
		}
	}
}