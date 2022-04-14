package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import herramientas.Constantes;
import herramientas.Utileria;
import nomina.bean.PagoNominaBean;
import nomina.servicio.PagoNominaServicio;

public class AplicacionPagosGridControlador  extends AbstractCommandController{

	PagoNominaServicio pagoNominaServicio = null;
	public static String ListaAplicacionPagoInstitucion = "ListaAplicacionPagoInstitucion";

	public AplicacionPagosGridControlador(){
		setCommandClass(PagoNominaBean.class);
		setCommandName("pagosNomina");
	}

	public static interface Enum_Page {
		String completa		= "completa";
		String primero		= "primero";
		String anterior		= "anterior";
		String ultimo		= "ultimo";
		String siguiente	= "siguiente";
	}

	protected ModelAndView handle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object object, BindException bindException) throws Exception {


		int tipoLista = (httpServletRequest.getParameter("tipoLista")!=null) ? Integer.parseInt(httpServletRequest.getParameter("tipoLista")) : 0;
		String pagina = httpServletRequest.getParameter("page");
		String tipoPaginacion = Constantes.STRING_VACIO;

		List listaPagoNominaBean = null;
		List listaResultado = (List) new ArrayList();
		PagedListHolder<PagoNominaBean> listaPaginada = null;

		if (pagina == null) {
			tipoPaginacion = Enum_Page.completa;
		}

		if (tipoPaginacion.equalsIgnoreCase(Enum_Page.completa)) {
			PagoNominaBean pagoNominaBean = (PagoNominaBean) object;
			listaPagoNominaBean = pagoNominaServicio.lista(tipoLista, pagoNominaBean);
			listaPaginada = new PagedListHolder<PagoNominaBean>(listaPagoNominaBean);
		} else{
			if (httpServletRequest.getSession().getAttribute(ListaAplicacionPagoInstitucion) != null) {

				// Agrego los objetos seleccionados
				listaResultado = (List) httpServletRequest.getSession().getAttribute(ListaAplicacionPagoInstitucion);
				listaPaginada = (PagedListHolder) listaResultado.get(1);
				List listaParametros = listaPaginada.getSource();
				listaPaginada.setSource(listaParametros);
			}

			// Se guarda la paginacion
			listaPagoNominaBean = (List) httpServletRequest.getSession().getAttribute(ListaAplicacionPagoInstitucion);
			listaPaginada = (PagedListHolder) listaPagoNominaBean.get(1);
			listaPaginada.getSource();

			if (Enum_Page.siguiente.equals(pagina)) {
				listaPaginada.nextPage();
				listaPaginada.getPage();
			} else if (Enum_Page.anterior.equals(pagina)) {
				listaPaginada.previousPage();
				listaPaginada.getPage();
			} else if(Enum_Page.primero.equals(pagina)){
				listaPaginada.setPage(0);
				listaPaginada.getPage();
			} else if(Enum_Page.ultimo.equals(pagina)){
				listaPaginada.setPage(listaPaginada.getPageCount()-1);
				listaPaginada.getPage();
			} else {
				listaPaginada = null;
			}
		}

		// Seccion de pagina
		listaPaginada.setPageSize(Constantes.PaginacionEstandar);
		listaResultado.add(0, tipoLista);
		listaResultado.add(1, listaPaginada);
		listaResultado.add(2, (listaPaginada.getPage()+1));
		listaResultado.add(3, listaPaginada.getPageCount());
		httpServletRequest.getSession().setAttribute(ListaAplicacionPagoInstitucion, listaResultado);
		return new ModelAndView("nomina/aplicacionPagosGrid", "listaResultado", listaResultado);
	}

	public PagoNominaServicio getPagoNominaServicio() {
		return pagoNominaServicio;
	}

	public void setPagoNominaServicio(PagoNominaServicio pagoNominaServicio) {
		this.pagoNominaServicio = pagoNominaServicio;
	}
}
