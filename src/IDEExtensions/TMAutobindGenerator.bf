using System;
using System.IO;
using System.Diagnostics;

namespace TheBeefMachinery.IDEExtensions
{
	class TMAutobindGenerator : Compiler.Generator
	{
		public override String Name
		{
			get => "TheMachinery Bindgen";
		}

		public override void InitUI()
		{
			AddEdit("namespace", "Namespace", scope $"{Namespace}");
			AddEdit("name", "Name", "");
			AddEdit("path", "TM Header Location", "");
		}

		public override void Generate(String outFileName, String outText, ref Flags generateFlags)
		{
			let program = "clang.exe";
			let arguments = "-Xclang -ast-dump=json -fsyntax-only";

			var path = mParams["path"];

			if (path.EndsWith(".h", .OrdinalIgnoreCase))
				path.RemoveFromEnd(2);

			let startInfo = scope ProcessStartInfo();

			startInfo.SetFileNameAndArguments(scope $"{program} {arguments} \"{path}.h\"");
			startInfo.RedirectStandardOutput = true;
			startInfo.UseShellExecute = false;

			let process = scope SpawnedProcess();
			let stream = scope FileStream();

			let ast = new String();
			defer delete ast;

			if (process.Start(startInfo) case .Err)
				Fail(scope $"Failed to start process: {program}");

			if (process.AttachStandardOutput(stream) case .Err)
				Fail(scope $"Failed to attach output to process: {program}");

			let reader = scope StreamReader(stream);

			if (reader.ReadToEnd(ast) case .Err) {
				Fail(scope $"Failed to read {program} output");
			}

			var name = mParams["name"];
			if (name.EndsWith(".bf", .OrdinalIgnoreCase))
				name.RemoveFromEnd(3);
			outFileName.Append(name);

			outText.AppendF
			($"""
			using System;

			namespace {Namespace}
			{{
				static
				{{
					const String ast =
			\"\"\"
			{ast}
			\"\"\";
				}}
			}}
			""");
		}
	}
}