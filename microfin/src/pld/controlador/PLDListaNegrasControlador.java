package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.PLDListaNegrasBean;
import pld.servicio.PLDListaNegrasServicio;

public class PLDListaNegrasControlador extends SimpleFormController{

	PLDListaNegrasServicio pldListaNegrasServicio=null;

	private PLDListaNegrasControlador(){
		setCommandClass(PLDListaNegrasBean.class);
		setCommandName("listasNegras");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response,
			Object command, BindException errors) throws Exception {

		pldListaNegrasServicio.getPldListaNegrasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		PLDListaNegrasBean  listasNegras = (PLDListaNegrasBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?Utileria.convierteEntero(request.getParameter("tipoTransaccion")):0;

		MensajeTransaccionBean mensaje = null;
		mensaje = pldListaNegrasServicio.grabaTransaccion(tipoTransaccion, listasNegras);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}
	//------------- setter----------------
	public void setPldListaNegrasServicio(
			PLDListaNegrasServicio pldListaNegrasServicio) {
		this.pldListaNegrasServicio = pldListaNegrasServicio;
	}

	public PLDListaNegrasServicio getPldListaNegrasServicio() {
		return pldListaNegrasServicio;
	}

}