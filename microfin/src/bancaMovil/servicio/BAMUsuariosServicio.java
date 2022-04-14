package bancaMovil.servicio;

import java.util.List;

import bancaMovil.bean.BAMUsuariosBean;
import bancaMovil.dao.BAMUsuariosDAO;
import cliente.servicio.ClienteServicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class BAMUsuariosServicio extends BaseServicio {

	// ---------- Variables
	// ------------------------------------------------------------------------
	BAMUsuariosDAO usuariosDAO = null;
	BAMEnviaCorreoServicio correoServicio = null;
	ClienteServicio clienteServicio = null;
	BAMNotificacionCorreoServicio correoNotificacion = null;

	String codigo = "";

	// ---------- Tipo de Consulta
	// ----------------------------------------------------------------
	public static interface Enum_Con_Usuario {
		int principal = 1;
	}

	public static interface Enum_Lis_Usuario {
		int principal = 1;
	}

	public static interface Enum_Tra_Usuario {
		int alta = 1;
		int modificacion = 2;
		int cambioPassword = 4;
		int bloquear = 7;
		int desbloquear = 8;
		int cancelar = 10;
		int activar = 11;
	}

	public static interface Enum_Act_BAMUsuario {
		int activo = 0;
		int inactivo = 1;
		int bloqueado = 2;
		int cancelado = 3;
		int cambioPassword = 4;
		int cambioPregSecreta = 5;
		int cambioFrase = 6;
		int ultimoAcceso = 7;
		int imagenAntPsPerson = 8;
	}

	public static interface Enum_Estatus_BAMUsuario {
		String activo = "A";
		String inactivo = "I";
		String bloqueado = "B";
		String cancelado = "C";
	}

	public static interface Act_Estatus_BAMUsuario {
		int activo = 1;
		int inactivo = 2;
		int bloqueado = 3;
		int cancelado = 4;
	}

	public static interface Enum_Con_CicloBaseIni {
		int principal = 1;
	}

	public BAMUsuariosServicio() {
		super();
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,
			BAMUsuariosBean usuarios) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_Usuario.alta:
			mensaje = altaUsuarios(usuarios);
			break;
		case Enum_Tra_Usuario.modificacion:
			mensaje = modificaUsuarios(usuarios);
			break;

		case Enum_Tra_Usuario.cambioPassword:
			mensaje = cambiaPassword(usuarios,
					Enum_Act_BAMUsuario.cambioPassword);
			break;
		case Enum_Tra_Usuario.bloquear:
			mensaje = bloqUsuarios(usuarios, tipoTransaccion);
			break;
		case Enum_Tra_Usuario.desbloquear:
			mensaje = debloqUsuarios(usuarios, tipoTransaccion);

			break;
		case Enum_Tra_Usuario.cancelar:
			mensaje = cancelaUsuarios(usuarios, tipoTransaccion);
			break;
		case Enum_Tra_Usuario.activar:
			mensaje = activarUsuarios(usuarios, tipoTransaccion);
			break;
		}
		return mensaje;
	}

	private MensajeTransaccionBean altaUsuarios(BAMUsuariosBean usuarios) {
		MensajeTransaccionBean mensaje = null;
		// usuarios.setContrasenia(SeguridadRecursosServicio.encriptaPass(usuarios.getTelefono(),
		
		mensaje = usuariosDAO.altaUsuarios(usuarios);
		return mensaje;
	}

	private MensajeTransaccionBean modificaUsuarios(BAMUsuariosBean usuarios) {
		MensajeTransaccionBean mensaje = null;
		mensaje = usuariosDAO.modificaUsuarios(usuarios);
		return mensaje;
	}

	private MensajeTransaccionBean bloqUsuarios(BAMUsuariosBean usuarios,
			int tipoActualizacion) {
		MensajeTransaccionBean mensaje = null;
		mensaje = usuariosDAO.actualizarStatus(usuarios,Act_Estatus_BAMUsuario.bloqueado);
		return mensaje;
	}

	private MensajeTransaccionBean debloqUsuarios(BAMUsuariosBean usuarios,
			int tipoActualizacion) {
		MensajeTransaccionBean mensaje = null;
		mensaje = usuariosDAO.actualizarStatus(usuarios,Act_Estatus_BAMUsuario.activo);
		return mensaje;
	}

	private MensajeTransaccionBean cancelaUsuarios(BAMUsuariosBean usuarios,
			int tipoActualizacion) {
		MensajeTransaccionBean mensaje = null;
		mensaje = usuariosDAO.actualizarStatus(usuarios,
				Act_Estatus_BAMUsuario.cancelado);
		return mensaje;
	}

	private MensajeTransaccionBean activarUsuarios(BAMUsuariosBean usuarios,
			int tipoActualizacion) {
		MensajeTransaccionBean mensaje = null;
		mensaje = usuariosDAO.actualizarStatus(usuarios,
				Act_Estatus_BAMUsuario.activo);
		return mensaje;
	}

	// Metodo para cambiar contraseña de usuario
	private MensajeTransaccionBean cambiaPassword(BAMUsuariosBean usuarios,
			int tipoActualizacion) {
		MensajeTransaccionBean mensaje = null;
		mensaje = usuariosDAO.cambiarContrasenia(usuarios);
		return mensaje;
	}

	public BAMUsuariosBean consultaUsuarios(int tipoConsulta, String parametro) {
		BAMUsuariosBean usuario = null;
		switch (tipoConsulta) {
		case Enum_Con_Usuario.principal:		
			usuario = usuariosDAO.consultaPrincipal(Utileria.convierteEntero(parametro));				
			break;	
		}

		return usuario;
	}

	public List lista(int tipoLista, BAMUsuariosBean usuarios){		
		List listaBAMUsuarios = null;
		switch (tipoLista) {
		case Enum_Lis_Usuario.principal:		
			listaBAMUsuarios = usuariosDAO.listaPrincipal(usuarios, tipoLista);				
			break;
		}
		return listaBAMUsuarios;
	}

	public boolean esNipValido(String cadena) {

		int veces=0;
		for(int i=0;i<cadena.length()-1;i++){
			if(cadena.charAt(i)+1==cadena.charAt(i+1)){
				veces+=1;
				if(veces>=3){
					loggerSAFI.error(this.getClass()+" - "+"Hay numeros consecutivos consecuentes");
					return false;
				}
			}
		}
			veces=0;
			
			for(int j=cadena.length()-1;j==1;j--){
				if(cadena.charAt(j)==cadena.charAt(j-1)){
					veces+=1;
					if(veces>=3){
						loggerSAFI.error(this.getClass()+" - "+"Hay numeros consecutivos consecuentes");
						return false;
					}
				}
		}	
			return true;
	}

	public void setBAMUsuariosDAO(BAMUsuariosDAO usuariosDAO) {
		this.usuariosDAO = usuariosDAO;
	}

	public BAMUsuariosDAO getBAMUsuariosDAO() {
		return usuariosDAO;
	}

	public BAMEnviaCorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(BAMEnviaCorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}

	public BAMNotificacionCorreoServicio getCorreoNotificacion() {
		return correoNotificacion;
	}

	public void setCorreoNotificacion(
			BAMNotificacionCorreoServicio correoNotificacion) {
		this.correoNotificacion = correoNotificacion;
	}

}
