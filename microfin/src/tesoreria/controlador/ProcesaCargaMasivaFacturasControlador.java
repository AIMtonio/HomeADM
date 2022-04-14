package tesoreria.controlador;
import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.BitacoraPagoNominaBean;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import tesoreria.bean.CargaMasivaFacturasBean;
import tesoreria.servicio.CargaMasivaFacturasServicio;

public class ProcesaCargaMasivaFacturasControlador extends SimpleFormController{
	CargaMasivaFacturasServicio cargaMasivaFacturasServicio = null;

	public ProcesaCargaMasivaFacturasControlador(){
		setCommandClass(CargaMasivaFacturasBean.class);
		setCommandName("cargaMasivaFacturasBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,	HttpServletResponse response,Object command,BindException errors) throws Exception {
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
		Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		cargaMasivaFacturasServicio.getCargaMasivaFacturasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
		CargaMasivaFacturasBean cargaMasivaFacturasBean = (CargaMasivaFacturasBean) command;
		String nombreLista = request.getParameter("nombreLista");
		
		List listaResultado = (List) new ArrayList();
		PagedListHolder listaDocumentos;
		listaResultado = (List) request.getSession().getAttribute(nombreLista);
		listaDocumentos = (PagedListHolder) ((ArrayList) listaResultado).get(1);
		
		List listaFacturas = (List) listaDocumentos.getSource();
		

		MensajeTransaccionBean mensaje = null;
		mensaje = cargaMasivaFacturasServicio.grabaTransaccion(tipoTransaccion,cargaMasivaFacturasBean, listaFacturas);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	public CargaMasivaFacturasServicio getCargaMasivaFacturasServicio() {
		return cargaMasivaFacturasServicio;
	}

	public void setCargaMasivaFacturasServicio(
			CargaMasivaFacturasServicio cargaMasivaFacturasServicio) {
		this.cargaMasivaFacturasServicio = cargaMasivaFacturasServicio;
	}
	

}
