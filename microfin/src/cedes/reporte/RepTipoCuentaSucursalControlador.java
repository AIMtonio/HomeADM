package cedes.reporte;

import java.io.ByteArrayOutputStream;
import org.springframework.validation.BindException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cedes.bean.TipoCuentaSucursalBean;
import cedes.servicio.TipoCuentaSucursalServicio;

public class RepTipoCuentaSucursalControlador extends AbstractCommandController{
	
	TipoCuentaSucursalServicio tipoCuentaSucursalServicio =null;
	String nombreReporte = null;
	String successView = null;	
	
	public RepTipoCuentaSucursalControlador(){
		setCommandClass(TipoCuentaSucursalBean.class);
		setCommandName("tipoCuentaSucursalBean");
	}
	
	public static interface Enum_Con_TipReporte {
		  int  ReporPDF= 1 ;
	}
 
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command,BindException errors) throws Exception {	
		TipoCuentaSucursalBean bean =(TipoCuentaSucursalBean) command;
		// TODO Auto-generated method stub
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
		Integer.parseInt(request.getParameter("tipoReporte")):0;
		String htmlString= "";
			
		switch(tipoReporte){
			case Enum_Con_TipReporte.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = repTipoCuentaSucursal(tipoReporte, bean, nombreReporte,response);
			break;
			
		}
		return null;
	}
	
	private ByteArrayOutputStream repTipoCuentaSucursal(int tipoReporte, TipoCuentaSucursalBean tipoCuentaSucBean, String nombreReporte,
			HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = tipoCuentaSucursalServicio.reporteTipoCuentaSucursal(tipoReporte, tipoCuentaSucBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=TipoProductoSucursal.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return htmlStringPDF;
	}

	public TipoCuentaSucursalServicio getTipoCuentaSucursalServicio() {
		return tipoCuentaSucursalServicio;
	}

	public void setTipoCuentaSucursalServicio(
			TipoCuentaSucursalServicio tipoCuentaSucursalServicio) {
		this.tipoCuentaSucursalServicio = tipoCuentaSucursalServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
	
	
}
