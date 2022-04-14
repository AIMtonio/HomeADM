package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import nomina.bean.ProcesaDomiciliacionPagosBean;
import nomina.servicio.ProcesaDomiciliacionPagosServicio;

public class ProcesaDomiciliacionPagosControlador extends SimpleFormController{
	
	ProcesaDomiciliacionPagosServicio procesaDomiciliacionPagosServicio = null;
	
	public ProcesaDomiciliacionPagosControlador() {
		setCommandClass(ProcesaDomiciliacionPagosBean.class);
		setCommandName("procesaDomiciliacionPagosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
				
		ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean = (ProcesaDomiciliacionPagosBean) command;
		
		MensajeTransaccionBean mensaje = null;
		
		procesaDomiciliacionPagosServicio.getProcesaDomiciliacionPagosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		List listaResultado = new ArrayList();
		
		PagedListHolder domiciliaPagosList;
		
		listaResultado = (List) request.getSession().getAttribute("domiciliaPagosList");
		
		String nombreArchivo = (String) request.getSession().getAttribute("archivoDomiciliacion");
		
		procesaDomiciliacionPagosBean.setNombreArchivo(nombreArchivo);
		
		domiciliaPagosList = (PagedListHolder) listaResultado.get(0);

		List listaProcesar = domiciliaPagosList.getSource();
		
		mensaje = procesaDomiciliacionPagosServicio.grabaTransaccion(tipoTransaccion,procesaDomiciliacionPagosBean,listaProcesar);
		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	// ============== GETTER & SETTER ============= //

	public ProcesaDomiciliacionPagosServicio getProcesaDomiciliacionPagosServicio() {
		return procesaDomiciliacionPagosServicio;
	}

	public void setProcesaDomiciliacionPagosServicio(ProcesaDomiciliacionPagosServicio procesaDomiciliacionPagosServicio) {
		this.procesaDomiciliacionPagosServicio = procesaDomiciliacionPagosServicio;
	}
}