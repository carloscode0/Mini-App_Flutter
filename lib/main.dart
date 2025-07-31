import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini-App Flutter',
      home: const PantallaPrincipal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});
  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  // Login
  final _formLoginKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  // Formulario Datos
  final _formDatosKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();

  String datosResumen = "";

  Future<void> _loginUsuario() async {
    if (!_formLoginKey.currentState!.validate()) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );
      _mostrarDialogo(
        titulo: 'Bienvenido',
        contenido: 'Inicio de sesión exitoso.',
      );
    } catch (e) {
      _mostrarDialogo(
        titulo: 'Error de inicio de sesión',
        contenido: 'Correo o contraseña incorrectos.',
      );
    }
  }

  void _mostrarDialogo({required String titulo, required String contenido}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void _mostrarModalRegistro() {
    showDialog(
      context: context,
      builder: (context) => DialogRegistroUsuario(
        onRegistroExitoso: () {
          Navigator.pop(context); // cerrar modal
          _mostrarDialogo(
            titulo: 'Registro exitoso',
            contenido: 'El usuario ha sido registrado correctamente.',
          );
        },
      ),
    );
  }

  void _procesarFormularioDatos() {
    if (_formDatosKey.currentState!.validate()) {
      setState(() {
        datosResumen =
        'Nombre: ${_nombreCtrl.text}\nEdad: ${_edadCtrl.text}\nCorreo: ${_correoCtrl.text}';
      });

      _mostrarDialogo(
        titulo: 'Datos Ingresados',
        contenido: datosResumen,
      );
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nombreCtrl.dispose();
    _edadCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini-App Flutter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔐 Autenticación con Firebase',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _formLoginKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final emailRegExp =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su correo';
                      }
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Correo inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su contraseña';
                      }
                      if (value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _loginUsuario,
                    child: const Text('Iniciar Sesión'),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _mostrarModalRegistro,
                    child: const Text(
                      '¿No tienes cuenta? Regístrate',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              '📝 Formulario Validado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _formDatosKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _edadCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Edad',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su edad';
                      }
                      final edad = int.tryParse(value);
                      if (edad == null || edad <= 0) {
                        return 'Edad inválida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _correoCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final emailRegExp =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su correo';
                      }
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Correo inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _procesarFormularioDatos,
                    child: const Text('Enviar Datos'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogRegistroUsuario extends StatefulWidget {
  final VoidCallback onRegistroExitoso;

  const DialogRegistroUsuario({super.key, required this.onRegistroExitoso});

  @override
  State<DialogRegistroUsuario> createState() => _DialogRegistroUsuarioState();
}

class _DialogRegistroUsuarioState extends State<DialogRegistroUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String mensaje = '';

  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _correoCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );
      widget.onRegistroExitoso(); // notifica al padre para cerrar modal y mostrar alerta
    } catch (e) {
      setState(() {
        mensaje = 'Error al registrar el usuario.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registro de Usuario'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _correoCtrl,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (value == null || value.isEmpty) return 'Ingrese un correo';
                  if (!emailRegExp.hasMatch(value)) return 'Correo inválido';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese contraseña';
                  if (value.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                mensaje,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
        ElevatedButton(
          onPressed: _registrarUsuario,
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}
