var dom = fl.getDocumentDOM();
var el = dom.selection[0]; // 得到场景上被选择的第一个元素。
if (el) {
	fl.trace("el.left = "+el.left);
	fl.trace("el.top = "+el.top);
	fl.trace("el.width = "+el.width);
	fl.trace("el.height = "+el.height);
	fl.trace("el.matrix.tx = "+el.matrix.tx);
	fl.trace("el.matrix.ty = "+el.matrix.ty);
	var tp = dom.getTransformationPoint();
	fl.trace("tp.x = "+tp.x);
	fl.trace("tp.y = "+tp.y);
}