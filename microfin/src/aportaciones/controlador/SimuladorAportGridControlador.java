package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;

public class SimuladorAportGridControlador extends AbstractCommandController{

	AportacionesServicio aportacionesServicio = null;

	public SimuladorAportGridControlador() {
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException error) throws Exception {
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));

		int tipoListaSim = AportacionesServicio.Enum_Lis_Aportaciones.simulador;
		AportacionesBean aportaciones = (AportacionesBean) command;

		List listaResultado = (List)new ArrayList();

		List LisPagos = aportacionesServicio.lista(tipoListaSim, aportaciones);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(Constantes.ENTERO_CERO);

		listaResultado.add(tipoLista);
		listaResultado.add(LisPagos);

		return new ModelAndView("aportaciones/simuladorPagosAportGridVista", "listaResultado", listaResultado);
	}

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}

}