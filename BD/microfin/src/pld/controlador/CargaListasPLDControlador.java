package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.CargaListasPLDBean;
import pld.servicio.CargaListasPLDServicio;

public class CargaListasPLDControlador extends SimpleFormController{
	
	CargaListasPLDServicio cargaListasPLDServicio = null;

	public CargaListasPLDControlador() {
		setCommandClass(CargaListasPLDBean.class); 
		setCommandName("cargaListasPLDBean");	
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
			
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;

		cargaListasPLDServicio.getCargaListasPLDDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		CargaListasPLDBean cargaListasPLDBean = (CargaListasPLDBean) command;

		MensajeTransaccionBean mensaje = null;
		mensaje = cargaListasPLDServicio.grabaTransaccion(tipoTransaccion,cargaListasPLDBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CargaListasPLDServicio getCargaListasPLDServicio() {
		return cargaListasPLDServicio;
	}

	public void setCargaListasPLDServicio(
			CargaListasPLDServicio cargaListasPLDServicio) {
		this.cargaListasPLDServicio = cargaListasPLDServicio;
	}

}
