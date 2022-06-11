import { camelCase, isArray, isObject, transform } from "lodash";

const camelize = (obj: any) =>
  transform(obj, (acc: any[], value, key: any, target) => {
    const camelKey = isArray(target) ? key : camelCase(key);

    acc[camelKey] = isObject(value) ? camelize(value) : value;
  });

export const parseConfig = (config: any) => {
  return camelize(config);
};
