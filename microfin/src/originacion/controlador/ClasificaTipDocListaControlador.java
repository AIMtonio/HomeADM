package originacion.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.servicio.ClasificaTipDocServicio;
import originacion.bean.ClasificaTipDocBean;


public class ClasificaTipDocListaControlador extends AbstractCommandController {
	ClasificaTipDocServicio clasificaTipDocServicio=null;

	public ClasificaTipDocListaControlador(){
		setCommandClass(ClasificaTipDocBean.class);
		setCommandName("clasificacionDocumentos");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {


		ClasificaTipDocBean clasificaTipDocBean = (ClasificaTipDocBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		String controlID = request.getParameter("controlID");
     
		
            List clasificaDoc = clasificaTipDocServicio.lista(tipoLista,clasificaTipDocBean);
          	List listaResultado = (List)new ArrayList();
    		listaResultado.add(tipoLista);
    		listaResultado.add(controlID);
    		listaResultado.add(clasificaDoc);

		return new ModelAndView("originacion/clasificaDocumentosListaVista", "listaResultado", listaResultado);
	}

	

	
	//----------setter--------------------
	public void setClasificaTipDocServicio(
			ClasificaTipDocServicio clasificaTipDocServicio) {
		this.clasificaTipDocServicio = clasificaTipDocServicio;
	}
	
	
	

}
