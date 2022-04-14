package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.CargaListasPLDBean;
import pld.servicio.CoincidenciasListasPLDServicio;

public class CoincidenciasListasPLDControlador extends SimpleFormController{

	CoincidenciasListasPLDServicio coincidenciasListasPLDServicio = null;

	public CoincidenciasListasPLDControlador() {
		setCommandClass(CargaListasPLDBean.class); 
		setCommandName("cargaListasPLDBean");	
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response,
			Object command, BindException errors) throws Exception {

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?Utileria.convierteEntero(request.getParameter("tipoTransaccion")):0;

		coincidenciasListasPLDServicio.getCargaListasPLDDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		CargaListasPLDBean cargaListasPLDBean = (CargaListasPLDBean) command;

		MensajeTransaccionBean mensaje = null;
		mensaje = coincidenciasListasPLDServicio.grabaTransaccion(tipoTransaccion,cargaListasPLDBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CoincidenciasListasPLDServicio getCoincidenciasListasPLDServicio() {
		return coincidenciasListasPLDServicio;
	}

	public void setCoincidenciasListasPLDServicio(
			CoincidenciasListasPLDServicio coincidenciasListasPLDServicio) {
		this.coincidenciasListasPLDServicio = coincidenciasListasPLDServicio;
	}

}