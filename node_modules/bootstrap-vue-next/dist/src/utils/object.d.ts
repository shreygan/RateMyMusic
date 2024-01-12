/**
 * Removes properties from an object, based on the values in an array, and returns the new object.
 * Equivalent to an object version of TS Omit<>
 */
export declare const omit: <A extends Record<PropertyKey, unknown>, const B extends readonly PropertyKey[]>(objToPluck: A, keysToPluck: B | (keyof A)[]) => Omit<A, B[number]>;
/**
 * Picks properties from an object, base on the values in an array, and returns the new object.
 * Equivalent to an object version of TS Pick<>
 */
export declare const pick: <A extends Record<PropertyKey, unknown>, const B extends readonly PropertyKey[]>(objToPluck: A, keysToPluck: B | (keyof A)[]) => Pick<A, B[number]>;
/**
 * Dynamically get a nested value from an array or
 * object with a string.
 *
 * @example get(person, 'friends[0].name')
 * @link https://github.com/rayepps/radash/blob/master/src/object.ts#L214
 */
export declare const get: <TDefault = unknown>(value: any, path: string, defaultValue?: TDefault | undefined) => TDefault;
