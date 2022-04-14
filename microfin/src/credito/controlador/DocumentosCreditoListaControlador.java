package credito.controlador;

import guardaValores.bean.CatalogoAlmacenesBean;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditoDocEntBean;
import credito.servicio.CreditoDocEntServicio;

public class DocumentosCreditoListaControlador extends AbstractCommandController {
	 
	CreditoDocEntServicio  creditoDocEntServicio= null;
	
	public DocumentosCreditoListaControlador() {
		setCommandClass(CreditoDocEntBean.class);
		setCommandName("creditoDocEntBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CreditoDocEntBean creditoDocEntBean = (CreditoDocEntBean) command;
		List listaGrupoDocumentos = creditoDocEntServicio.lista(tipoLista, creditoDocEntBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaGrupoDocumentos);
		
		return new ModelAndView("credito/documentosCreditoListaVista", "listaResultado", listaResultado);
	}

	public CreditoDocEntServicio getCreditoDocEntServicio() {
		return creditoDocEntServicio;
	}

	public void setCreditoDocEntServicio(CreditoDocEntServicio creditoDocEntServicio) {
		this.creditoDocEntServicio = creditoDocEntServicio;
	}

}
