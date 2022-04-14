package aportaciones.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.TasasISRExtBean;
import aportaciones.servicio.TasasISRExtServicio;

public class TasasISRExtGridControlador extends SimpleFormController {

	TasasISRExtServicio tasasISRExtServicio;

	public TasasISRExtGridControlador() {
		setCommandClass(TasasISRExtBean.class);
		setCommandName("tasasISRExtBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		TasasISRExtBean paisesBean = (TasasISRExtBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<TasasISRExtBean> lista = tasasISRExtServicio.lista(tipoLista, paisesBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public TasasISRExtServicio getTasasISRExtServicio() {
		return tasasISRExtServicio;
	}

	public void setTasasISRExtServicio(TasasISRExtServicio tasasISRExtServicio) {
		this.tasasISRExtServicio = tasasISRExtServicio;
	}

}