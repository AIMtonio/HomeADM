package fira.controlador;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.UniConceptosInvAgroBean;
import fira.servicio.UniConceptosInvAgroServicio;
import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

public class UniConceptosInvAgroControlador extends SimpleFormController{
	
	UniConceptosInvAgroServicio uniConceptosInvAgroServicio = null;
	
	public UniConceptosInvAgroControlador() {
		setCommandClass(UniConceptosInvAgroBean.class);
		setCommandName("uniConceptosInvAgroBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
		UniConceptosInvAgroBean bean = (UniConceptosInvAgroBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		uniConceptosInvAgroServicio.getCreditosAgroDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		mensaje = uniConceptosInvAgroServicio.grabaTransaccion(tipoTransaccion, bean);
		 } catch (Exception ex) {
				ex.printStackTrace();
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(404);
				mensaje.setDescripcion("Error en el controlador .");
			}
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public UniConceptosInvAgroServicio getUniConceptosInvAgroServicio() {
		return uniConceptosInvAgroServicio;
	}

	public void setUniConceptosInvAgroServicio(UniConceptosInvAgroServicio uniConceptosInvAgroServicio) {
		this.uniConceptosInvAgroServicio = uniConceptosInvAgroServicio;
	}
}
