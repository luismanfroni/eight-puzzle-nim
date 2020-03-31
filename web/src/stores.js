import { writable } from 'svelte/store';

export const painting = writable(false);
export const board = writable([1,2,3,4,5,6,7,8,0]);
export const lastUpdate = writable(null);
export const solution = writable(null);
export const view = writable("input");