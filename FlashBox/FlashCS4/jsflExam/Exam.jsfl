var dom = fl.getDocumentDOM();
var lib = dom.library;
var result = dom.xmlPanel("file:///ruler.xml");
if(result.dismiss == "accept") {
  fl.outputPanel.clear();
  drawRuler();
}

function drawRuler() {
  var _width = Number(result.width);
  var _height = Number(result.height);
  var _grad = Number(result.grad);
  var grad_length;
  var start = -1;
  dom.addNewLine({x:0,y:0},{x:_width,y:0});
  dom.addNewLine({x:_width,y:0},{x:_width,y:_height});
  dom.addNewLine({x:_width,y:_height},{x:0,y:_height});
  dom.addNewLine({x:0,y:_height},{x:0,y:0});
  for(var i=_grad*2; i<=_width; i+=_grad){
    start ++;
    if((start % 10) == 0 || start == 0){
      grad_length = _height/2.5;
      dom.addNewText({left:i-5, top:grad_length, right:i+5, bottom:grad_length+10});
      dom.setTextString(start/10);
      dom.setElementTextAttr('size', 12);
      dom.setElementProperty('alignment', 'center');
      dom.setElementTextAttr('bold', false);
      dom.setElementTextAttr('italic', false);
      dom.setElementTextAttr('face', 'Times New Roman');
    } else if((start % 5) == 0){
      grad_length = _height/3;
    } else {
      grad_length = _height/5;
    }
    dom.addNewLine({x:i, y:0}, {x:i, y:grad_length});
  }
  dom.selectNone();
}
