package nomina.reporte;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import nomina.bean.ProcesaDomiciliacionPagosBean;
import nomina.servicio.ProcesaDomiciliacionPagosServicio;


public class ExpProcesaDomiciliacionPagosControlador extends AbstractCommandController{
	
	ProcesaDomiciliacionPagosServicio procesaDomiciliacionPagosServicio = null;
	
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_Domiciliacion{
		int layoutDomPagos		= 6;		// Lista de Domiciliación de Pagos para generar el Layout 
	}
		
	public ExpProcesaDomiciliacionPagosControlador(){
		setCommandClass(ProcesaDomiciliacionPagosBean.class);
		setCommandName("procesaDomiciliacionPagosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, 
			Object command, 
			BindException errors) throws Exception {

		MensajeTransaccionBean mensaje = null;
		
		procesaDomiciliacionPagosServicio.getProcesaDomiciliacionPagosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean = (ProcesaDomiciliacionPagosBean) command;
		
		long consecutivo =(request.getParameter("consecutivo")!=null) ?
				Integer.parseInt(request.getParameter("consecutivo")): 0;
				
		long transaccion =(request.getParameter("transaccion")!=null) ?
				Integer.parseInt(request.getParameter("transaccion")): 0;
				
		String folioID =request.getParameter("folioID");
		
		try{
		
			List listaResultado = new ArrayList();
			PagedListHolder listaDomicilia;
			listaResultado = (List) request.getSession().getAttribute("domiciliaPagosList");
			listaDomicilia = (PagedListHolder) listaResultado.get(0);
			
			List listaGenerar = listaDomicilia.getSource();
			
			List<ProcesaDomiciliacionPagosBean> listaDomiciliacionPagos = null;
			
			// Lista de Domiciliación de Pagos para generar el Layout 
			listaDomiciliacionPagos = procesaDomiciliacionPagosServicio.listaLayoutDomPagos(folioID,Enum_Lis_Domiciliacion.layoutDomPagos);
			
			// Genera el Layout de Domiciliación de Pagos
			procesaDomiciliacionPagosServicio.generaLayout(listaDomiciliacionPagos,consecutivo,listaGenerar,transaccion,response);
	
		
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return null;
	}

	// ====================== GETTER & SETTER ================ //
	

	public ProcesaDomiciliacionPagosServicio getProcesaDomiciliacionPagosServicio() {
		return procesaDomiciliacionPagosServicio;
	}

	public void setProcesaDomiciliacionPagosServicio(ProcesaDomiciliacionPagosServicio procesaDomiciliacionPagosServicio) {
		this.procesaDomiciliacionPagosServicio = procesaDomiciliacionPagosServicio;
	}
	
	

}
