package nomina.controlador;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import herramientas.Utileria;
import mondrian.test.loader.CsvDBLoader.ListRowStream;
import nomina.bean.ArchivoInstalBean;
import nomina.servicio.ArchivoInstalServicio;

public class ArchivoInstalListaControlador  extends AbstractCommandController {
	//InstitucionNominaServicio institucionNominaServicio = null;
	ArchivoInstalServicio archivoInstalServicio = null;
			
	public ArchivoInstalListaControlador(){
		setCommandClass(ArchivoInstalBean.class);
		setCommandName("ArchivoInstalBean");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ArchivoInstalBean bean = (ArchivoInstalBean) command;
		
		List listaValores = null;
		List listaResultado = new ArrayList();
		
		listaValores = archivoInstalServicio.lista(tipoLista, bean);
		
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaValores);
		
		return new ModelAndView("nomina/archivoInstalListaVista", "listaResultado", listaResultado);
	}
	public ArchivoInstalServicio getArchivoInstalServicio() {
		return archivoInstalServicio;
	}
	public void setArchivoInstalServicio(ArchivoInstalServicio archivoInstalServicio) {
		this.archivoInstalServicio = archivoInstalServicio;
	}
		
		
}
