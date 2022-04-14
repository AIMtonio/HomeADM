package cedes.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.bean.CedesAnclajeBean;
import cedes.servicio.CedesAnclajeServicio;

public class CedesAnclajeControlador extends SimpleFormController {
	
	CedesAnclajeServicio cedesAnclajeServicio = null;
	
	
	public CedesAnclajeControlador(){
		setCommandClass(CedesAnclajeBean.class);
 		setCommandName("cedesAnclajeBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
	cedesAnclajeServicio.getCedesAnclajeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	CedesAnclajeBean cedesAnclajeBean = (CedesAnclajeBean) command;
	int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
	MensajeTransaccionBean mensaje = null;
	mensaje = cedesAnclajeServicio.grabaTransaccion(tipoTransaccion, cedesAnclajeBean);
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

	public CedesAnclajeServicio getCedesAnclajeServicio() {
		return cedesAnclajeServicio;
	}

	public void setCedesAnclajeServicio(CedesAnclajeServicio cedesAnclajeServicio) {
		this.cedesAnclajeServicio = cedesAnclajeServicio;
	} 
	
}
