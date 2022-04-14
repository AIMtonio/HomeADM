package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ConvenSecPreinsBean;
import cliente.servicio.ConvenSecPreinsServicio;

public class ConvenSecPreinsControlador extends SimpleFormController{
	
	ConvenSecPreinsServicio convenSecPreinsServicio = null;
	
	
	public ConvenSecPreinsControlador() {
		setCommandClass(ConvenSecPreinsBean.class);
		setCommandName("convenSecPreinsBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
			BindException errors) throws Exception {
		
		convenSecPreinsServicio.getConvenSecPreinsDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ConvenSecPreinsBean convenSecPreinsBean = (ConvenSecPreinsBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
				MensajeTransaccionBean mensaje = null;
				mensaje = convenSecPreinsServicio.grabaTransaccion(tipoTransaccion, convenSecPreinsBean);
				return new ModelAndView(getSuccessView(), "mensaje", mensaje);
				}
// --------------------setter y getter---------------------

	public ConvenSecPreinsServicio getConvenSecPreinsServicio() {
		return convenSecPreinsServicio;
	}

	public void setConvenSecPreinsServicio(
			ConvenSecPreinsServicio convenSecPreinsServicio) {
		this.convenSecPreinsServicio = convenSecPreinsServicio;
	}


}
