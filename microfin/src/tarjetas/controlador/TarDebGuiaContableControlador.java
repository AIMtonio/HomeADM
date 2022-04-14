package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarDebCuentasMayorBean;
import tarjetas.servicio.TarDebGuiaContableServicio;

public class TarDebGuiaContableControlador extends SimpleFormController{

	TarDebGuiaContableServicio tarDebGuiaContableServicio = null;
	public TarDebGuiaContableControlador(){
		setCommandClass(TarDebCuentasMayorBean.class);
		setCommandName("guiaTarDeb");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

			MensajeTransaccionBean mensaje = null;
			TarDebCuentasMayorBean guiaTarjetas = (TarDebCuentasMayorBean) command;
			tarDebGuiaContableServicio.getTarDebGuiaContableDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			int  tipoTransaccionCM = ( request.getParameter("tipoTransaccionCM") != null ) ?
					Integer.parseInt(request.getParameter("tipoTransaccionCM")) : 0;

			mensaje = tarDebGuiaContableServicio.grabaTransaccion(tipoTransaccionCM,request);

			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public TarDebGuiaContableServicio getTarDebGuiaContableServicio() {
		return tarDebGuiaContableServicio;
	}
	public void setTarDebGuiaContableServicio(
			TarDebGuiaContableServicio tarDebGuiaContableServicio) {
		this.tarDebGuiaContableServicio = tarDebGuiaContableServicio;
	}
}