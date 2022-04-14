package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.CancelaFacturaBean;
import soporte.servicio.CancelaFacturaServicio;

	public class CancelaFacturaListaControlador  extends AbstractCommandController{	    
		CancelaFacturaServicio cancelaFacturaServicio= null; 
		public CancelaFacturaListaControlador(){
			setCommandClass(CancelaFacturaBean.class);
			setCommandName("cancelarFactura");
		}
		@Override
		protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
			
				int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			   String controlID = request.getParameter("controlID");
			   			  
			   CancelaFacturaBean cancelaFacturaBean = (CancelaFacturaBean)command;
			   List listaCancelaFactura = cancelaFacturaServicio.lista(tipoLista, cancelaFacturaBean);
			   
			   List listaResultado = (List)new ArrayList();
			   listaResultado.add(tipoLista);
			   listaResultado.add(controlID);
			   listaResultado.add(listaCancelaFactura);
			   
			   return new ModelAndView("soporte/listaFacturaCFDI", "listaResultado", listaResultado);
		}
		
		//------------------setter---------------
		public void setCancelaFacturaServicio(CancelaFacturaServicio cancelaFacturaServicio) {
			this.cancelaFacturaServicio = cancelaFacturaServicio;
		}

}
