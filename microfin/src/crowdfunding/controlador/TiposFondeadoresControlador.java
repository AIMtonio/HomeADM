package crowdfunding.controlador;

import general.bean.MensajeTransaccionBean;
import crowdfunding.bean.TiposFondeadoresBean;
import crowdfunding.servicio.TiposFondeadoresServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class TiposFondeadoresControlador extends SimpleFormController{

	TiposFondeadoresServicio tiposFondeadoresServicio = null;

	public TiposFondeadoresControlador() {
		setCommandClass(TiposFondeadoresBean.class);
		setCommandName("tiposFondeadores");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		tiposFondeadoresServicio.getTiposFondeadoresDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		TiposFondeadoresBean tiposFonde = (TiposFondeadoresBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));


		MensajeTransaccionBean mensaje = null;
		mensaje = tiposFondeadoresServicio.grabaTransaccion(tipoTransaccion,tiposFonde);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public void setTiposFondeadoresServicio(TiposFondeadoresServicio tiposFondeadoresServicio) {
		this.tiposFondeadoresServicio = tiposFondeadoresServicio;
	}
}
