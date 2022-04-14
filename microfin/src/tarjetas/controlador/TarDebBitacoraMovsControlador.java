package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarDebBitacoraMovsBean;
import tarjetas.servicio.TarDebBitacoraMovsServicio;

public class TarDebBitacoraMovsControlador extends SimpleFormController{
	TarDebBitacoraMovsServicio  tarDebBitacoraMovsServicio= null;

	public TarDebBitacoraMovsControlador() {
		setCommandClass(TarDebBitacoraMovsBean.class);
		setCommandName("tarDebBitacoraMovsBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
			BindException errors) throws Exception {

		TarDebBitacoraMovsBean tarDebBitacoraMovsBean = (TarDebBitacoraMovsBean) command;

		tarDebBitacoraMovsServicio.getTarDebBitacoraMovsDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
			Integer.parseInt(request.getParameter("tipoTransaccion")):0;

			MensajeTransaccionBean mensaje = null;
			mensaje = tarDebBitacoraMovsServicio.grabaTransaccion(tarDebBitacoraMovsBean, tipoTransaccion);

			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public TarDebBitacoraMovsServicio getTarDebBitacoraMovsServicio() {
		return tarDebBitacoraMovsServicio;
	}
	public void setTarDebBitacoraMovsServicio(
			TarDebBitacoraMovsServicio tarDebBitacoraMovsServicio) {
		this.tarDebBitacoraMovsServicio = tarDebBitacoraMovsServicio;
	}


}

