package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.ConfiguracionRatiosBean;
import originacion.servicio.ConfiguracionRatiosServicio;

public class ConfiguracionRatiosControlador extends SimpleFormController {
	
	private ConfiguracionRatiosServicio	configuracionRatiosServicio;
	
	public ConfiguracionRatiosControlador() {
		setCommandClass(ConfiguracionRatiosBean.class);
		setCommandName("ConfiguracionRatios");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			ConfiguracionRatiosBean configuracionRatiosBean = (ConfiguracionRatiosBean) command;
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			String detalles = request.getParameter("detalle");
			mensaje = configuracionRatiosServicio.graba(listaDetalles(detalles), tipoTransaccion);
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(888);
			mensaje.setDescripcion("Error al guardar la Configuración de Ratios.");
		} finally {
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(777);
				mensaje.setDescripcion("Error al guardar la Configuración de Ratios.");
			}
		}
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	/**
	 * Método para generar la lista apartir del String enviado desde la pantalla
	 * @param detalle: Cadena String con el detalle para la configuración de los ratios.
	 * @return List<ConfiguracionRatiosBean>
	 */
	public List<ConfiguracionRatiosBean> listaDetalles(String detalle) {
		try {
			List<ConfiguracionRatiosBean> listaDetalle = new ArrayList<ConfiguracionRatiosBean>();
			StringTokenizer tokensBean = new StringTokenizer(detalle, "[");
			String stringCampos;
			String tokensCampos[];
			while (tokensBean.hasMoreTokens()) {
				ConfiguracionRatiosBean conf = new ConfiguracionRatiosBean();
				stringCampos = tokensBean.nextToken();
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				conf.setRatiosCatalogoID(tokensCampos[0]);
				conf.setProducCreditoID(tokensCampos[1]);
				conf.setPorcentaje(tokensCampos[2]);
				conf.setLimiteInferior(tokensCampos[3]);
				conf.setLimiteSuperior(tokensCampos[4]);
				conf.setPuntos(tokensCampos[5]);
				listaDetalle.add(conf);
			}
			return listaDetalle;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public ConfiguracionRatiosServicio getConfiguracionRatiosServicio() {
		return configuracionRatiosServicio;
	}
	
	public void setConfiguracionRatiosServicio(ConfiguracionRatiosServicio configuracionRatiosServicio) {
		this.configuracionRatiosServicio = configuracionRatiosServicio;
	}
	
}
