// place files you want to import through the `$lib` alias in this folder.
class ShaderUniform {
  name: string;
  type: string;
  value: any;

  constructor(name: string, type: string) {
    this.name = name;
    this.type = type;

    this.value = null
  }
}
