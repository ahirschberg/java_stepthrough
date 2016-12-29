import 'package:angular2/core.dart';
import 'ace_facade.dart';
@Component(
    selector: 'ace-edit',
    template: '',
    styleUrls: const ['css/ace_editor_component.css'])
class AceEditorComponent implements OnInit {
  static int _uniq_id_num = 0;
  Editor aceController;
  ElementRef elementRef;
  @Output('onInit')
  EventEmitter init = new EventEmitter();

  AceEditorComponent(this.elementRef) {
  }

  ngOnInit() {
    if (dom_id.length == 0) dom_id = 'ace-edit-${_uniq_id_num++}';
    aceController = ace.edit(elementRef.nativeElement.id);
    aceController.$blockScrolling = double.INFINITY; // disables scroll warning spam in ace 1.2.6
    init.emit(this);
  }

  String get text => aceController.getValue();
  set text(String newValue) => aceController.setValue(newValue);

  String get dom_id => elementRef.nativeElement.id;
  set dom_id(id) => elementRef.nativeElement.id = id;
}
