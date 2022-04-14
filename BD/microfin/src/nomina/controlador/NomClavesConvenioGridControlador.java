package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nomina.bean.NomClavesConvenioBean;
import nomina.servicio.NomClavesConvenioServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class NomClavesConvenioGridControlador extends AbstractCommandController{
	NomClavesConvenioServicio nomClavesConvenioServicio = null;
	
	public NomClavesConvenioGridControlador() {
		setCommandClass(NomClavesConvenioBean.class);
		setCommandName("nomClavesConvenioBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
	
		NomClavesConvenioBean clavePresupConvenio = (NomClavesConvenioBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List clavePresupConvenioLis = nomClavesConvenioServicio.lista(tipoLista, clavePresupConvenio);
		 
		List listaResultado = (List)new ArrayList();
		
		listaResultado.add(tipoLista); // 0
		listaResultado.add(clavePresupConvenioLis); // 1
		
		return new ModelAndView("nomina/nomClavesConvenioGridVista", "listaResultado", listaResultado);
	}

	public NomClavesConvenioServicio getNomClavesConvenioServicio() {
		return nomClavesConvenioServicio;
	}

	public void setNomClavesConvenioServicio(
			NomClavesConvenioServicio nomClavesConvenioServicio) {
		this.nomClavesConvenioServicio = nomClavesConvenioServicio;
	}

}
