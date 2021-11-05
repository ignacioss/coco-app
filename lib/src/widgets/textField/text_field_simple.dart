import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFieldSimple extends StatefulWidget {
  final Function? onValueChanged;
  final Function(String)? onDone;
  final String? initialValue;
  final Widget? prefijo;
  final String? textoPrefijo;
  final String? titulo;
  final Color? tituloColor;
  final String? hint;
  final String? requiredErrorMsg;
  final bool? isRequired;
  final bool? autofocus;
  final FocusNode? thisFocusNode;
  final FocusNode? nextFocusNode;
  final bool? isPassword;
  final bool? isEmail;
  final bool? isNumeric;
  final int? maxLines;
  final Color? fillColor;
  final int? minCharacters;
  final int? maxCharacters;
  final TextCapitalization? capitalization;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final bool? enabled;
  final bool? enableSuggestions;
  final bool? autocorrect;

  AppTextFieldSimple({
    Key? key,
    this.onValueChanged,
    this.onDone,
    this.initialValue,
    this.prefijo,
    this.titulo,
    this.tituloColor,
    this.hint,
    this.requiredErrorMsg,
    this.isRequired = false,
    this.autofocus = false,
    this.thisFocusNode,
    this.nextFocusNode,
    this.isPassword = false,
    this.isEmail = false,
    this.isNumeric = false,
    this.maxLines = 1,
    this.fillColor,
    this.minCharacters = 3,
    this.maxCharacters,
    this.capitalization = TextCapitalization.sentences,
    this.border,
    this.focusedBorder,
    this.textStyle,
    this.textAlign,
    this.enabled = true,
    this.textoPrefijo,
    this.enableSuggestions = true,
    this.autocorrect = true,
  }) : super(key: key);

  @override
  AppTextFieldSimpleState createState() => new AppTextFieldSimpleState();
}

class AppTextFieldSimpleState extends State<AppTextFieldSimple> {
  TextEditingController controller = TextEditingController();
  bool hayError = false;
  bool mostrarPass = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      String value = controller.text;
      if (widget.onValueChanged != null) {
        widget.onValueChanged!(value);
      }
    });

    controller.text = widget.initialValue!;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void actualizarValue(String newValue) {
    controller.text = newValue;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.titulo != null) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(bottom: widget.maxLines! > 1 ? 10 : 10),
                  child: Text(
                    widget.titulo!,
                    style: TextStyle(
                      color: widget.tituloColor != null
                          ? widget.tituloColor
                          : Color(0xff39FC7A),
                    ),
                  ),
                ),
              ],
            ),
            _buildTextEdit(),
          ],
        ),
      );
    } else {
      return Container(
        child: _buildTextEdit(),
      );
    }
  }

  Widget _buildTextEdit() {
    return Container(
      margin: hayError ? EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
      child: TextFormField(
        textCapitalization: widget.capitalization!,
        keyboardType: (widget.isEmail!)
            ? TextInputType.emailAddress
            : (widget.isNumeric!) ? TextInputType.number : TextInputType.text,
        inputFormatters: (widget.isNumeric!)
            ? <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly]
            : <TextInputFormatter>[
                BlacklistingTextInputFormatter(
                  RegExp(
                      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                ),
              ],
        focusNode: (widget.thisFocusNode != null) ? widget.thisFocusNode : null,
        autofocus: widget.autofocus!,
        obscureText: !mostrarPass && widget.isPassword!,
        controller: controller,
        textInputAction: (widget.nextFocusNode != null)
            ? TextInputAction.next
            : (widget.maxLines! > 1)
                ? TextInputAction.newline
                : TextInputAction.done,
        onEditingComplete: () {
          if (widget.nextFocusNode != null) {
            widget.nextFocusNode!.requestFocus();
          } else {
            if (widget.onDone != null) {
              widget.onDone!(controller.value.text);
            }
            widget.thisFocusNode!.unfocus();
          }
        },
        enableSuggestions: widget.enableSuggestions!,
        autocorrect: widget.autocorrect!,
        maxLines: widget.maxLines,
        maxLength: widget.maxCharacters,
        style: widget.textStyle
            ?? TextStyle(color:Color(0xff39FC7A) ),
        textAlign: widget.textAlign ?? TextAlign.left,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: widget.prefijo,
          //prefix: widget.prefijo,
          suffixIcon: widget.isRequired! && !widget.isPassword!
              ? Icon(
                  Icons.priority_high,
                  color:Color(0xff39FC7A),
                )
              : null,
          suffix: widget.isPassword!
              ? Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: GestureDetector(
                    onTap: () {
                      if (mostrarPass == true) {
                        mostrarPass = false;
                      } else {
                        mostrarPass = true;
                      }
                      setState(() {});
                    },
                    child: Icon(
                      Icons.visibility,
                      color:
                          mostrarPass ? Color(0XFFf25252) : Color(0XFFfc9c9c),
                    ),
                  ),
                )
              : null,

          prefixText: widget.textoPrefijo,
          prefixStyle: TextStyle(color: Colors.grey, fontSize: 16),
          counter: hayError ? Text("") : Container(),
          contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.black26),
          fillColor:
              widget.fillColor != null ? widget.fillColor : Colors.transparent,
          filled: true,
          enabledBorder: widget.border != null
              ? widget.border
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
          focusedBorder: widget.focusedBorder != null
              ? widget.focusedBorder
              : OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
          disabledBorder: widget.border != null
              ? widget.border
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
          errorBorder: widget.border != null
              ? widget.border
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff39FC7A),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
          border: widget.border != null
              ? widget.border
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
        ),
        validator: (value) {
          if ((value == null || value == "") && widget.isRequired!) {
            hayError = true;
            return widget.requiredErrorMsg;
          }
          if (value!.length < widget.minCharacters! && widget.isRequired!) {
            hayError = true;
            return "Debe ingresar al menos " +
                widget.minCharacters.toString() +
                " caracteres.";
          }
          if (widget.isEmail!) {
            bool emailValido = EmailValidator.validate(value);

            if (!emailValido) {
              hayError = true;
              return "El correo ingresado no es válido.";
            }
          }

          hayError = false;
          return null;
        },
        enabled: widget.enabled,
      ),
    );
  }
}
