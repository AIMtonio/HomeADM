package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.util.List;

import org.springframework.core.task.TaskExecutor;
import org.springframework.util.StringUtils;

import pld.bean.ClavesPorResultadoOpeEscIntBean;
import pld.bean.OpeEscalamientoInternoBean;
import pld.bean.PldEscalaVentBean;
import pld.bean.ProcesoEscalamientoInternoBean;
import pld.dao.ClavesPorResultadoOpeEscIntDAO;
import pld.dao.OpeEscalamientoInternoDAO;
import pld.dao.OpeEscalamientoInternoDAO.Enum_EstatusPLD;
import pld.dao.OpeEscalamientoInternoDAO.Enum_ProcesoPLD;
import pld.dao.ProcesoEscalamientoInternoDAO;
import soporte.bean.EnvioCorreoBean;
import soporte.bean.ParamGeneralesBean;
import soporte.bean.ParametrosSisBean;
import soporte.bean.UsuarioBean;
import soporte.dao.EnvioCorreoDAO;
import soporte.servicio.CorreoServicio;
import soporte.servicio.ParamGeneralesServicio;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;
import soporte.servicio.UsuarioServicio;


public class OpeEscalamientoInternoServicio extends BaseServicio {
	
	//------------Constantes------------------
	
	//---------- Variables ------------------------------------------------------------------------
	OpeEscalamientoInternoDAO opeEscalamientoInternoDAO = null;
	ProcesoEscalamientoInternoDAO procesoEscalamientoInternoDAO = null;
	ClavesPorResultadoOpeEscIntDAO clavesPorResultadoOpeEscIntDAO = null;
	ParamGeneralesServicio	paramGeneralesServicio	= null;
	UsuarioServicio usuarioServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	EnvioCorreoDAO envioCorreoDAO = null;
	CorreoServicio correoServicio = null;
	ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	private TaskExecutor taskExecutor;

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_OpeInternaEscalamiento {
		int principal = 1;
		
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_OpeInternaEscalamiento {
		int principal = 1;
		int ventanilla = 2;
		
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Act_OpeInternaEscalamiento {
		int estatus = 1;
		
	}
	public static interface Enum_Tra_OpeInternaEscalamiento{
		int validaEscala = 1;
	}
	
	public static interface Enum_Proceso{
		String OPERACION = "OPERACION";
	}
	
	
	//---------- Constructor ------------------------------------------------------------------------
	public OpeEscalamientoInternoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	//---------- Transacciones y Consultas ------------------------------------------------------------------
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, OpeEscalamientoInternoBean opeEscalamientoInterno){
		MensajeTransaccionBean mensaje = null;		
		switch (tipoTransaccion) {
			case Enum_Tra_OpeInternaEscalamiento.validaEscala:		
				mensaje = validaOperacionEscalamientoInt(opeEscalamientoInterno);				
				break;				
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean validaOperacionEscalamientoInt(OpeEscalamientoInternoBean opeEscalamientoInterno){
		MensajeTransaccionBean mensaje = null;
		mensaje = opeEscalamientoInternoDAO.validaOperacionEscalamientoInt(opeEscalamientoInterno);		
		return mensaje;
	}
	
	public MensajeTransaccionBean actualiza(int tipoActualizacion, OpeEscalamientoInternoBean operEscalamientoInternoBean){
		MensajeTransaccionBean mensaje = null;		
		switch (tipoActualizacion) {
			case Enum_Act_OpeInternaEscalamiento.estatus:		
				mensaje = opeEscalamientoInternoDAO.actualizaEstatusOperacionEscalamiento(operEscalamientoInternoBean,tipoActualizacion);
				if(operEscalamientoInternoBean.getProcesoEscalamientoID().equals(Enum_Proceso.OPERACION) && mensaje.getNumero()==Constantes.ENTERO_CERO){
						PldEscalaVentBean pldEscalaVentBean=new PldEscalaVentBean();
						pldEscalaVentBean.setFolioEscala(operEscalamientoInternoBean.getFolioOperacionID());
						
						if(operEscalamientoInternoBean.getResultadoRevision()!=null)
						switch(operEscalamientoInternoBean.getResultadoRevision().charAt(0)){
							case 'A': 
								pldEscalaVentBean.setProceso(Enum_ProcesoPLD.AUTORIZADA+"");
								pldEscalaVentBean.setTipoResultEscID(Enum_EstatusPLD.AUTORIZADA);
							break;
							case 'R': 
								pldEscalaVentBean.setProceso(Enum_ProcesoPLD.RECHAZADA+"");
								pldEscalaVentBean.setTipoResultEscID(Enum_EstatusPLD.RECHAZADA);
							break;
						}
						opeEscalamientoInternoDAO.validaOpEscalamientoIngreso(pldEscalaVentBean);
				}
				break;
		}
		return mensaje;
	}
	
	
	public OpeEscalamientoInternoBean consulta(int tipoConsulta,
												OpeEscalamientoInternoBean operEscalamientoInternoBean ){
		OpeEscalamientoInternoBean  operEscalamientoInterno= null;
		switch (tipoConsulta) {
			case Enum_Con_OpeInternaEscalamiento.principal:		
				operEscalamientoInterno = opeEscalamientoInternoDAO.consultaOperacionEscalamiento(
																	operEscalamientoInternoBean, tipoConsulta);
				break;	
		}
				
		return operEscalamientoInterno;
	}
	
	public List lista(int tipoLista, OpeEscalamientoInternoBean operEscalamientoInternoBean){		
		List listaOperaciones = null;
		switch (tipoLista) {
			case Enum_Lis_OpeInternaEscalamiento.principal:
				listaOperaciones =  opeEscalamientoInternoDAO.opeEscalamientolistaPrincipal(operEscalamientoInternoBean,
																							tipoLista);
				break;
			case Enum_Lis_OpeInternaEscalamiento.ventanilla:
				listaOperaciones =  opeEscalamientoInternoDAO.opeEscalamientolistaVentanilla(operEscalamientoInternoBean,
																							tipoLista);
				break; 
		}		
		return listaOperaciones;
	}
	
	// Envio de correo al Oficial de Cumplimiento por autorizacion de una operacion de escalamiento interno
	public MensajeTransaccionBean envioCorreoAutorizacion(final OpeEscalamientoInternoBean escalamientoBean, final MensajeTransaccionBean mensaje){
		UsuarioBean usuarioBean = new UsuarioBean();
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		final EnvioCorreoBean envioCorreoBean = new EnvioCorreoBean();
		int tipoConsulta = 1;
		int tipoConParam = 3;
		List listaUsuario = null;
		String remitente ="";
		String mensajeCorreo = "";
		String host="";
		String puerto="";
		String userName="";
		String contrasenia="";
		String mailDes="";
		ParamGeneralesBean	paramGeneralesBean = new ParamGeneralesBean();
		paramGeneralesBean = paramGeneralesServicio.consulta(tipoConParam, paramGeneralesBean);
		
		final String ruta=paramGeneralesBean.getValorParametro();
		if(mensaje.getNumero()==0){
			final String origenDatos = parametrosAuditoriaBean.getOrigenDatos();
			
			usuarioBean.setUsuarioID(escalamientoBean.getFuncionarioUsuarioID());
			usuarioBean = usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.principal, usuarioBean);
			usuarioBean.setOrigenDatos(parametrosAuditoriaBean.getOrigenDatos());
			listaUsuario = usuarioServicio.lista(UsuarioServicio.Enum_Con_Usuario.consultaUsuPorNomExterna, usuarioBean);
			mailDes =((UsuarioBean) listaUsuario.get(0)).getCorreo();
			parametrosSisBean.setEmpresaID("1");
			parametrosSisBean.setRutaArchivos(parametrosAuditoriaBean.getOrigenDatos());
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.principalExterna, parametrosSisBean);
			remitente = parametrosSisBean.getRemitente();
			host = parametrosSisBean.getServidorCorreo();
			puerto = parametrosSisBean.getPuerto();
			userName = parametrosSisBean.getUsuarioCorreo();
			contrasenia = parametrosSisBean.getContrasenia();
			
			ProcesoEscalamientoInternoBean preocesoEscBean = new ProcesoEscalamientoInternoBean();
			preocesoEscBean.setProcesoEscalamientoID(escalamientoBean.getProcesoEscalamientoID());
			preocesoEscBean = procesoEscalamientoInternoDAO.consultaProcesoEscalamiento(preocesoEscBean, tipoConsulta);
			ClavesPorResultadoOpeEscIntBean clavesPorResBean = new ClavesPorResultadoOpeEscIntBean();
			clavesPorResBean.setClaveJustificacionOpeEscalaIntID(escalamientoBean.getClaveJustificacion());
			clavesPorResBean = clavesPorResultadoOpeEscIntDAO.consultaClavesPorResultado(clavesPorResBean, tipoConsulta);
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
			String safilocaleCliente = "safilocale.cliente";
			String nombreCliente = "";
			if(Utileria.esNumero(escalamientoBean.getUsuarioServicioID())){
				safilocaleCliente = "Usuario Servicios";
				nombreCliente = escalamientoBean.getNombreUsuarioServicio();
			} else {
				safilocaleCliente = Utileria.generaLocale(safilocaleCliente, parametrosSisBean.getNombreCortoInst());
				nombreCliente = escalamientoBean.getNombreCliente();
			}
			mensajeCorreo = Constantes.CORREO_OPE_ESCALAMIENTO;
			mensajeCorreo = StringUtils.replace(mensajeCorreo, "%PersInvolucrada%",safilocaleCliente);
			mensajeCorreo = StringUtils.replace(mensajeCorreo, "%NumeroFolio%",mensaje.getConsecutivoString());
			mensajeCorreo = StringUtils.replace(mensajeCorreo, "%CteInv%",nombreCliente);
			mensajeCorreo = StringUtils.replace(mensajeCorreo, "%UsuarioGestion%",usuarioBean.getNombreCompleto());
			mensajeCorreo = StringUtils.replace(mensajeCorreo, "%Fecha%",escalamientoBean.getFechaGestion());
			mensajeCorreo = StringUtils.replace(mensajeCorreo, "%Proceso%",preocesoEscBean.getDescripcion());
			mensajeCorreo = StringUtils.replace(mensajeCorreo, "%Justificacion%",clavesPorResBean.getDescripcionJustificacionOpeEscalaInt());
			mensajeCorreo = StringUtils.replace(mensajeCorreo, "%Comentarios%",escalamientoBean.getNotasComentarios());
		
			
			envioCorreoBean.setRemitente(remitente);
			envioCorreoBean.setDestinatario(mailDes);
			envioCorreoBean.setAsunto("Notificación en Autorización Gestión Escalamiento Interno.");
			envioCorreoBean.setMensaje(mensajeCorreo);
			envioCorreoBean.setSevidorCorreo(host);
			envioCorreoBean.setPuerto(puerto);
			envioCorreoBean.setUsuarioCorreo(userName);
			envioCorreoBean.setContrasenia(contrasenia);
			
			taskExecutor.execute(new Runnable() {
				public void run() {
					envioCorreoDAO.altaCorreoExterno(envioCorreoBean,origenDatos);
					correoServicio.enviarCorreo(ruta);
				}
			});
		}
		return mensaje;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------
	public OpeEscalamientoInternoDAO getOpeEscalamientoInternoDAO() {
		return opeEscalamientoInternoDAO;
	}

	public void setOpeEscalamientoInternoDAO(
			OpeEscalamientoInternoDAO opeEscalamientoInternoDAO) {
		this.opeEscalamientoInternoDAO = opeEscalamientoInternoDAO;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public EnvioCorreoDAO getEnvioCorreoDAO() {
		return envioCorreoDAO;
	}

	public void setEnvioCorreoDAO(EnvioCorreoDAO envioCorreoDAO) {
		this.envioCorreoDAO = envioCorreoDAO;
	}

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public TaskExecutor getTaskExecutor() {
		return taskExecutor;
	}

	public void setTaskExecutor(TaskExecutor taskExecutor) {
		this.taskExecutor = taskExecutor;
	}

	public ProcesoEscalamientoInternoDAO getProcesoEscalamientoInternoDAO() {
		return procesoEscalamientoInternoDAO;
	}

	public void setProcesoEscalamientoInternoDAO(
			ProcesoEscalamientoInternoDAO procesoEscalamientoInternoDAO) {
		this.procesoEscalamientoInternoDAO = procesoEscalamientoInternoDAO;
	}

	public ClavesPorResultadoOpeEscIntDAO getClavesPorResultadoOpeEscIntDAO() {
		return clavesPorResultadoOpeEscIntDAO;
	}

	public void setClavesPorResultadoOpeEscIntDAO(
			ClavesPorResultadoOpeEscIntDAO clavesPorResultadoOpeEscIntDAO) {
		this.clavesPorResultadoOpeEscIntDAO = clavesPorResultadoOpeEscIntDAO;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}
	
}
