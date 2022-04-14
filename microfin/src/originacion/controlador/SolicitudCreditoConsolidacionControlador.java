
package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.ConsolidacionCartaLiqBean;
import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.ConsolidacionCartaLiqServicio;
import originacion.servicio.SolicitudCreditoServicio;

public class SolicitudCreditoConsolidacionControlador extends SimpleFormController {

	
	SolicitudCreditoServicio solicitudCreditoServicio  = null;
	ConsolidacionCartaLiqServicio consolidacionCartaLiqServicio;

	public SolicitudCreditoConsolidacionControlador(){
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("solicitudCreditoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		SolicitudCreditoBean solicitudCredito = (SolicitudCreditoBean) command;
		
		solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
				Integer.parseInt(request.getParameter("tipoActualizacion")):
				0;		
						
		if (tipoActualizacion == SolicitudCreditoServicio.Enum_Act_SolCredito.liberar) {				 											
			String comentario = request.getParameter("comentario");
			String comentarioEjecutivo = request.getParameter("comentarioEjecutivo");
			
			solicitudCredito.setComentarioEjecutivo(comentario);			
		}
		
		int tipoTransaccionCons = (request.getParameter("tipoTransaccionCons") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccionCons")) : 0;
		ConsolidacionCartaLiqBean conCartaLiqBean = new ConsolidacionCartaLiqBean();
		conCartaLiqBean.setRecurso((request.getParameter("recursoCons") != null) ? request.getParameter("recursoCons") : "");         
		conCartaLiqBean.setClienteID((request.getParameter("clienteIDCons") != null) ? request.getParameter("clienteIDCons") : "");       
		conCartaLiqBean.setConsolidacionCartaID((request.getParameter("consolidaCartaIDCons") != null) ? request.getParameter("consolidaCartaIDCons") : "");
		conCartaLiqBean.setEstatus((request.getParameter("estatusCons") != null) ? request.getParameter("estatusCons") : "");         
		conCartaLiqBean.setMonto((request.getParameter("montoConsolidaCons") != null) ? request.getParameter("montoConsolidaCons") : "");  
		conCartaLiqBean.setRelacionado((request.getParameter("relacionadoCons") != null) ? request.getParameter("relacionadoCons") : "");     
		conCartaLiqBean.setTipoCredito((request.getParameter("tipoCreditoCons") != null) ? request.getParameter("tipoCreditoCons") : ""); 
		
				
		String detalleFirmasAutoriza = request.getParameter("detalleFirmasAutoriza");
		
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeActCons = null;

		mensaje = solicitudCreditoServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion,solicitudCredito,detalleFirmasAutoriza);
		
		if(mensaje.getNumero()==0)
		{
			conCartaLiqBean.setSolicitudCreditoID(mensaje.getConsecutivoString());
			consolidacionCartaLiqServicio.getConsolidaCartaLiqDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensajeActCons = consolidacionCartaLiqServicio.grabaTransaccion(tipoTransaccionCons, conCartaLiqBean, "", tipoTransaccion);
			if(mensajeActCons.getNumero()!=0)
			{
				mensaje = mensajeActCons;
				mensaje.setConsecutivoString("0");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	
	public void setSolicitudCreditoServicio(
			SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}

	public SolicitudCreditoServicio getSolicitudCreditoServicio() {
		return solicitudCreditoServicio;
	}

	public ConsolidacionCartaLiqServicio getConsolidacionCartaLiqServicio() {
		return consolidacionCartaLiqServicio;
	}

	public void setConsolidacionCartaLiqServicio(ConsolidacionCartaLiqServicio consolidacionCartaLiqServicio) {
		this.consolidacionCartaLiqServicio = consolidacionCartaLiqServicio;
	}
} 
