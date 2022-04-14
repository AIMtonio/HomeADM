package aportaciones.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.GruposFamiliarBean;
import aportaciones.servicio.GruposFamiliarServicio;

public class GruposFamiliarGridControlador extends SimpleFormController {

	GruposFamiliarServicio gruposFamiliarServicio;
	
	public GruposFamiliarGridControlador() {
		setCommandClass(GruposFamiliarBean.class);
		setCommandName("gruposFamiliarBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		GruposFamiliarBean gruposFamBean = (GruposFamiliarBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<GruposFamiliarBean> lista = gruposFamiliarServicio.lista(tipoLista, gruposFamBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public GruposFamiliarServicio getGruposFamiliarServicio() {
		return gruposFamiliarServicio;
	}

	public void setGruposFamiliarServicio(
			GruposFamiliarServicio gruposFamiliarServicio) {
		this.gruposFamiliarServicio = gruposFamiliarServicio;
	}
}