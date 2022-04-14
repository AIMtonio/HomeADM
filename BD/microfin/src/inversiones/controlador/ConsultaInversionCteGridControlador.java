package inversiones.controlador;

import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


public class ConsultaInversionCteGridControlador extends AbstractCommandController {
	InversionServicio inversionServicio = null;
	
	public static interface Enum_Lis_ConsultaInversion{
		int vencidas = 10;
		int vigentes = 2;
	}

	public ConsultaInversionCteGridControlador() {
		setCommandClass(InversionBean.class);
		setCommandName("inversionBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		InversionBean inver = (InversionBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String pagina = request.getParameter("pagina");
 		String tipoPaginacion = "";
 		List listaInversiones = null;
 		PagedListHolder inversionesList = null;
 		
		if(pagina == null){
			tipoPaginacion = "Completa";
		}

		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			
			listaInversiones =inversionServicio.lista(tipoLista, inver);
			inversionesList = new PagedListHolder(listaInversiones);
			inversionesList.setPageSize(10);
			
			switch(tipoLista){
				case Enum_Lis_ConsultaInversion.vencidas:
					request.getSession().setAttribute("ConsultaInversionesCte_Vencidos", inversionesList);
					break;
				case Enum_Lis_ConsultaInversion.vigentes:
					request.getSession().setAttribute("ConsultaInversionesCte_Vigentes", inversionesList);
					break;
			}

		}else{
			if(tipoLista == Enum_Lis_ConsultaInversion.vencidas){
				if(request.getSession().getAttribute("ConsultaInversionesCte_Vencidos")!= null){
					inversionesList = (PagedListHolder) request.getSession().getAttribute("ConsultaInversionesCte_Vencidos");
					if ("next".equals(pagina)) {
						inversionesList.nextPage();
					}
					else if ("previous".equals(pagina)) {
						inversionesList.previousPage();
					}	
				}else{
					inversionesList = null;
				}
			}
			if(tipoLista == Enum_Lis_ConsultaInversion.vigentes){
				if(request.getSession().getAttribute("ConsultaInversionesCte_Vigentes")!= null){
					inversionesList = (PagedListHolder) request.getSession().getAttribute("ConsultaInversionesCte_Vigentes");
					if ("next".equals(pagina)) {
						inversionesList.nextPage();
					}
					else if ("previous".equals(pagina)) {
						inversionesList.previousPage();
					}	
				}else{
					inversionesList = null;
				}
			}
			
		}
		List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(inversionesList);
		
	return new ModelAndView("inversiones/consultaInversionCteGridVista", "listaResultado", listaResultado);
	}

	public InversionServicio getInversionServicio() {
		return inversionServicio;
	}

	public void setInversionServicio(InversionServicio inversionServicio) {
		this.inversionServicio = inversionServicio;
	}

}
