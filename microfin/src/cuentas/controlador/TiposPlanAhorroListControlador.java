package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.TiposPlanAhorroBean;
import cuentas.servicio.TiposPlanAhorroServicio;

public class TiposPlanAhorroListControlador extends AbstractCommandController{
	
	TiposPlanAhorroServicio tiposPlanAhorroServicio = null;
	
	public TiposPlanAhorroListControlador() {
		setCommandClass(TiposPlanAhorroBean.class);
		setCommandName("tiposPlanAhorro");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errores) throws Exception{
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		TiposPlanAhorroBean tiposPlanAhorro = (TiposPlanAhorroBean) command;
		List tiposPlanAhorroLista = tiposPlanAhorroServicio.lista(tipoLista, tiposPlanAhorro);
		
		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(tiposPlanAhorroLista);
		
		return new ModelAndView("cuentas/listaTiposPlanAhorro","listaResultado",listaResultado);
	}

	public TiposPlanAhorroServicio getTiposPlanAhorroServicio() {
		return tiposPlanAhorroServicio;
	}

	public void setTiposPlanAhorroServicio(TiposPlanAhorroServicio tiposPlanAhorroServicio) {
		this.tiposPlanAhorroServicio = tiposPlanAhorroServicio;
	}
}
