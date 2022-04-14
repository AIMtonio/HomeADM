package originacion.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.ConfiguracionRatiosBean;
import originacion.servicio.ConfiguracionRatiosServicio;

/**
 * Clase para mostrar la pantalla que lista la configuracion de Ratios por
 * Producto de Crédito
 * 
 * @category grid
 */
public class ConfiguracionRatiosGridControlador extends AbstractCommandController {
	ConfiguracionRatiosServicio	configuracionRatiosServicio	= null;
	
	public ConfiguracionRatiosGridControlador() {
		setCommandClass(ConfiguracionRatiosBean.class);
		setCommandName("ConfiguracionRatios");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, org.springframework.validation.BindException errors) throws Exception {
		List listaResultado = (List) new ArrayList();
		try {
			ConfiguracionRatiosBean configuracionRatiosBean = (ConfiguracionRatiosBean) command;
			int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
			double total = 0;
			List<ConfiguracionRatiosBean> lista = configuracionRatiosServicio.lista(tipoLista, configuracionRatiosBean);
			
			listaResultado.add(tipoLista);
			listaResultado.add(lista);
			if (lista != null && !lista.isEmpty()) {
				total = Utileria.convierteDoble(lista.get(0).getTotal());
			}
			listaResultado.add(total);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return new ModelAndView("originacion/configuracionRatiosGridVista", "listaResultado", listaResultado);
	}
	
	public ConfiguracionRatiosServicio getConfiguracionRatiosServicio() {
		return configuracionRatiosServicio;
	}
	
	public void setConfiguracionRatiosServicio(ConfiguracionRatiosServicio configuracionRatiosServicio) {
		this.configuracionRatiosServicio = configuracionRatiosServicio;
	}
	
}
