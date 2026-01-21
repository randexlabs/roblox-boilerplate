type LanguageMode = 'strict' | 'nonstrict' | 'nocheck'

type LintWarning =
	'*'
	| 'UnknownGlobal'
	| 'DeprecatedGlobal'
	| 'GlobalUsedAsLocal'
	| 'LocalShadow'
	| 'SameLineStatement'
	| 'MultiLineStatement'
	| 'LocalUnused'
	| 'FunctionUnused'
	| 'ImportUnused'
	| 'BuiltinGlobalWrite'
	| 'PlaceholderRead'
	| 'UnreachableCode'
	| 'UnknownType'
	| 'ForRange'
	| 'UnbalancedAssignment'
	| 'ImplicitReturn'
	| 'DuplicateLocal'
	| 'FormatString'
	| 'TableLiteral'
	| 'UninitializedLocal'
	| 'DuplicateFunction'
	| 'DeprecatedApi'
	| 'TableOperations'
	| 'DuplicateCondition'
	| 'MisleadingAndOr'
	| 'CommentDirective'
	| 'IntegerParsing'
	| 'ComparisonPrecedence'
	| 'RedundantNativeAttribute'

type LuauConfig = {
	languagemode: LanguageMode?,
	lint: { [LintWarning]: boolean }?,
	linterrors: boolean?,
	typeerrors: boolean?,
	globals: { string }?,
	aliases: { [string]: string }?,
}

type Config = { luau: LuauConfig? }

return {
	luau = {
		languagemode = 'strict',
		aliases = {
			lune = '~/.lune/.typedefs/0.10.4/',
			Pkg = 'roblox_packages',
			SharedFirst = 'src/ReplicatedFirst',
			Shared = 'src/ReplicatedStorage',
			Server = 'src/ServerScriptService',
			Client = 'src/StarterPlayerScripts',
			NetServer = 'src/ServerScriptService/NetServer.luau',
			NetClient = 'src/ReplicatedStorage/NetClient.luau',
			NetTypes = 'src/ReplicatedStorage/NetTypes.luau',
		},
	},
} :: Config
