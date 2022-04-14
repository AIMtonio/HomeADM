  package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.DatSocDemogBean;
import originacion.servicio.DatSocDemogServicio;



public class DatSocDemogControlador extends SimpleFormController {

	
	DatSocDemogServicio datSocDemogServicio  = null;

	public DatSocDemogControlador(){
		setCommandClass(DatSocDemogBean.class);
		setCommandName("datSocDemogBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		DatSocDemogBean datSocDemogBean = (DatSocDemogBean) command;
		
		datSocDemogServicio.getDatSocDemograDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccionDSE")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionDSE")):
				0;		
				
				
						
		MensajeTransaccionBean mensaje = null;
		mensaje = datSocDemogServicio.grabaTransaccion(tipoTransaccion,datSocDemogBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	public void setDatSocDemogServicio(DatSocDemogServicio datSocDemogServicio) {
		this.datSocDemogServicio = datSocDemogServicio;
	}

} 
 