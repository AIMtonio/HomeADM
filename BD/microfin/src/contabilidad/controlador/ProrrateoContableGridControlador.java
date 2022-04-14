package contabilidad.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.CentroCostosBean;
import contabilidad.servicio.CentroCostosServicio;

public class ProrrateoContableGridControlador extends AbstractCommandController{
		CentroCostosServicio centroCostosServicio=null;
	
		public ProrrateoContableGridControlador(){
			setCommandClass(CentroCostosBean.class);	
			setCommandName("prorrateoMetod");
		}		
		protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors)throws Exception{
			CentroCostosBean centroCostosBean= (CentroCostosBean) command;			
			int tipoConsulta = Integer.parseInt(request.getParameter("tipoConsulta"));			
			List prorrateoContable= centroCostosServicio.lista(tipoConsulta,centroCostosBean);
			
			return new ModelAndView("contabilidad/prorrateoContableGridVista","prorrateoContable",prorrateoContable);
		}

		public void setCentroCostosServicio(CentroCostosServicio centroCostosServicio) {
			this.centroCostosServicio = centroCostosServicio;
		}
}
