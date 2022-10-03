/**********************************************************************************************
*
*   raylib v4.2 - A simple and easy-to-use library to enjoy videogames programming (www.raylib.com)
*
*   NOTICE: This is an incomplete Raylib wrapper for demonstrating libffi in Euphoria.
*
**********************************************************************************************/

include std/ffi.e
include std/machine.e

------------------------------------------------------------------------------------
-- Some basic Defines
------------------------------------------------------------------------------------

public constant PI = 3.14159265358979323846
public constant DEG2RAD = (PI / 180.0)
public constant RAD2DEG = (180.0 / PI)

-- Some Basic Colors
public constant LIGHTGRAY  = { 200, 200, 200, 255 } -- Light Gray
public constant GRAY       = { 130, 130, 130, 255 } -- Gray
public constant DARKGRAY   = { 80, 80, 80, 255 }    -- Dark Gray
public constant YELLOW     = { 253, 249, 0, 255 }   -- Yellow
public constant GOLD       = { 255, 203, 0, 255 }   -- Gold
public constant ORANGE     = { 255, 161, 0, 255 }   -- Orange
public constant PINK       = { 255, 109, 194, 255 } -- Pink
public constant RED        = { 230, 41, 55, 255 }   -- Red
public constant MAROON     = { 190, 33, 55, 255 }   -- Maroon
public constant GREEN      = { 0, 228, 48, 255 }    -- Green
public constant LIME       = { 0, 158, 47, 255 }    -- Lime
public constant DARKGREEN  = { 0, 117, 44, 255 }    -- Dark Green
public constant SKYBLUE    = { 102, 191, 255, 255 } -- Sky Blue
public constant BLUE       = { 0, 121, 241, 255 }   -- Blue
public constant DARKBLUE   = { 0, 82, 172, 255 }    -- Dark Blue
public constant PURPLE     = { 200, 122, 255, 255 } -- Purple
public constant VIOLET     = { 135, 60, 190, 255 }  -- Violet
public constant DARKPURPLE = { 112, 31, 126, 255 }  -- Dark Purple
public constant BEIGE      = { 211, 176, 131, 255 } -- Beige
public constant BROWN      = { 127, 106, 79, 255 }  -- Brown
public constant DARKBROWN  = { 76, 63, 47, 255 }    -- Dark Brown
public constant WHITE      = { 255, 255, 255, 255 } -- White
public constant BLACK      = { 0, 0, 0, 255 }       -- Black
public constant BLANK      = { 0, 0, 0, 0 }         -- Blank (Transparent)
public constant MAGENTA    = { 255, 0, 255, 255 }   -- Magenta
public constant RAYWHITE   = { 245, 245, 245, 255 } -- My own White (raylib logo)

------------------------------------------------------------------------------------
-- Structures Definition
------------------------------------------------------------------------------------

-- Boolean type
public enum type bool
	false = 0,
	true
end type

-- Vector2, 2 components
public constant RL_VECTOR2 = define_c_type({
	C_FLOAT, -- x   // Vector x component
	C_FLOAT  -- y   // Vector y component
})

-- Vector3, 3 components
public constant RL_VECTOR3 = define_c_type({
	C_FLOAT, -- x   // Vector x component
	C_FLOAT, -- y   // Vector y component
	C_FLOAT  -- z   // Vector z component
})

-- Vector4, 4 components
public constant RL_VECTOR4 = define_c_type({
	C_FLOAT, -- x   // Vector x component
	C_FLOAT, -- y   // Vector y component
	C_FLOAT, -- z   // Vector z component
	C_FLOAT  -- w   // Vector w component
})

-- Quaternion, 4 components (Vector4 alias)
public constant RL_QUATERNION = define_c_type( RL_VECTOR4 )

-- Matrix, 4x4 components, column major, OpenGL style, right handed
public constant RL_MATRIX = define_c_type({
	C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT, -- m0, m4, m8, m12,    // Matrix first row (4 components)
	C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT, -- m1, m5, m9, m13,    // Matrix second row (4 components)
	C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT, -- m2, m6, m10, m14,   // Matrix third row (4 components)
	C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT  -- m3, m7, m11, m15    // Matrix fourth row (4 components)
})

-- Color, 4 components, R8G8B8A8 (32bit)
public constant RL_COLOR = define_c_type({
	C_UCHAR, -- r   // Color red value
	C_UCHAR, -- g   // Color green value
	C_UCHAR, -- b   // Color blue value
	C_UCHAR  -- a   // Color alpha value
})

-- Rectangle, 4 components
public constant RL_RECTANGLE = define_c_type({
	C_FLOAT, -- x       // Rectangle top-left corner position x
	C_FLOAT, -- y       // Rectangle top-left corner position y
	C_FLOAT, -- width   // Rectangle width
	C_FLOAT  -- height  // Rectangle height
})

-- Image, pixel data stored in CPU memory (RAM)
public constant RL_IMAGE = define_c_type({
	C_POINTER, -- data      // Image raw data
	C_INT,     -- width     // Image base width
	C_INT,     -- height    // Image base height
	C_INT,     -- mipmaps   // Mipmap levels, 1 by default
	C_INT      -- format    // Data format (PixelFormat type)
})

-- Texture, tex data stored in GPU memory (VRAM)
public constant RL_TEXTURE = define_c_type({
	C_UINT, -- id       // OpenGL texture id
	C_INT,  -- width    // Texture base width
	C_INT,  -- height   // Texture base height
	C_INT,  -- mipmaps  // Mipmap levels, 1 by default
	C_INT   -- format   // Data format (PixelFormat type)
})

-- Texture2D, same as Texture
public constant RL_TEXTURE2D = define_c_type( RL_TEXTURE )

-- TextureCubemap, same as Texture
public constant RL_TEXTURECUBEMAP = define_c_type( RL_TEXTURE )

-- RenderTexture, fbo for texture rendering
public constant RL_RENDERTEXTURE = define_c_type({
	C_UINT,     -- id       // OpenGL framebuffer object id
	RL_TEXTURE, -- texture  // Color buffer attachment texture
	RL_TEXTURE  -- depth    // Depth buffer attachment texture
})

-- RenderTexture2D, same as RenderTexture
public constant RL_RENDERTEXTURE2D = define_c_type( RL_RENDERTEXTURE )

-- NPatchInfo, n-patch layout info
public constant RL_NPATCHINFO = define_c_type({
	RL_RECTANGLE, -- source   // Texture source rectangle
	C_INT,        -- left     // Left border offset
	C_INT,        -- top      // Top border offset
	C_INT,        -- right    // Right border offset
	C_INT,        -- bottom   // Bottom border offset
	C_INT         -- layout   // Layout of the n-patch: 3x3, 1x3 or 3x1
})

-- GlyphInfo, font characters glyphs info
public constant RL_CHARINFO = define_c_type({
	C_INT,   -- value     // Character value (Unicode)
	C_INT,   -- offsetX   // Character offset X when drawing
	C_INT,   -- offsetY   // Character offset Y when drawing
	C_INT,   -- advanceX  // Character advance position X
	RL_IMAGE -- image     // Character image data
})

-- Font, font texture and GlyphInfo array data
public constant RL_FONT = define_c_type({
	C_INT,        -- baseSize       // Base size (default chars height)
	C_INT,        -- glyphCount     // Number of glyph characters
	C_INT,        -- glyphPadding   // Padding around the glyph characters
	RL_TEXTURE2D, -- texture        // Texture atlas containing the glyphs
	C_POINTER,    -- recs           // Rectangles in texture for the glyphs
	C_POINTER     -- glyphs         // Glyphs info data
})

-- Camera, defines position/orientation in 3d space
public constant RL_CAMERA3D = define_c_type({
	RL_VECTOR3, -- position     // Camera position
	RL_VECTOR3, -- target       // Camera target it looks-at
	RL_VECTOR3, -- up           // Camera up vector (rotation over its axis)
	C_FLOAT,    -- fovy         // Camera field-of-view apperture in Y (degrees) in perspective, used as near plane width in orthographic
	C_INT       -- projection   // Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
})

-- Camera type fallback, defaults to Camera3D
public constant RL_CAMERA = define_c_type( RL_CAMERA3D )

-- Camera2D, defines position/orientation in 2d space
public constant RL_CAMERA2D = define_c_type({
	RL_VECTOR2, -- offset     // Camera offset (displacement from target)
	RL_VECTOR2, -- target     // Camera target (rotation and zoom origin)
	C_FLOAT,    -- rotation   // Camera rotation in degrees
	C_FLOAT     -- zoom       // Camera zoom (scaling), should be 1.0f by default
})

-- Vertex data definning a mesh
public constant RL_MESH = define_c_type({
	C_INT,     -- vertexCount     // Number of vertices stored in arrays
	C_INT,     -- triangleCount   // Number of triangles stored (indexed or not)
	-- Default vertex data
	C_POINTER, -- vertices        // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
	C_POINTER, -- texcoords       // Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
	C_POINTER, -- texcoords2      // Vertex texture second coordinates (UV - 2 components per vertex) (shader-location = 5)
	C_POINTER, -- normals         // Vertex normals (XYZ - 3 components per vertex) (shader-location = 2)
	C_POINTER, -- tangents        // Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4)
	C_POINTER, -- colors          // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
	C_POINTER, -- indices         // Vertex indices (in case vertex data comes indexed)
	-- Animation vertex data
	C_POINTER, -- animVertices    // Animated vertex positions (after bones transformations)
	C_POINTER, -- animNormals     // Animated normals (after bones transformations)
	C_POINTER, -- boneIds         // Vertex bone ids, max 255 bone ids, up to 4 bones influence by vertex (skinning)
	C_POINTER, -- boneWeights     // Vertex bone weight, up to 4 bones influence by vertex (skinning)
	-- OpenGL identifiers
	C_UINT,    -- vaoId           // OpenGL Vertex Array Object id
	C_POINTER  -- vboId           // OpenGL Vertex Buffer Objects id (default vertex data)
})

-- Shader
public constant RL_SHADER = define_c_type({
	C_UINT,   -- id     // Shader program id
	C_POINTER -- locs   // Shader locations array (RL_MAX_SHADER_LOCATIONS)
})

-- MaterialMap
public constant RL_MATERIALMAP = define_c_type({
	RL_TEXTURE2D, -- texture  // Material map texture
	RL_COLOR,     -- color    // Material map color
	C_FLOAT       -- value    // Material map value
})

-- Material, includes shader and maps
public constant RL_MATERIAL = define_c_type({
	RL_SHADER,  -- shader   // Material shader
	C_POINTER,  -- maps     // Material maps array (MAX_MATERIAL_MAPS)
	{C_FLOAT,4} -- params   // Material generic parameters (if required)
})

-- Transform, vectex transformation data
public constant RL_TRANSFORM = define_c_type({
	RL_VECTOR3,    -- translation   // Translation
	RL_QUATERNION, -- rotation      // Rotation
	RL_VECTOR3     -- scale         // Scale
})

-- Bone, skeletal animation bone
public constant RL_BONEINFO = define_c_type({
	{C_CHAR,32}, -- name    // Bone name
	C_INT        -- parent  // Bone parent
})

-- Model, meshes, materials and animation data
public constant RL_MODEL = define_c_type({
	RL_MATRIX, -- transform       // Local transform matrix
	C_INT,     -- meshCount       // Number of meshes
	C_INT,     -- materialCount   // Number of materials
	C_POINTER, -- meshes          // Meshes array
	C_POINTER, -- materials       // Materials array
	C_POINTER, -- meshMaterial    // Mesh material number
	-- Animation data
	C_INT,     -- boneCount       // Number of bones
	C_POINTER, -- bones           // Bones information (skeleton)
	C_POINTER  -- bindPose        // Bones base transformation (pose)
})

-- ModelAnimation
public constant RL_MODELANIMATION = define_c_type({
	C_INT,     -- boneCount   // Number of bones
	C_INT,     -- frameCount  // Number of animation frames
	C_POINTER, -- bones       // Bones information (skeleton)
	C_POINTER  -- framePoses  // Poses array by frame
})

-- Ray, ray for raycasting
public constant RL_RAY = define_c_type({
	RL_VECTOR3, -- position   // Ray position (origin)
	RL_VECTOR3  -- direction  // Ray direction
})

-- RayCollision, ray hit information
public constant RL_RAYCOLLISION = define_c_type({
	C_BOOL,     -- hit        // Did the ray hit something?
	C_FLOAT,    -- distance   // Distance to nearest hit
	RL_VECTOR3, -- point      // Point of nearest hit
	RL_VECTOR3  -- normal     // Surface normal of hit
})

-- BoundingBox
public constant RL_BOUNDINGBOX = define_c_type({
	RL_VECTOR3, -- min  // Minimum vertex box-corner
	RL_VECTOR3  -- max  // Maximum vertex box-corner
})

-- Wave, audio wave data
public constant RL_WAVE = define_c_type({
	C_UINT,   -- frameCount   // Total number of frames (considering channels)
	C_UINT,   -- sampleRate   // Frequency (samples per second)
	C_UINT,   -- sampleSize   // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
	C_UINT,   -- channels     // Number of channels (1-mono, 2-stereo, ...)
	C_POINTER -- data         // Buffer data pointer
})

-- AudioStream, custom audio stream
public constant RL_AUDIOSTREAM = define_c_type({
	C_POINTER, -- buffer        // Pointer to internal data used by the audio system
	C_POINTER, -- processor     // Pointer to internal data processor, useful for audio effects
	C_UINT,    -- sampleRate    // Frequency (samples per second)
	C_UINT,    -- sampleSize    // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
	C_UINT     -- channels      // Number of channels (1-mono, 2-stereo, ...)
})

--Sound
public constant RL_SOUND = define_c_type({
    RL_AUDIOSTREAM, -- Audio stream
    C_UINT -- Total number of frames (considering channels)
})

--Music, audio stream, anything longer than 10 seconds should be streamed
public constant RL_MUSIC = define_c_type({
   RL_AUDIOSTREAM, --Audio stream
   C_UINT, --total numer of frames (considering channels)
   C_BOOL, --music looping enable
   C_INT, --type of music context (audio filetype)
   C_POINTER --audio context data, depends on type
})

--VrDeviceInfo, Head-Mounted-Display device parameters
public constant RL_VRDEVICEINFO = define_c_type({
   C_INT, --Horizontal resolution in pixels
   C_INT, --Vertical resolution in pixels
   C_FLOAT, --Horizontal size in meters
   C_FLOAT, --Vertical size in meters
   C_FLOAT, --Screen center in meters
   C_FLOAT, --Distance between eye and display in meters
   C_FLOAT, --Lens separation distance in meters
   C_FLOAT, --IDP (distance between pupils) in meters
   {C_FLOAT,4}, --Lens distortion constant parameters
   {C_FLOAT,4} --Chromatic aberration correction parameters
})

--VrStereoConfig, VR stereo rendering configuation for simulator
public constant RL_VRSTEREOCONFIG = define_c_type({
   {RL_MATRIX,2}, --VR projection matrices (per eye)
   {RL_MATRIX,2}, --VR view offset matrices (per eye)
   {C_FLOAT,2}, --VR left lens center
   {C_FLOAT,2}, --VR right lens center
   {C_FLOAT,2}, --vr left screen center
   {C_FLOAT,2}, --vr right screen center
   {C_FLOAT,2}, --VR distortion scale
   {C_FLOAT,2} --VR distortion scale in
})

--File path list
public constant RL_FILEPATHLIST = define_c_type({
   C_UINT, --filepaths max entries
   C_UINT, --filepathes entries count
   C_CHAR --filepathes entries
})

--System/Window config flags
--Note: Every bit registers one state (use it with bit masks)
--By default all flags are set to 0

public enum type ConfigFlags
	FLAG_VSYNC_HINT = 0x00000040, --Set to try enabling V-sync on GPU
	FLAG_FULLSCREEN_MODE = 0x00000002, --Set to run program in fullscreen
	FLAG_WINDOW_RESIZABLE =  0x00000004, --Set to allow resizable window
	FLAG_WINDOW_UNDECORATED = 0x00000008, --Set to disable window decoration (frame & buttons)
	FLAG_WINDOW_HIDDEN = 0x00000080, --Set to hide window
	FLAG_WINDOW_MINIMIZED = 0x00000200, --Set to minimize window (iconify)
	FLAG_WINDOW_MAXIMIZED = 0x00000400, --Set to maximize window (expanded to monitor)
	FLAG_WINDOW_UNFOCUSED = 0x00000800, --Set to window non focused
	FLAG_WINDOW_TOPMOST = 0x00001000, --Set to windows always on top
	FLAG_WINDOW_ALWAYS_RUN = 0x00000100, --Set to allow windows running while minimized
	FLAG_WINDOW_TRANSPARENT = 0x00000010, --Set to allow transparent framebuffer
	FLAG_WINDOW_HIGHDPI = 0x00002000, --Set to support highDPI
	FLAG_WINDOW_MOUSE_PASSTHROUGH = 0x00004000, --Set to support mouse passthrough, only supported when FLAG_WINDOW_UNDECORATED
	FLAG_MSAA_4X_HINT = 0x00000020, --Set to try enabling MSAA 4X
	FLAG_INTERLACED_HINT = 0x00010000 --Set to try enabling interlaced video format (V3D)
end type

--Trace log level
public enum type TraceLogLevel
   LOG_ALL = 0,
   LOG_TRACE,
   LOG_DEBUG,
   LOG_INFO,
   LOG_WARNING,
   LOG_ERROR,
   LOG_FATAL,
   LOG_NONE
end type

--Mouse Cursor
public enum type MouseCursor
    MOUSE_CURSOR_DEFAULT = 0, --Default pointer shape
    MOUSE_CURSOR_ARROW = 1, --Arrow shape
    MOUSE_CURSOR_IBEAM = 2, --Text writing cursor shape
    MOUSE_CURSOR_CROSSHAIR = 3, --Cross shape
    MOUSE_CURSOR_POINTING_HAND = 4, --Pointing hand cursor
    MOUSE_CURSOR_RESIZE_EW = 5, --Horizontal resize/move arrow shape
    MOUSE_CURSOR_RESIZE_NS = 6, --Vertical resize/move arrow shape
    MOUSE_CURSOR_RESIZE_NWSE = 7, --Top-left to bottom-right diagonal resize/move arrow shape
    MOUSE_CURSOR_RESIZE_NESW = 8, --The top-right to bottom-left diagonal resize/move arrow shape
    MOUSE_CURSOR_RESIZE_ALL = 9, --The omni-directional resize/move cursor shape
    MOUSE_CURSOR_NOT_ALLOWED = 10 --The operation-not-allowed shape
end type

-- Keyboard keys (US keyboard layout)
-- NOTE: Use GetKeyPressed() to allow redefining
-- required keys for alternative layouts
public enum type KeyboardKey
	KEY_NULL            =   0,  -- Key: NULL, used for no key pressed
	-- Alphanumeric keys
	KEY_APOSTROPHE      =  39,  -- Key: '
	KEY_COMMA           =  44,  -- Key: ,
	KEY_MINUS           =  45,  -- Key: -
	KEY_PERIOD          =  46,  -- Key: .
	KEY_SLASH           =  47,  -- Key: /
	KEY_ZERO            =  48,  -- Key: 0
	KEY_ONE             =  49,  -- Key: 1
	KEY_TWO             =  50,  -- Key: 2
	KEY_THREE           =  51,  -- Key: 3
	KEY_FOUR            =  52,  -- Key: 4
	KEY_FIVE            =  53,  -- Key: 5
	KEY_SIX             =  54,  -- Key: 6
	KEY_SEVEN           =  55,  -- Key: 7
	KEY_EIGHT           =  56,  -- Key: 8
	KEY_NINE            =  57,  -- Key: 9
	KEY_SEMICOLON       =  59,  -- Key: ;
	KEY_EQUAL           =  61,  -- Key: =
	KEY_A               =  65,  -- Key: A | a
	KEY_B               =  66,  -- Key: B | b
	KEY_C               =  67,  -- Key: C | c
	KEY_D               =  68,  -- Key: D | d
	KEY_E               =  69,  -- Key: E | e
	KEY_F               =  70,  -- Key: F | f
	KEY_G               =  71,  -- Key: G | g
	KEY_H               =  72,  -- Key: H | h
	KEY_I               =  73,  -- Key: I | i
	KEY_J               =  74,  -- Key: J | j
	KEY_K               =  75,  -- Key: K | k
	KEY_L               =  76,  -- Key: L | l
	KEY_M               =  77,  -- Key: M | m
	KEY_N               =  78,  -- Key: N | n
	KEY_O               =  79,  -- Key: O | o
	KEY_P               =  80,  -- Key: P | p
	KEY_Q               =  81,  -- Key: Q | q
	KEY_R               =  82,  -- Key: R | r
	KEY_S               =  83,  -- Key: S | s
	KEY_T               =  84,  -- Key: T | t
	KEY_U               =  85,  -- Key: U | u
	KEY_V               =  86,  -- Key: V | v
	KEY_W               =  87,  -- Key: W | w
	KEY_X               =  88,  -- Key: X | x
	KEY_Y               =  89,  -- Key: Y | y
	KEY_Z               =  90,  -- Key: Z | z
	KEY_LEFT_BRACKET    =  91,  -- Key: [
	KEY_BACKSLASH       =  92,  -- Key: '\'
	KEY_RIGHT_BRACKET   =  93,  -- Key: ]
	KEY_GRAVE           =  96,  -- Key: `
	-- Function keys
	KEY_SPACE           =  32,  -- Key: Space
	KEY_ESCAPE          = 256,  -- Key: Esc
	KEY_ENTER           = 257,  -- Key: Enter
	KEY_TAB             = 258,  -- Key: Tab
	KEY_BACKSPACE       = 259,  -- Key: Backspace
	KEY_INSERT          = 260,  -- Key: Ins
	KEY_DELETE          = 261,  -- Key: Del
	KEY_RIGHT           = 262,  -- Key: Cursor right
	KEY_LEFT            = 263,  -- Key: Cursor left
	KEY_DOWN            = 264,  -- Key: Cursor down
	KEY_UP              = 265,  -- Key: Cursor up
	KEY_PAGE_UP         = 266,  -- Key: Page up
	KEY_PAGE_DOWN       = 267,  -- Key: Page down
	KEY_HOME            = 268,  -- Key: Home
	KEY_END             = 269,  -- Key: End
	KEY_CAPS_LOCK       = 280,  -- Key: Caps lock
	KEY_SCROLL_LOCK     = 281,  -- Key: Scroll down
	KEY_NUM_LOCK        = 282,  -- Key: Num lock
	KEY_PRINT_SCREEN    = 283,  -- Key: Print screen
	KEY_PAUSE           = 284,  -- Key: Pause
	KEY_F1              = 290,  -- Key: F1
	KEY_F2              = 291,  -- Key: F2
	KEY_F3              = 292,  -- Key: F3
	KEY_F4              = 293,  -- Key: F4
	KEY_F5              = 294,  -- Key: F5
	KEY_F6              = 295,  -- Key: F6
	KEY_F7              = 296,  -- Key: F7
	KEY_F8              = 297,  -- Key: F8
	KEY_F9              = 298,  -- Key: F9
	KEY_F10             = 299,  -- Key: F10
	KEY_F11             = 300,  -- Key: F11
	KEY_F12             = 301,  -- Key: F12
	KEY_LEFT_SHIFT      = 340,  -- Key: Shift left
	KEY_LEFT_CONTROL    = 341,  -- Key: Control left
	KEY_LEFT_ALT        = 342,  -- Key: Alt left
	KEY_LEFT_SUPER      = 343,  -- Key: Super left
	KEY_RIGHT_SHIFT     = 344,  -- Key: Shift right
	KEY_RIGHT_CONTROL   = 345,  -- Key: Control right
	KEY_RIGHT_ALT       = 346,  -- Key: Alt right
	KEY_RIGHT_SUPER     = 347,  -- Key: Super right
	KEY_KB_MENU         = 348,  -- Key: KB menu
	-- Keypad keys
	KEY_KP_0            = 320,  -- Key: Keypad 0
	KEY_KP_1            = 321,  -- Key: Keypad 1
	KEY_KP_2            = 322,  -- Key: Keypad 2
	KEY_KP_3            = 323,  -- Key: Keypad 3
	KEY_KP_4            = 324,  -- Key: Keypad 4
	KEY_KP_5            = 325,  -- Key: Keypad 5
	KEY_KP_6            = 326,  -- Key: Keypad 6
	KEY_KP_7            = 327,  -- Key: Keypad 7
	KEY_KP_8            = 328,  -- Key: Keypad 8
	KEY_KP_9            = 329,  -- Key: Keypad 9
	KEY_KP_DECIMAL      = 330,  -- Key: Keypad .
	KEY_KP_DIVIDE       = 331,  -- Key: Keypad /
	KEY_KP_MULTIPLY     = 332,  -- Key: Keypad *
	KEY_KP_SUBTRACT     = 333,  -- Key: Keypad -
	KEY_KP_ADD          = 334,  -- Key: Keypad +
	KEY_KP_ENTER        = 335,  -- Key: Keypad Enter
	KEY_KP_EQUAL        = 336   -- Key: Keypad =
end type

-- Mouse buttons
public enum type MouseButton
	MOUSE_BUTTON_LEFT    = 0,   -- Mouse button left
	MOUSE_BUTTON_RIGHT   = 1,   -- Mouse button right
	MOUSE_BUTTON_MIDDLE  = 2,   -- Mouse button middle (pressed wheel)
	MOUSE_BUTTON_SIDE    = 3,   -- Mouse button side (advanced mouse device)
	MOUSE_BUTTON_EXTRA   = 4,   -- Mouse button extra (advanced mouse device)
	MOUSE_BUTTON_FORWARD = 5,   -- Mouse button fordward (advanced mouse device)
	MOUSE_BUTTON_BACK    = 6    -- Mouse button back (advanced mouse device)
end type

--Gamepad Buttons
public enum type GamepadButton
   GAMEPAD_BUTTON_UNKNOWN = 0, --Unknown button, just for checking
   GAMEPAD_BUTTON_LEFT_FACE_UP, --Gamepad left DPad up button
   GAMEPAD_BUTTON_LEFT_FACE_RIGHT, --Gamepad left Dpad right button
   GAMEPAD_BUTTON_LEFT_FACE_DOWN, --Gamepad left dpad down button
   GAMEPAD_BUTTON_LEFT_FACE_LEFT, --Gamepad left dpad left button
   GAMEPAD_BUTTON_RIGHT_FACE_UP, --Gamepad right button up (Triangle or Y)
   GAMEPAD_BUTTON_RIGHT_FACE_RIGHT, --Gamepad right button right (Square or X)
   GAMEPAD_BUTTON_RIGHT_FACE_DOWN, --Gamepad right button down (Cross or A)
   GAMEPAD_BUTTON_RIGHT_FACE_LEFT, --Gamepad right button left(Circle or B)
   GAMEPAD_BUTTON_LEFT_TRIGGER_1, --Gamepad top/back trigger left (first)
   GAMEPAD_BUTTON_LEFT_TRIGGER_2, --Gamepad top/back trigger left (second)
   GAMEPAD_BUTTON_RIGHT_TRIGGER_1, --Gamepad top/back trigger right (first)
   GAMEPAD_BUTTON_RIGHT_TRIGGER_2, --Gamepad top/back trigger right (second)
   GAMEPAD_BUTTON_MIDDLE_LEFT, --Gamepad center button, left one
   GAMEPAD_BUTTON_MIDDLE, --Gamepad center button
   GAMEPAD_BUTTON_MIDDLE_RIGHT, --Gamepad center button, right one
   GAMEPAD_BUTTON_LEFT_THUMB, --Gamepad joystick pressed button left
   GAMEPAD_BUTTON_RIGHT_THUMB --Gamepad joystick pressed button right
end type

--Gamepad Axis
public enum type GamepadAxis
     GAMEPAD_AXIS_LEFT_X = 0, --Gamepad left stick X axis
     GAMEPAD_AXIS_LEFT_Y = 1, --Gamepad left stick Y axis
     GAMEPAD_AXIS_RIGHT_X = 2, --Gamepad right stick X axis
     GAMEPAD_AXIS_RIGHT_Y = 3, --Gamepad right stick Y axis
     GAMEPAD_AXIS_LEFT_TRIGGER = 4, --Gamepad back trigger left, pressure level: [1..-1]
     GAMEPAD_AXIS_RIGHT_TRIGGER = 5 --Gamepad back trigger right, pressure level: [1..-1]
end type

public enum type MaterialMapIndex
		MATERIAL_MAP_ALBEDO = 0, --Albedo material
		MATERIAL_MAP_METALNESS, --Metalness material
		MATERIAL_MAP_NORMAL, --Normal material
		MATERIAL_MAP_ROUGHNESS, --Roughness material
		MATERIAL_MAP_OCCLUSION, --Ambient occlusion material
		MATERIAL_MAP_EMISSION, --Emission material
		MATERIAL_MAP_HEIGHT, --Heightmap material
		MATERIAL_MAP_CUBEMAP, --Cubemap material
		MATERIAL_MAP_IRRADIANCE, --Irradiance material
		MATERIAL_MAP_PREFILTER, --Prefilter material
		MATERIAL_MAP_BRDF --Brdf material
end type

public constant MATERIAL_MAP_DIFFUSE = MATERIAL_MAP_ALBEDO
public constant MATERIAL_MAP_SPECULAR = MATERIAL_MAP_METALNESS

--Shader location index
public enum type ShaderLocationIndex
	SHADER_LOC_VERTEX_POSITION = 0, --Shader location: vertex attribute: position
	SHADER_LOC_VERTEX_TEXCOORD01, --Shader location: vertex attribute: texcoord01
	SHADER_LOC_VERTEX_TEXCOORD02, --Shader location: vertex attribute: texcoord02
	SHADER_LOC_VERTEX_NORMAL, --Shader location: vertex attribute: normal
	SHADER_LOC_VERTEX_TANGENT, --Shader location: vertex attribute: tangent
	SHADER_LOC_VERTEX_COLOR, --Shader location: vertex attribute: color
	SHADER_LOC_MATRIX_MVP, --Shader location: matrix uniform: model-view-position
	SHADER_LOC_MATRIX_VIEW, --Shader location: matrix uniform: view (camera transform)
	SHADER_LOC_MATRIX_PROJECTION, --Shader location: matrix uniform: projection
	SHADER_LOC_MATRIX_MODEL, --Shader location: matrix uniform: model (transform)
	SHADER_LOC_MATRIX_NORMAL, --Shader location: matrix uniform: normal
	SHADER_LOC_VECTOR_VIEW, --Shader location: vector uniform: view
	SHADER_LOC_COLOR_DIFFUSE, --Shader location: vector uniform: diffuse color
	SHADER_LOC_COLOR_SPECULAR, --Shader location: vector uniform: specular color
	SHADER_LOC_COLOR_AMBIENT, --Shader location: vector unifrom: ambient color
	SHADER_LOC_MAP_ALBEDO, --Shader location: sampler2d texture: albedo
	SHADER_LOC_MAP_METALNESS, --Shader location: sampler2d texture: metalness
	SHADER_LOC_MAP_NORMAL, --Shader location: sampler2d texture: normal
	SHADER_LOC_MAP_ROUGHNESS, --Shader location: sampler2d texture: roughness
	SHADER_LOC_MAP_OCCLUSION, --Shader location: sampler2d texture: occlusion
	SHADER_LOC_MAP_EMISSION, --Shader location: sampler2d texture: emission
	SHADER_LOC_MAP_HEIGHT, --Shader location: sampler2d texture: height
	SHADER_LOC_MAP_CUBEMAP, --Shader location: samplerCube texture: cubemap
	SHADER_LOC_MAP_IRRADIANCE, --Shader Location: samplercube texture: irradiance
	SHADER_LOC_MAP_PREFILTER, --Shader location: samplercube texture: prefilter
	SHADER_LOC_MAP_BRDF --Shader location: sampler2d texture: brdf
end type

public constant SHADER_LOC_MAP_DIFFUSE = SHADER_LOC_MAP_ALBEDO
public constant SHADER_LOC_MAP_SPECULAR = SHADER_LOC_MAP_METALNESS

--Shader uniform data type
public enum type ShaderUniformDataType
		SHADER_UNIFORM_FLOAT = 0, --Shader uniform type: float
		SHADER_UNIFORM_VEC2, --Shader uniform type: vec 2
		SHADER_UNIFORM_VEC3, --Shader uniform type: vec3
		SHADER_UNIFORM_VEC4, --Shader uniform type: vec4
		SHADER_UNIFORM_INT, --Shader uniform type: int
		SHADER_UNIFORM_IVEC2, --Shader uniform type: 2 int
		SHADER_UNIFORM_IVEC3, --Shader uniform type: 3 int
		SHADER_UNIFORM_IVEC4, --Shader uniform type: 4 int
		SHADER_UNIFORM_SAMPLER2D --Shader uniform type: sampler2d
end type

--Shader attribute data type
public enum type ShaderAttributeDataType
	SHADER_ATTRIB_FLOAT = 0, --Shader attribute type: float
	SHADER_ATTRIB_VEC2, --Shader attribute type: 2 float
	SHADER_ATTRIB_VEC3, --Shader attribute type: 3 float
	SHADER_ATTRIB_VEC4 --Shader attribute type: 4 float
end type

--Pixel formats
--Noye: Support depends on OPENGL version & platform
public enum type PixelFormat
	PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1, --8 bit per pixel no alpha
	PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA, --8*2 2 channels
	PIXELFORMAT_UNCOMPRESSED_R5G6B5, --16 bpp
	PIXELFORMAT_UNCOMPRESSED_R8G8B8, --       // 24 bpp
    PIXELFORMAT_UNCOMPRESSED_R5G5B5A1, --     // 16 bpp (1 bit alpha)
    PIXELFORMAT_UNCOMPRESSED_R4G4B4A4,  --    // 16 bpp (4 bit alpha)
    PIXELFORMAT_UNCOMPRESSED_R8G8B8A8,  --    // 32 bpp
    PIXELFORMAT_UNCOMPRESSED_R32,       --    // 32 bpp (1 channel - float)
    PIXELFORMAT_UNCOMPRESSED_R32G32B32,  --   // 32*3 bpp (3 channels - float)
    PIXELFORMAT_UNCOMPRESSED_R32G32B32A32,--  // 32*4 bpp (4 channels - float)
    PIXELFORMAT_COMPRESSED_DXT1_RGB,      --  // 4 bpp (no alpha)
    PIXELFORMAT_COMPRESSED_DXT1_RGBA,     --  // 4 bpp (1 bit alpha)
    PIXELFORMAT_COMPRESSED_DXT3_RGBA,     --  // 8 bpp
    PIXELFORMAT_COMPRESSED_DXT5_RGBA,     --  // 8 bpp
    PIXELFORMAT_COMPRESSED_ETC1_RGB,      --  // 4 bpp
    PIXELFORMAT_COMPRESSED_ETC2_RGB,      --  // 4 bpp
    PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA, --  // 8 bpp
    PIXELFORMAT_COMPRESSED_PVRT_RGB,      --  // 4 bpp
    PIXELFORMAT_COMPRESSED_PVRT_RGBA,      -- // 4 bpp
    PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA,  -- // 8 bpp
    PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA   -- // 2 bpp
end type

--Texture parameters: filter mode
--Note: Filtering considers mipmaps if available in the texture
--Note2: Filter is accordingly set for minifcation and magnification

public enum type TextureFilter
	TEXTURE_FILTER_POINT = 0,        --       // No filter, just pixel approximation
    TEXTURE_FILTER_BILINEAR,            --    // Linear filtering
    TEXTURE_FILTER_TRILINEAR,          --     // Trilinear filtering (linear with mipmaps)
    TEXTURE_FILTER_ANISOTROPIC_4X,      --    // Anisotropic filtering 4x
    TEXTURE_FILTER_ANISOTROPIC_8X,      --    // Anisotropic filtering 8x
    TEXTURE_FILTER_ANISOTROPIC_16X      --   // Anisotropic filtering 16x
end type

--Texture parameters: wrap mode
public enum type TextureWrap
	TEXTURE_WRAP_REPEAT = 0,             --   // Repeats texture in tiled mode
    TEXTURE_WRAP_CLAMP,                   --  // Clamps texture to edge pixel in tiled mode
    TEXTURE_WRAP_MIRROR_REPEAT,           --  // Mirrors and repeats the texture in tiled mode
    TEXTURE_WRAP_MIRROR_CLAMP             --  // Mirrors and
end type

--Cubemap layouts
public enum type CubemapLayout
	CUBEMAP_LAYOUT_AUTO_DETECT = 0,        -- // Automatically detect layout type
    CUBEMAP_LAYOUT_LINE_VERTICAL,         --  // Layout is defined by a vertical line with faces
    CUBEMAP_LAYOUT_LINE_HORIZONTAL,        -- // Layout is defined by an horizontal line with faces
    CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR,    -- // Layout is defined by a 3x4 cross with cubemap faces
    CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE,    -- // Layout is defined by a 4x3 cross with cubemap faces
    CUBEMAP_LAYOUT_PANORAMA    
end type

--Font type, defines generation method
public enum type FontType
	FONT_DEFAULT = 0,          --     // Default font generation, anti-aliased
    FONT_BITMAP,                --    // Bitmap font generation, no anti-aliasing
    FONT_SDF    --SDF font generation, requires external shader
end type

--Color blending modes (pre-defined)
public enum type BlendMode
     BLEND_ALPHA = 0, --Blend textures considering alpha (default)
     BLEND_ADDITIVE, --Blend textures adding colors
     BLEND_MULTIPLIED, --Blend textures multiplying colors
     BLEND_ADD_COLORS, --Blend textures adding colors (alternative)
     BLEND_SUBTRACT_COLORS, --Blend textures subtracting colors (alternative)
     BLEND_ALPHA_PREMULTIPLY, --Blend premultiplied textures considering alpha
     BLEND_CUSTOM --Blend textures using custom src/dst factors (use rlSetBlendMode() )
end type

--Gesture
--Note: It could be used as flags to enable only some gestures
public enum type Gesture
	GESTURE_NONE        = 0,       -- // No gesture
    GESTURE_TAP         = 1,       -- // Tap gesture
    GESTURE_DOUBLETAP   = 2,       -- // Double tap gesture
    GESTURE_HOLD        = 4,       -- // Hold gesture
    GESTURE_DRAG        = 8,       -- // Drag gesture
    GESTURE_SWIPE_RIGHT = 16,      -- // Swipe right gesture
    GESTURE_SWIPE_LEFT  = 32,      -- // Swipe left gesture
    GESTURE_SWIPE_UP    = 64,      -- // Swipe up gesture
    GESTURE_SWIPE_DOWN  = 128,     -- // Swipe down gesture
    GESTURE_PINCH_IN    = 256,     --// Pinch in gesture
    GESTURE_PINCH_OUT   = 512      -- // Pinch out gesture
end type

--Camera system modes
public enum type CameraMode
   CAMERA_CUSTOM = 0, --Custom camera
   CAMERA_FREE, --Free Camera
   CAMERA_ORBITAL, --Orbital camera
   CAMERA_FIRST_PERSON, --First person camera
   CAMERA_THIRD_PERSON --Third person camera
end type

-- Camera projection
public enum type CameraProjection
	CAMERA_PERSPECTIVE = 0,   -- Perspective projection
	CAMERA_ORTHOGRAPHIC       -- Orthographic projection
end type

--N-patch layout
public enum type NPatchLayout
	NPATCH_NINE_PATCH = 0, --Npatch layout: 3x3 tiles
	 NPATCH_THREE_PATCH_VERTICAL,  --  // Npatch layout: 1x3 tiles
    NPATCH_THREE_PATCH_HORIZONTAL  -- // Npatch layout: 3x1 tiles
end type

export constant raylib = open_dll( "raylib.dll" ),
	xInitWindow         = define_c_proc( raylib, "+InitWindow", {C_INT,C_INT,C_STRING} ),
	xWindowShouldClose  = define_c_func( raylib, "+WindowShouldClose", {}, C_BOOL ),
	xCloseWindow        = define_c_proc( raylib, "+CloseWindow", {} ),
	xGetWindowPosition  = define_c_func( raylib, "+GetWindowPosition", {}, RL_VECTOR2 ),
	xGetScreenToWorld2D = define_c_func( raylib, "+GetScreenToWorld2D", {RL_VECTOR2,RL_CAMERA2D}, RL_VECTOR2 ),
	xSetTargetFPS       = define_c_proc( raylib, "+SetTargetFPS", {C_INT} ),
	xGetFPS				= define_c_func( raylib, "+GetFPS", {}, C_INT),
	xGetFrameTime		= define_c_func( raylib, "+GetFrameTime",{}, C_FLOAT),
	xGetTime			= define_c_func( raylib, "+GetTime",{}, C_DOUBLE),
	xGetRandomValue     = define_c_func( raylib, "+GetRandomValue", {C_INT,C_INT}, C_INT ),
	xSetRandomSeed      = define_c_proc( raylib, "+SetRandomSeed", {C_UINT} ),
	xTakeScreenshot     = define_c_proc( raylib, "+TakeScreenshot", {C_STRING} ),
	xSetConfigFlags     = define_c_proc( raylib, "+SetConfigFlags", {C_UINT} ),
	xClearBackground    = define_c_proc( raylib, "+ClearBackground", {RL_COLOR} ),
	xBeginDrawing       = define_c_proc( raylib, "+BeginDrawing", {} ),
	xEndDrawing         = define_c_proc( raylib, "+EndDrawing", {} ),
	xBeginMode2D        = define_c_proc( raylib, "+BeginMode2D", {RL_CAMERA2D} ),
	xEndMode2D          = define_c_proc( raylib, "+EndMode2D", {} ),
	xBeginMode3D        = define_c_proc( raylib, "+BeginMode3D", {RL_CAMERA3D} ),
	xEndMode3D          = define_c_proc( raylib, "+EndMode3D", {} ),
	xBeginBlendMode     = define_c_proc( raylib, "+BeginBlendMode", {C_INT} ),
	xEndBlendMode       = define_c_proc( raylib, "+EndBlendMode", {} ),
	xIsKeyPressed       = define_c_func( raylib, "+IsKeyPressed", {C_INT}, C_BOOL ),
	xIsKeyDown          = define_c_func( raylib, "+IsKeyDown", {C_INT}, C_BOOL ),
	xIsKeyReleased      = define_c_func( raylib, "+IsKeyReleased", {C_INT}, C_BOOL ),
	xIsKeyUp            = define_c_func( raylib, "+IsKeyUp", {C_INT}, C_BOOL),
	xSetExitKey         = define_c_proc( raylib, "+SetExitKey", {C_INT} ),
	xGetKeyPressed      = define_c_func( raylib, "+GetKeyPressed",{}, C_INT),
	xGetCharPressed     = define_c_func( raylib, "+GetCharPressed",{}, C_INT),
	xIsMouseButtonDown  = define_c_func( raylib, "+IsMouseButtonDown", {C_INT}, C_BOOL ),
	xIsMouseButtonPressed = define_c_func( raylib, "+IsMouseButtonPressed", {C_INT}, C_BOOL),
	xIsMouseButtonReleased = define_c_func( raylib, "+IsMouseButtonReleased", {C_INT}, C_BOOL),
	xIsMouseButtonUp	= define_c_func( raylib, "+IsMouseButtonUp", {C_INT}, C_BOOL),
	xGetMousePosition   = define_c_func( raylib, "+GetMousePosition", {}, RL_VECTOR2 ),
	xGetMouseDelta      = define_c_func( raylib, "+GetMouseDelta", {}, RL_VECTOR2 ),
	xGetMouseWheelMove  = define_c_func( raylib, "+GetMouseWheelMove", {}, C_FLOAT ),
	xGetMouseWheelMoveV = define_c_func( raylib, "+GetMouseWheelMoveV", {}, RL_VECTOR2),
	xDrawPixel          = define_c_proc( raylib, "+DrawPixel", {C_INT, C_INT, RL_COLOR} ),
	xDrawPixelV			= define_c_proc( raylib,"+DrawPixelV",{RL_VECTOR2,RL_COLOR}),
	xDrawLine           = define_c_proc( raylib, "+DrawLine", {C_INT,C_INT,C_INT,C_INT,RL_COLOR} ),
	xDrawCircle         = define_c_proc( raylib, "+DrawCircle", {C_INT,C_INT,C_FLOAT,RL_COLOR} ),
	xDrawCircleV        = define_c_proc( raylib, "+DrawCircleV", {RL_VECTOR2, C_FLOAT, RL_COLOR} ),
	xDrawRectangle      = define_c_proc( raylib, "+DrawRectangle", {C_INT,C_INT,C_INT,C_INT,RL_COLOR} ),
	xDrawRectangleRec   = define_c_proc( raylib, "+DrawRectangleRec", {RL_RECTANGLE,RL_COLOR} ),
	xDrawRectangleV		= define_c_proc( raylib,"+DrawRectangleV",{RL_VECTOR2,RL_VECTOR2,RL_COLOR}),
	xDrawRectanglePro   = define_c_proc( raylib,"+DrawRectanglePro",{RL_RECTANGLE,RL_VECTOR2,C_FLOAT,RL_COLOR}),
	xDrawRectangleGradientV = define_c_proc(raylib,"+DrawRectangleGradientV",{C_INT,C_INT,C_INT,C_INT,RL_COLOR,RL_COLOR}),
	xDrawRectangleGradientH = define_c_proc(raylib,"+DrawRectangleGradientH",{C_INT,C_INT,C_INT,C_INT,RL_COLOR,RL_COLOR}),
	xDrawRectangleGradientEx = define_c_proc(raylib,"+DrawRectangleGradientEx",{RL_RECTANGLE,RL_COLOR,RL_COLOR,RL_COLOR,RL_COLOR}),
	xDrawRectangleLinesEx = define_c_proc(raylib,"+DrawRectangleLinesEx",{RL_RECTANGLE,C_FLOAT,RL_COLOR}),
	xDrawRectangleRounded = define_c_proc(raylib,"+DrawRectangleRounded",{RL_RECTANGLE,C_FLOAT,C_INT,RL_COLOR}),
	xDrawRectangleRoundedLines = define_c_proc(raylib,"+DrawRectangleRoundedLines",{RL_RECTANGLE,C_FLOAT,C_INT,C_FLOAT,RL_COLOR}),
	xDrawRectangleLines = define_c_proc( raylib, "+DrawRectangleLines", {C_INT,C_INT,C_INT,C_INT,RL_COLOR} ),
	xFade               = define_c_func( raylib, "+Fade", {RL_COLOR,C_FLOAT}, RL_COLOR ),
	xDrawFPS            = define_c_proc( raylib, "+DrawFPS", {C_INT,C_INT} ),
	xDrawText           = define_c_proc( raylib, "+DrawText", {C_STRING,C_INT,C_INT,C_INT,RL_COLOR} ),
	xDrawCube           = define_c_proc( raylib, "+DrawCube", {RL_VECTOR3,C_FLOAT,C_FLOAT,C_FLOAT,RL_COLOR} ),
	xDrawCubeWires      = define_c_proc( raylib, "+DrawCubeWires", {RL_VECTOR3,C_FLOAT,C_FLOAT,C_FLOAT,RL_COLOR} ),
	xDrawGrid           = define_c_proc( raylib, "+DrawGrid", {C_INT,C_FLOAT} ),
	xOpenURL            = define_c_proc( raylib, "+OpenURL", {C_STRING} ),
	xGetMouseRay        = define_c_func( raylib, "+GetMouseRay", {RL_VECTOR2, RL_CAMERA}, RL_RAY),
	xGetCameraMatrix    = define_c_func( raylib, "+GetCameraMatrix", {RL_CAMERA}, RL_MATRIX),
	xGetCameraMatrix2D  = define_c_func( raylib, "+GetCameraMatrix2D", {RL_CAMERA2D}, RL_MATRIX),
	xGetWorldToScreen   = define_c_func( raylib, "+GetWorldToScreen", {RL_VECTOR3, RL_CAMERA}, RL_VECTOR2),
	xGetWorldToScreenEx = define_c_func( raylib, "+GetWorldToScreenEx", {RL_VECTOR3, RL_CAMERA, C_INT, C_INT}, RL_VECTOR2),
	xGetWorldToScreen2D = define_c_func( raylib, "+GetWorldToScreen2D", {RL_VECTOR2, RL_CAMERA2D}, RL_VECTOR2),
	xGetScreenWidth     = define_c_func( raylib, "+GetScreenWidth", {}, C_INT),
	xGetScreenHeight    = define_c_func( raylib, "+GetScreenHeight", {}, C_INT),
	xGetMouseX		 	= define_c_func( raylib, "+GetMouseX", {}, C_INT),
	xGetMouseY			= define_c_func( raylib, "+GetMouseY",{}, C_INT),
	xSetMousePosition	= define_c_proc( raylib, "+SetMousePosition", {C_INT, C_INT}),
	xSetMouseOffset		= define_c_proc( raylib, "+SetMouseOffset",{C_INT, C_INT}),
	xSetMouseScale		= define_c_proc( raylib, "+SetMouseScale",{C_FLOAT, C_FLOAT}),
	xSetMouseCursor		= define_c_proc( raylib, "+SetMouseCursor",{C_INT}),
	xIsWindowReady		= define_c_func( raylib, "+IsWindowReady",{},C_BOOL),
	xIsWindowFullscreen = define_c_func( raylib, "+IsWindowFullscreen",{}, C_BOOL),
	xIsWindowHidden		= define_c_func( raylib, "+IsWindowHidden",{},C_BOOL),
	xIsWindowMinimized  = define_c_func( raylib, "+IsWindowMinimized",{},C_BOOL),
	xIsWindowMaximized  = define_c_func( raylib, "+IsWindowMaximized",{},C_BOOL),
	xIsWindowFocused	= define_c_func( raylib, "+IsWindowFocused",{},C_BOOL),
	xIsWindowResized	= define_c_func( raylib, "+IsWindowResized",{},C_BOOL),
	xIsWindowState		= define_c_func( raylib,"+IsWindowState",{C_UINT},C_BOOL),
	xSetWindowState		= define_c_proc( raylib,"+SetWindowState",{C_UINT}),
	xClearWindowState	= define_c_proc( raylib,"+ClearWindowState",{C_UINT}),
	xToggleFullscreen	= define_c_proc( raylib,"+ToggleFullscreen",{}),
	xMaximizeWindow		= define_c_proc( raylib,"+MaximizeWindow",{}),
	xMinimizeWindow		= define_c_proc( raylib,"+MinimizeWindow",{}),
	xRestoreWindow		= define_c_proc( raylib,"+RestoreWindow",{}),
	xSetWindowIcon		= define_c_proc( raylib,"+SetWindowIcon",{RL_IMAGE}),
	xSetWindowTitle		= define_c_proc( raylib,"+SetWindowTitle",{C_STRING}),
	xSetWindowPosition	= define_c_proc( raylib,"+SetWindowPosition",{C_INT,C_INT}),
	xSetWindowMonitor	= define_c_proc( raylib,"+SetWindowMonitor",{C_INT}),
	xSetWindowMinSize	= define_c_proc( raylib,"+SetWindowMinSize",{C_INT,C_INT}),
	xSetWindowOpacity 	= define_c_proc( raylib,"+SetWindowOpacity",{C_FLOAT}),
	xGetWindowHandle	= define_c_func( raylib,"+GetWindowHandle",{},C_POINTER),
	--xGetScreenWidth	= define_c_func( raylib,"+GetScreenWidth",{},C_INT),
	--xGetScreenHeight	= define_c_func( raylib, "+GetScreenHeight",{},C_INT),
	xGetRenderWidth		= define_c_func( raylib,"+GetRenderWidth",{},C_INT),
	xGetRenderHeight	= define_c_func( raylib,"+GetRenderHeight",{},C_INT),
	xGetMonitorCount	= define_c_func( raylib,"+GetMonitorCount",{},C_INT),
	xGetCurrentMonitor	= define_c_func( raylib,"+GetCurrentMonitor",{},C_INT),
	xGetMonitorWidth	= define_c_func( raylib,"+GetMonitorWidth",{C_INT},C_INT),
	xGetMonitorHeight	= define_c_func( raylib,"+GetMonitorHeight",{C_INT},C_INT),
	xGetMonitorPhysicalWidth = define_c_func(raylib,"+GetMonitorPhysicalWidth",{C_INT},C_INT),
	xGetMonitorPhysicalHeight = define_c_func(raylib,"+GetMonitorPhysicalHeight",{C_INT},C_INT),
	xGetMonitorRefreshRate	= define_c_func(raylib,"+GetMonitorRefreshRate",{C_INT},C_INT),
	xGetWindowScaleDPI = define_c_func(raylib,"+GetWindowScaleDPI",{},RL_VECTOR2),
	xGetMonitorName	= define_c_func(raylib,"+GetMonitorName",{C_INT},C_STRING),
	xSetClipboardText = define_c_proc(raylib,"+SetClipboardText",{C_STRING}),
	xGetClipboardText = define_c_func(raylib,"+GetClipboardText",{},C_STRING),
	xEnableEventWaiting = define_c_proc(raylib,"+EnableEventWaiting",{}),
	xDisableEventWaiting = define_c_proc(raylib,"+DisableEventWaiting",{}),
	xGetMonitorPosition = define_c_func(raylib,"+GetMonitorPosition",{C_INT},RL_VECTOR2),
	xSwapScreenBuffer = define_c_proc(raylib,"+SwapScreenBuffer",{}),
	xPollInputEvents = define_c_proc(raylib,"+PollInputEvents",{}),
	xWaitTime		= define_c_proc(raylib,"+WaitTime",{C_DOUBLE}),
	xShowCursor		= define_c_proc(raylib,"+ShowCursor",{}),
	xHideCursor		= define_c_proc(raylib,"+HideCursor",{}),
	xIsCursorHidden	= define_c_func(raylib,"+IsCursorHidden",{},C_BOOL),
	xEnableCursor = define_c_proc(raylib,"+EnableCursor",{}),
	xDisableCursor	= define_c_proc(raylib,"+DisableCursor",{}),
	xIsCursorOnScreen = define_c_func(raylib,"+IsCursorOnScreen",{},C_BOOL),
	xBeginTextureMode = define_c_proc(raylib,"+BeginTextureMode",{RL_TEXTURE2D}),
	xEndTextureMode	  = define_c_proc(raylib,"+EndTextureMode",{}),
	xBeginShaderMode  = define_c_proc(raylib,"+BeginShaderMode",{RL_SHADER}),
	xEndShaderMode	  = define_c_proc(raylib,"+EndShaderMode",{}),
	xBeginScissorMode = define_c_proc(raylib,"+BeginScissorMode",{C_INT,C_INT,C_INT,C_INT}),
	xEndScissorMode	 = define_c_proc(raylib,"+EndScissorMode",{}),
	xBeginVrStereoMode = define_c_proc(raylib,"+BeginVrStereoMode",{RL_VRSTEREOCONFIG}),
	xEndVrStereoMode = define_c_proc(raylib,"+EndVrStereoMode",{}),
	xLoadVrStereoConfig = define_c_func(raylib,"+LoadVrStereoConfig",{RL_VRDEVICEINFO},RL_VRSTEREOCONFIG),
	xUnloadVrStereoConfig = define_c_proc(raylib,"+UnloadVrStereoConfig",{RL_VRSTEREOCONFIG}),
	xLoadShader	= define_c_func(raylib,"+LoadShader",{C_STRING,C_STRING},RL_SHADER),
	xLoadShaderFromMemory = define_c_func(raylib,"+LoadShaderFromMemory",{C_STRING,C_STRING},RL_SHADER),
	xGetShaderLocation = define_c_func(raylib,"+GetShaderLocation",{RL_SHADER,C_STRING},C_INT),
	xGetShaderLocationAttrib = define_c_func(raylib,"+GetShaderLocationAttrib",{RL_SHADER,C_STRING},C_INT),
	xSetShaderValue = define_c_proc(raylib,"+SetShaderValue",{RL_SHADER,C_INT,C_POINTER,C_INT}),
	xSetShaderValueMatrix = define_c_proc(raylib,"+SetShaderValueMatrix",{RL_SHADER,C_INT,RL_MATRIX}),
	xSetShaderValueTexture = define_c_proc(raylib,"+SetShaderValueTexture",{RL_SHADER,C_INT,RL_TEXTURE2D}),
	xUnloadShader = define_c_proc(raylib,"+UnloadShader",{RL_SHADER}),
	xSetShaderValueV = define_c_proc(raylib,"+SetShaderValueV",{RL_SHADER,C_INT,C_POINTER,C_INT,C_INT}),
	xTraceLog = define_c_proc(raylib,"+TraceLog",{C_INT,C_STRING}),
	xSetTraceLogLevel = define_c_proc(raylib,"+SetTraceLogLevel",{C_INT}),
	xMemAlloc = define_c_func(raylib,"+MemAlloc",{C_INT},C_POINTER),
	xMemRealloc = define_c_proc(raylib,"+MemRealloc",{C_POINTER,C_INT}),
	xMemFree = define_c_proc(raylib,"+MemFree",{C_POINTER}),
	xSetShapesTexture = define_c_proc(raylib,"+SetShapesTexture",{RL_TEXTURE2D,RL_RECTANGLE}),
	xDrawLineV = define_c_proc(raylib,"+DrawLineV",{RL_VECTOR2,RL_VECTOR2,RL_COLOR}),
	xDrawLineEx = define_c_proc(raylib,"+DrawLineEx",{RL_VECTOR2,RL_VECTOR2,C_FLOAT,RL_COLOR}),
	xDrawLineBezier = define_c_proc(raylib,"+DrawLineBezier",{RL_VECTOR2,RL_VECTOR2,C_FLOAT,RL_COLOR}),
	xDrawLineBezierQuad = define_c_proc(raylib,"+DrawLineBezierQuad",{RL_VECTOR2,RL_VECTOR2,RL_VECTOR2,C_FLOAT,RL_COLOR}),
	xDrawLineBezierCubic = define_c_proc(raylib,"+DrawLineBezierCubic",{RL_VECTOR2,RL_VECTOR2,RL_VECTOR2,RL_VECTOR2,C_FLOAT,RL_COLOR}),
	xDrawLineStrip = define_c_proc(raylib,"+DrawLineStrip",{RL_VECTOR2,C_INT,RL_COLOR}),
	xDrawCircleSector = define_c_proc(raylib,"+DrawCircleSector",{RL_VECTOR2,C_FLOAT,C_FLOAT,C_FLOAT,C_INT,RL_COLOR}),
	xDrawCircleSectorLines = define_c_proc(raylib,"+DrawCircleSectorLines",{RL_VECTOR2,C_FLOAT,C_FLOAT,C_FLOAT,C_INT,RL_COLOR}),
	xDrawCircleGradient = define_c_proc(raylib,"+DrawCircleGradient",{C_INT,C_INT,C_FLOAT,RL_COLOR,RL_COLOR}),
	xDrawCircleLines = define_c_proc(raylib,"+DrawCircleLines",{C_INT,C_INT,C_FLOAT,RL_COLOR}),
	xLoadFileData = define_c_func(raylib,"+LoadFileData",{C_STRING,C_POINTER},C_POINTER),
	xUnloadFileData = define_c_proc(raylib,"+UnloadFileData",{C_POINTER}),
	xSaveFileData = define_c_func(raylib,"+SaveFileData",{C_STRING,C_POINTER,C_UINT},C_BOOL),
	xExportDataAsCode = define_c_func(raylib,"+ExportDataAsCode",{C_STRING,C_UINT,C_STRING},C_BOOL),
	xLoadFileText = define_c_func(raylib,"+LoadFileText",{C_STRING},C_POINTER),
	xUnloadFileText = define_c_proc(raylib,"+UnloadFileText",{C_STRING}),
	xSaveFileText = define_c_func(raylib,"+SaveFileText",{C_STRING,C_STRING},C_BOOL),
	xFileExists = define_c_func(raylib,"+FileExists",{C_STRING},C_BOOL),
	xDirectoryExists = define_c_func(raylib,"+DirectoryExists",{C_STRING},C_BOOL),
	xIsFileExtension = define_c_func(raylib,"+IsFileExtension",{C_STRING,C_STRING},C_BOOL),
	xGetFileLength = define_c_func(raylib,"+GetFileLength",{C_STRING},C_INT),
	xGetFileExtension = define_c_func(raylib,"+GetFileExtension",{C_STRING},C_STRING),
	xGetFileName = define_c_func(raylib,"+GetFileName",{C_STRING},C_STRING),
	xGetFileNameWithoutExt = define_c_func(raylib,"+GetFileNameWithoutExt",{C_STRING},C_STRING),
	xGetDirectoryPath = define_c_func(raylib,"+GetDirectoryPath",{C_STRING},C_STRING),
	xGetPrevDirectoryPath = define_c_func(raylib,"+GetPrevDirectoryPath",{C_STRING},C_STRING),
	xGetWorkingDirectory = define_c_func(raylib,"+GetWorkingDirectory",{},C_STRING),
	xGetApplicationDirectory = define_c_func(raylib,"+GetApplicationDirectory",{},C_STRING),
	xChangeDirectory = define_c_func(raylib,"+ChangeDirectory",{C_STRING},C_BOOL),
	xIsPathFile = define_c_func(raylib,"+IsPathFile",{C_STRING},C_BOOL),
	xLoadDirectoryFiles = define_c_func(raylib,"+LoadDirectoryFiles",{C_STRING},C_INT),
	xLoadDirectoryFilesEx = define_c_func(raylib,"+LoadDirectoryFilesEx",{C_STRING,C_STRING,C_BOOL},C_INT),
	xUnloadDirectoryFiles = define_c_proc(raylib,"+UnloadDirectoryFiles",{C_INT}),
	xIsFileDropped = define_c_func(raylib,"+IsFileDropped",{},C_BOOL),
	xLoadDroppedFiles = define_c_func(raylib,"+LoadDroppedFiles",{},C_INT),
	xUnloadDroppedFiles = define_c_proc(raylib,"+UnloadDroppedFiles",{C_INT}),
	xGetFileModTime = define_c_func(raylib,"+GetFileModTime",{C_STRING},C_LONG),
	xCompressData = define_c_func(raylib,"+CompressData",{C_STRING,C_INT,C_POINTER},C_STRING),
	xDecompressData = define_c_func(raylib,"+DecompressData",{C_STRING,C_INT,C_POINTER},C_STRING),
	xEncodeDataBase64 = define_c_func(raylib,"+EncodeDataBase64",{C_STRING,C_INT,C_POINTER},C_STRING),
	xDecodeDataBase64 = define_c_func(raylib,"+DecodeDataBase64",{C_STRING,C_POINTER},C_STRING),
	xIsGamepadAvailable = define_c_func(raylib,"+IsGamepadAvailable",{C_INT},C_BOOL),
	xGetGamepadName = define_c_func(raylib,"+GetGamepadName",{C_INT},C_STRING),
	xIsGamepadButtonPressed = define_c_func(raylib,"+IsGamepadButtonPressed",{C_INT,C_INT},C_BOOL),
	xIsGamepadButtonDown = define_c_func(raylib,"+IsGamepadButtonDown",{C_INT,C_INT},C_BOOL),
	xIsGamepadButtonReleased = define_c_func(raylib,"+IsGamepadButtonReleased",{C_INT,C_INT},C_BOOL),
	xIsGamepadButtonUp = define_c_func(raylib,"+IsGamepadButtonUp",{C_INT,C_INT},C_BOOL),
	xGetGamepadButtonPressed = define_c_func(raylib,"+GetGamepadButtonPressed",{},C_INT),
	xGetGamepadAxisCount = define_c_func(raylib,"+GetGamepadAxisCount",{C_INT},C_INT),
	xGetGamepadAxisMovement = define_c_func(raylib,"+GetGamepadAxisMovement",{C_INT,C_INT},C_FLOAT),
	xSetGamepadMappings = define_c_func(raylib,"+SetGamepadMappings",{C_STRING},C_INT),
	xGetTouchX = define_c_func(raylib,"+GetTouchX",{},C_INT),
	xGetTouchY = define_c_func(raylib,"+GetTouchY",{},C_INT),
	xGetTouchPosition = define_c_func(raylib,"+GetTouchPosition",{C_INT},RL_VECTOR2),
	xGetTouchPointId = define_c_func(raylib,"+GetTouchPointId",{C_INT},C_INT),
	xGetTouchPointCount = define_c_func(raylib,"+GetTouchPointCount",{},C_INT),
	xSetGesturesEnabled = define_c_proc(raylib,"+SetGesturesEnabled",{C_UINT}),
	xIsGestureDetected = define_c_func(raylib,"+IsGestureDetected",{C_INT},C_BOOL),
	xGetGestureDetected = define_c_func(raylib,"+GetGestureDetected",{},C_INT),
	xGetGestureHoldDuration = define_c_func(raylib,"+GetGestureHoldDuration",{},C_FLOAT),
	xGetGestureDragVector = define_c_func(raylib,"+GetGestureDragVector",{},RL_VECTOR2),
	xGetGestureDragAngle = define_c_func(raylib,"+GetGestureDragAngle",{},C_FLOAT),
	xGetGesturePinchVector = define_c_func(raylib,"+GetGesturePinchVector",{},RL_VECTOR2),
	xGetGesturePinchAngle = define_c_func(raylib,"+GetGesturePinchAngle",{},C_FLOAT),
	xSetCameraMode = define_c_proc(raylib,"+SetCameraMode",{RL_CAMERA,C_INT}),
	xUpdateCamera = define_c_proc(raylib,"+UpdateCamera",{RL_CAMERA}),
	xSetCameraPanControl = define_c_proc(raylib,"+SetCameraPanControl",{C_INT}),
	xSetCameraAltControl = define_c_proc(raylib,"+SetCameaAltControl",{C_INT}),
	xSetCameraSmoothZoomControl = define_c_proc(raylib,"+SetCameraSmoothZoomControl",{C_INT}),
	xSetCameraMoveControls = define_c_proc(raylib,"+SetCameraMoveControls",{C_INT,C_INT,C_INT,C_INT,C_INT,C_INT}),
	xDrawEllipse = define_c_proc(raylib,"+DrawEllipse",{C_INT,C_INT,C_FLOAT,C_FLOAT,RL_COLOR}),
	xDrawEllipseLines = define_c_proc(raylib,"+DrawEllipseLines",{C_INT,C_INT,C_FLOAT,C_FLOAT,RL_COLOR}),
	xDrawRing = define_c_proc(raylib,"+DrawRing",{RL_VECTOR2,C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT,C_INT,RL_COLOR}),
	xDrawRingLines = define_c_proc(raylib,"+DrawRingLines",{RL_VECTOR2,C_FLOAT,C_FLOAT,C_FLOAT,C_FLOAT,C_INT,RL_COLOR}),
	xDrawTriangle = define_c_proc(raylib,"+DrawTriangle",{RL_VECTOR2,RL_VECTOR2,RL_VECTOR2,RL_COLOR}),
	xDrawTriangleFan = define_c_proc(raylib,"+DrawTriangleFan",{RL_VECTOR2,C_INT,RL_COLOR}),
	xDrawTriangleStrip = define_c_proc(raylib,"+DrawTriangleStrip",{RL_VECTOR2,C_INT,RL_COLOR}),
	xDrawPoly = define_c_proc(raylib,"+DrawPoly",{RL_VECTOR2,C_INT,C_FLOAT,C_FLOAT,RL_COLOR}),
	xDrawPolyLines = define_c_proc(raylib,"+DrawPolyLines",{RL_VECTOR2,C_INT,C_FLOAT,C_FLOAT,RL_COLOR}),
	xDrawPolyLinesEx = define_c_proc(raylib,"+DrawPolyLinesEx",{RL_VECTOR2,C_INT,C_FLOAT,C_FLOAT,C_FLOAT,RL_COLOR}),
	xCheckCollisionRecs = define_c_func(raylib,"+CheckCollisionRecs",{RL_RECTANGLE,RL_RECTANGLE},C_BOOL),
	xCheckCollisionCircles = define_c_func(raylib,"+CheckCollisionCircles",{RL_VECTOR2,C_FLOAT,RL_VECTOR2,C_FLOAT},C_BOOL),
	xCheckCollisionCircleRec = define_c_func(raylib,"+CheckCollisionCircleRec",{RL_VECTOR2,C_FLOAT,RL_RECTANGLE},C_BOOL),
	xCheckCollisionPointRec = define_c_func(raylib,"+CheckCollisionPointRec",{RL_VECTOR2,RL_RECTANGLE},C_BOOL),
	xCheckCollisionPointCircle = define_c_func(raylib,"+CheckCollisionPointCircle",{RL_VECTOR2,RL_VECTOR2,C_FLOAT},C_BOOL),
	xCheckCollisionPointTriangle = define_c_func(raylib,"+CheckCollisionPointTriangle",{RL_VECTOR2,RL_VECTOR2,RL_VECTOR2,RL_VECTOR2},C_BOOL),
	xCheckCollisionLines = define_c_func(raylib,"+CheckCollisionLines",{RL_VECTOR2,RL_VECTOR2,RL_VECTOR2,RL_VECTOR2,RL_VECTOR2},C_BOOL),
	xCheckCollisionPointLine = define_c_func(raylib,"+CheckCollisionPointLine",{RL_VECTOR2,RL_VECTOR2,RL_VECTOR2,C_INT},C_BOOL),
	xGetCollisionRec = define_c_func(raylib,"+GetCollisionRec",{RL_RECTANGLE,RL_RECTANGLE},RL_RECTANGLE),
	xLoadImage = define_c_func(raylib,"+LoadImage",{C_STRING},RL_IMAGE),
	xLoadImageRaw = define_c_func(raylib,"+LoadImageRaw",{C_STRING,C_INT,C_INT,C_INT,C_INT},RL_IMAGE),
	xLoadImageAnim = define_c_func(raylib,"+LoadImageAnim",{C_STRING,C_POINTER},RL_IMAGE),
	xLoadImageFromMemory = define_c_func(raylib,"+LoadImageFromMemory",{C_STRING,C_POINTER,C_INT},RL_IMAGE),
	xLoadImageFromTexture = define_c_func(raylib,"+LoadImageFromTexture",{RL_TEXTURE2D},RL_IMAGE),
	xLoadImageFromScreen = define_c_func(raylib,"+LoadImageFromScreen",{},RL_IMAGE),
	xUnloadImage = define_c_proc(raylib,"+UnloadImage",{RL_IMAGE}),
	xExportImage = define_c_func(raylib,"+ExportImage",{RL_IMAGE,C_STRING},C_BOOL),
	xExportImageAsCode = define_c_func(raylib,"+ExportImageAsCode",{RL_IMAGE,C_STRING},C_BOOL),
	xGenImageColor = define_c_func(raylib,"+GenImageColor",{C_INT,C_INT,RL_COLOR},RL_IMAGE),
	xGenImageGradientV = define_c_func(raylib,"+GenImageGradientV",{C_INT,C_INT,RL_COLOR,RL_COLOR},RL_IMAGE),
	xGenImageGradientH = define_c_func(raylib,"+GenImageGradientH",{C_INT,C_INT,RL_COLOR,RL_COLOR},RL_IMAGE),
	xGenImageGradientRadial = define_c_func(raylib,"+GenImageGradientRadial",{C_INT,C_INT,C_FLOAT,RL_COLOR,RL_COLOR},RL_IMAGE),
	xGenImageChecked = define_c_func(raylib,"+GenImageChecked",{C_INT,C_INT,C_INT,C_INT,RL_COLOR,RL_COLOR},RL_IMAGE),
	xGenImageWhiteNoise = define_c_func(raylib,"+GenImageWhiteNoise",{C_INT,C_INT,C_FLOAT},RL_IMAGE),
	xGenImageCellular = define_c_func(raylib,"+GenImageCellular",{C_INT,C_INT,C_INT},RL_IMAGE),
	xImageCopy = define_c_func(raylib,"+ImageCopy",{RL_IMAGE},RL_IMAGE),
	xImageFromImage = define_c_func(raylib,"+ImageFromImage",{RL_IMAGE,RL_RECTANGLE},RL_IMAGE),
	xImageText = define_c_func(raylib,"+ImageText",{C_STRING,C_INT,RL_COLOR},RL_IMAGE),
	xImageTextEx = define_c_func(raylib,"+ImageTextEx",{RL_FONT,C_STRING,C_FLOAT,C_FLOAT,RL_COLOR},RL_IMAGE),
	xImageFormat = define_c_proc(raylib,"+ImageFormat",{RL_IMAGE,C_INT}),
	xImageToPOT = define_c_proc(raylib,"+ImageToPOT",{RL_IMAGE,RL_COLOR}),
	xImageCrop = define_c_proc(raylib,"+ImageCrop",{RL_IMAGE,RL_RECTANGLE}),
	xImageAlphaCrop = define_c_proc(raylib,"+ImageAlphaCrop",{RL_IMAGE,C_FLOAT}),
	xImageAlphaClear = define_c_proc(raylib,"+ImageAlphaClear",{RL_IMAGE,RL_COLOR,C_FLOAT}),
	xImageAlphaMask = define_c_proc(raylib,"+ImageAlphaMask",{RL_IMAGE,RL_IMAGE}),
	xImageAlphaPremultiply = define_c_proc(raylib,"+ImageAlphaPremultiply",{RL_IMAGE}),
	xImageResize = define_c_proc(raylib,"+ImageResize",{RL_IMAGE,C_INT,C_INT}),
	xImageResizeNN = define_c_proc(raylib,"+ImageResizeNN",{RL_IMAGE,C_INT,C_INT}),
	xImageResizeCanvas = define_c_proc(raylib,"+ImageResizeCanvas",{RL_IMAGE,C_INT,C_INT,C_INT,C_INT,RL_COLOR}),
	xImageMipmaps = define_c_proc(raylib,"+ImageMipmaps",{RL_IMAGE}),
	xImageDither = define_c_proc(raylib,"+ImageDither",{RL_IMAGE,C_INT,C_INT,C_INT,C_INT}),
	xImageFlipVertical = define_c_proc(raylib,"+ImageFlipVertical",{RL_IMAGE}),
	xImageFlipHorizontal = define_c_proc(raylib,"+ImageFlipHorizontal",{RL_IMAGE}),
	xImageRotateCW = define_c_proc(raylib,"+ImageRotateCW",{RL_IMAGE}),
	xImageRotateCCW = define_c_proc(raylib,"+ImageRotateCCW",{RL_IMAGE}),
	xImageColorTint = define_c_proc(raylib,"+ImageColorTint",{RL_IMAGE,RL_COLOR}),
	xImageColorInvert = define_c_proc(raylib,"+ImageColorInvert",{RL_IMAGE}),
	xImageColorGrayscale = define_c_proc(raylib,"+ImageColorGrayscale",{RL_IMAGE}),
	xImageColorContrast = define_c_proc(raylib,"+ImageColorContrast",{RL_IMAGE,C_FLOAT}),
	xImageColorBrightness = define_c_proc(raylib,"+ImageColorBrightness",{RL_IMAGE,C_INT}),
	xImageColorReplace = define_c_proc(raylib,"+ImageColorReplace",{RL_IMAGE,RL_COLOR,RL_COLOR}),
	xLoadImageColors = define_c_func(raylib,"+ImageLoadImageColors",{RL_IMAGE},RL_COLOR),
	xLoadImagePalette = define_c_func(raylib,"+LoadImagePalette",{RL_IMAGE,C_INT,C_POINTER},RL_COLOR),
	xUnloadImageColors = define_c_proc(raylib,"+UnloadImageColors",{RL_COLOR}),
	xUnloadImagePalette = define_c_proc(raylib,"+UnloadImagePalette",{RL_COLOR}),
	xGetImageAlphaBorder = define_c_func(raylib,"+GetImageAlphaBorder",{RL_IMAGE,C_FLOAT},RL_RECTANGLE),
	xGetImageColor = define_c_func(raylib,"+GetImageColor",{RL_IMAGE,C_INT,C_INT},RL_COLOR),
	xImageClearBackground = define_c_proc(raylib,"+ImageClearBackground",{RL_IMAGE,RL_COLOR}),
	xImageDrawPixel = define_c_proc(raylib,"+ImageDrawPixel",{RL_IMAGE,C_INT,C_INT,RL_COLOR}),
	xImageDrawPixelV = define_c_proc(raylib,"+ImageDrawPixelV",{RL_IMAGE,RL_VECTOR2,RL_COLOR}),
	xImageDrawLine = define_c_proc(raylib,"+ImageDrawLine",{RL_IMAGE,C_INT,C_INT,C_INT,C_INT,RL_COLOR}),
	xImageDrawLineV = define_c_proc(raylib,"+ImageDrawLineV",{RL_IMAGE,RL_VECTOR2,RL_VECTOR2,RL_COLOR}),
	xImageDrawCircle = define_c_proc(raylib,"+ImageDrawCircle",{RL_IMAGE,C_INT,C_INT,C_INT,RL_COLOR}),
	xImageDrawCircleV = define_c_proc(raylib,"+ImageDrawCircleV",{RL_IMAGE,RL_VECTOR2,C_INT,RL_COLOR}),
	xImageDrawRectangle = define_c_proc(raylib,"+ImageDrawRectangle",{RL_IMAGE,C_INT,C_INT,C_INT,C_INT,RL_COLOR}),
	xImageDrawRectangleV = define_c_proc(raylib,"+ImageDrawRectangleV",{RL_IMAGE,RL_VECTOR2,RL_VECTOR2,RL_COLOR}),
	xImageDrawRectangleRec = define_c_proc(raylib,"+ImageDrawRectangleRec",{RL_IMAGE,RL_RECTANGLE,RL_COLOR}),
	xImageDrawRectangleLines = define_c_proc(raylib,"+ImageDrawRectangleLines",{RL_IMAGE,RL_RECTANGLE,C_INT,RL_COLOR}),
	xImageDraw = define_c_proc(raylib,"+ImageDraw",{RL_IMAGE,RL_IMAGE,RL_RECTANGLE,RL_RECTANGLE,RL_COLOR}),
	xImageDrawText = define_c_proc(raylib,"+ImageDrawText",{RL_IMAGE,C_STRING,C_INT,C_INT,C_INT,RL_COLOR}),
	xImageDrawTextEx = define_c_proc(raylib,"+ImageDrawTextEx",{RL_IMAGE,RL_FONT,C_STRING,RL_VECTOR2,C_FLOAT,C_FLOAT,RL_COLOR}),
	xLoadTexture = define_c_func(raylib,"+LoadTexture",{C_STRING},RL_TEXTURE2D),
	xLoadTextureFromImage = define_c_func(raylib,"+LoadTextureFromImage",{RL_IMAGE},RL_TEXTURE2D),
	xLoadTextureCubemap = define_c_func(raylib,"+LoadTextureCubemap",{RL_IMAGE,C_INT},RL_TEXTURECUBEMAP),
	xLoadRenderTexture = define_c_func(raylib,"+LoadRenderTexture",{C_INT,C_INT},RL_RENDERTEXTURE2D),
	xUnloadTexture = define_c_proc(raylib,"+UnloadTexture",{RL_TEXTURE2D}),
	xUnloadRenderTexture = define_c_proc(raylib,"+UnloadRenderTexture",{RL_RENDERTEXTURE2D}),
	xUpdateTexture = define_c_proc(raylib,"+UpdateTexture",{RL_TEXTURE2D,C_POINTER}),
	xUpdateTextureRec = define_c_proc(raylib,"+UpdateTextureRec",{RL_TEXTURE2D,RL_RECTANGLE,C_POINTER}),
	xGenTextureMipmaps = define_c_proc(raylib,"+GenTextureMipmaps",{RL_TEXTURE2D}),
	xSetTextureFilter = define_c_proc(raylib,"+SetTextureFilter",{RL_TEXTURE2D,C_INT}),
	xSetTextureWrap = define_c_proc(raylib,"+SetTextureWrap",{RL_TEXTURE2D,C_INT}),
	xDrawTexture = define_c_proc(raylib,"+DrawTexture",{RL_TEXTURE2D,C_INT,C_INT,RL_COLOR}),
	xDrawTextureV = define_c_proc(raylib,"+DrawTextureV",{RL_TEXTURE2D,RL_VECTOR2,RL_COLOR}),
	xDrawTextureEx = define_c_proc(raylib,"+DrawTextureEx",{RL_TEXTURE2D,RL_VECTOR2,C_FLOAT,C_FLOAT,RL_COLOR}),
	xDrawTextureRec = define_c_proc(raylib,"+DrawTextureRec",{RL_TEXTURE2D,RL_RECTANGLE,RL_VECTOR2,RL_COLOR}),
	xDrawTextureQuad = define_c_proc(raylib,"+DrawTextureQuad",{RL_TEXTURE2D,RL_VECTOR2,RL_VECTOR2,RL_RECTANGLE,RL_COLOR}),
	xDrawTextureTiled = define_c_proc(raylib,"+DrawTextureTiled",{RL_TEXTURE2D,RL_RECTANGLE,RL_RECTANGLE,RL_VECTOR2,C_FLOAT,C_FLOAT,RL_COLOR}),
	xDrawTexturePro = define_c_proc(raylib,"+DrawTexturePro",{RL_TEXTURE2D,RL_RECTANGLE,RL_RECTANGLE,RL_VECTOR2,C_FLOAT,RL_COLOR}),
	xDrawTextureNPatch = define_c_proc(raylib,"+DrawTextureNPatch",{RL_TEXTURE2D,RL_NPATCHINFO,RL_RECTANGLE,RL_VECTOR2,C_FLOAT,RL_COLOR}),
	xDrawTexturePoly = define_c_proc(raylib,"+DrawTexturePoly",{RL_TEXTURE2D,RL_VECTOR2,RL_VECTOR2,RL_VECTOR2,C_INT,RL_COLOR}),
	xColorToInt = define_c_func(raylib,"+ColorToInt",{RL_COLOR},C_INT),
	xColorNormalize = define_c_func(raylib,"+ColorNormalize",{RL_COLOR},RL_VECTOR4),
	xColorFromNormalized = define_c_func(raylib,"+ColorFromNormalized",{RL_VECTOR4},RL_COLOR),
	xColorToHSV = define_c_func(raylib,"+ColorToHSV",{RL_COLOR},RL_VECTOR3),
	xColorFromHSV = define_c_func(raylib,"+ColorFromHSV",{C_FLOAT,C_FLOAT,C_FLOAT},RL_COLOR),
	xColorAlpha = define_c_func(raylib,"+ColorAlpha",{RL_COLOR,C_FLOAT},RL_COLOR),
	xColorAlphaBlend = define_c_func(raylib,"+ColorAlphaBlend",{RL_COLOR,RL_COLOR,RL_COLOR},RL_COLOR),
	xGetColor = define_c_func(raylib,"+GetColor",{C_UINT},RL_COLOR),
	xGetPixelColor = define_c_func(raylib,"+GetPixelColor",{C_POINTER,C_INT},RL_COLOR),
	xSetPixelColor = define_c_proc(raylib,"+SetPixelColor",{C_POINTER,RL_COLOR,C_INT}),
	xGetPixelDataSize = define_c_func(raylib,"+GetPixelDataSize",{C_INT,C_INT,C_INT},C_INT),
	xGetFontDefault = define_c_func(raylib,"+GetFontDefault",{},RL_FONT),
	xLoadFont = define_c_func(raylib,"+LoadFont",{C_STRING},RL_FONT),
	xLoadFontEx = define_c_func(raylib,"+LoadFontEx",{C_STRING,C_INT,C_POINTER,C_INT},RL_FONT),
	xLoadFontFromImage = define_c_func(raylib,"+LoadFontFromImage",{RL_IMAGE,RL_COLOR,C_INT},RL_FONT),
	xLoadFontFromMemory = define_c_func(raylib,"+LoadFontFromMemory",{C_STRING,C_POINTER,C_INT,C_INT,C_POINTER,C_INT},RL_FONT),
	xLoadFontData = define_c_func(raylib,"+LoadFontData",{C_POINTER,C_INT,C_INT,C_POINTER,C_INT,C_INT},RL_CHARINFO),
	xGenImageFontAtlas = define_c_func(raylib,"+GenImageFontAtlas",{RL_CHARINFO,RL_RECTANGLE,C_INT,C_INT,C_INT,C_INT},RL_IMAGE),
	xUnloadFontData = define_c_proc(raylib,"+UnloadFontData",{RL_CHARINFO,C_INT}),
	xUnloadFont = define_c_proc(raylib,"+UnloadFont",{RL_FONT}),
	xExportFontAsCode = define_c_func(raylib,"+ExportFontAsCode",{RL_FONT,C_STRING},C_BOOL),
	xDrawTextEx = define_c_proc(raylib,"+DrawTextEx",{RL_FONT,C_STRING,RL_VECTOR2,C_FLOAT,C_FLOAT,RL_COLOR}),
	xDrawTextPro = define_c_proc(raylib,"+DrawTextPro",{RL_FONT,C_STRING,RL_VECTOR2,RL_VECTOR2,C_FLOAT,C_FLOAT,C_FLOAT,RL_COLOR}),
	xDrawTextCodepoint = define_c_proc(raylib,"+DrawTextCodepoint",{RL_FONT,C_INT,RL_VECTOR2,C_FLOAT,RL_COLOR}),
	xDrawTextCodepoints = define_c_proc(raylib,"+DrawTextCodepoints",{RL_FONT,C_POINTER,C_INT,RL_VECTOR2,C_FLOAT,C_FLOAT,RL_COLOR}),
	xMeasureText = define_c_func(raylib,"+MeasureText",{C_STRING,C_INT},C_INT),
	xMeasureTextEx = define_c_func(raylib,"+MeasureTextEx",{RL_FONT,C_STRING,C_FLOAT,C_FLOAT},RL_VECTOR2),
	xGetGlyphIndex = define_c_func(raylib,"+GetGlyphIndex",{RL_FONT,C_INT},C_INT),
	xGetGlyphInfo = define_c_func(raylib,"+GetGlyphInfo",{RL_FONT,C_INT},RL_CHARINFO),
	xGetGlyphAtlasRec = define_c_func(raylib,"+GetGelyphAtlasRec",{RL_FONT,C_INT},RL_RECTANGLE),
	xLoadCodepoints = define_c_func(raylib,"+LoadCodepoints",{C_STRING,C_POINTER},C_POINTER),
	xUnloadCodepoints = define_c_proc(raylib,"+UnloadCodepoints",{C_POINTER}),
	xGetCodepointCount = define_c_func(raylib,"+GetCodepointCount",{C_STRING},C_INT),
	xGetCodepoint = define_c_func(raylib,"+GetCodepoint",{C_STRING,C_POINTER},C_INT),
	xCodepointToUTF8 = define_c_func(raylib,"+CodepointtoUTF8",{C_INT,C_POINTER},C_STRING),
	xTextCodepointsToUTF8 = define_c_func(raylib,"+TextCodepointsToUTF8",{C_POINTER,C_INT},C_STRING),
	xTextCopy = define_c_func(raylib,"+TextCopy",{C_STRING,C_STRING},C_INT),
	xTextIsEqual = define_c_func(raylib,"+TextIsEqual",{C_STRING,C_STRING},C_BOOL),
	xTextLength = define_c_func(raylib,"+TextLength",{C_STRING},C_UINT),
	xTextFormat = define_c_func(raylib,"+TextFormat",{C_STRING},C_STRING),
	xTextSubtext = define_c_func(raylib,"+TextSubtext",{C_STRING,C_INT,C_INT},C_STRING),
	xTextReplace = define_c_func(raylib,"+TextReplace",{C_STRING,C_STRING,C_STRING},C_STRING),
	xTextInsert = define_c_func(raylib,"+TextInsert",{C_STRING,C_STRING,C_INT},C_STRING),
	xTextJoin = define_c_func(raylib,"+TextJoin",{C_STRING,C_INT,C_STRING},C_STRING),
	xTextSplit = define_c_func(raylib,"+TextSplit",{C_STRING,C_CHAR,C_POINTER},C_STRING),
	xTextAppend = define_c_proc(raylib,"+TextAppend",{C_STRING,C_STRING,C_POINTER}),
	xTextFindIndex = define_c_func(raylib,"+TextFindIndex",{C_STRING,C_STRING},C_INT),
	xTextToUpper = define_c_func(raylib,"+TextToUpper",{C_STRING},C_STRING),
	xTextToLower = define_c_func(raylib,"+TextToLower",{C_STRING},C_STRING),
	xTextToPascal = define_c_func(raylib,"+TextToPascal",{C_STRING},C_STRING),
	xTextToInteger = define_c_func(raylib,"+TextToInteger",{C_STRING},C_INT),
	xDrawLine3D = define_c_proc(raylib,"+DrawLine3D",{RL_VECTOR3,RL_VECTOR3,RL_COLOR}),
	xDrawPoint3D = define_c_proc(raylib,"+DrawPoint3D",{RL_VECTOR3,RL_COLOR}),
	xDrawCircle3D = define_c_proc(raylib,"+DrawCircle3D",{RL_VECTOR3,C_FLOAT,RL_VECTOR3,C_FLOAT,RL_COLOR}),
	xDrawTriangle3D = define_c_proc(raylib,"+DrawTriangle3D",{RL_VECTOR3,RL_VECTOR3,RL_VECTOR3,RL_COLOR}),
	xDrawTriangleStrip3D = define_c_proc(raylib,"+DrawTriangleStrip3D",{RL_VECTOR3,C_INT,RL_COLOR}),
	xDrawCubeV = define_c_proc(raylib,"+DrawCubeV",{RL_VECTOR3,RL_VECTOR3,RL_COLOR}),
	xDrawCubeWiresV = define_c_proc(raylib,"+DrawCubeWiresV",{RL_VECTOR3,RL_VECTOR3,RL_COLOR}),
	xDrawCubeTexture = define_c_proc(raylib,"+DrawCubeTexture",{RL_TEXTURE2D,RL_VECTOR3,C_FLOAT,C_FLOAT,C_FLOAT,RL_COLOR}),
	xDrawCubeTextureRec = define_c_proc(raylib,"+DrawCubeTextureRec",{RL_TEXTURE2D,RL_RECTANGLE,RL_VECTOR3,C_FLOAT,C_FLOAT,C_FLOAT,RL_COLOR}),
	xDrawSphere = define_c_proc(raylib,"+DrawSphere",{RL_VECTOR3,C_FLOAT,RL_COLOR}),
	xDrawSphereEx = define_c_proc(raylib,"+DrawSphereEx",{RL_VECTOR3,C_FLOAT,C_INT,C_INT,RL_COLOR}),
	xDrawSphereWires = define_c_proc(raylib,"+DrawSphereWires",{RL_VECTOR3,C_FLOAT,C_INT,C_INT,RL_COLOR}),
	xDrawCylinder = define_c_proc(raylib,"+DrawCylinder",{RL_VECTOR3,C_FLOAT,C_FLOAT,C_FLOAT,C_INT,RL_COLOR}),
	xDrawCylinderEx = define_c_proc(raylib,"+DrawCylinderEx",{RL_VECTOR3,RL_VECTOR3,C_FLOAT,C_FLOAT,C_INT,RL_COLOR}),
	xDrawCylinderWires = define_c_proc(raylib,"+DrawCylinderWires",{RL_VECTOR3,C_FLOAT,C_FLOAT,C_FLOAT,C_INT,RL_COLOR}),
	xDrawCylinderWiresEx = define_c_proc(raylib,"+DrawCylinderWiresEx",{RL_VECTOR3,RL_VECTOR3,C_FLOAT,C_FLOAT,C_INT,RL_COLOR}),
	xDrawPlane = define_c_proc(raylib,"+DrawPlane",{RL_VECTOR3,RL_VECTOR2,RL_COLOR}),
	xDrawRay = define_c_proc(raylib,"+DrawRay",{RL_RAY,RL_COLOR}),
	xLoadModel = define_c_func(raylib,"+LoadModel",{C_STRING},RL_MODEL),
	xLoadModelFromMesh = define_c_func(raylib,"+LoadModelFromMesh",{RL_MESH},RL_MODEL),
	xUnloadModel = define_c_proc(raylib,"+UnloadModel",{RL_MODEL}),
	xUnloadModelKeepMeshes = define_c_proc(raylib,"+UnloadModelKeepMeshes",{RL_MODEL}),
	xGetModelBoundingBox = define_c_func(raylib,"+GetModelBoundingBox",{RL_MODEL},RL_BOUNDINGBOX),
	xDrawModel = define_c_proc(raylib,"+DrawModel",{RL_MODEL,RL_VECTOR3,C_FLOAT,RL_COLOR}),
	xDrawModelEx = define_c_proc(raylib,"+DrawModelEx",{RL_MODEL,RL_VECTOR3,RL_VECTOR3,C_FLOAT,RL_VECTOR3,RL_COLOR}),
	xDrawModelWires = define_c_proc(raylib,"+DrawModelWires",{RL_MODEL,RL_VECTOR3,C_FLOAT,RL_COLOR}),
	xDrawModelWiresEx = define_c_proc(raylib,"+DrawModelWiresEx",{RL_MODEL,RL_VECTOR3,RL_VECTOR3,C_FLOAT,RL_VECTOR3,RL_COLOR}),
	xDrawBoundingBox = define_c_proc(raylib,"+DrawBoundingBox",{RL_BOUNDINGBOX,RL_COLOR}),
	xDrawBillboard = define_c_proc(raylib,"+DrawBillboard",{RL_CAMERA,RL_TEXTURE2D,RL_VECTOR3,C_FLOAT,RL_COLOR}),
	xDrawBillboardRec = define_c_proc(raylib,"+DrawBillboardRec",{RL_CAMERA,RL_TEXTURE2D,RL_RECTANGLE,RL_VECTOR3,RL_VECTOR2,RL_COLOR}),
	xDrawBillboardPro = define_c_proc(raylib,"+DrawBillboardPro",{RL_CAMERA,RL_TEXTURE2D,RL_RECTANGLE,RL_VECTOR3,RL_VECTOR3,RL_VECTOR2,RL_VECTOR2,C_FLOAT,RL_COLOR}),
	xUploadMesh = define_c_proc(raylib,"+UploadMesh",{RL_MESH,C_BOOL}),
	xUpdateMeshBuffer = define_c_proc(raylib,"+UpdateMeshBuffer",{RL_MESH,C_INT,C_POINTER,C_INT,C_INT}),
	xUnloadMesh = define_c_proc(raylib,"+UnloadMesh",{RL_MESH}),
	xDrawMesh = define_c_proc(raylib,"+DrawMesh",{RL_MESH,RL_MATERIAL,RL_MATRIX}),
	xDrawMeshInstanced = define_c_proc(raylib,"+DrawMeshInstanced",{RL_MESH,RL_MATERIAL,RL_MATRIX,C_INT}),
	xExportMesh = define_c_func(raylib,"+ExportMesh",{RL_MESH,C_STRING},C_BOOL),
	xGetMeshBoundingBox = define_c_func(raylib,"+GetMeshBoundingBox",{RL_MESH},RL_BOUNDINGBOX),
	xGenMeshTangents = define_c_proc(raylib,"+GenMeshTangents",{RL_MESH}),
	xGenMeshPoly = define_c_func(raylib,"+GenMeshPoly",{C_INT,C_FLOAT},RL_MESH),
	xGenMeshPlane = define_c_func(raylib,"+GenMeshPlane",{C_FLOAT,C_FLOAT,C_INT,C_INT},RL_MESH),
	xGenMeshCube = define_c_func(raylib,"+GenMeshCube",{C_FLOAT,C_FLOAT,C_FLOAT},RL_MESH),
	xGenMeshSphere = define_c_func(raylib,"+GenMeshSphere",{C_FLOAT,C_INT,C_INT},RL_MESH),
	xGenMeshHemiSphere = define_c_func(raylib,"+GenMeshHemiSphere",{C_FLOAT,C_INT,C_INT},RL_MESH),
	xGenMeshCylinder = define_c_func(raylib,"+GenMeshCylinder",{C_FLOAT,C_FLOAT,C_INT},RL_MESH),
	xGenMeshCone = define_c_func(raylib,"+GenMeshCone",{C_FLOAT,C_FLOAT,C_INT},RL_MESH),
	xGenMeshTorus = define_c_func(raylib,"+GenMeshTorus",{C_FLOAT,C_FLOAT,C_INT,C_INT},RL_MESH),
	xGenMeshKnot = define_c_func(raylib,"+GenMeshKnot",{C_FLOAT,C_FLOAT,C_INT,C_INT},RL_MESH),
	xGenMeshHeightmap = define_c_func(raylib,"+GenMeshHeightmap",{RL_IMAGE,RL_VECTOR3},RL_MESH),
	xGenMeshCubicmap = define_c_func(raylib,"+GenMeshCubicmap",{RL_IMAGE,RL_VECTOR3},RL_MESH),
	xLoadMaterials = define_c_func(raylib,"+LoadMaterials",{C_STRING,C_POINTER},RL_MATERIAL),
	xLoadMaterialDefault = define_c_func(raylib,"+LoadMaterialDefault",{},RL_MATERIAL),
	xUnloadMaterial = define_c_proc(raylib,"+UnloadMaterial",{RL_MATERIAL}),
	xSetMaterialTexture = define_c_proc(raylib,"+SetMaterialTexture",{RL_MATERIAL,C_INT,RL_TEXTURE2D}),
	xSetModelMeshMaterial = define_c_proc(raylib,"+SetModelMeshMaterial",{RL_MODEL,C_INT,C_INT}),
	xLoadModelAnimations = define_c_func(raylib,"+LoadModelAnimations",{C_STRING,C_POINTER},RL_MODELANIMATION),
	xUpdateModelAnimation = define_c_proc(raylib,"+UpdateModelAnimation",{RL_MODEL,RL_MODELANIMATION,C_INT}),
	xUnloadModelAnimation = define_c_proc(raylib,"+UnloadModelAnimation",{RL_MODELANIMATION}),
	xUnloadModelAnimations = define_c_proc(raylib,"+UnloadModelAnimations",{RL_MODELANIMATION,C_UINT}),
	xIsModelAnimationValid = define_c_func(raylib,"+IsModelAnimationValid",{RL_MODEL,RL_MODELANIMATION},C_BOOL),
	xCheckCollisionSpheres = define_c_func(raylib,"+CheckCollisionSpheres",{RL_VECTOR3,C_FLOAT,RL_VECTOR3,C_FLOAT},C_BOOL),
	xCheckCollisionBoxes = define_c_func(raylib,"+CheckCollisionBoxes",{RL_BOUNDINGBOX,RL_BOUNDINGBOX},C_BOOL),
	xCheckCollisionBoxSphere = define_c_func(raylib,"+CheckCollisionBoxSphere",{RL_BOUNDINGBOX,RL_VECTOR3,C_FLOAT},C_BOOL),
	xGetRayCollisionSphere = define_c_func(raylib,"+GetRayCollisionSphere",{RL_RAY,RL_VECTOR3,C_FLOAT},RL_RAY),
	xGetRayCollisionBox = define_c_func(raylib,"+GetRayCollisionBox",{RL_RAY,RL_BOUNDINGBOX},RL_RAY),
	xGetRayCollisionMesh = define_c_func(raylib,"+GenRayCollisionMesh",{RL_RAY,RL_MESH,RL_MATRIX},RL_RAY),
	xGetRayCollisionTriangle = define_c_func(raylib,"+GetRayCollisionTriangle",{RL_RAY,RL_VECTOR3,RL_VECTOR3,RL_VECTOR3},RL_RAY),
	xGetRayCollisionQuad = define_c_func(raylib,"+GetRayCollisionQuad",{RL_RAY,RL_VECTOR3,RL_VECTOR3,RL_VECTOR3,RL_VECTOR3},RL_RAY),
	xInitAudioDevice = define_c_proc(raylib,"+InitAudioDevice",{}),
	xCloseAudioDevice = define_c_proc(raylib,"+CloseAudioDevice",{}),
	xIsAudioDeviceReady = define_c_func(raylib,"+IsAudioDeviceReady",{},C_BOOL),
	xSetMasterVolume = define_c_proc(raylib,"+SetMasterVolume",{C_FLOAT}),
	xLoadWave = define_c_func(raylib,"+LoadWave",{C_STRING},RL_WAVE),
	xLoadWaveFromMemory = define_c_func(raylib,"+LoadWaveFromMemory",{C_STRING,C_POINTER,C_INT},RL_WAVE),
	xLoadSound = define_c_func(raylib,"+LoadSound",{C_STRING},RL_SOUND),
	xLoadSoundFromWave = define_c_func(raylib,"+LoadSoundFromWave",{RL_WAVE},RL_SOUND),
	xUpdateSound = define_c_proc(raylib,"+UpdateSound",{RL_SOUND,C_POINTER,C_INT}),
	xUnloadWave = define_c_proc(raylib,"+UnloadWave",{RL_WAVE}),
	xUnloadSound = define_c_proc(raylib,"+UnloadSound",{RL_SOUND}),
	xExportWave = define_c_func(raylib,"+ExportWave",{RL_WAVE,C_STRING},C_BOOL),
	xExportWaveAsCode = define_c_func(raylib,"+ExportWaveAsCode",{RL_WAVE,C_STRING},C_BOOL),
	xPlaySound = define_c_proc(raylib,"+PlaySound",{RL_SOUND}),
	xStopSound = define_c_proc(raylib,"+StopSound",{RL_SOUND}),
	xPauseSound = define_c_proc(raylib,"+PauseSound",{RL_SOUND}),
	xResumeSound = define_c_proc(raylib,"+ResumeSound",{RL_SOUND}),
	xPlaySoundMulti = define_c_proc(raylib,"+PlaySoundMulti",{RL_SOUND}),
	xStopSoundMulti = define_c_proc(raylib,"+StopSoundMulti",{RL_SOUND}),
	xGetSoundsPlaying = define_c_func(raylib,"+GetSoundsPlaying",{},C_INT),
	xIsSoundPlaying = define_c_func(raylib,"+IsSoundPlaying",{RL_SOUND},C_BOOL),
	xSetSoundVolume = define_c_proc(raylib,"+SetSoundVolume",{RL_SOUND,C_FLOAT}),
	xSetSoundPitch = define_c_proc(raylib,"+SetSoundPitch",{RL_SOUND,C_FLOAT}),
	xSetSoundPan = define_c_proc(raylib,"+SetSoundPan",{RL_SOUND,C_FLOAT}),
	xWaveCopy = define_c_func(raylib,"+WaveCopy",{RL_WAVE},RL_WAVE),
	xWaveCrop = define_c_proc(raylib,"+WaveCrop",{RL_WAVE,C_INT,C_INT}),
	xWaveFormat = define_c_proc(raylib,"+WaveFormat",{RL_WAVE,C_INT,C_INT,C_INT}),
	xLoadWaveSamples = define_c_func(raylib,"+LoadWaveSamples",{RL_WAVE},C_FLOAT),
	xUnloadWaveSamples = define_c_proc(raylib,"+UnloadWaveSamples",{C_POINTER}),
	xLoadMusicStream = define_c_func(raylib,"+LoadMusicStream",{C_STRING},RL_MUSIC),
	xLoadMusicStreamFromMemory = define_c_func(raylib,"+LoadMusicStreamFromMemory",{C_STRING,C_POINTER,C_INT},RL_MUSIC),
	xUnloadMusicStream = define_c_proc(raylib,"+UnloadMusicStream",{RL_MUSIC}),
	xPlayMusicStream = define_c_proc(raylib,"+PlayMusicStream",{RL_MUSIC}),
	xIsMusicStreamPlaying = define_c_func(raylib,"+IsMusicStreamPlaying",{RL_MUSIC},C_BOOL),
	xUpdateMusicStream = define_c_proc(raylib,"+UpdateMusicStream",{RL_MUSIC}),
	xStopMusicStream = define_c_proc(raylib,"+StopMusicStream",{RL_MUSIC}),
	xPauseMusicStream = define_c_proc(raylib,"+PauseMusicStream",{RL_MUSIC}),
	xResumeMusicStream = define_c_proc(raylib,"+ResumeMusicStream",{RL_MUSIC}),
	xSeekMusicStream = define_c_proc(raylib,"+SeekMusicStream",{RL_MUSIC,C_FLOAT}),
	xSetMusicVolume = define_c_proc(raylib,"+SetMusicVolume",{RL_MUSIC,C_FLOAT}),
	xSetMusicPitch = define_c_proc(raylib,"+SetMusicPitch",{RL_MUSIC,C_FLOAT}),
	xSetMusicPan = define_c_proc(raylib,"+SetMusicPan",{RL_MUSIC,C_FLOAT}),
	xGetMusicTimeLength = define_c_func(raylib,"+GetMusicTimeLength",{RL_MUSIC},C_FLOAT),
	xGetMusicTimePlayed = define_c_func(raylib,"+GetMusicTimePlayed",{RL_MUSIC},C_FLOAT),
	xLoadAudioStream = define_c_func(raylib,"+LoadAudioStream",{C_UINT,C_UINT,C_UINT},RL_AUDIOSTREAM),
	xUnloadAudioStream = define_c_proc(raylib,"+UnloadAudioStream",{RL_AUDIOSTREAM}),
	xUpdateAudioStream = define_c_proc(raylib,"+UpdateAudioStream",{RL_AUDIOSTREAM,C_POINTER,C_INT}),
	xIsAudioStreamProcessed = define_c_func(raylib,"+IsAudioStreamProcessed",{RL_AUDIOSTREAM},C_BOOL),
	xPlayAudioStream = define_c_proc(raylib,"+PlayAudioStream",{RL_AUDIOSTREAM}),
	xPauseAudioStream = define_c_proc(raylib,"+PauseAudioStream",{RL_AUDIOSTREAM}),
	xResumeAudioStream = define_c_proc(raylib,"+ResumeAudioStream",{RL_AUDIOSTREAM}),
	xIsAudioStreamPlaying = define_c_func(raylib,"+IsAudioStreamPlaying",{RL_AUDIOSTREAM},C_BOOL),
	xStopAudioStream = define_c_proc(raylib,"+StopAudioStream",{RL_AUDIOSTREAM}),
	xSetAudioStreamVolume = define_c_proc(raylib,"+SetAduioStreamVolume",{RL_AUDIOSTREAM,C_FLOAT}),
	xSetAudioStreamPitch = define_c_proc(raylib,"+SetAudioStreamPitch",{RL_AUDIOSTREAM,C_FLOAT}),
	xSetAudioStreamPan = define_c_proc(raylib,"+SetAudioStreamPan",{RL_AUDIOSTREAM,C_FLOAT}),
	xSetAudioStreamBufferSizeDefault = define_c_proc(raylib,"+SetAudioStreamBufferSizeDefault",{C_INT}),
	xSetAudioStreamCallback = define_c_proc(raylib,"+SetAudioStreamCallback",{RL_AUDIOSTREAM,C_POINTER}),
	xAttachAudioStreamProcessor = define_c_proc(raylib,"+AttachAudioStreamProcessor",{RL_AUDIOSTREAM,C_POINTER}),
	xDetachAudioStreamProcessor = define_c_proc(raylib,"+DetachAudioStreamProcessor",{RL_AUDIOSTREAM,C_POINTER}),
$

public procedure InitWindow( integer width, integer height, sequence title )
	c_proc( xInitWindow, {width,height,title} ) -- title string is allocated/freed automatically
end procedure

public function WindowShouldClose()
	return c_func( xWindowShouldClose, {} )
end function

public procedure CloseWindow()
	c_proc( xCloseWindow, {} )
end procedure

public function GetWindowPosition()
	return c_func( xGetWindowPosition, {} ) -- returns {x,y}
end function

public function GetScreenToWorld2D( sequence position, sequence camera )
	return c_func( xGetScreenToWorld2D, {position,camera} )
end function

public procedure SetTargetFPS( integer fps )
	c_proc( xSetTargetFPS, {fps} )
end procedure

public function GetFPS()
	return c_func(xGetFPS, {})
end function

public function GetFrameTime()
	return c_func(xGetFrameTime,{})
end function

public function GetTime()
	return c_func(xGetTime,{})
end function

public function GetRandomValue( integer min, integer max )
	return c_func( xGetRandomValue, {min,max} )
end function

public procedure SetRandomSeed( atom seed )
	c_proc(xSetRandomSeed, {seed} )
end procedure

public procedure TakeScreenshot( sequence fileName )
	c_proc(xTakeScreenshot, {fileName} )
end procedure

public procedure SetConfigFlags( atom flags )
	c_proc(xSetConfigFlags, {flags} )
end procedure

public procedure ClearBackground( sequence color )
	c_proc( xClearBackground, {color} ) -- color is {r,g,b,a}
end procedure

public procedure BeginDrawing()
	c_proc( xBeginDrawing, {} )
end procedure

public procedure EndDrawing()
	c_proc( xEndDrawing, {} )
end procedure

public procedure BeginMode2D( sequence camera )
	c_proc( xBeginMode2D, {camera} )
end procedure

public procedure EndMode2D()
	c_proc( xEndMode2D, {} )
end procedure

public procedure BeginMode3D( sequence camera )
	c_proc( xBeginMode3D, {camera} )
end procedure

public procedure EndMode3D()
	c_proc( xEndMode3D, {} )
end procedure

public function IsKeyPressed( integer key )
	return c_func( xIsKeyPressed, {key} )
end function

public function IsKeyDown( integer key )
	return c_func( xIsKeyDown, {key} )
end function

public function IsKeyReleased( integer key )
       return c_func(xIsKeyReleased, {key} )
end function

public function IsKeyUp( integer key )
       return c_func(xIsKeyUp, {key} )
end function

public procedure SetExitKey(integer key )
      c_proc(xSetExitKey, {key} )
end procedure

public function GetKeyPressed()
     return c_func(xGetKeyPressed, {} )
end function

public function GetCharPressed()
    return c_func(xGetCharPressed, {} )
end function

public function IsMouseButtonPressed(integer button)
	return c_func(xIsMouseButtonPressed,{button})
end function

public function IsMouseButtonDown( integer button )
	return c_func( xIsMouseButtonDown, {button} )
end function

public function IsMouseButtonReleased(integer button)
	return c_func(xIsMouseButtonReleased,{button})
end function

public function IsMouseButtonUp(integer button)
	return c_func(xIsMouseButtonUp,{button})
end function

public function GetMousePosition()
	return c_func( xGetMousePosition, {} )
end function

public function GetMouseDelta()
	return c_func( xGetMouseDelta, {} )
end function

public function GetMouseWheelMove()
	return c_func( xGetMouseWheelMove, {} )
end function

public function GetMouseWheelMoveV()
	return c_func(xGetMouseWheelMoveV,{})
end function

public procedure DrawPixel(integer posX, integer posY, sequence color)
	c_proc(xDrawPixel,{posX,posY,color})
end procedure

public procedure DrawLine( integer startPosX, integer startPosY, integer endPosX, integer endPosY, sequence color )
	c_proc( xDrawLine, {startPosX,startPosY,endPosX,endPosY,color} )
end procedure

public procedure DrawCircle( integer centerX, integer centerY, atom radius, sequence color )
	c_proc( xDrawCircle, {centerX,centerY,radius,color} )
end procedure

public procedure DrawCircleV(sequence center, atom radius, sequence color)
	c_proc(xDrawCircleV,{center,radius,color})
end procedure

public procedure DrawRectangle( integer posX, integer posY, integer width, integer height, sequence color )
	c_proc( xDrawRectangle, {posX,posY,width,height,color} )
end procedure

public procedure DrawRectangleRec( sequence rec, sequence color )
	c_proc( xDrawRectangleRec, {rec,color} )
end procedure

public procedure DrawRectangleLines( integer posX, integer posY, integer width, integer height, sequence color )
	c_proc( xDrawRectangleLines, {posX,posY,width,height,color} )
end procedure

public function Fade( sequence color, atom alpha )
	return c_func( xFade, {color,alpha} )
end function

public procedure DrawFPS( integer posX, integer posY )
	c_proc( xDrawFPS, {posX,posY} )
end procedure

public procedure DrawText( sequence text, integer posX, integer posY, integer fontSize, sequence color )
	c_proc( xDrawText, {text,posX,posY,fontSize,color} )
end procedure

public procedure DrawCube( sequence position, atom width, atom height, atom length, sequence color )
	c_proc( xDrawCube, {position,width,height,length,color} )
end procedure

public procedure DrawCubeWires( sequence position, atom width, atom height, atom length, sequence color )
	c_proc( xDrawCubeWires, {position,width,height,length,color} )
end procedure

public procedure DrawGrid( integer slices, atom spacing )
	c_proc( xDrawGrid, {slices,spacing} )
end procedure

public function GetMouseRay(sequence mousePosition, sequence camera)
	return c_func(xGetMouseRay,{mousePosition,camera} )
end function

public function GetCameraMatrix(sequence camera)
	return c_func(xGetCameraMatrix,{camera} )
end function

public function GetCameraMatrix2D(sequence camera)
	return c_func(xGetCameraMatrix2D,{camera} )
end function

public function GetWorldToScreen(sequence pos, sequence camera)
	return c_func(xGetWorldToScreen,{pos,camera})
end function

public function GetWorldToScreenEx(sequence pos,sequence camera,integer width,integer height)
	return c_func(xGetWorldToScreenEx,{pos,camera,width,height})
end function

public function GetWorldToScreen2D(sequence pos,sequence camera)
	return c_func(xGetWorldToScreen2D,{pos,camera})
end function

public function GetScreenWidth()
	return c_func(xGetScreenWidth,{})
end function

public function GetScreenHeight()
	return c_func(xGetScreenHeight,{})
end function

public procedure BeginBlendMode(integer mode)
	c_proc(xBeginBlendMode,{mode})
end procedure

public procedure EndBlendMode()
	c_proc(xEndBlendMode,{})
end procedure

public function GetMouseX()
	return c_func(xGetMouseX,{})
end function

public function GetMouseY()
	return c_func(xGetMouseY,{})
end function

public procedure SetMousePosition(integer x,integer y)
	c_proc(xSetMousePosition,{x,y})
end procedure

public procedure SetMouseOffset(integer offsetx,integer offsety)
	c_proc(xSetMouseOffset,{offsetx,offsety})
end procedure

public procedure SetMouseScale(atom scaleX,atom scaleY)
	c_proc(xSetMouseScale,{scaleX,scaleY})
end procedure

public procedure SetMouseCursor(integer cursor)
	c_proc(xSetMouseCursor,{cursor})
end procedure

public function IsWindowReady()
	return c_func(xIsWindowReady,{})
end function

public function IsWindowFullscreen()
	return c_func(xIsWindowFullscreen,{})
end function

public function IsWindowHidden()
	return c_func(xIsWindowHidden,{})
end function

public function IsWindowMinimized()
	return c_func(xIsWindowMinimized,{})
end function

public function IsWindowMaximized()
	return c_func(xIsWindowMaximized,{})
end function

public function IsWindowFocused()
	return c_func(xIsWindowFocused,{})
end function

public function IsWindowResized()
	return c_func(xIsWindowResized,{})
end function

public function IsWindowState(atom flag)
	return c_func(xIsWindowState,{flag})
end function

public procedure SetWindowState(atom flags)
	c_proc(xSetWindowState,{flags})
end procedure

public procedure ClearWindowState(atom flags)
	c_proc(xClearWindowState,{flags})
end procedure

public procedure ToggleFullscreen()
	c_proc(xToggleFullscreen,{})
end procedure

public procedure MaximizeWindow()
	c_proc(xMaximizeWindow,{})
end procedure

public procedure MinimizeWindow()
	c_proc(xMinimizeWindow,{})
end procedure

public procedure RestoreWindow()
	c_proc(xRestoreWindow,{})
end procedure

--image[1] - data, image[2] - width, image[3] - height,
--image[4] - mipmaps, image[5] - format 
public procedure SetWindowIcon(sequence image)
	c_proc(xSetWindowIcon,{image})
end procedure

public procedure SetWindowTitle(sequence title)
	c_proc(xSetWindowTitle,{title})
end procedure

public procedure SetWindowPosition(integer x,integer y)
	c_proc(xSetWindowPosition,{x,y})
end procedure

public procedure SetWindowMonitor(integer monitor)
	c_proc(xSetWindowMonitor,{monitor})
end procedure

public procedure SetWindowMinSize(integer width,integer height)
	c_proc(xSetWindowMinSize,{width,height})
end procedure

public procedure SetWindowOpacity(atom opacity)
	c_proc(xSetWindowOpacity,{opacity})
end procedure

public function GetWindowHandle()
	return c_func(xGetWindowHandle,{})
end function

--public function GetScreenWidth()
--	return c_func(xGetScreenWidth,{})
--end function

--public function GetScreenHeight()
--	return c_func(xGetScreenHeight,{})
--end function

public function GetRenderWidth()
	return c_func(xGetRenderWidth,{})
end function

public function GetRenderHeight()
	return c_func(xGetRenderHeight,{})
end function

public function GetMonitorCount()
	return c_func(xGetMonitorCount,{})
end function

public function GetCurrentMonitor()
	return c_func(xGetCurrentMonitor,{})
end function

public function GetMonitorWidth(integer monitor)
	return c_func(xGetMonitorWidth,{monitor})
end function

public function GetMonitorHeight(integer monitor)
	return c_func(xGetMonitorHeight,{monitor})
end function

public function GetMonitorPhysicalWidth(integer monitor)
	return c_func(xGetMonitorPhysicalWidth,{monitor})
end function

public function GetMonitorPhysicalHeight(integer monitor)
	return c_func(xGetMonitorPhysicalHeight,{monitor})
end function

public function GetMonitorRefreshRate(integer monitor)
	return c_func(xGetMonitorRefreshRate,{monitor})
end function

public function GetWindowScaleDPI()
	return c_func(xGetWindowScaleDPI,{})
end function

public function GetMonitorName(integer monitor)
	return c_func(xGetMonitorName,{monitor})
end function

public procedure SetClipboardText(sequence text)
	c_proc(xSetClipboardText,{text})
end procedure

public function GetClipboardText()
	return c_func(xGetClipboardText,{})
end function

public procedure EnableEventWaiting()
	c_proc(xEnableEventWaiting,{})
end procedure

public procedure DisableEventWaiting()
	c_proc(xDisableEventWaiting,{})
end procedure

public procedure SwapScreenBuffer()
	c_proc(xSwapScreenBuffer,{})
end procedure

public procedure PollInputEvents()
	c_proc(xPollInputEvents,{})
end procedure

public procedure WaitTime(atom seconds)
	c_proc(xWaitTime,{seconds})
end procedure

public procedure ShowCursor()
	c_proc(xShowCursor,{})
end procedure

public procedure HideCursor()
	c_proc(xHideCursor,{})
end procedure

public function IsCursorHidden()
	return c_func(xIsCursorHidden,{})
end function

public procedure EnableCursor()
	c_proc(xEnableCursor,{})
end procedure

public procedure DisableCursor()
	c_proc(xDisableCursor,{})
end procedure

public function IsCursorOnScreen()
	return c_func(xIsCursorOnScreen,{})
end function

public procedure BeginTextureMode(sequence target)
	c_proc(xBeginTextureMode,{target})
end procedure

public procedure EndTextureMode()
	c_proc(xEndTextureMode,{})
end procedure

public procedure BeginShaderMode(sequence shader)
	c_proc(xBeginShaderMode,{shader})
end procedure

public procedure EndShaderMode()
	c_proc(xEndShaderMode,{})
end procedure

public procedure BeginScissorMode(integer x,integer y,integer width,integer height)
	c_proc(xBeginScissorMode,{x,y,width,height})
end procedure

public procedure EndScissorMode()
	c_proc(xEndScissorMode,{})
end procedure

public procedure BeginVrStereoMode(sequence config)
	c_proc(xBeginVrStereoMode,{config})
end procedure

public procedure EndVrStereoMode()
	c_proc(xEndVrStereoMode,{})
end procedure

public function LoadVrStereoConfig(sequence device)
	return c_func(xLoadVrStereoConfig,{device})
end function

public procedure UnloadVrStereoConfig(sequence config)
	c_proc(xUnloadVrStereoConfig,{config})
end procedure

public function LoadShader(sequence vsFileName,sequence fsFileName)
	return c_func(xLoadShader,{vsFileName,fsFileName})
end function

public function LoadShaderFromMemory(sequence vsCode,sequence fsCode)
	return c_func(xLoadShaderFromMemory,{vsCode,fsCode})
end function

public function GetShaderLocation(sequence shader,sequence uniformName)
	return c_func(xGetShaderLocation,{shader,uniformName})
end function

public function GetShaderLocationAttrib(sequence shader,sequence attribName)
	return c_func(xGetShaderLocationAttrib,{shader,attribName})
end function

public procedure SetShaderValue(sequence shader,integer locIndex,object val,integer uniformType)
	c_proc(xSetShaderValue,{shader,locIndex,val,uniformType})
end procedure

public procedure SetShaderValueMatrix(sequence shader,integer locIndex,sequence mat)
	c_proc(xSetShaderValueMatrix,{shader,locIndex,mat})
end procedure

public procedure SetShaderValueTexture(sequence shader,integer locIndex,sequence texture)
	c_proc(xSetShaderValueTexture,{shader,locIndex,texture})
end procedure

public procedure UnloadShader(sequence shader)
	c_proc(xUnloadShader,{shader})
end procedure

public procedure SetShaderValueV(sequence shader,integer locIndex,object val,integer uniformType,integer count)
	c_proc(xSetShaderValueV,{shader,locIndex,val,uniformType,count})
end procedure

public procedure TraceLog(integer logLevel,sequence text)
	c_proc(xTraceLog,{logLevel,text})
end procedure

public procedure SetTraceLogLevel(integer logLevel)
	c_proc(xSetTraceLogLevel,{logLevel})
end procedure

public function MemAlloc(integer size)
	return c_func(xMemAlloc,{size})
end function

public procedure MemRealloc(object ptr,integer size)
	c_proc(xMemRealloc,{ptr,size})
end procedure

public procedure MemFree(object ptr)
	c_proc(xMemFree,{ptr})
end procedure

public procedure SetShapesTexture(sequence texture,sequence source)
	c_proc(xSetShapesTexture,{texture,source})
end procedure

public procedure DrawPixelV(sequence position,sequence color)
	c_proc(xDrawPixelV,{position,color})
end procedure

public procedure DrawLineV(sequence startPos,sequence endPos,sequence color)
	c_proc(xDrawLineV,{startPos,endPos,color})
end procedure

public procedure DrawLineEx(sequence startPos,sequence endPos,atom thick,sequence color)
	c_proc(xDrawLineEx,{startPos,endPos,thick,color})
end procedure

public procedure DrawLineBezier(sequence startPos,sequence endPos,atom thick,sequence color)
	c_proc(xDrawLineBezier,{startPos,endPos,thick,color})
end procedure

public procedure DrawLineBezierQuad(sequence startPos,sequence endPos,sequence controlPos,atom thick,sequence color)
	c_proc(xDrawLineBezierQuad,{startPos,endPos,controlPos,thick,color})
end procedure

public procedure DrawLineBezierCubic(sequence startPos,sequence endPos,sequence startControlPos,sequence endControlPos,atom thick,sequence color)
	c_proc(xDrawLineBezierCubic,{startPos,endPos,startControlPos,endControlPos,thick,color})
end procedure

public procedure DrawLineStrip(sequence points,integer pointCount,sequence color)
	c_proc(xDrawLineStrip,{points,pointCount,color})
end procedure

public procedure DrawRectangleV(sequence position,sequence size,sequence color)
	c_proc(xDrawRectangleV,{position,size,color})
end procedure

public procedure DrawRectanglePro(sequence rec,sequence origin,atom rotation,sequence color)
	c_proc(xDrawRectanglePro,{rec,origin,rotation,color})
end procedure

public procedure DrawRectangleGradientV(integer posX,integer posY,integer width,integer height,sequence color,sequence color2)
	c_proc(xDrawRectangleGradientV,{posX,posY,width,height,color,color2})
end procedure

public procedure DrawRectangleGradientH(integer posX,integer posY,integer width,integer height,sequence color,sequence color2)
	c_proc(xDrawRectangleGradientH,{posX,posY,width,height,color,color2})
end procedure

public procedure DrawRectangleLinesEx(sequence rec,atom lineThick,sequence color)
	c_proc(xDrawRectangleLinesEx,{rec,lineThick,color})
end procedure

public procedure DrawRectangleRounded(sequence rec,atom roundness,integer segments,sequence color)
	c_proc(xDrawRectangleRounded,{rec,roundness,segments,color})
end procedure

public procedure DrawRectangleRoundedLines(sequence rec,atom roundness,integer segments,atom lineThick,sequence color)
	c_proc(xDrawRectangleRoundedLines,{rec,roundness,segments,lineThick,color})
end procedure

public procedure DrawCircleSector(sequence center,atom radius,atom startAngle,atom endAngle,integer segments,sequence color)
	c_proc(xDrawCircleSector,{center,radius,startAngle,endAngle,segments,color})
end procedure

public procedure DrawCircleSectorLines(sequence center,atom radius,atom startAngle,atom endAngle,integer segments,sequence color)
	c_proc(xDrawCircleSectorLines,{center,radius,startAngle,endAngle,segments,color})
end procedure

public procedure DrawCircleGradient(integer centerX,integer centerY,atom radius,sequence color,sequence color2)
	c_proc(xDrawCircleGradient,{centerX,centerY,radius,color,color2})
end procedure

public procedure DrawCircleLines(integer centerX,integer centerY,atom radius,sequence color)
	c_proc(xDrawCircleLines,{centerX,centerY,radius,color})
end procedure

public function LoadFileData(sequence fileName,atom bytesRead)
	return c_func(xLoadFileData,{fileName,bytesRead})
end function

public procedure UnloadFileData(sequence data)
	c_proc(xUnloadFileData,{data})
end procedure

public function SaveFileData(sequence fileName,object data,atom bytesToWrite)
	return c_func(xSaveFileData,{fileName,data,bytesToWrite})
end function

public function ExportDataAsCode(sequence data,atom size,sequence fileName)
	return c_func(xExportDataAsCode,{data,size,fileName})
end function

public function LoadFileText(sequence fileName)
	return c_func(xLoadFileText,{fileName})
end function

public procedure UnloadFileText(sequence text)
	c_proc(xUnloadFileText,{text})
end procedure

public function SaveFileText(sequence fileName,sequence text)
	return c_func(xSaveFileText,{fileName,text})
end function

public function FileExists(sequence fileName)
	return c_func(xFileExists,{fileName})
end function

public function DirectoryExists(sequence dirPath)
	return c_func(xDirectoryExists,{dirPath})
end function

public function IsFileExtension(sequence fileName,sequence ext)
	return c_func(xIsFileExtension,{fileName,ext})
end function

public function GetFileLength(sequence fileName)
	return c_func(xGetFileLength,{fileName})
end function

public function GetFileExtension(sequence fileName)
	return c_func(xGetFileExtension,{fileName})
end function

public function GetFileName(sequence filePath)
	return c_func(xGetFileName,{filePath})
end function

public function GetFileNameWithoutExt(sequence filePath)
	return c_func(xGetFileNameWithoutExt,{filePath})
end function

public function GetDirectoryPath(sequence filePath)
	return c_func(xGetDirectoryPath,{filePath})
end function

public function GetPrevDirectoryPath()
	return c_func(xGetPrevDirectoryPath,{})
end function

public function GetWorkingDirectory()
	return c_func(xGetWorkingDirectory,{})
end function

public function GetApplicationDirectory()
	return c_func(xGetApplicationDirectory,{})
end function

public function ChangeDirectory(sequence d)
	return c_func(xChangeDirectory,{d})
end function

public function IsPathFile(sequence path)
	return c_func(xIsPathFile,{path})
end function

public function LoadDirectoryFiles(sequence dirPath)
	return c_func(xLoadDirectoryFiles,{dirPath})
end function

public function LoadDirectoryFilesEx(sequence basePath,sequence filter,integer scanSubdirs)
	return c_func(xLoadDirectoryFilesEx,{basePath,filter,scanSubdirs})
end function

public procedure UnloadDirectoryFiles(integer files)
	c_proc(xUnloadDirectoryFiles,{files})
end procedure

public function IsFileDropped()
	return c_func(xIsFileDropped,{})
end function

public function LoadDroppedFiles()
	return c_func(xLoadDroppedFiles,{})
end function

public procedure UnloadDroppedFiles(integer files)
	c_proc(xUnloadDroppedFiles,{files})
end procedure

public function GetFileModTime(sequence fileName)
	return c_func(xGetFileModTime,{fileName})
end function

public function CompressData(sequence data,atom dataSize,atom compDataSize)
	return c_func(xCompressData,{data,dataSize,compDataSize})
end function

public function DecompressData(sequence compData,atom compDataSize,atom dataSize)
	return c_func(xDecompressData,{compData,compDataSize,dataSize})
end function

public function EncodeDataBase64(sequence data,atom dataSize,atom outputSize)
	return c_func(xEncodeDataBase64,{data,dataSize,outputSize})
end function

public function DecodeDataBase64(sequence data,atom outputSize)
	return c_func(xDecodeDataBase64,{data,outputSize})
end function

public function IsGamepadAvailable(atom gp)
	return c_func(xIsGamepadAvailable,{gp})
end function

public function GetGamepadName(atom gp)
	return c_func(xGetGamepadName,{gp})
end function

public function IsGamepadButtonPressed(atom gp,atom btn)
	return c_func(xIsGamepadButtonPressed,{gp,btn})
end function

public function IsGamepadButtonDown(atom gp,atom btn)
	return c_func(xIsGamepadButtonDown,{gp,btn})
end function

public function IsGamepadButtonReleased(atom gp,atom btn)
	return c_func(xIsGamepadButtonReleased,{gp,btn})
end function

public function IsGamepadButtonUp(atom gp,atom btn)
	return c_func(xIsGamepadButtonUp,{gp,btn})
end function

public function GetGamepadButtonPressed()
	return c_func(xGetGamepadButtonPressed,{})
end function

public function GetGamepadAxisCount(atom gp)
	return c_func(xGetGamepadAxisCount,{gp})
end function

public function GetGamepadAxisMovement(atom gp,atom axis)
	return c_func(xGetGamepadAxisMovement,{gp,axis})
end function

public function SetGamepadMappings(sequence mappings)
	return c_func(xSetGamepadMappings,{mappings})
end function

public function GetTouchX()
	return c_func(xGetTouchX,{})
end function

public function GetTouchY()
	return c_func(xGetTouchY,{})
end function

public function GetTouchPosition(integer index)
	return c_func(xGetTouchPosition,{index})
end function

public function GetTouchPointId(integer index)
	return c_func(xGetTouchPointId,{index})
end function

public function GetTouchPointCount()
	return c_func(xGetTouchPointCount,{})
end function

public procedure SetGesturesEnabled(atom flags)
	c_proc(xSetGesturesEnabled,{flags})
end procedure

public function IsGestureDetected(integer gesture)
	return c_func(xIsGestureDetected,{gesture})
end function

public function GetGestureDetected()
	return c_func(xGetGestureDetected,{})
end function

public function GetGestureHoldDuration()
	return c_func(xGetGestureHoldDuration,{})
end function

public function GetGestureDragVector()
	return c_func(xGetGestureDragVector,{})
end function

public function GetGestureDragAngle()
	return c_func(xGetGestureDragAngle,{})
end function

public function GetGesturePinchVector()
	return c_func(xGetGesturePinchVector,{})
end function

public function GetGesturePinchAngle()
	return c_func(xGetGesturePinchAngle,{})
end function

public procedure SetCameraMode(sequence cam,integer mode)
	c_proc(xSetCameraMode,{cam,mode})
end procedure

public procedure UpdateCamera(sequence cam)
	c_proc(xUpdateCamera,{cam})
end procedure

public procedure SetCameraPanControl(integer keyPan)
	c_proc(xSetCameraPanControl,{keyPan})
end procedure

public procedure SetCameraAltControl(integer keyAlt)
	c_proc(xSetCameraAltControl,{keyAlt})
end procedure

public procedure SetCameraSmoothZoomControl(integer keySmoothZoom)
	c_proc(xSetCameraSmoothZoomControl,{keySmoothZoom})
end procedure

public procedure SetCameraMoveControls(integer keyFront,integer keyBack,integer keyRight,integer keyLeft,integer keyUp,integer keyDown)
	c_proc(xSetCameraMoveControls,{keyFront,keyBack,keyRight,keyLeft,keyUp,keyDown})
end procedure

public procedure DrawEllipse(integer centerX,integer centerY,atom radH,atom radV,sequence color)
	c_proc(xDrawEllipse,{centerX,centerY,radH,radV,color})
end procedure

public procedure DrawEllipseLines(integer centerX,integer centerY,atom radH,atom radV, sequence color)
	c_proc(xDrawEllipseLines,{centerX,centerY,radH,radV,color})
end procedure

public procedure DrawRing(sequence center,atom inRad,atom outRad,atom startAng,atom endAng,integer seg,sequence color)
	c_proc(xDrawRing,{center,inRad,outRad,startAng,endAng,seg,color})
end procedure

public procedure DrawRingLines(sequence center,atom inRad,atom outRad,atom startAng,atom endAng,integer seg,sequence color)
	c_proc(xDrawRingLines,{center,inRad,outRad,startAng,endAng,seg,color})
end procedure

public procedure DrawTriangle(sequence v1,sequence v2,sequence v3,sequence color)
	c_proc(xDrawTriangle,{v1,v2,v3,color})
end procedure

public procedure DrawTriangleFan(sequence points,integer ptCount,sequence color)
	c_proc(xDrawTriangleFan,{points,ptCount,color})
end procedure

public procedure DrawTriangleStrip(sequence points,integer ptCount,sequence color)
	c_proc(xDrawTriangleStrip,{points,ptCount,color})
end procedure

public procedure DrawPoly(sequence center,integer sides,atom rad,atom rot,sequence color)
	c_proc(xDrawPoly,{center,sides,rad,rot,color})
end procedure

public procedure DrawPolyLines(sequence center,integer sides,atom rad,atom rot,sequence color)
	c_proc(xDrawPolyLines,{center,sides,rad,rot,color})
end procedure

public procedure DrawPolyLinesEx(sequence center,integer sides,atom rad,atom rot,atom lineThick,sequence color)
	c_proc(xDrawPolyLinesEx,{center,sides,rad,rot,lineThick,color})
end procedure

public function CheckCollisionRecs(sequence rec,sequence rec2)
	return c_func(xCheckCollisionRecs,{rec,rec2})
end function

public function CheckCollisionCircles(sequence center1,atom rad,sequence center2,atom rad2)
	return c_func(xCheckCollisionCircles,{center1,rad,center2,rad2})
end function

public function CheckCollisionCircleRec(sequence center,atom rad,sequence rec)
	return c_func(xCheckCollisionCircleRec,{center,rad,rec})
end function

public function CheckCollisionPointRec(sequence pt,sequence rec)
	return c_func(xCheckCollisionPointRec,{pt,rec})
end function

public function CheckCollisionPointCircle(sequence pt,sequence cent,atom rad)
	return c_func(xCheckCollisionPointCircle,{pt,cent,rad})
end function

public function CheckCollisionPointTriangle(sequence pt,sequence p1,sequence p2,sequence p3)
	return c_func(xCheckCollisionPointTriangle,{pt,p1,p2,p3})
end function

public function CheckCollisionLines(sequence startpos,sequence endpos,sequence startpos2,sequence endpos2,sequence colpt)
	return c_func(xCheckCollisionLines,{startpos,endpos,startpos2,endpos2,colpt})
end function

public function CheckCollisionPointLine(sequence pt,sequence p1,sequence p2,integer hold)
	return c_func(xCheckCollisionPointLine,{pt,p1,p2,hold})
end function

public function GetCollisionRec(sequence rec,sequence rec2)
	return c_func(xGetCollisionRec,{rec,rec2})
end function

public function LoadImage(sequence fileName)
	return c_func(xLoadImage,{fileName})
end function

public function LoadImageRaw(sequence fileName,atom w,atom h,atom format,atom size)
	return c_func(xLoadImageRaw,{fileName,w,h,format,size})
end function

public function LoadImageAnim(sequence fileName,atom frames)
	return c_func(xLoadImageAnim,{fileName,frames})
end function

public function LoadImageFromMemory(sequence fileType,atom fileData,atom size)
	return c_func(xLoadImageFromMemory,{fileType,fileData,size})
end function

public function LoadImageFromTexture(sequence texture)
	return c_func(xLoadImageFromTexture,{texture})
end function

public function LoadImageFromScreen()
	return c_func(xLoadImageFromScreen,{})
end function

public procedure UnloadImage(sequence image)
	c_proc(xUnloadImage,{image})
end procedure

public function ExportImage(sequence image,sequence fileName)
	return c_func(xExportImage,{image,fileName})
end function

public function ExportImageAsCode(sequence image,sequence fileName)
	return c_func(xExportImageAsCode,{image,fileName})
end function

public function GenImageColor(atom w,atom h,sequence color)
	return c_func(xGenImageColor,{w,h,color})
end function

public function GenImageGradientV(atom w,atom h,sequence top,sequence bottom)
	return c_func(xGenImageGradientV,{w,h,top,bottom})
end function

public function GenImageGradientH(atom w,atom h,sequence left,sequence right)
	return c_func(xGenImageGradientH,{w,h,left,right})
end function

public function GenImageGradientRadial(atom w,atom h,atom density,sequence inner,sequence outer)
	return c_func(xGenImageGradientRadial,{w,h,density,inner,outer})
end function

public function GenImageChecked(atom w,atom h,atom x,atom y,sequence col,sequence col2)
	return c_func(xGenImageChecked,{w,h,x,y,col,col2})
end function

public function GenImageWhiteNoise(atom w,atom h,atom factor)
	return c_func(xGenImageWhiteNoise,{w,h,factor})
end function

public function GenImageCellular(atom w,atom h,atom tileSize)
	return c_func(xGenImageCellular,{w,h,tileSize})
end function

public function ImageCopy(sequence image)
	return c_func(xImageCopy,{image})
end function

public function ImageFromImage(sequence image,sequence rec)
	return c_func(xImageFromImage,{image,rec})
end function

public function ImageText(sequence text,atom fontSize,sequence col)
	return c_func(xImageText,{text,fontSize,col})
end function

public function ImageTextEx(sequence font,sequence text,atom fontSize,atom space,sequence tint)
	return c_func(xImageTextEx,{font,text,fontSize,space,tint})
end function

public procedure ImageFormat(sequence image,atom newFormat)
	c_proc(xImageFormat,{image,newFormat})
end procedure

public procedure ImageToPOT(sequence image,sequence fill)
	c_proc(xImageToPOT,{image,fill}) --fill is color
end procedure

public procedure ImageCrop(sequence image,sequence crop)
	c_proc(xImageCrop,{image,crop}) --crop is rect
end procedure

public procedure ImageAlphaCrop(sequence image,atom threshold)
	c_proc(xImageAlphaCrop,{image,threshold})
end procedure

public procedure ImageAlphaClear(sequence image,sequence color,atom threshold)
	c_proc(xImageAlphaClear,{image,color,threshold})
end procedure

public procedure ImageAlphaMask(sequence image,sequence mask)
	c_proc(xImageAlphaMask,{image,mask})
end procedure

public procedure ImageAlphaPremultiply(sequence image)
	c_proc(xImageAlphaPremultiply,{image})
end procedure

public procedure ImageResize(sequence image,atom nw,atom nh)
	c_proc(xImageResize,{image,nw,nh})
end procedure

public procedure ImageResizeNN(sequence image,atom nw,atom nh)
	c_proc(xImageResizeNN,{image,nw,nh})
end procedure

public procedure ImageResizeCanvas(sequence image,atom nw,atom nh,atom x,atom y,sequence fill)
	c_proc(xImageResizeCanvas,{image,nw,nh,x,y,fill}) --fill is color
end procedure

public procedure ImageMipmaps(sequence image)
	c_proc(xImageMipmaps,{image})
end procedure

public procedure ImageDither(sequence image,atom r,atom g,atom b,atom a)
	c_proc(xImageDither,{image,r,g,b,a})
end procedure

public procedure ImageFlipVertical(sequence image)
	c_proc(xImageFlipVertical,{image})
end procedure

public procedure ImageFlipHorizontal(sequence image)
	c_proc(xImageFlipHorizontal,{image})
end procedure

public procedure ImageRotateCW(sequence image)
	c_proc(xImageRotateCW,{image})
end procedure

public procedure ImageRotateCCW(sequence image)
	c_proc(xImageRotateCCW,{image})
end procedure

public procedure ImageColorTint(sequence image,sequence col)
	c_proc(xImageColorTint,{image,col})
end procedure

public procedure ImageColorInvert(sequence image)
	c_proc(xImageColorInvert,{image})
end procedure

public procedure ImageColorGrayscale(sequence image)
	c_proc(xImageColorGrayscale,{image})
end procedure

public procedure ImageColorContrast(sequence image,atom contrast)
	c_proc(xImageColorContrast,{image,contrast})
end procedure

public procedure ImageColorBrightness(sequence image,atom bright)
	c_proc(xImageColorBrightness,{image,bright})
end procedure

public procedure ImageColorReplace(sequence image,sequence color,sequence replace)
	c_proc(xImageColorReplace,{image,color,replace}) --replace is color
end procedure

public function LoadImageColors(sequence image)
	return c_func(xLoadImageColors,{image})
end function

public function LoadImagePalette(sequence image,atom maxsize,atom count)
	return c_func(xLoadImagePalette,{image,maxsize,count})
end function

public procedure UnloadImageColors(sequence color)
	c_proc(xUnloadImageColors,{color})
end procedure

public procedure UnloadImagePalette(sequence color)
	c_proc(xUnloadImagePalette,{color})
end procedure

public function GetImageAlphaBorder(sequence image,atom threshold)
	return c_func(xGetImageAlphaBorder,{image,threshold})
end function

public function GetImageColor(sequence image,atom x,atom y)
	return c_func(xGetImageColor,{image,x,y})
end function

public procedure ImageClearBackground(sequence dst,sequence col)
	c_proc(xImageClearBackground,{dst,col})
end procedure

public procedure ImageDrawPixel(sequence dst,atom x,atom y,sequence col)
	c_proc(xImageDrawPixel,{dst,x,y,col})
end procedure

public procedure ImageDrawPixelV(sequence dst,sequence pos,sequence col)
	c_proc(xImageDrawPixelV,{dst,pos,col})
end procedure

public procedure ImageDrawLine(sequence dst,atom x,atom y,atom ex,atom ey,sequence col) 
	c_proc(xImageDrawLine,{dst,x,y,ex,ey,col})
end procedure

public procedure ImageDrawLineV(sequence dst,sequence center,atom rad,sequence col)
	c_proc(xImageDrawLineV,{dst,center,rad,col})
end procedure

public procedure ImageDrawCircle(sequence dst,atom x,atom y,atom rad,sequence col)
	c_proc(xImageDrawCircle,{dst,x,y,rad,col})
end procedure

public procedure ImageDrawCircleV(sequence dst,sequence center,atom rad,sequence col)
	c_proc(xImageDrawCircleV,{dst,center,rad,col})
end procedure

public procedure ImageDrawRectangle(sequence dst,atom x,atom y,atom w,atom h,sequence col)
	c_proc(xImageDrawRectangle,{dst,x,y,w,h,col})
end procedure

public procedure ImageDrawRectangleV(sequence dst,sequence pos,sequence size,sequence col)
	c_proc(xImageDrawRectangleV,{dst,pos,size,col})
end procedure

public procedure ImageDrawRectangleRec(sequence dst,sequence rec,sequence col)
	c_proc(xImageDrawRectangleRec,{dst,rec,col})
end procedure

public procedure ImageDrawRectangleLines(sequence dst,sequence rec,atom thick,sequence col)
	c_proc(xImageDrawRectangleLines,{dst,rec,thick,col})
end procedure

public procedure ImageDraw(sequence dst,sequence src,sequence srcR,sequence dstR,sequence tint)
	c_proc(xImageDraw,{dst,src,srcR,dstR,tint})
end procedure

public procedure ImageDrawText(sequence dst,sequence text,atom x,atom y,atom size,sequence col)
	c_proc(xImageDrawText,{dst,text,x,y,size,col})
end procedure

public procedure ImageDrawTextEx(sequence dst,sequence font,sequence text,sequence pos,atom size,atom space,sequence tint)
	c_proc(xImageDrawTextEx,{dst,font,text,pos,size,space,tint})
end procedure

public function LoadTexture(sequence fileName)
	return c_func(xLoadTexture,{fileName})
end function

public function LoadTextureFromImage(sequence image)
	return c_func(xLoadTextureFromImage,{image})
end function

public function LoadTextureCubemap(sequence image,atom layout)
	return c_func(xLoadTextureCubemap,{image,layout})
end function

public function LoadRenderTexture(atom w,atom h)
	return c_func(xLoadRenderTexture,{w,h})
end function

public procedure UnloadTexture(sequence tex)
	c_proc(xUnloadTexture,{tex})
end procedure

public procedure UnloadRenderTexture(sequence tar)
	c_proc(xUnloadRenderTexture,{tar})
end procedure

public procedure UpdateTexture(sequence tex,atom pix)
	c_proc(xUpdateTexture,{tex,pix})
end procedure

public procedure UpdateTextureRec(sequence tex,sequence rec,atom pix)
	c_proc(xUpdateTextureRec,{tex,rec,pix})
end procedure

public procedure GenTextureMipmaps(sequence tex)
	c_proc(xGenTextureMipmaps,{tex})
end procedure

public procedure SetTextureFilter(sequence tex,atom filter)
	c_proc(xSetTextureFilter,{tex,filter})
end procedure

public procedure SetTextureWrap(sequence tex,atom xwrap)
	c_proc(xSetTextureWrap,{tex,xwrap})
end procedure

public procedure DrawTexture(sequence tex,atom x,atom y,sequence tint)
	c_proc(xDrawTexture,{tex,x,y,tint})
end procedure

public procedure DrawTextureV(sequence tex,sequence pos,sequence col)
	c_proc(xDrawTextureV,{tex,pos,col})
end procedure

public procedure DrawTextureEx(sequence tex,sequence pos,atom rot,atom scale,sequence tint)
	c_proc(xDrawTextureEx,{tex,pos,rot,scale,tint})
end procedure

public procedure DrawTextureRec(sequence tex,sequence src,sequence pos,sequence tint)
	c_proc(xDrawTextureRec,{tex,src,pos,tint})
end procedure

public procedure DrawTextureQuad(sequence tex,sequence tiling,sequence offset,sequence quad,sequence tint)
	c_proc(xDrawTextureQuad,{tex,tiling,offset,quad,tint})
end procedure

public procedure DrawTextureTiled(sequence tex,sequence src,sequence dst,sequence ori,atom rot,atom scale,sequence tint)
	c_proc(xDrawTextureTiled,{tex,src,dst,ori,rot,scale,tint})
end procedure

public procedure DrawTexturePro(sequence tex,sequence src,sequence dst,sequence ori,atom rot,sequence tint)
	c_proc(xDrawTexturePro,{tex,src,dst,ori,rot,tint})
end procedure

public procedure DrawTextureNPatch(sequence tex,sequence npatch,sequence dst,sequence ori,atom rot,sequence tint)
	c_proc(xDrawTextureNPatch,{tex,npatch,dst,ori,rot,tint})
end procedure

public procedure DrawTexturePoly(sequence tex,sequence cent,sequence pts,sequence texcord,atom count,sequence tint)
	c_proc(xDrawTexturePoly,{tex,cent,pts,texcord,count,tint})
end procedure

public function ColorToInt(sequence col)
	return c_func(xColorToInt,{col})
end function

public function ColorNormalize(sequence col)
	return c_func(xColorNormalize,{col})
end function

public function ColorFromNormalized(sequence norm)
	return c_func(xColorFromNormalized,{norm})
end function

public function ColorToHSV(sequence col)
	return c_func(xColorToHSV,{col})
end function

public function ColorFromHSV(atom hue,atom sat,atom val)
	return c_func(xColorFromHSV,{hue,sat,val})
end function

public function ColorAlpha(sequence col,atom al)
	return c_func(xColorAlpha,{col,al})
end function

public function ColorAlphaBlend(sequence dst,sequence src,sequence tint)
	return c_func(xColorAlphaBlend,{dst,src,tint})
end function

public function GetColor(atom hexVal)
	return c_func(xGetColor,{hexVal})
end function

public function GetPixelColor(atom ptr,atom format)
	return c_func(xGetPixelColor,{ptr,format})
end function

public procedure SetPixelColor(atom ptr,sequence col,atom format)
	c_proc(xSetPixelColor,{ptr,col,format})
end procedure

public function GetPixelDataSize(atom w,atom h,atom format)
	return c_func(xGetPixelDataSize,{w,h,format})
end function

public function GetFontDefault()
	return c_func(xGetFontDefault,{})
end function

public function LoadFont(sequence fileName)
	return c_func(xLoadFont,{fileName})
end function

public function LoadFontEx(sequence fileName,atom size,atom chars,atom count)
	return c_func(xLoadFontEx,{fileName,size,chars,count})
end function

public function LoadFontFromImage(sequence image,sequence key,atom first)
	return c_func(xLoadFontFromImage,{image,key,first})
end function

public function LoadFontFromMemory(sequence fileType,sequence data,atom size,atom fontSize,atom chars,atom count)
	return c_func(xLoadFontFromMemory,{fileType,data,size,fontSize,chars,count})
end function

public function LoadFontData(sequence data,atom size,atom fontSize,atom chars,atom count,atom xtype)
	return c_func(xLoadFontData,{data,size,fontSize,chars,count,xtype})
end function

public function GenImageFontAtlas(sequence chars,sequence recs,atom count,atom size,atom padding,atom packMethod)
	return c_func(xGenImageFontAtlas,{chars,recs,count,size,padding,packMethod})
end function

public procedure UnloadFontData(sequence chars,atom count)
	c_proc(xUnloadFontData,{chars,count})
end procedure

public procedure UnloadFont(sequence font)
	c_proc(xUnloadFont,{font})
end procedure

public function ExportFontAsCode(sequence font,sequence fileName)
	return c_func(xExportFontAsCode,{font,fileName})
end function

public procedure DrawTextEx(sequence font,sequence text,sequence pos,atom size,atom space,sequence tint)
	c_proc(xDrawTextEx,{font,text,pos,size,space,tint})
end procedure

public procedure DrawTextPro(sequence font,sequence text,sequence pos,sequence ori,atom rot,atom size,atom space,sequence tint)
	c_proc(xDrawTextPro,{font,text,pos,ori,rot,size,space,tint})
end procedure

public procedure DrawTextCodepoint(sequence font,atom point,sequence pos,atom size,sequence tint)
	c_proc(xDrawTextCodepoint,{font,point,pos,size,tint})
end procedure

public procedure DrawTextCodepoints(sequence font,atom pts,atom count,sequence pos,atom size,atom space,sequence tint)
	c_proc(xDrawTextCodepoints,{font,pts,count,pos,size,space,tint})
end procedure

public function MeasureText(sequence text,atom size)
	return c_func(xMeasureText,{text,size})
end function

public function MeasureTextEx(sequence font,sequence text,atom size,atom space)
	return c_func(xMeasureTextEx,{font,text,size,space})
end function

public function GetGlyphIndex(sequence font,atom cp)
	return c_func(xGetGlyphIndex,{font,cp})
end function

public function GetGlyphInfo(sequence font,atom cp)
	return c_func(xGetGlyphInfo,{font,cp})
end function

public function GetGlyphAtlasRec(sequence font,atom cp)
	return c_func(xGetGlyphAtlasRec,{font,cp})
end function

public function LoadCodepoints(sequence text,atom count)
	return c_func(xLoadCodepoints,{text,count})
end function

public procedure UnloadCodepoints(atom cp)
	c_proc(xUnloadCodepoints,{cp})
end procedure

public function GetCodepointCount(sequence text)
	return c_func(xGetCodepointCount,{text})
end function

public function GetCodepoint(sequence text,atom bp)
	return c_func(xGetCodepoint,{text,bp})
end function

public function CodepointToUTF8(atom cp,atom size)
	return c_func(xCodepointToUTF8,{cp,size})
end function

public function TextCodepointsToUTF8(atom cp,atom len)
	return c_func(xTextCodepointsToUTF8,{cp,len})
end function

public function TextCopy(sequence dst,sequence src)
	return c_func(xTextCopy,{dst,src})
end function

public function TextIsEqual(sequence text,sequence text2)
	return c_func(xTextIsEqual,{text,text2})
end function

public function TextLength(sequence text)
	return c_func(xTextLength,{text})
end function

public function TextFormat(sequence text)
	return c_func(xTextFormat,{text})
end function

public function TextSubtext(sequence text,atom pos,atom len)
	return c_func(xTextSubtext,{text,pos,len})
end function

public function TextReplace(sequence text,sequence rep,sequence b)
	return c_func(xTextReplace,{text,rep,b})
end function

public function TextInsert(sequence text,sequence in,atom pos)
	return c_func(xTextInsert,{text,in,pos})
end function

public function TextJoin(sequence text,atom count,sequence de)
	return c_func(xTextJoin,{text,count,de})
end function

public function TextSplit(sequence text,sequence de,atom count)
	return c_func(xTextSplit,{text,de,count})
end function

public procedure TextAppend(sequence text,sequence app,atom pos)
	c_proc(xTextAppend,{text,app,pos})
end procedure

public function TextFindIndex(sequence text,sequence f)
	return c_func(xTextFindIndex,{text,f})
end function

public function TextToUpper(sequence text)
	return c_func(xTextToUpper,{text})
end function

public function TextToLower(sequence text)
	return c_func(xTextToLower,{text})
end function

public function TextToPascal(sequence text)
	return c_func(xTextToPascal,{text})
end function

public function TextToInteger(sequence text)
	return c_func(xTextToInteger,{text})
end function

public procedure DrawLine3D(sequence startPos,sequence endPos,sequence col)
	c_proc(xDrawLine3D,{startPos,endPos,col})
end procedure

public procedure DrawPoint3D(sequence pos,sequence col)
	c_proc(xDrawPoint3D,{pos,col})
end procedure

public procedure DrawCircle3D(sequence center,atom rad,sequence rotAxis,atom rotAngle,sequence col)
	c_proc(xDrawCircle3D,{center,rad,rotAxis,rotAngle,col})
end procedure

public procedure DrawTriangle3D(sequence v1,sequence v2,sequence v3,sequence col)
	c_proc(xDrawTriangle3D,{v1,v2,v3,col})
end procedure

public procedure DrawTriangleStrip3D(sequence pts,atom count,sequence col)
	c_proc(xDrawTriangleStrip3D,{pts,count,col})
end procedure

public procedure DrawCubeV(sequence pos,sequence size,sequence col)
	c_proc(xDrawCubeV,{pos,size,col})
end procedure

public procedure DrawCubeWiresV(sequence pos,sequence size,sequence col)
	c_proc(xDrawCubeWiresV,{pos,size,col})
end procedure

public procedure DrawCubeTexture(sequence tex,sequence pos,atom w,atom h,atom len,sequence col)
	c_proc(xDrawCubeTexture,{tex,pos,w,h,len,col})
end procedure

public procedure DrawCubeTextureRec(sequence tex,sequence src,sequence pos,atom w,atom h,atom len,sequence col)
	c_proc(xDrawCubeTextureRec,{tex,src,pos,w,h,len,col})
end procedure

public procedure DrawSphere(sequence pos,atom rad,sequence col)
	c_proc(xDrawSphere,{pos,rad,col})
end procedure

public procedure DrawSphereEx(sequence pos,atom rad,atom rings,atom slices,sequence col)
	c_proc(xDrawSphereEx,{pos,rad,rings,slices,col})
end procedure

public procedure DrawSphereWires(sequence pos,atom rad,atom rings,atom slices,sequence col)
	c_proc(xDrawSphereWires,{pos,rad,rings,slices,col})
end procedure

public procedure DrawCylinder(sequence pos,atom radTop,atom radBot,atom h,atom slices,sequence col)
	c_proc(xDrawCylinder,{pos,radTop,radBot,h,slices,col})
end procedure

public procedure DrawCylinderEx(sequence pos,sequence endpos,atom sRad,atom eRad,atom sides,sequence col)
	c_proc(xDrawCylinderEx,{pos,endpos,sRad,eRad,sides,col})
end procedure

public procedure DrawCylinderWires(sequence pos,atom radTop,atom radBot,atom h,atom slices,sequence col)
	c_proc(xDrawCylinderWires,{pos,radTop,radBot,h,slices,col})
end procedure

public procedure DrawCylinderWiresEx(sequence pos,sequence endpos,atom sRad,atom eRad,atom sides,sequence col)
	c_proc(xDrawCylinderWiresEx,{pos,endpos,sRad,eRad,sides,col})
end procedure

public procedure DrawPlane(sequence pos,sequence size,sequence col)
	c_proc(xDrawPlane,{pos,size,col})
end procedure

public procedure DrawRay(sequence ray,sequence col)
	c_proc(xDrawRay,{ray,col})
end procedure

public function LoadModel(sequence fileName)
	return c_func(xLoadModel,{fileName})
end function

public function LoadModelFromMesh(sequence mesh)
	return c_func(xLoadModelFromMesh,{mesh})
end function

public procedure UnloadModel(sequence model)
	c_proc(xUnloadModel,{model})
end procedure

public procedure UnloadModelKeepMeshes(sequence mod)
	c_proc(xUnloadModelKeepMeshes,{mod})
end procedure

public function GetModelBoundingBox(sequence mod)
	return c_func(xGetModelBoundingBox,{mod})
end function

public procedure DrawModel(sequence mod,sequence pos,atom scale,sequence col)
	c_proc(xDrawModel,{mod,pos,scale,col})
end procedure

public procedure DrawModelEx(sequence mod,sequence pos,sequence rotAxis,sequence rotAng,sequence scale,sequence col)
	c_proc(xDrawModelEx,{mod,pos,rotAxis,rotAng,scale,col})
end procedure

public procedure DrawModelWires(sequence mod,sequence pos,atom scale,sequence col)
	c_proc(xDrawModelWires,{mod,pos,scale,col})
end procedure

public procedure DrawModelWiresEx(sequence mod,sequence pos,sequence rotAxis,atom rotAng,sequence scale,sequence col)
	c_proc(xDrawModelWiresEx,{mod,pos,rotAxis,rotAng,scale,col})
end procedure

public procedure DrawBoundingBox(sequence box,sequence col)
	c_proc(xDrawBoundingBox,{box,col})
end procedure

public procedure DrawBillboard(sequence cam,sequence tex,sequence pos,atom size,sequence col)
	c_proc(xDrawBillboard,{cam,tex,pos,size,col})
end procedure

public procedure DrawBillboardRec(sequence cam,sequence tex,sequence src,sequence pos,sequence size,sequence col)
	c_proc(xDrawBillboardRec,{cam,tex,src,pos,size,col})
end procedure

public procedure DrawBillboardPro(sequence cam,sequence tex,sequence src,sequence pos,sequence up,sequence size,sequence ori,atom rot,sequence col)
	c_proc(xDrawBillboardPro,{cam,tex,src,pos,up,size,ori,rot,col})
end procedure

public procedure UploadMesh(sequence mesh,atom dyn)
	c_proc(xUploadMesh,{mesh,dyn})
end procedure

public procedure UpdateMeshBuffer(sequence mesh,atom idx,atom dat,atom size,atom off)
	c_proc(xUpdateMeshBuffer,{mesh,idx,dat,size,off})
end procedure

public procedure UnloadMesh(sequence mesh)
	c_proc(xUnloadMesh,{mesh})
end procedure

public procedure DrawMesh(sequence mesh,sequence mat,sequence trans)
	c_proc(xDrawMesh,{mesh,mat,trans})
end procedure

public procedure DrawMeshInstanced(sequence mesh,sequence mat,sequence trans,atom inst)
	c_proc(xDrawMeshInstanced,{mesh,mat,trans,inst})
end procedure

public function ExportMesh(sequence mesh,sequence file)
	return c_func(xExportMesh,{mesh,file})
end function

public function GetMeshBoundingBox(sequence mesh)
	return c_func(xGetMeshBoundingBox,{mesh})
end function

public procedure GenMeshTangents(sequence mesh)
	c_proc(xGenMeshTangents,{mesh})
end procedure

public function GenMeshPoly(atom sides,atom rad)
	return c_func(xGenMeshPoly,{sides,rad})
end function

public function GenMeshPlane(atom w,atom len,atom x,atom z)
	return c_func(xGenMeshPlane,{w,len,x,z})
end function

public function GenMeshCube(atom w,atom h,atom len)
	return c_func(xGenMeshCube,{w,h,len})
end function

public function GenMeshSphere(atom rad,atom rings,atom slices)
	return c_func(xGenMeshSphere,{rad,rings,slices})
end function

public function GenMeshHemiSphere(atom rad,atom rings,atom slices)
	return c_func(xGenMeshHemiSphere,{rad,rings,slices})
end function

public function GenMeshCylinder(atom rad,atom h,atom slices)
	return c_func(xGenMeshCylinder,{rad,h,slices})
end function

public function GenMeshCone(atom rad,atom h,atom slice)
	return c_func(xGenMeshCone,{rad,h,slice})
end function

public function GenMeshTorus(atom rad,atom size,atom seg,atom side)
	return c_func(xGenMeshTorus,{rad,size,seg,side})
end function

public function GenMeshKnot(atom rad,atom size,atom seg,atom side)
	return c_func(xGenMeshKnot,{rad,size,seg,side})
end function

public function GenMeshHeightmap(sequence heightmap,sequence size)
	return c_func(xGenMeshHeightmap,{heightmap,size})
end function

public function GenMeshCubicmap(sequence cubic,sequence size)
	return c_func(xGenMeshCubicmap,{cubic,size})
end function

public function LoadMaterials(sequence file,atom count)
	return c_func(xLoadMaterials,{file,count})
end function

public function LoadMaterialDefault()
	return c_func(xLoadMaterialDefault,{})
end function

public procedure UnloadMaterial(sequence mat)
	c_proc(xUnloadMaterial,{mat})
end procedure

public procedure SetMaterialTexture(sequence mat,atom mtype,sequence tex)
	c_proc(xSetMaterialTexture,{mat,mtype,tex})
end procedure

public procedure SetModelMeshMaterial(sequence mod,atom id,atom mid)
	c_proc(xSetModelMeshMaterial,{mod,id,mid})
end procedure

public function LoadModelAnimations(sequence file,atom count)
	return c_func(xLoadModelAnimations,{file,count})
end function

public procedure UpdateModelAnimation(sequence mod,sequence ani,atom frame)
	c_proc(xUpdateModelAnimation,{mod,ani,frame})
end procedure

public procedure UnloadModelAnimation(sequence ani)
	c_proc(xUnloadModelAnimation,{ani})
end procedure

public procedure UnloadModelAnimations(sequence ani,atom count)
	c_proc(xUnloadModelAnimations,{ani,count})
end procedure

public function IsModelAnimationValid(sequence mod,sequence ani)
	return c_func(xIsModelAnimationValid,{mod,ani})
end function

public function CheckCollisionSpheres(sequence center,atom rad,sequence center2,atom rad2)
	return c_func(xCheckCollisionSpheres,{center,rad,center2,rad2})
end function

public function CheckCollisionBoxes(sequence box,sequence box2)
	return c_func(xCheckCollisionBoxes,{box,box2})
end function

public function CheckCollisionBoxSphere(sequence box,sequence center,atom rad)
	return c_func(xCheckCollisionBoxSphere,{box,center,rad})
end function

public function GetRayCollisionSphere(sequence ray,sequence center,atom rad)
	return c_func(xGetRayCollisionSphere,{ray,center,rad})
end function

public function GetRayCollisionBox(sequence ray,sequence box)
	return c_func(xGetRayCollisionBox,{ray,box})
end function

public function GetRayCollisionMesh(sequence ray,sequence mesh,sequence trans)
	return c_func(xGetRayCollisionMesh,{ray,mesh,trans})
end function

public function GetRayCollisionTriangle(sequence ray,sequence p1,sequence p2,sequence p3)
	return c_func(xGetRayCollisionTriangle,{ray,p1,p2,p3})
end function

public function GetRayCollisionQuad(sequence ray,sequence p1,sequence p2,sequence p3,sequence p4)
	return c_func(xGetRayCollisionQuad,{ray,p1,p2,p3,p4})
end function

public procedure InitAudioDevice()
	c_proc(xInitAudioDevice,{})
end procedure

public procedure CloseAudioDevice()
	c_proc(xCloseAudioDevice,{})
end procedure

public function IsAudioDeviceReady()
	return c_func(xIsAudioDeviceReady,{})
end function

public procedure SetMasterVolume(atom vol)
	c_proc(xSetMasterVolume,{vol})
end procedure

public function LoadWave(sequence file)
	return c_func(xLoadWave,{file})
end function

public function LoadWaveFromMemory(sequence file,sequence dat,atom size)
	return c_func(xLoadWaveFromMemory,{file,dat,size})
end function

public function LoadSound(sequence file)
	return c_func(xLoadSound,{file})
end function

public function LoadSoundFromWave(sequence wav)
	return c_func(xLoadSoundFromWave,{wav})
end function

public procedure UpdateSound(sequence snd,atom dat,atom count)
	c_proc(xUpdateSound,{snd,dat,count})
end procedure

public procedure UnloadWave(sequence wav)
	c_proc(xUnloadWave,{wav})
end procedure

public procedure UnloadSound(sequence snd)
	c_proc(xUnloadSound,{snd})
end procedure

public function ExportWave(sequence wav,sequence file)
	return c_func(xExportWave,{wav,file})
end function

public function ExportWaveAsCode(sequence wav,sequence file)
	return c_func(xExportWaveAsCode,{wav,file})
end function

public procedure PlaySound(sequence snd)
	c_proc(xPlaySound,{snd})
end procedure

public procedure StopSound(sequence snd)
	c_proc(xStopSound,{snd})
end procedure

public procedure PauseSound(sequence snd)
	c_proc(xPauseSound,{snd})
end procedure

public procedure ResumeSound(sequence snd)
	c_proc(xResumeSound,{snd})
end procedure

public procedure PlaySoundMulti(sequence snd)
	c_proc(xPlaySoundMulti,{snd})
end procedure

public procedure StopSoundMulti()
	c_proc(xStopSoundMulti,{})
end procedure

public function GetSoundsPlaying()
	return c_func(xGetSoundsPlaying,{})
end function

public function IsSoundPlaying(sequence snd)
	return c_func(xIsSoundPlaying,{snd})
end function

public procedure SetSoundVolume(sequence snd,atom vol)
	c_proc(xSetSoundVolume,{snd,vol})
end procedure

public procedure SetSoundPitch(sequence snd,atom pit)
	c_proc(xSetSoundPitch,{snd,pit})
end procedure

public procedure SetSoundPan(sequence snd,atom pan)
	c_proc(xSetSoundPan,{snd,pan})
end procedure

public function WaveCopy(sequence wav)
	return c_func(xWaveCopy,{wav})
end function

public procedure WaveCrop(sequence wav,atom init,atom final)
	c_proc(xWaveCrop,{wav,init,final})
end procedure

public procedure WaveFormat(sequence wav,atom sample,atom size,atom chan)
	c_proc(xWaveFormat,{wav,sample,size,chan})
end procedure

public function LoadWaveSamples(sequence wav)
	return c_func(xLoadWaveSamples,{wav})
end function

public procedure UnloadWaveSamples(atom samp)
	c_proc(xUnloadWaveSamples,{samp})
end procedure

public function LoadMusicStream(sequence file)
	return c_func(xLoadMusicStream,{file})
end function

public function LoadMusicStreamFromMemory(sequence file,sequence dat,atom size)
	return c_func(xLoadMusicStreamFromMemory,{file,dat,size})
end function

public procedure UnloadMusicStream(sequence mus)
	c_proc(xUnloadMusicStream,{mus})
end procedure

public procedure PlayMusicStream(sequence mus)
	c_proc(xPlayMusicStream,{mus})
end procedure

public function IsMusicStreamPlaying(sequence mus)
	return c_func(xIsMusicStreamPlaying,{mus})
end function

public procedure UpdateMusicStream(sequence mus)
	c_proc(xUpdateMusicStream,{mus})
end procedure

public procedure StopMusicStream(sequence mus)
	c_proc(xStopMusicStream,{mus})
end procedure

public procedure PauseMusicStream(sequence mus)
	c_proc(xPauseMusicStream,{mus})
end procedure

public procedure ResumeMusicStream(sequence mus)
	c_proc(xResumeMusicStream,{mus})
end procedure

public procedure SeekMusicStream(sequence mus,atom pos)
	c_proc(xSeekMusicStream,{mus,pos})
end procedure

public procedure SetMusicVolume(sequence mus,atom vol)
	c_proc(xSetMusicVolume,{mus,vol})
end procedure

public procedure SetMusicPitch(sequence mus,atom pit)
	c_proc(xSetMusicPitch,{mus,pit})
end procedure

public procedure SetMusicPan(sequence mus,atom pan)
	c_proc(xSetMusicPan,{mus,pan})
end procedure

public function GetMusicTimeLength(sequence mus)
	return c_func(xGetMusicTimeLength,{mus})
end function

public function GetMusicTimePlayed(sequence mus)
	return c_func(xGetMusicTimePlayed,{mus})
end function

public function LoadAudioStream(atom sam,atom size,atom chan)
	return c_func(xLoadAudioStream,{sam,size,chan})
end function

public procedure UnloadAudioStream(sequence s)
	c_proc(xUnloadAudioStream,{s})
end procedure

public procedure UpdateAudioStream(sequence s,atom dat,atom count)
	c_proc(xUpdateAudioStream,{s,dat,count})
end procedure

public function IsAudioStreamProcessed(sequence s)
	return c_func(xIsAudioStreamProcessed,{s})
end function

public procedure PlayAudioStream(sequence s)
	c_proc(xPlayAudioStream,{s})
end procedure

public procedure PauseAudioStream(sequence s)
	c_proc(xPauseAudioStream,{s})
end procedure

public procedure ResumeAudioStream(sequence s)
	c_proc(xResumeAudioStream,{s})
end procedure

public function IsAudioStreamPlaying(sequence s)
	return c_func(xIsAudioStreamPlaying,{s})
end function

public procedure StopAudioStream(sequence s)
	c_proc(xStopAudioStream,{s})
end procedure

public procedure SetAudioStreamVolume(sequence s,atom vol)
	c_proc(xSetAudioStreamVolume,{s,vol})
end procedure

public procedure SetAudioStreamPitch(sequence s,atom pit)
	c_proc(xSetAudioStreamPitch,{s,pit})
end procedure

public procedure SetAudioStreamPan(sequence s,atom pan)
	c_proc(xSetAudioStreamPan,{s,pan})
end procedure

public procedure SetAudioStreamBufferSizeDefault(atom size)
	c_proc(xSetAudioStreamBufferSizeDefault,{size})
end procedure

public procedure SetAudioStreamCallback(sequence s,atom cb)
	c_proc(xSetAudioStreamCallback,{s,cb})
end procedure

public procedure AttachAudioStreamProcessor(sequence s,atom pro)
	c_proc(xAttachAudioStreamProcessor,{s,pro})
end procedure

public procedure DetachAudioStreamProcessor(sequence s,atom pro)
	c_proc(xDetachAudioStreamProcessor,{s,pro})
end procedure
­3218.44