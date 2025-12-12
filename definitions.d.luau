export type Set<T> = { [T]: true }
export type Map<K, V> = { [K]: V }
export type Callback<P..., R... = ()> = (P...) -> R...

declare _G: {
    __DEV__: boolean?
}