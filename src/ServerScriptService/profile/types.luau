local store = require(script.Parent.store)
export type Profile = typeof(store:StartSessionAsync(`profile_key`, {}))
export type Data = typeof(assert(({} :: any) :: Profile).Data)

return nil
