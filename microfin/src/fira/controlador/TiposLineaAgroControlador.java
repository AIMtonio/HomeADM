package fira.controlador;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.TiposLineasAgroBean;
import fira.servicio.TiposLineasAgroServicio;
import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

public class TiposLineaAgroControlador extends SimpleFormController{
	
	TiposLineasAgroServicio tiposLineasAgroServicio = null;
	
	public TiposLineaAgroControlador() {
		setCommandClass(TiposLineasAgroBean.class);
		setCommandName("tiposLineasAgroBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensajeTransaccionBean = null;
		try {
			TiposLineasAgroBean tiposLineasAgroBean = (TiposLineasAgroBean) command;
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			int tipoActualizacion = Utileria.convierteEntero(request.getParameter("tipoActualizacion"));
			tiposLineasAgroServicio.getTiposLineasAgroDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensajeTransaccionBean = tiposLineasAgroServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, tiposLineasAgroBean);
		 } catch (Exception exception) {
			 exception.printStackTrace();
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(404);
				mensajeTransaccionBean.setDescripcion("Error en el controlador .");
			}
		
		return new ModelAndView(getSuccessView(), "mensaje", mensajeTransaccionBean);
	}

	public TiposLineasAgroServicio getTiposLineasAgroServicio() {
		return tiposLineasAgroServicio;
	}

	public void setTiposLineasAgroServicio(TiposLineasAgroServicio tiposLineasAgroServicio) {
		this.tiposLineasAgroServicio = tiposLineasAgroServicio;
	}
}
