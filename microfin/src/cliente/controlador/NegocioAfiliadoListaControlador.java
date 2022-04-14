package cliente.controlador; 

 import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.NegocioAfiliadoBean;
import cliente.servicio.NegocioAfiliadoServicio;

 public class NegocioAfiliadoListaControlador extends AbstractCommandController {

 	NegocioAfiliadoServicio negocioAfiliadoServicio = null;

 	public NegocioAfiliadoListaControlador(){
 		setCommandClass(NegocioAfiliadoBean.class);
 		setCommandName("negocioAfiliadoBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        NegocioAfiliadoBean negocioAfiliadoBean = (NegocioAfiliadoBean) command;
		List listaNegocioAfiliado = negocioAfiliadoServicio.lista(tipoLista, negocioAfiliadoBean);
		 
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaNegocioAfiliado);
 		return new ModelAndView("cliente/negocioAfiliadoListaVista", "listaResultado", listaResultado);
 	}

	public NegocioAfiliadoServicio getNegocioAfiliadoServicio() {
		return negocioAfiliadoServicio;
	}

	public void setNegocioAfiliadoServicio(
			NegocioAfiliadoServicio negocioAfiliadoServicio) {
		this.negocioAfiliadoServicio = negocioAfiliadoServicio;
	}

	
 } 
