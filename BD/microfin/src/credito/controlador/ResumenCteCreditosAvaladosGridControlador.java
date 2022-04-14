package credito.controlador;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class ResumenCteCreditosAvaladosGridControlador extends AbstractCommandController{
	
	CreditosServicio creditosServicio = null;

	public ResumenCteCreditosAvaladosGridControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		CreditosBean bean = (CreditosBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listResultado = creditosServicio.lista(tipoLista,bean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listResultado);
		
		return new ModelAndView("credito/creditosAvaladosClienteGridVista", "listaResultado", listaResultado);
	
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}
	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
}