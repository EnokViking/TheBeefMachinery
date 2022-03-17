using System;
using System.Reflection;
using TheMachinery.Foundation;

namespace TheMachinery.Plugins.Simulation
{
	static
	{
		const tm_version_t tm_simulation_entry_i_version = .(1, 0, 0);
		public const int32 TM_MAX_DEPENDENCIES_FOR_SIMULATION_ENTRY = 16;
	}

	/*opaque blobs*/
	[CRepr] struct tm_physx_scene_o;
	[CRepr] struct tm_entity_context_o;
	[CRepr] struct tm_simulation_o;
	[CRepr] struct tm_the_truth_o;
	[CRepr] struct tm_ui_o;
	[CRepr] struct tm_ui_style_t;
	[CRepr] struct tm_entity_commands_o;
	[CRepr] struct tm_simulation_state_o;

	[CRepr]
	struct tm_simulation_entry_i
	{
		public tm_strhash_t id;
		public char8* display_name;
		public tm_strhash_t settings_type_hash;

		public function tm_simulation_state_o*(tm_simulation_start_args_t* args) start;
		public function void(tm_simulation_state_o* state, tm_entity_commands_o* args) stop;

		public function void(tm_simulation_state_o* state, tm_simulation_frame_args* args) tick;
		public function void(tm_simulation_state_o* state, tm_simulation_state_commands_o* commands) hot_reload;

		public tm_strhash_t[TM_MAX_DEPENDENCIES_FOR_SIMULATION_ENTRY] before_me;
		public tm_strhash_t[TM_MAX_DEPENDENCIES_FOR_SIMULATION_ENTRY] after_me;

		public tm_strhash_t phase;
	}

	[CRepr]
	struct tm_simulation_state_commands_o
	{
		
	}

	[CRepr]
	struct tm_simulation_frame_args
	{
		tm_entity_commands_o* commands;

		float dt;
		float dt_unscaled;
		double time;
		double time_unscaled;
		bool running_in_editor;

		uint8[7] padding;

		tm_ui_o* ui;
		tm_ui_style_t* uistyle;
		tm_rect_t rect;
		tm_physx_scene_o* physx_scene;
	}

	[CRepr]
	struct tm_simulation_start_args_t
	{
		public tm_allocator_i* allocator;

		tm_the_truth_o* tt;

		tm_entity_context_o* entity_ctx;

		tm_simulation_o* simulation_ctx;

		tm_tt_id_t asset_root;

		tm_tt_id_t settings_id;

		tm_entity_commands_o* commands;

		bool running_in_editor;

		private uint8[7] padding;
	}
}