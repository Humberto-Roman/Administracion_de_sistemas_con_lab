# principal.ps1

# Importar los scripts de funciones y mensajes
. .\funciones.ps1
. .\mensajes.ps1

# Mostrar mensaje de inicio
MensajeInicio

# Ejecutar las funciones
ActualizarSistema
InstalarOpenSSH
HabilitarServicioSSH
IniciarServicioSSH
ConfigurarSSH
ReiniciarServicioSSH
MostrarEstadoSSH
MostrarIP

# Mostrar mensaje de éxito
MensajeExito