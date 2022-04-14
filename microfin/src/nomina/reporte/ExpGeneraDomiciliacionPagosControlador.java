package nomina.reporte;


import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import general.bean.MensajeTransaccionBean;
import nomina.bean.GeneraDomiciliacionPagosBean;
import nomina.servicio.GeneraDomiciliacionPagosServicio;

public class ExpGeneraDomiciliacionPagosControlador extends AbstractCommandController {
	GeneraDomiciliacionPagosServicio generaDomiciliacionPagosServicio = null;
	

	public static interface Enum_Tipo_Transaccion{
		int bajaDomiciliacion   = 2;		// Baja de Domiciliación de Pagos
	}

	public static interface Enum_Lis_Domiciliacion{
		int layoutDomPagos		= 6;		// Lista de Domiciliación de Pagos para generar el Layout 
	}

	public ExpGeneraDomiciliacionPagosControlador(){
		setCommandClass(GeneraDomiciliacionPagosBean.class);
		setCommandName("generaDomiciliacionPagosBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, 
			Object command, 
			BindException errors) throws Exception {
			MensajeTransaccionBean mensaje = null;
			generaDomiciliacionPagosServicio.getGeneraDomiciliacionPagosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean = (GeneraDomiciliacionPagosBean) command;
			int folioAfiliacion =(request.getParameter("consecutivo")!=null) ?
					Integer.parseInt(request.getParameter("consecutivo")): 0;
			String folioID =request.getParameter("folioID");
			try{
					List listaGuarda = generaDomiciliacionPagosServicio.listaLayoutDomPagos(folioID,Enum_Lis_Domiciliacion.layoutDomPagos);
					
					mensaje = generaDomiciliacionPagosServicio.bajaDomiciliacionPagos(Enum_Tipo_Transaccion.bajaDomiciliacion,generaDomiciliacionPagosBean);
					if(mensaje.getNumero() != 0){
								throw new Exception(mensaje.getDescripcion());
					}
					generaDomiciliacionPagosServicio.generaLayout(listaGuarda,folioAfiliacion,response);
				}catch(Exception ex){
					ex.printStackTrace();
				}
		return null;
	}

	public GeneraDomiciliacionPagosServicio getGeneraDomiciliacionPagosServicio() {
		return generaDomiciliacionPagosServicio;
	}

	public void setGeneraDomiciliacionPagosServicio(GeneraDomiciliacionPagosServicio generaDomiciliacionPagosServicio) {
		this.generaDomiciliacionPagosServicio = generaDomiciliacionPagosServicio;
	}
}

