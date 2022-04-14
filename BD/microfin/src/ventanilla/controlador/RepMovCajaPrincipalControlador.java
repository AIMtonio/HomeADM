package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.CajasMovsBean;
import ventanilla.servicio.CajasMovsServicio;


public class RepMovCajaPrincipalControlador extends SimpleFormController{
	CajasMovsServicio  cajasMovsServicio	= null;
	
	public RepMovCajaPrincipalControlador() {
		setCommandClass(CajasMovsBean.class);
		setCommandName("cajasMovsBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
			cajasMovsServicio.getCajasMovsDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccion")):
									0;
			
			CajasMovsBean cajasMovs = (CajasMovsBean) command;
	
			MensajeTransaccionBean mensaje = null;
	
	
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	//-------- getter y setter
	public CajasMovsServicio getCajasMovsServicio() {
		return cajasMovsServicio;
	}

	public void setCajasMovsServicio(CajasMovsServicio cajasMovsServicio) {
		this.cajasMovsServicio = cajasMovsServicio;
	}
	
	
	
	

	
}
