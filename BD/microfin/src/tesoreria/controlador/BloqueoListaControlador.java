package tesoreria.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;

import tesoreria.bean.BloqueoBean;
import tesoreria.bean.DispersionBean;
import tesoreria.servicio.BloqueoServicio;



	public class BloqueoListaControlador extends AbstractCommandController {
 	
		BloqueoServicio bloqueoServicio = null;
		
		public BloqueoListaControlador(){
	 		setCommandClass(BloqueoBean.class);
	 		setCommandName("bloqueoBean");
	 	}

		protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {
			BloqueoBean bloqueoBean = new BloqueoBean();
			BloqueoBean bloqueoBean2 = new BloqueoBean();
			String  cuentaAhoID = (request.getParameter("cuentaAhoID")!=null) ? request.getParameter("cuentaAhoID") : "";
			int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
			int mes = (request.getParameter("mes")!=null) ? Integer.parseInt(request.getParameter("mes")) : 0;
			int anio = (request.getParameter("anio")!=null) ? Integer.parseInt(request.getParameter("anio")) : 0;
		    		   
			bloqueoBean.setCuentaAhoID(cuentaAhoID);
			bloqueoBean.setMes(String.valueOf(mes));
			bloqueoBean.setAnio(String.valueOf(anio));
			
			bloqueoBean2=bloqueoServicio.consulta(BloqueoServicio.Enum_Con_Bloqueo.principal, bloqueoBean);
			List listaResul = bloqueoServicio.lista(tipoLista, bloqueoBean);
				
			List listaResultado = (List)new ArrayList();
			listaResultado.add(listaResul);
			listaResultado.add(bloqueoBean2.getAuxMonto());
			
			String paginaRegreso = null;
			
			if(tipoLista == 1){
				paginaRegreso = "tesoreria/bloqueoListaVista";
			}else 
			
			System.out.println("Pagina: " + paginaRegreso + " Tipo Lista: " +tipoLista);
			
	return new ModelAndView("tesoreria/bloqueoListaVista", "listaResultado", listaResultado);
}

public void setBloqueoServicio(BloqueoServicio bloqueoServicio){
                this.bloqueoServicio = bloqueoServicio;
}
} 
