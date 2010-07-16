#include "class_definition.h"
#include "../../class.h"
#include "../../utils.h"
#include "../../bootstrap/core_classes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      ClassDefExpr::ClassDefExpr(Identifier* class_name,
                                 ExpressionList* class_body) :
        _superclass(ObjectClass),
        _superclass_name(NULL),
        _class_name(class_name),
        _class_body(class_body)
      {
      }

      ClassDefExpr::ClassDefExpr(Identifier* superclass_name,
                                 Identifier* class_name,
                                 ExpressionList* class_body) :
        _superclass(NULL),
        _superclass_name(superclass_name),
        _class_name(class_name),
        _class_body(class_body)
      {
      }

      ClassDefExpr::ClassDefExpr(Class* superclass,
                                 Identifier* class_name,
                                 ExpressionList* class_body) :
        _superclass(superclass),
        _superclass_name(Identifier::from_string(superclass->name())),
        _class_name(class_name),
        _class_body(class_body)
      {
      }

      FancyObject* ClassDefExpr::eval(Scope *scope)
      {
        Class* the_class = NULL;
        FancyObject* class_obj = nil;
        if(_outer_class) { // nested class
          class_obj = _outer_class->get_nested_class(_class_name->name());
        } else {
          class_obj = _class_name->eval(scope);
        }

        // check if class is already defined.
        // if so, don't create a new class
        // if not yet defined, create a new class and define it in the
        // current scope
        if(!(the_class = dynamic_cast<Class*>(class_obj))) {
          Class* superclass = _superclass;
          if(!superclass && _superclass_name) {
            FancyObject* class_obj = scope->get(_superclass_name->name());
            if(IS_CLASS(class_obj)) {
              superclass = dynamic_cast<Class*>(class_obj);
            } else {
              error("Superclass identifier does not reference a class: ")
                << _superclass_name->name()
                << "(" << class_obj->type() << ")"
                << endl;
              return nil;
            }
          }

          the_class = new Class(_class_name->name(), superclass);
          scope->define(_class_name->name(), the_class);
        }
        // create new scope with current_self set to new class
        // and eval the body of the class definition
        Scope *class_eval_scope = new Scope(the_class, scope);
        class_eval_scope->set_current_class(the_class);
        _class_body->eval(class_eval_scope);
        // set documentation string, if given
        if(_class_body->docstring() != "") {
          the_class->set_docstring(_class_body->docstring());
        }
        return the_class;
      }

    }
  }
}
