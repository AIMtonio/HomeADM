package nomina.controlador;
import java.util.List;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.AfiliacionBajaCtasClabeBean;

import nomina.servicio.AfiliacionBajaCtasClabeServicio;

public class AfiliaClienteNominaListaControlador extends AbstractCommandController{
	//AfiliaClienteNominaServicio  afiliaClienteNominaServicio = null;
	AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio = null;
	public AfiliaClienteNominaListaControlador() {
		setCommandClass(AfiliacionBajaCtasClabeBean.class);
		setCommandName("afiliacionBajaCtasClabeBean");
	}
	
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		List clientes = null;
		AfiliacionBajaCtasClabeBean cliente = (AfiliacionBajaCtasClabeBean) command;
		clientes = afiliacionBajaCtasClabeServicio.lista(tipoLista, cliente);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(clientes);
		
		return new ModelAndView("nomina/afiliaClienteNominaListaVista", "listaResultado",listaResultado);

	}


	public AfiliacionBajaCtasClabeServicio getAfiliacionBajaCtasClabeServicio() {
		return afiliacionBajaCtasClabeServicio;
	}


	public void setAfiliacionBajaCtasClabeServicio(AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio) {
		this.afiliacionBajaCtasClabeServicio = afiliacionBajaCtasClabeServicio;
	}
	


}
