package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;

public class ClabeListaControlador extends AbstractCommandController{
	
	CuentasAhoServicio cuentasAhoServicio = null;

 	public ClabeListaControlador(){
 		setCommandClass(CuentasAhoBean.class);
 		setCommandName("cuentasAhoBean");
 	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		// TODO Auto-generated method stub
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        CuentasAhoBean cuentasAhoBean = (CuentasAhoBean) command;
                 List cuentasAho = cuentasAhoServicio.lista(tipoLista, cuentasAhoBean);
                 
                 List listaResultado = (List)new ArrayList();
                 listaResultado.add(controlID);
                 listaResultado.add(cuentasAho);
 		return new ModelAndView("cuentas/clabesListaVista", "listaResultado", listaResultado);
		
	}
	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}
	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}
	

}
