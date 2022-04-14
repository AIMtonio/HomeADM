package cobranza.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cobranza.bean.LiberaCarteraBean;
import cobranza.servicio.LiberaCarteraServicio;

public class LiberaCreditosGridControlador extends AbstractCommandController {
	LiberaCarteraServicio liberaCarteraServicio = null;
	
	public LiberaCreditosGridControlador(){
		setCommandClass(LiberaCarteraBean.class);
		setCommandName("liberaCartera");		
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		LiberaCarteraBean liberaCartera = (LiberaCarteraBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));

		List listaResultado = new ArrayList();
		List listaCreditos = liberaCarteraServicio.listaGrid(tipoLista,liberaCartera);
		
		listaResultado.add(tipoLista);
		listaResultado.add(listaCreditos);
		
		return new ModelAndView("cobranza/liberaCreditosGridVista", "listaResultado", listaResultado);
	}

	public LiberaCarteraServicio getLiberaCarteraServicio() {
		return liberaCarteraServicio;
	}

	public void setLiberaCarteraServicio(LiberaCarteraServicio liberaCarteraServicio) {
		this.liberaCarteraServicio = liberaCarteraServicio;
	}
	
	

}
