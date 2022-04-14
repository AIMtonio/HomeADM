package aportaciones.controlador;

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
import aportaciones.servicio.CondicionesVencimServicio;


public class CondicionesVencimGridControlador extends AbstractCommandController{
	AportacionesServicio aportacionesServicio = null;
	CondicionesVencimServicio condicionesVencimServicio = null;
	
	public CondicionesVencimGridControlador(){
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException error) throws Exception {
		AportacionesBean aportacionesBean = (AportacionesBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		int tipoListaSim = AportacionesServicio.Enum_Lis_Aportaciones.simulador;
		
		List listaResultado = (List)new ArrayList();
		List<AportacionesBean> LisPagos = aportacionesServicio.lista(tipoListaSim, aportacionesBean);
		
		listaResultado.add(tipoLista);
		listaResultado.add(LisPagos);
		
		return new ModelAndView("aportaciones/simCondVencimGridVista", "listaResultado", listaResultado);
	}

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}

	public CondicionesVencimServicio getCondicionesVencimServicio() {
		return condicionesVencimServicio;
	}

	public void setCondicionesVencimServicio(CondicionesVencimServicio condicionesVencimServicio) {
		this.condicionesVencimServicio = condicionesVencimServicio;
	}
}
