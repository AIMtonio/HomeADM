package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.CuentasTransferBean;
import cliente.servicio.CuentasTransferServicio;

public class CuentasDestinoListaControlador extends  AbstractCommandController{
	
	CuentasTransferServicio cuentasTransferServicio = null;
	
	public CuentasDestinoListaControlador() {
		setCommandClass(CuentasTransferBean.class);
		setCommandName("cuentas");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CuentasTransferBean cuentasTransferBean= (CuentasTransferBean) command;
		List listaCuentas =	cuentasTransferServicio.lista(tipoLista, cuentasTransferBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaCuentas);
		
		return new ModelAndView("cliente/cuentasDestinoListaVista", "listaResultado",listaResultado);
	}

	
	
	//-----------------------setter--------------------------------------
	public void setCuentasTransferServicio(
			CuentasTransferServicio cuentasTransferServicio) {
		this.cuentasTransferServicio = cuentasTransferServicio;
	}

	
	
	
}
