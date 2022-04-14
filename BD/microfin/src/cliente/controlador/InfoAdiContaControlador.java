package cliente.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.InfoAdiContaBean;
import cliente.servicio.InfoAdiContaServicio;

public class InfoAdiContaControlador extends SimpleFormController {
	InfoAdiContaServicio	infoAdiContaServicio	= null;
	
	public InfoAdiContaControlador() {
		setCommandClass(InfoAdiContaBean.class);
		setCommandName("infoAdiConta");
	}
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		infoAdiContaServicio.getInfoAdiContaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		InfoAdiContaBean infoAdiContaBean = (InfoAdiContaBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = infoAdiContaServicio.grabaTransaccion(tipoTransaccion, infoAdiContaBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public InfoAdiContaServicio getInfoAdiContaServicio() {
		return infoAdiContaServicio;
	}
	
	public void setInfoAdiContaServicio(InfoAdiContaServicio infoAdiContaServicio) {
		this.infoAdiContaServicio = infoAdiContaServicio;
	}
}
