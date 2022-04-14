package psl.controlador;

import java.util.Arrays;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import psl.bean.PSLConfigServicioBean;
import psl.servicio.PSLConfigServicioServicio;

public class PSLConfigServicioControlador extends SimpleFormController {
	PSLConfigServicioServicio pslConfigServicioServicio;

	public PSLConfigServicioControlador(){
		setCommandClass(PSLConfigServicioBean.class);
 		setCommandName("pslConfigServicioBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		PSLConfigServicioBean pslConfigServicioBean = (PSLConfigServicioBean) command;
		pslConfigServicioServicio.getPslConfigServicioDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
				
		if(tipoTransaccion == 1) {			
						
			pslConfigServicioBean.setServicioID(request.getParameter("servicioID"));
			pslConfigServicioBean.setClasificacionServ(request.getParameter("clasificacionServ"));
			pslConfigServicioBean.setCContaServicio(request.getParameter("cContaServicio"));
			pslConfigServicioBean.setCContaComision(request.getParameter("cContaComision"));
			pslConfigServicioBean.setCContaIVAComisi(request.getParameter("cContaIVAComisi"));
			pslConfigServicioBean.setNomenclaturaCC(request.getParameter("nomenclaturaCC"));
			pslConfigServicioBean.setVentanillaAct(request.getParameter("ventanillaAct")!=null?"S":"N");
			pslConfigServicioBean.setBancaLineaAct(request.getParameter("bancaLineaAct")!=null?"S":"N");
			pslConfigServicioBean.setBancaMovilAct(request.getParameter("bancaMovilAct")!=null?"S":"N");
			pslConfigServicioBean.setCobComVentanilla(request.getParameter("cobComVentanillaOculto"));
			pslConfigServicioBean.setCobComBancaLinea(request.getParameter("cobComBancaLineaOculto"));
			pslConfigServicioBean.setCobComBancaMovil(request.getParameter("cobComBancaMovilOculto"));
			pslConfigServicioBean.setMtoCteVentanilla(request.getParameter("mtoCteVentanilla"));
			pslConfigServicioBean.setMtoCteBancaLinea(request.getParameter("mtoCteBancaLinea"));
			pslConfigServicioBean.setMtoCteBancaMovil(request.getParameter("mtoCteBancaMovil"));
			pslConfigServicioBean.setMtoUsuVentanilla(request.getParameter("mtoUsuVentanilla"));			
			
			String[] productosID = request.getParameterValues("productosID");
			String[] productos = request.getParameterValues("productos");
			String[] habilitados = request.getParameterValues("habilitados");
			
			pslConfigServicioBean.setProductosID(Arrays.asList(productosID));
			pslConfigServicioBean.setProductos(Arrays.asList(productos));
			pslConfigServicioBean.setHabilitados(Arrays.asList(habilitados));
		}
		
		MensajeTransaccionBean mensaje = null;
		mensaje = pslConfigServicioServicio.grabaTransaccion(tipoTransaccion, pslConfigServicioBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public PSLConfigServicioServicio getPslConfigServicioServicio() {
		return pslConfigServicioServicio;
	}

	public void setPslConfigServicioServicio(
			PSLConfigServicioServicio pslConfigServicioServicio) {
		this.pslConfigServicioServicio = pslConfigServicioServicio;
	}
}
