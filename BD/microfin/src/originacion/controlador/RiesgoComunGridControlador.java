package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.RiesgoComunBean;
import originacion.servicio.RiesgoComunServicio;


public class RiesgoComunGridControlador extends AbstractCommandController{
	RiesgoComunServicio riesgoComunServicio = null;
	
	public RiesgoComunGridControlador(){
		setCommandClass(RiesgoComunBean.class);
		setCommandName("riesgoComunBean");	
		
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		RiesgoComunBean respuestaBean = (RiesgoComunBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	

		String page = request.getParameter("page");
	    String tipoPaginacion = "";
		  
	    
	    List listaResultado = (List)new ArrayList();
		if (page == null) {
			tipoPaginacion = "Completa";
		}
		
		if (tipoPaginacion.equalsIgnoreCase("Completa")) {

			List listaResul = riesgoComunServicio.listaRiesgoComun(tipoLista,respuestaBean);
			
			PagedListHolder riesgosLis = new PagedListHolder(listaResul);
			riesgosLis.setPageSize(50);
			listaResultado.add(tipoLista);
			listaResultado.add(riesgosLis);			
	
			request.getSession().setAttribute("ConsultaRiesgosGridControlador", listaResultado);

		} else {
			PagedListHolder credList = null;
	
			if (request.getSession().getAttribute("ConsultaRiesgosGridControlador") != null) {
				listaResultado = (List) request.getSession().getAttribute("ConsultaRiesgosGridControlador");
				credList = (PagedListHolder) listaResultado.get(1);

				if ("next".equals(page)) {
					credList.nextPage();
				}
				else if ("previous".equals(page)) {
					credList.previousPage();
					credList.getPage();
				}
			} else {
				credList = null;
			}
			
			listaResultado.add(tipoLista);
			listaResultado.add(credList);
			
	
		}
	
		
		return new ModelAndView("originacion/riesgoComunGridVista", "listaResultado", listaResultado);
	}

	public RiesgoComunServicio getRiesgoComunServicio() {
		return riesgoComunServicio;
	}

	public void setRiesgoComunServicio(RiesgoComunServicio riesgoComunServicio) {
		this.riesgoComunServicio = riesgoComunServicio;
	}	

		
}
