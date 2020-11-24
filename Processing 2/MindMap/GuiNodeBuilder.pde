class GuiNodeBuilder extends NodeBuilder<GuiNodeBuilder> {
  private Method action;
  private Object context;
  private String hintText;

  GuiNodeBuilder setHintText(String text) {
    this.hintText = text;
    return this;
  }

  GuiNodeBuilder registerActionContext(Object context) {
    this.context = context;
    return this;
  }

  GuiNodeBuilder registerNodeMethod(String methodName) {
    try {
      this.action = MindMap.this.getClass().getMethod(methodName, GuiNode.class, Node.class);
    }
    catch(NoSuchMethodException e) {
      e.printStackTrace();
      throw new IllegalArgumentException(String.format("Could not find method of name '%s' when attempting to register this method to a GuiNodeBuilder.", methodName));
    }
    return this;
  }

  GuiNodeBuilder registerNodeMethod(Method method) {
    this.action = method;
    return this;
  }

  GuiNode build() {
    return new GuiNode(this.action, this.context, this.hintText, this.location, this.renderLocation, this.size, this.actualSize, this.outlineSize, this.alignAngle, this.text, this.fill, this.highlightFill, this.stroke, this.ignoreParent, this.childCount);
  }
}

