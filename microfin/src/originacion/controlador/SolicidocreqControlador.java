package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.SolicidocreqBean;
import originacion.servicio.SolicidocreqServicio;


public class SolicidocreqControlador extends SimpleFormController {

	
	SolicidocreqServicio solicidocreqServicio  = null;

	public SolicidocreqControlador(){
		setCommandClass(SolicidocreqBean.class);
		setCommandName("solicidocreqBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		SolicidocreqBean solicidocreqBean = (SolicidocreqBean) command;
		
		solicidocreqServicio.getSolicidocreqDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;		
				
		String detalleDocumentosReq = request.getParameter("detalleDocumentosReq");
						
		MensajeTransaccionBean mensaje = null;
		mensaje = solicidocreqServicio.grabaTransaccion(tipoTransaccion,solicidocreqBean,detalleDocumentosReq);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setSolicidocreqServicio(SolicidocreqServicio solicidocreqServicio) {
		this.solicidocreqServicio = solicidocreqServicio;
	}

	
	

} 

