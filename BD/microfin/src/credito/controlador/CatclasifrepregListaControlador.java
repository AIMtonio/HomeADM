package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CatclasifrepregBean;
import credito.bean.ProductosCreditoBean;
import credito.servicio.CatclasifrepregServicio;
import credito.servicio.ProductosCreditoServicio;

public class CatclasifrepregListaControlador  extends AbstractCommandController {

	CatclasifrepregServicio catclasifrepregServicio = null;

	public CatclasifrepregListaControlador(){
		setCommandClass(CatclasifrepregBean.class);
		setCommandName("catclasifrepreg");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
       String controlID = request.getParameter("controlID");
       
       CatclasifrepregBean catclasifrepreg = (CatclasifrepregBean) command;
       catclasifrepregServicio.getCatclasifrepregDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
       
                List clasifrepreg = catclasifrepregServicio.lista(tipoLista, catclasifrepreg);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(clasifrepreg);
		return new ModelAndView("credito/catclasifrepregListaVista", "listaResultado", listaResultado);
	}

	
	public CatclasifrepregServicio getCatclasifrepregServicio() {
		return catclasifrepregServicio;
	}

	public void setCatclasifrepregServicio(
			CatclasifrepregServicio catclasifrepregServicio) {
		this.catclasifrepregServicio = catclasifrepregServicio;
	}
	

} 

