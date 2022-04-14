package seguimiento.servicio;

import java.io.File;
import java.util.List;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;

import org.springframework.core.io.FileSystemResource;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.util.StringUtils;
import org.springframework.core.task.TaskExecutor;

import seguimiento.bean.SegtoRealizadosBean;
import seguimiento.bean.SegtoRecomendasBean;
import seguimiento.bean.SegtoResultadosBean;
import seguimiento.dao.SegtoRealizadosDAO;
import seguimiento.dao.SegtoRecomendasDAO;
import seguimiento.dao.SegtoResultadosDAO;
import soporte.bean.UsuarioBean;
import soporte.dao.UsuarioDAO;
import soporte.servicio.CorreoServicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

public class SegtoRealizadosServicio extends BaseServicio {

	SegtoRealizadosDAO segtoRealizadosDAO = null;
	SegtoRecomendasDAO segtoRecomendasDAO = null;
	SegtoResultadosDAO segtoResultadosDAO = null;
	CorreoServicio correoServicio = null;
	private TaskExecutor taskExecutor;
	UsuarioDAO usuarioDAO = null;
	public SegtoRealizadosServicio(){
		super();
	}
		
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_SegtoRealizados {
		int principal	= 1;
		int foranea 	= 2;
		int estatus		= 3;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_SegtoRealizados {
		int principal 	= 1;
		int foranea   	= 2;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_SegtoRealizados {
		int alta 		= 1;
		int modifica 	= 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, SegtoRealizadosBean segtoRealizadosBean,
			HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SegtoRealizados.alta:
			mensaje = altaRealizado(segtoRealizadosBean, request );
			break;
		case Enum_Tra_SegtoRealizados.modifica:
			mensaje = modificaRealizado(segtoRealizadosBean, request );
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaRealizado(SegtoRealizadosBean seguimiento, HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		mensaje = segtoRealizadosDAO.modificaSegtoRealizado(seguimiento, request);
		transaccEnvioCorreo(seguimiento, request, mensaje.getNumero());
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaRealizado(SegtoRealizadosBean seguimiento, HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		mensaje = segtoRealizadosDAO.altaSegtoRealizado(seguimiento, request);
		transaccEnvioCorreo(seguimiento, request, mensaje.getNumero());
		return mensaje;
	}
	
	public void transaccEnvioCorreo(final SegtoRealizadosBean seguimiento, final  HttpServletRequest request, final int mensajeExito){

		taskExecutor.execute(new Runnable() {
			public void run() {
				boolean resultado = false;
				String nombreUsuario = (request.getParameter("nombreUsuario").isEmpty() ? Constantes.STRING_VACIO : request.getParameter("nombreUsuario"));
				String supervisorID = (request.getParameter("puestoSupervisorID").isEmpty() ? Constantes.STRING_VACIO : request.getParameter("puestoSupervisorID"));
				String nombreCompleto = (request.getParameter("nombreCompleto").isEmpty() ? Constantes.STRING_VACIO : request.getParameter("nombreCompleto"));
				String nombreGrupo = (request.getParameter("nombreGrupo").isEmpty() ? Constantes.STRING_VACIO : request.getParameter("nombreGrupo"));
				//numTransaccion = transaccionDAO.generaNumeroTransaccionOut();
				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
				String mensajeCorreo = "";
				//segtoRecomendasDAO.bitacoraMovsTarAlta(operacionesTarjetaBean, numTransaccion);
				if (mensajeExito == 0 ){
					String nomReferencia ="";
					if(nombreCompleto.equals("")){
						nomReferencia = nombreGrupo;
					}else{
						nomReferencia = nombreCompleto;
					}
					SegtoRecomendasBean segtoRecomendasBean = new SegtoRecomendasBean();
					SegtoRecomendasBean segtoRecomendasRes = new SegtoRecomendasBean();
					SegtoResultadosBean segtoResultadoBean = new SegtoResultadosBean();
					SegtoResultadosBean segtoResultadoRes = new SegtoResultadosBean(); 
					UsuarioBean segtoUsuarioBean= new UsuarioBean();
					UsuarioBean usuarioBean = new UsuarioBean();
					int numConsulta = 3;
				//	Obtener el alcance de la recomendacion
					segtoRecomendasBean.setRecomendacionSegtoID(seguimiento.getRecomendacionSegtoID());
					segtoRecomendasRes = segtoRecomendasDAO.consultaRecomendaAlcance(segtoRecomendasBean, numConsulta);
					segtoResultadoBean.setResultadoSegtoID(seguimiento.getResultadoSegtoID());
					segtoResultadoRes = segtoResultadosDAO.consultaAlcance(segtoResultadoBean, numConsulta);
					if(segtoRecomendasRes.getAlcance().equals("G") || segtoResultadoRes.getAlcance().equals("G")){
						int numConsultaUsuario= 1;
						usuarioBean.setUsuarioID(supervisorID);
						segtoUsuarioBean = usuarioDAO.consultaPrincipal(usuarioBean, numConsultaUsuario);
					//	Obtener el correo del Supervisor
						mensajeCorreo=  Constantes.CORREO_SEGTO_SUPERV;
						mensajeCorreo = StringUtils.replace(mensajeCorreo, "%NumeroSeguimiento%",seguimiento.getSegtoPrograID());
						mensajeCorreo = StringUtils.replace(mensajeCorreo, "%Consecutivo%", String.valueOf(mensajeExito));
						mensajeCorreo = StringUtils.replace(mensajeCorreo, "%NomCliente%", nomReferencia);
						mensajeCorreo = StringUtils.replace(mensajeCorreo, "%NomGestor%", nombreUsuario);
						mensajeCorreo = StringUtils.replace(mensajeCorreo, "%NombreEmpresa%", "");
						FileSystemResource recurso = new FileSystemResource(new File(Constantes.RUTA_IMAGENES +
																			System.getProperty("file.separator") +
																			"LogoPrincipal.png"));
						correoServicio.enviaCorreo("seguimientosoporte@efisys.com.mx", 
								segtoUsuarioBean.getCorreo(),
								null, 
								"Notificación de Supervisión de Seguimiento",
								mensajeCorreo, 
								seguimiento, 
								4,
								recurso);
					}
				}
			}
		});
	}

	public SegtoRealizadosBean consulta(int tipoConsulta, SegtoRealizadosBean segtoRealizadosBean){
		SegtoRealizadosBean segtoRealizados = null;
		switch (tipoConsulta) {
			case Enum_Con_SegtoRealizados.principal:		
				segtoRealizados = segtoRealizadosDAO.consultaPrincipal(segtoRealizadosBean, tipoConsulta);				
				break;	
			case Enum_Con_SegtoRealizados.estatus:		
				segtoRealizados = segtoRealizadosDAO.consultaEstatus(segtoRealizadosBean, tipoConsulta);				
				break;
		}						
		return segtoRealizados;
	}
	
	public List lista(int tipoLista, SegtoRealizadosBean segtoRealizadosBean){
		List listaSegtoResultado = null;
		switch (tipoLista) {
	        case  Enum_Lis_SegtoRealizados.principal:
	        	listaSegtoResultado = segtoRealizadosDAO.listaPrincipal(segtoRealizadosBean, tipoLista);
	        break;
		}
		return listaSegtoResultado;
	}
	
	//---------- Getter y Setters  ----------------------------------------------------------------
	public SegtoRealizadosDAO getSegtoRealizadosDAO() {
		return segtoRealizadosDAO;
	}

	public void setSegtoRealizadosDAO(SegtoRealizadosDAO segtoRealizadosDAO) {
		this.segtoRealizadosDAO = segtoRealizadosDAO;
	}

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

	public SegtoRecomendasDAO getSegtoRecomendasDAO() {
		return segtoRecomendasDAO;
	}

	public void setSegtoRecomendasDAO(SegtoRecomendasDAO segtoRecomendasDAO) {
		this.segtoRecomendasDAO = segtoRecomendasDAO;
	}

	public UsuarioDAO getUsuarioDAO() {
		return usuarioDAO;
	}

	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}

	public SegtoResultadosDAO getSegtoResultadosDAO() {
		return segtoResultadosDAO;
	}

	public void setSegtoResultadosDAO(SegtoResultadosDAO segtoResultadosDAO) {
		this.segtoResultadosDAO = segtoResultadosDAO;
	}

	public TaskExecutor getTaskExecutor() {
		return taskExecutor;
	}

	public void setTaskExecutor(TaskExecutor taskExecutor) {
		this.taskExecutor = taskExecutor;
	}	
}