import { Plugin } from "obsidian";

export default class ExamplePlugin extends Plugin {
  async onload() {
    console.log('loading plugin')
  }
  async onunload() {
    console.log('unloading plugin')
  }
}
