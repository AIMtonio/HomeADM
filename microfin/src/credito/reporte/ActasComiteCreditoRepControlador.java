package credito.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.AbstractFormController;

import reporte.Reporte;
import credito.bean.ActasComiteCreditoBean;
import credito.bean.CreCastigosRepBean;
import credito.reporte.CreCastigosRepControlador.Enum_Con_TipRepor;
import credito.servicio.ActasComiteCreditoServicio;
import credito.servicio.ActasComiteCreditoServicio.Enum_Tipo_ActaComite;

public class ActasComiteCreditoRepControlador extends AbstractCommandController{
	ActasComiteCreditoServicio actasComiteCreditoServicio = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor{
		int ReporPDF=1;
	}
	
	public ActasComiteCreditoRepControlador () {
		setCommandClass(ActasComiteCreditoBean.class);
		setCommandName("actasComite");
	}
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command, BindException errors)throws Exception{				
		ActasComiteCreditoBean comiteCreditoBean = (ActasComiteCreditoBean) command;
		int tipoActa = Utileria.convierteEntero(comiteCreditoBean.getTipoActa());
		ByteArrayOutputStream htmlStringPDF = null;
		
		try {
			htmlStringPDF = actasComiteCreditoServicio.reporteActaComite(comiteCreditoBean, tipoActa);
			switch (tipoActa) {
				case ActasComiteCreditoServicio.Enum_Tipo_ActaComite.sucursales:
					response.addHeader("Content-Disposition","inline; filename=ActaSucursales" + comiteCreditoBean.getFechaReporte() + ".pdf");
					break;
				case Enum_Tipo_ActaComite.mayores:
					response.addHeader("Content-Disposition","inline; filename=ActaCredMayores" + comiteCreditoBean.getFechaReporte() + ".pdf");
					break;
				case Enum_Tipo_ActaComite.relacionados:
					response.addHeader("Content-Disposition","inline; filename=ActaCreditosRelacionados"+ comiteCreditoBean.getFechaReporte() + ".pdf");
					break;
				case Enum_Tipo_ActaComite.reestructuras:
					response.addHeader("Content-Disposition","inline; filename=ActaReestructuras" + comiteCreditoBean.getFechaReporte() + ".pdf");
					break;
			}
						
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	// ------------- GETTERS y SETTERS --------------------------

	public ActasComiteCreditoServicio getActasComiteCreditoServicio() {
		return actasComiteCreditoServicio;
	}
	public void setActasComiteCreditoServicio(
			ActasComiteCreditoServicio actasComiteCreditoServicio) {
		this.actasComiteCreditoServicio = actasComiteCreditoServicio;
	}

	
	
}
