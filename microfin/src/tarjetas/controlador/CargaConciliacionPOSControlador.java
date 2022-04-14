package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarDebConciEncabezaBean;
import tarjetas.servicio.TarDebConciliaPosServicio;

public class CargaConciliacionPOSControlador extends  SimpleFormController{

	TarDebConciliaPosServicio tarDebConciliaPosServicio= null;
	public CargaConciliacionPOSControlador(){
		setCommandClass(TarDebConciEncabezaBean.class);
 		setCommandName("carcaConciliacion");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		tarDebConciliaPosServicio.getTarDebConciliaPosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		TarDebConciEncabezaBean tarjetaConciBean = (TarDebConciEncabezaBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		mensaje = tarDebConciliaPosServicio.grabaTransaccion(tipoTransaccion, tarjetaConciBean);
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TarDebConciliaPosServicio getTarDebConciliaPosServicio() {
		return tarDebConciliaPosServicio;
	}

	public void setTarDebConciliaPosServicio(
			TarDebConciliaPosServicio tarDebConciliaPosServicio) {
		this.tarDebConciliaPosServicio = tarDebConciliaPosServicio;
	}	
}