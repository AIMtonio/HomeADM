package nomina.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.ArchivoInstalBean;
import nomina.servicio.ArchivoInstalServicio;

public class ArchivoInstaGridControlador extends AbstractCommandController {
	ArchivoInstalServicio archivoInstalServicio;
	
	public ArchivoInstaGridControlador() {
		setCommandClass(ArchivoInstalBean.class);
		setCommandName("archivoInstalBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		List<ArchivoInstalBean> lista = null;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String folioID = request.getParameter("folioID");
		ArchivoInstalBean archivo = new ArchivoInstalBean();
		archivo.setFolioID(folioID);		
		
		lista = archivoInstalServicio.obtenerListadoCreditosReporte(archivo);
		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(lista);
	
		return new ModelAndView("nomina/archivoInstalGridVista", "listaResultado", listaResultado);
	}

	public ArchivoInstalServicio getArchivoInstalServicio() {
		return archivoInstalServicio;
	}

	public void setArchivoInstalServicio(ArchivoInstalServicio archivoInstalServicio) {
		this.archivoInstalServicio = archivoInstalServicio;
	}

}
