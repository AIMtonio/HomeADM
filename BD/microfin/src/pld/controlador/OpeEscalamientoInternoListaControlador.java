package pld.controlador; 

 import java.util.ArrayList;
 import java.util.List;
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.OpeEscalamientoInternoBean;
import pld.servicio.OpeEscalamientoInternoServicio;

 public class OpeEscalamientoInternoListaControlador extends AbstractCommandController {

	 OpeEscalamientoInternoServicio opeEscalamientoInternoServicio = null;

 	public OpeEscalamientoInternoListaControlador(){
 		setCommandClass(OpeEscalamientoInternoBean.class);
 		setCommandName("opeEscalamientoInternoBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        OpeEscalamientoInternoBean operEscalamientoInternoBean = (OpeEscalamientoInternoBean) command;
                 List operEscalamientoInternoList = opeEscalamientoInternoServicio.lista(tipoLista, operEscalamientoInternoBean);
                 
                 List listaResultado = (List)new ArrayList();
                 listaResultado.add(tipoLista);
                 listaResultado.add(controlID);
                 listaResultado.add(operEscalamientoInternoList);
 		return new ModelAndView("pld/opeEscalamientoInternoListaVista", "listaResultado", listaResultado);
 	}

	public void setOpeEscalamientoInternoServicio(
			OpeEscalamientoInternoServicio opeEscalamientoInternoServicio) {
		this.opeEscalamientoInternoServicio = opeEscalamientoInternoServicio;
	}
 } 
