package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.AplicaPagoInstBean;
import nomina.bean.InstitucionNominaBean;
import nomina.servicio.AplicaPagoInstServicio;
import nomina.servicio.InstitucionNominaServicio;

public class AplicacionPagosInsListaControlador extends AbstractCommandController{
		
	AplicaPagoInstServicio aplicaPagoInstServicio = null;
		
		public AplicacionPagosInsListaControlador() {
			setCommandClass(AplicaPagoInstBean.class);
			setCommandName("aplicaPagoInstBean");
		}
				
		protected ModelAndView handle(HttpServletRequest request,
										  HttpServletResponse response,
										  Object command,
										  BindException errors) throws Exception {
				
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			String controlID = request.getParameter("controlID");
	
			AplicaPagoInstBean aplicaPagosBean = (AplicaPagoInstBean) command;
			List listaAplicapagos =	aplicaPagoInstServicio.lista( tipoLista, aplicaPagosBean);
			
			List listaResultado = (List)new ArrayList();
			listaResultado.add(tipoLista);
			listaResultado.add(controlID);
			listaResultado.add(listaAplicapagos);
			if(tipoLista == 6){
				return new ModelAndView("tesoreria/tiposMovTesoListaVista", "listaResultado", listaResultado);
			}
			if(tipoLista == 3){
				return new ModelAndView("nomina/aplicacionPagosInsListaVista", "listaResultado", listaResultado);
			}else{
				return new ModelAndView("nomina/movsConciliaListaVista", "listaResultado", listaResultado);
			}
			
		}

		public AplicaPagoInstServicio getAplicaPagoInstServicio() {
			return aplicaPagoInstServicio;
		}

		public void setAplicaPagoInstServicio(AplicaPagoInstServicio aplicaPagoInstServicio) {
			this.aplicaPagoInstServicio = aplicaPagoInstServicio;
		}

		
	}