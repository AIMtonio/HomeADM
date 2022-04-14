package guardaValores.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import guardaValores.bean.CatInstGuardaValoresBean;
import guardaValores.servicio.CatInstGuardaValoresServicio;

import org.springframework.web.servlet.mvc.SimpleFormController;

public class CatInstGuardaValoresControlador extends SimpleFormController {
	
	CatInstGuardaValoresServicio catInstGuardaValoresServicio = null;
	
	public CatInstGuardaValoresControlador() {
		setCommandClass(CatInstGuardaValoresBean.class);
		setCommandName("catInstGuardaValoresBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		catInstGuardaValoresServicio.getCatInstGuardaValoresDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		
		CatInstGuardaValoresBean catInstGuardaValoresBean = (CatInstGuardaValoresBean) command;
		MensajeTransaccionBean mensajeTransaccionBean = null;
		mensajeTransaccionBean = catInstGuardaValoresServicio.grabaTransaccion(tipoTransaccion, catInstGuardaValoresBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensajeTransaccionBean);
	}

	public CatInstGuardaValoresServicio getCatInstGuardaValoresServicio() {
		return catInstGuardaValoresServicio;
	}

	public void setCatInstGuardaValoresServicio(
			CatInstGuardaValoresServicio catInstGuardaValoresServicio) {
		this.catInstGuardaValoresServicio = catInstGuardaValoresServicio;
	}

}
