package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.FacturaprovBean;
import tesoreria.servicio.FacturaprovServicio;


public class FacturaprovControlador extends SimpleFormController {

	FacturaprovServicio facturaprovServicio = null;

	public FacturaprovControlador(){
		setCommandClass(FacturaprovBean.class);
		setCommandName("facturaprovBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		FacturaprovBean facturaprovBean = (FacturaprovBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		int tipoActualizacion =(request.getParameter("tipoActualizacion")!=null)?
					Integer.parseInt(request.getParameter("tipoActualizacion")):
						0;
		String detalleFactura = request.getParameter("detalleFactura");
		String detalleFacturaImp = request.getParameter("detalleFacturaImp");
		// OBTENER EL DETALLE DEL GRID DE IMPUESTOS 
		
		
		
		facturaprovServicio.getFacturaprovDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());				
		MensajeTransaccionBean mensaje = null;
		
		if(facturaprovBean.getSaldoFactura()!=null){
			facturaprovBean.setSaldoFactura(facturaprovBean.getSaldoFactura().replaceAll("[,]","").replaceAll("[$]",""));
		}
		if(facturaprovBean.getSubTotal()!=null){
			facturaprovBean.setSubTotal(facturaprovBean.getSubTotal().replaceAll("[,]","").replaceAll("[$]",""));	
		}
		if(facturaprovBean.getTotalFactura()!=null){
			facturaprovBean.setTotalFactura(facturaprovBean.getTotalFactura().replaceAll("[,]","").replaceAll("[$]",""));	
		}

		if(facturaprovBean.getTotalGravable()!=null){
			facturaprovBean.setTotalGravable(facturaprovBean.getTotalGravable().replaceAll("[,]","").replaceAll("[$]",""));	
		}
		if(facturaprovBean.getMonto()!=null){
			facturaprovBean.setMonto(facturaprovBean.getMonto().replaceAll("[,]","").replaceAll("[$]",""));	
		}
		mensaje = facturaprovServicio.grabaTransaccion(tipoTransaccion,facturaprovBean,detalleFactura,detalleFacturaImp,tipoActualizacion);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	public void setFacturaprovServicio(FacturaprovServicio facturaprovServicio) {
		this.facturaprovServicio = facturaprovServicio;
	}
	
} 
