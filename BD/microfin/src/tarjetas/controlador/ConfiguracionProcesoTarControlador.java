package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import com.google.gson.Gson;

import tarjetas.bean.ConfigFTPProsaBean;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.ConfiguracionProcesoTarServicio;

public class ConfiguracionProcesoTarControlador extends SimpleFormController {
	ConfiguracionProcesoTarServicio configuracionProcesoTarServicio = null;
	
	String archivoNombre="";
	public ConfiguracionProcesoTarControlador() {
		setCommandClass(ConfigFTPProsaBean.class);
 		setCommandName("configProcesoTar");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) {
		MensajeTransaccionBean mensaje = null;
		ConfigFTPProsaBean configFTPProsaBean = (ConfigFTPProsaBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		if (tipoTransaccion != 0) {
			if(tipoTransaccion == 3){
				mensaje = configuracionProcesoTarServicio.actualizaDestinatarios(configFTPProsaBean, tipoTransaccion);
			}else {
				mensaje = configuracionProcesoTarServicio.actualiza(configFTPProsaBean, tipoTransaccion);
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ConfiguracionProcesoTarServicio getConfiguracionProcesoTarServicio() {
		return configuracionProcesoTarServicio;
	}

	public void setConfiguracionProcesoTarServicio(
			ConfiguracionProcesoTarServicio configuracionProcesoTarServicio) {
		this.configuracionProcesoTarServicio = configuracionProcesoTarServicio;
	}
	
}
