package ventanilla.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.core.task.TaskExecutor;

import cliente.servicio.TiposDireccionServicio.Enum_Con_TiposDir;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParamGeneralesBean;
import soporte.servicio.CorreoServicio;
import soporte.servicio.ParamGeneralesServicio;
import ventanilla.bean.UsuarioServiciosBean;
import ventanilla.dao.UsuarioServiciosDAO;

public class UsuarioServiciosServicio extends BaseServicio {

	UsuarioServiciosDAO usuarioServiciosDAO= null;
	ParamGeneralesServicio paramGeneralesServicio = null;

	public UsuarioServiciosServicio(){
		super();
	}
	//---------- Tipos de Transaccion ----------------
	public static interface Enum_Tra_Usuario {
		int alta		 			= 1;
		int modificacion 			= 2;
		int actualiza	 			= 3;
		int altaRemitente 			= 5;
		int modificacionRemitente 	= 6;
	}

	//---------- Tipos de Actualizacion ----------------
	public static interface Enum_Act_Usuario {
		int inactivaUsuario	= 1;
		int unificar	 	= 2;
	}

	//---------- Tipos de Consulta ----------------
	public static interface Enum_Con_Usuario {
		int principal 		= 1;
		int foranea 		= 2;
		int conTipoPersona 	= 3;
		int remitentesUsu 	= 4;
		int unificacion		= 5;
		int conocimiento	= 6;
	}
	//---------- Tipos de Lista ----------------
	public static interface Enum_Lis_Usuario {
		int principal 		= 1;
		int ventanilla 		= 2;
		int remitentesUsu 	= 3;
		int coincidencias  	= 4;
		int unificacion		= 5;
	}
	//---------- Tipos de Lista para Reportes----------------
	public static interface Enum_Tip_Reporte {
		int excel = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion,UsuarioServiciosBean usuario){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Usuario.alta:
				mensaje = altaUsuariosServicio(usuario);
				break;
			case Enum_Tra_Usuario.modificacion:
				mensaje = modificaUsuariosServicio(usuario);
				break;
			case Enum_Tra_Usuario.actualiza:
				mensaje = actualizaUsuariosServicio(usuario, tipoActualizacion);
				break;
			case Enum_Tra_Usuario.altaRemitente:
				mensaje = altaRemiUsuariosServicio(usuario);
				break;
			case Enum_Tra_Usuario.modificacionRemitente:
				mensaje = modificaRemiUsuariosServicio(usuario);
				break;
		}
		return mensaje;
	}


	public MensajeTransaccionBean altaUsuariosServicio(UsuarioServiciosBean usuario){
		MensajeTransaccionBean mensaje = null;
		mensaje = usuarioServiciosDAO.altaUsuario(usuario);
		return mensaje;
	}

	public MensajeTransaccionBean altaRemiUsuariosServicio(UsuarioServiciosBean usuario){
		MensajeTransaccionBean mensaje = null;
		mensaje = usuarioServiciosDAO.altaRemitenteUsuario(usuario);
		return mensaje;
	}

	public MensajeTransaccionBean modificaUsuariosServicio(UsuarioServiciosBean usuario){
		MensajeTransaccionBean mensaje = null;
		mensaje = usuarioServiciosDAO.modificaUsuario(usuario);
		return mensaje;
	}

	public MensajeTransaccionBean modificaRemiUsuariosServicio(UsuarioServiciosBean usuario){
		MensajeTransaccionBean mensaje = null;
		mensaje = usuarioServiciosDAO.modificaRemitenteUsuario(usuario);
		return mensaje;
	}

	public MensajeTransaccionBean actualizaUsuariosServicio(UsuarioServiciosBean usuario, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch (tipoActualizacion) {
			case Enum_Act_Usuario.inactivaUsuario:
				mensaje = usuarioServiciosDAO.inactivaUsuario(usuario, tipoActualizacion);
			break;
			case Enum_Act_Usuario.unificar:
				mensaje = usuarioServiciosDAO.unificaUsuarios(usuario, tipoActualizacion);
			break;
		}
		return mensaje;
	}


	public UsuarioServiciosBean consulta(int tipoConsulta, UsuarioServiciosBean usuarioServiciosBean){
		UsuarioServiciosBean usuario = null;
		switch (tipoConsulta) {
			case Enum_Con_Usuario.principal:
				usuario = usuarioServiciosDAO.consultaPrincipal(usuarioServiciosBean, tipoConsulta);
			break;
			case Enum_Con_Usuario.remitentesUsu:
				usuario = usuarioServiciosDAO.consultaRemitentesUsuario(usuarioServiciosBean, tipoConsulta);
			break;
			case Enum_Con_Usuario.unificacion:
				usuario = usuarioServiciosDAO.consultaUnificacion(usuarioServiciosBean, tipoConsulta);
			break;
			case Enum_Con_Usuario.conocimiento:
				usuario = usuarioServiciosDAO.consultaConocimiento(usuarioServiciosBean, tipoConsulta);
			break;
		}
		return usuario;
	}

	public List lista(int tipoLista, UsuarioServiciosBean usuario){
		List UsuariosLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_Usuario.principal:
	        	UsuariosLista = usuarioServiciosDAO.listaPrincipal(usuario, tipoLista);
	        break;
			case Enum_Lis_Usuario.ventanilla:
				UsuariosLista = usuarioServiciosDAO.listaVentanilla(usuario, tipoLista);
			break;
			case Enum_Lis_Usuario.remitentesUsu:
				UsuariosLista = usuarioServiciosDAO.listaRemitentesUsuario(usuario, tipoLista);
			break;
			case Enum_Lis_Usuario.coincidencias:
				UsuariosLista = usuarioServiciosDAO.listaCoincidencias(usuario, tipoLista);
			break;
			case Enum_Lis_Usuario.unificacion:
				UsuariosLista = usuarioServiciosDAO.listaPrincipal(usuario, tipoLista);
			break;
		}
		return UsuariosLista;
	}


	/* ========= Reporte de  Usuarios de Servicios Excel =========== */
	public List listaReporte(int tipoReporte,
				UsuarioServiciosBean usuarioServicios,
				HttpServletResponse response) {
			List listaRep = null;

			switch (tipoReporte) {
			case Enum_Tip_Reporte.excel:
				listaRep = usuarioServiciosDAO.listaReporte(usuarioServicios, tipoReporte);
				break;
			}
			return listaRep;
		}

	// Listas para ComboBox
	public  Object[] listaCombo(int tipoConsulta) {
		List listaUsuarios = null;
		switch(tipoConsulta){
			case (Enum_Con_Usuario.conTipoPersona):
				listaUsuarios =  usuarioServiciosDAO.listaTipoPersona(tipoConsulta);
			break;
		}
		return listaUsuarios.toArray();
	}

	/* ========= Reporte de Operaciones  de Servicios PDF =========== */
	public ByteArrayOutputStream reporteUsuariosServicioPDF(int tipoReporte,
			UsuarioServiciosBean usuarioServicios, String nomReporte)

			throws Exception {

		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_UsuarioID", usuarioServicios.getUsuarioID());
		parametrosReporte.agregaParametro("Par_DesUsuarioID", usuarioServicios.getDesUsuarioID());
		parametrosReporte.agregaParametro("Par_SucursalID", usuarioServicios.getSucursalID());
		parametrosReporte.agregaParametro("Par_DescSucursal", usuarioServicios.getDescSucursal());
		parametrosReporte.agregaParametro("Par_Sexo", usuarioServicios.getSexo());
		parametrosReporte.agregaParametro("Par_DesSexo", usuarioServicios.getDesSexo());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", usuarioServicios.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema", Utileria.convierteFecha(usuarioServicios.getFechaSistema()));
		parametrosReporte.agregaParametro("Par_Usuario", usuarioServicios.getNombreUsuario().toUpperCase());
		parametrosReporte.agregaParametro("Par_RutaImagen",PropiedadesSAFIBean.propiedadesSAFI.getProperty("RutaImgReportes"));
		parametrosReporte.agregaParametro("Par_NumCon",Integer.toString(tipoReporte));
		parametrosReporte.agregaParametro("Par_EtiquetaSocio",usuarioServicios.getEtiquetaSocio());


		return Reporte.creaPDFReporte(nomReporte, parametrosReporte,
				parametrosAuditoriaBean.getRutaReportes(),
				parametrosAuditoriaBean.getRutaImgReportes());
	}


	public UsuarioServiciosDAO getUsuarioServiciosDAO() {
		return usuarioServiciosDAO;
	}

	public void setUsuarioServiciosDAO(UsuarioServiciosDAO usuarioServiciosDAO) {
		this.usuarioServiciosDAO = usuarioServiciosDAO;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

}
