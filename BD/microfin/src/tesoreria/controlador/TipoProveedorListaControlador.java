package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.TipoproveedoresBean;
import tesoreria.servicio.TipoproveedoresServicio;

public class TipoProveedorListaControlador extends AbstractCommandController{
	TipoproveedoresServicio tipoproveedoresServicio = null;

	public TipoProveedorListaControlador() {
			setCommandClass(TipoproveedoresBean.class);
			setCommandName("tipoProveedorBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		TipoproveedoresBean tipoProveedorBean = (TipoproveedoresBean) command;
		List tipoProveedorList = tipoproveedoresServicio.lista(tipoLista, tipoProveedorBean);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(tipoProveedorList);

		return new ModelAndView("tesoreria/tipoProveedorListaVista", "listaResultado", listaResultado);
	}

	public TipoproveedoresServicio getTipoproveedoresServicio() {
		return tipoproveedoresServicio;
	}

	public void setTipoproveedoresServicio(
			TipoproveedoresServicio tipoproveedoresServicio) {
		this.tipoproveedoresServicio = tipoproveedoresServicio;
	}
	
}
