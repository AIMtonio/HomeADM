package seguimiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import seguimiento.bean.CatSegtoCategoriasBean;
import seguimiento.servicio.CatSegtoCategoriasServicio;

public class CatSegtoCategoriaListaControlador extends AbstractCommandController {

	CatSegtoCategoriasServicio catSegtoCategoriasServicio= null;

 	public CatSegtoCategoriaListaControlador(){
 		setCommandClass(CatSegtoCategoriasBean.class);
		setCommandName("catSegtoCategoriasBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        CatSegtoCategoriasBean categoriasBean = (CatSegtoCategoriasBean) command;
        List listaCategorias = catSegtoCategoriasServicio.lista(tipoLista, categoriasBean);
        
        List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(controlID);
        listaResultado.add(listaCategorias);
        
        return new ModelAndView("seguimiento/catSegtoCategoriaListaVista", "listaResultado", listaResultado);
	}
	
	public CatSegtoCategoriasServicio getCatSegtoCategoriasServicio() {
		return catSegtoCategoriasServicio;
	}
	public void setCatSegtoCategoriasServicio(
			CatSegtoCategoriasServicio catSegtoCategoriasServicio) {
		this.catSegtoCategoriasServicio = catSegtoCategoriasServicio;
	}
}