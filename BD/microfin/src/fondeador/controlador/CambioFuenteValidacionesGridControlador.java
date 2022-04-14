package fondeador.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CarCambioFondeoBitBean;
import credito.servicio.CarCambioFondeoBitServicio;

public class CambioFuenteValidacionesGridControlador extends AbstractCommandController {
	CarCambioFondeoBitServicio carCambioFondeoBitServicio = null;
	
	public CambioFuenteValidacionesGridControlador(){
		setCommandClass(CarCambioFondeoBitBean.class);
		setCommandName("carCambioFondeoBitBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		CarCambioFondeoBitBean carCambioFondeoBitBean = (CarCambioFondeoBitBean) command;
		List listaResultado = null;
		PagedListHolder pageListaFondeo = null;

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String pagina = request.getParameter("pagina");
		int numRegistros = 0;
		
		if("0".equals(pagina)){
			listaResultado = new ArrayList();
			
			List<CarCambioFondeoBitBean> listaCambioFondeoBean = carCambioFondeoBitServicio.lista(tipoLista, carCambioFondeoBitBean);
			tipoLista = listaCambioFondeoBean.size() == 0?0:tipoLista;
			
			pageListaFondeo = new PagedListHolder(listaCambioFondeoBean);
			pageListaFondeo.setPageSize(30);
			
			listaResultado.add(tipoLista); // 0
			listaResultado.add(pageListaFondeo);
			request.getSession().setAttribute("GridValidaciones", listaResultado);
		}else{
			if(request.getSession().getAttribute("GridValidaciones")!=null){
				listaResultado = new ArrayList();
				pageListaFondeo = null;
				
				listaResultado = (List) request.getSession().getAttribute("GridValidaciones");
				pageListaFondeo = (PagedListHolder) listaResultado.get(1);
				
				if ("next".equals(pagina)) {
					pageListaFondeo.nextPage();
				}
				else if ("previous".equals(pagina)) {
					pageListaFondeo.previousPage();
					pageListaFondeo.getPage();
				}
			}else{
				pageListaFondeo = null;
			}
			
			listaResultado.add(tipoLista);
			listaResultado.add(pageListaFondeo);
		}
		return new ModelAndView("fondeador/cambioFuenteValidacionesGridVista", "listaResultado",listaResultado);
	}

	public CarCambioFondeoBitServicio getCarCambioFondeoBitServicio() {
		return carCambioFondeoBitServicio;
	}

	public void setCarCambioFondeoBitServicio(
			CarCambioFondeoBitServicio carCambioFondeoBitServicio) {
		this.carCambioFondeoBitServicio = carCambioFondeoBitServicio;
	}
	
	

}
