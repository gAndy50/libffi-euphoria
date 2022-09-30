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
	xDrawLine           = define_c_proc( raylib, "+DrawLine", {C_INT,C_INT,C_INT,C_INT,RL_COLOR} ),
	xDrawCircle         = define_c_proc( raylib, "+DrawCircle", {C_INT,C_INT,C_FLOAT,RL_COLOR} ),
	xDrawCircleV        = define_c_proc( raylib, "+DrawCircleV", {RL_VECTOR2, C_FLOAT, RL_COLOR} ),
	xDrawRectangle      = define_c_proc( raylib, "+DrawRectangle", {C_INT,C_INT,C_INT,C_INT,RL_COLOR} ),
	xDrawRectangleRec   = define_c_proc( raylib, "+DrawRectangleRec", {RL_RECTANGLE,RL_COLOR} ),
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
­756.57