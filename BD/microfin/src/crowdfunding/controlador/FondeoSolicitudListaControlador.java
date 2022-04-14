package crowdfunding.controlador;

import crowdfunding.bean.FondeoSolicitudBean;
import crowdfunding.servicio.FondeoSolicitudServicio;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class FondeoSolicitudListaControlador extends AbstractCommandController {

	FondeoSolicitudServicio fondeoSolicitudServicio = null;

	public FondeoSolicitudListaControlador(){
		setCommandClass(FondeoSolicitudBean.class);
		setCommandName("fondeoSolicitudBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		FondeoSolicitudBean fondeoSolicitud = (FondeoSolicitudBean) command;
		List fondeoSolicitudList = fondeoSolicitudServicio.listaGrid(FondeoSolicitudServicio.Enum_Lis_FondeoSolicitud.altoRiesgo, fondeoSolicitud);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(fondeoSolicitudList);
		return new ModelAndView("crowdfunding/gridFondeoSolicitud", "listaResultado", listaResultado);
	}

	public void setFondeoSolicitudServicio(
			FondeoSolicitudServicio fondeoSolicitudServicio) {
		this.fondeoSolicitudServicio = fondeoSolicitudServicio;
	}
}