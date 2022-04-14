package ventanilla.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.ReimpresionChequeBean;
import ventanilla.servicio.ReimpresionChequeServicio;


public class ReimpresionChequesListaControlador extends AbstractCommandController {
	
	ReimpresionChequeServicio reimpresionChequeServicio = null;
	
	public ReimpresionChequesListaControlador() {
		setCommandClass(ReimpresionChequeBean.class);		
		setCommandName("reimpresionCheque");
		
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ReimpresionChequeBean reimpresionChequeBean = (ReimpresionChequeBean) command;		
		List chequesLis =	reimpresionChequeServicio.lista(tipoLista, reimpresionChequeBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(chequesLis);
		
		return new ModelAndView("ventanilla/reimpresionChequesListaVista", "listaResultado",listaResultado);
	}

	public ReimpresionChequeServicio getReimpresionChequeServicio() {
		return reimpresionChequeServicio;
	}

	public void setReimpresionChequeServicio(
			ReimpresionChequeServicio reimpresionChequeServicio) {
		this.reimpresionChequeServicio = reimpresionChequeServicio;
	}

	
	
}


