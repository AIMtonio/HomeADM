package ventanilla.reporte;
 
import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.OperLimExcedidosRepBean;
import pld.reporte.ReporteOperLimitesExcedControlador.Enum_Con_TipRepor;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.ReporteChequesSBCBean;
import ventanilla.bean.RepPagServBean;
import ventanilla.bean.UsuarioServiciosBean;
import ventanilla.servicio.CajasVentanillaServicio;
import ventanilla.servicio.RepPagoServiciosServicio;
import ventanilla.servicio.UsuarioServiciosServicio;

public class RepUsuarioServicioControlador extends AbstractCommandController{
	
	ParametrosSesionBean parametrosSesionBean=null;
	UsuarioServiciosServicio usuarioServiciosServicio = new  UsuarioServiciosServicio();
	CajasVentanillaServicio cajasVentanillaServicio = null;
	
	String nomReporte = null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	
	public static interface Enum_Con_TipRepor {
		  int  reportePDF= 1 ;
		  int  reporteExcel= 2 ;
	}
	public RepUsuarioServicioControlador(){
		setCommandClass(UsuarioServiciosBean.class);
		setCommandName("usuarioServiciosBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors)throws Exception {
		UsuarioServiciosBean usuarioServiciosBean = (UsuarioServiciosBean) command;

		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
				
		
		switch (tipoReporte) {
		case Enum_Con_TipRepor.reportePDF:
			ByteArrayOutputStream htmlStringPDF = UsuariosServiciosRepPDF(tipoReporte, usuarioServiciosBean, nomReporte, response);
			break;
		case Enum_Con_TipRepor.reporteExcel:
			
			List listaReportes = usuariosServiciosExcel(tipoReporte, usuarioServiciosBean, response);
			break;
		}
		
		return null;
	}
	
			
	/* Reporte de cuentas limite excento en PDF */
	public ByteArrayOutputStream UsuariosServiciosRepPDF(int tipoReporte,UsuarioServiciosBean usuarioServiciosBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = usuarioServiciosServicio.reporteUsuariosServicioPDF(tipoReporte,usuarioServiciosBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteUsuariosServicios.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	return htmlStringPDF;
	}// reporte PDF
	
	/* Reporte de cuentas limite excento en Excel */
	public List  usuariosServiciosExcel(int tipoReporte,UsuarioServiciosBean usuarioServiciosBean,  HttpServletResponse response){
	List listaUsuarioServicios=null;
	listaUsuarioServicios = usuarioServiciosServicio.listaReporte(tipoReporte,usuarioServiciosBean,response); 
		
		try {
		HSSFWorkbook libro = new HSSFWorkbook();
		//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
		HSSFFont fuenteNegrita10= libro.createFont();
		fuenteNegrita10.setFontHeightInPoints((short)10);
		fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
		fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		
		//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
		HSSFFont fuenteNegrita8= libro.createFont();
		fuenteNegrita8.setFontHeightInPoints((short)8);
		fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
		fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		
		// La fuente se mete en un estilo para poder ser usada.
		//Estilo negrita de 10 para el titulo del reporte
		HSSFCellStyle estiloNeg10 = libro.createCellStyle();
		estiloNeg10.setFont(fuenteNegrita10);
		
		//Estilo negrita de 8  para encabezados del reporte
		HSSFCellStyle estiloNeg8 = libro.createCellStyle();
		estiloNeg8.setFont(fuenteNegrita8);

		HSSFCellStyle estiloNegIzq8 = libro.createCellStyle();
		estiloNegIzq8.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
		estiloNegIzq8.setFont(fuenteNegrita10);
		estiloNegIzq8.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
		
		HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
		estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
		estiloDatosCentrado.setFont(fuenteNegrita10);
		estiloDatosCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
		

		HSSFCellStyle estiloDatosDerecha = libro.createCellStyle();
		estiloDatosDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);  
		
		HSSFCellStyle estiloCentrado = libro.createCellStyle();
		estiloCentrado.setFont(fuenteNegrita8);
		estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
		estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);

		//Estilo negrita de 8  y color de fondo
		HSSFCellStyle estiloColor = libro.createCellStyle();
		estiloColor.setFont(fuenteNegrita8);
		estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
		estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
	
		
		/* Crea la hoja y el nombre cuando se descar */				
		HSSFSheet hoja = libro.createSheet("Reporte de Usuarios de Servicio");
		
		HSSFRow fila= hoja.createRow(0);			
		HSSFCell celda1=fila.createCell((short)2);
		celda1.setCellValue(usuarioServiciosBean.getNombreInstitucion());
		celda1.setCellStyle(estiloDatosCentrado);

		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            0, //primera fila (0-based)
	            0, //ultima fila  (0-based)
	            2, //primer celda (0-based)
	            7  //ultima celda   (0-based)
	    ));
		
		//HSSFCell celdaFec=fila.createCell((short)1);
		celda1 = fila.createCell((short)8);
		celda1.setCellValue("Usuario:");
		celda1.setCellStyle(estiloNegIzq8);
		celda1 = fila.createCell((short)9);
		celda1.setCellValue(usuarioServiciosBean.getNombreUsuario().toUpperCase());				
		
		fila = hoja.createRow(1);		
		HSSFCell celda=fila.createCell((short)2);
		celda.setCellValue("REPORTE DE USUARIOS DE SERVICIOS");
		celda.setCellStyle(estiloDatosCentrado);
		
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            1, //primera fila (0-based)
	            1, //ultima fila  (0-based)
	            2, //primer celda (0-based)
	            7  //ultima celda   (0-based)
	    ));
		celda = fila.createCell((short)8);
		celda.setCellValue("Fecha:");
		celda.setCellStyle(estiloNegIzq8);
		celda = fila.createCell((short)9);
		celda.setCellValue(usuarioServiciosBean.getFechaSistema());
		
						
		fila = hoja.createRow(2);
		Calendar calendario=new GregorianCalendar();
		SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
		usuarioServiciosBean.setHoraEmision(postFormater.format(calendario.getTime()));
		
		HSSFCell celdaHora=fila.createCell((short)1);
		celdaHora = fila.createCell((short)8);
		celdaHora.setCellValue("Hora:");
		celdaHora.setCellStyle(estiloNegIzq8);
		celdaHora = fila.createCell((short)9);
		celdaHora.setCellValue(usuarioServiciosBean.getHoraEmision());
		
		fila = hoja.createRow(3);
		if(usuarioServiciosBean.getSexo().equals("")){
			usuarioServiciosBean.setDesSexo("TODOS");
		}
		if(usuarioServiciosBean.getSexo().equals("F")){
			usuarioServiciosBean.setDesSexo("FEMENINO");
			usuarioServiciosBean.setSexo("FEMENINO");
			
		}
		if(usuarioServiciosBean.getSexo().equals("M")){
			usuarioServiciosBean.setDesSexo("MASCULINO");
			usuarioServiciosBean.setSexo("MASCULINO");
		}
		
		HSSFCell celdaFiltros=fila.createCell((short)1);
		celdaFiltros=fila.createCell((short)3);
		celdaFiltros.setCellStyle(estiloNeg10);
		celdaFiltros.setCellValue("Usuario Servicio: "+usuarioServiciosBean.getDesUsuarioID());
		
		celdaFiltros=fila.createCell((short)5);
		celdaFiltros.setCellStyle(estiloNeg10);
		celdaFiltros.setCellValue("Sucursal: "+usuarioServiciosBean.getDescSucursal());

		celdaFiltros=fila.createCell((short)7);
		celdaFiltros.setCellStyle(estiloNeg10);
		celdaFiltros.setCellValue("Sexo: "+usuarioServiciosBean.getDesSexo());

	
		
		fila = hoja.createRow(5);
		

			celda = fila.createCell((short)1);
			celda.setCellValue("Usuario Servicio");
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Tipo de Persona");
			celda.setCellStyle(estiloDatosCentrado);
			
	
			celda = fila.createCell((short)3);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Fecha de Nacimiento");
			

			celda = fila.createCell((short)4);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Nacionalidad");
			
			
			celda = fila.createCell((short)5);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("País de Residencia");
			
			celda = fila.createCell((short)6);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Estado");
			
			
			celda = fila.createCell((short)7);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Dirección");
			
			celda = fila.createCell((short)8);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Sexo");
			
			celda = fila.createCell((short)9);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("CURP");
			
			
			celda = fila.createCell((short)10);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("RFC");
			
			celda = fila.createCell((short)11);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Ocupación/Tipo de Sociedad");
			


		int i=7,iter=0;
		int tamanioLista = listaUsuarioServicios!=null?listaUsuarioServicios.size():0;
		UsuarioServiciosBean usuarioServicios= null;
		
		
		for( iter=0; iter<tamanioLista; iter ++){
		 
			usuarioServicios = (UsuarioServiciosBean) listaUsuarioServicios.get(iter);
			fila=hoja.createRow(i);
			
				celda=fila.createCell((short)1);
				celda.setCellValue(usuarioServicios.getNombreCompleto());				
				
				
				celda=fila.createCell((short)2);
				celda.setCellValue(usuarioServicios.getTipoPersona());
				
	
				celda=fila.createCell((short)3);
				celda.setCellValue(usuarioServicios.getFechaNacimiento());	
				
			    
			    celda=fila.createCell((short)4);
				celda.setCellValue(usuarioServicios.getNacion());
				
			    			    
			    celda=fila.createCell((short)5);
				celda.setCellValue(usuarioServicios.getPaisResidencia());
				
			    
			    celda=fila.createCell((short)6);
				celda.setCellValue(usuarioServicios.getEstadoNac());	
				
			    
			    celda=fila.createCell((short)7);
				celda.setCellValue(usuarioServicios.getDireccion().toUpperCase());	
				

			
				celda=fila.createCell((short)8);
				celda.setCellValue(usuarioServicios.getSexo());
				

				
				celda=fila.createCell((short)9);
				celda.setCellValue(usuarioServicios.getCURP());	
				
				
				celda=fila.createCell((short)10);
				celda.setCellValue(usuarioServicios.getRFC());
				
				celda=fila.createCell((short)11);
				celda.setCellValue(usuarioServicios.getOcupacionID());	
			i++;
		}
		 
		i = i+2;
		
		fila=hoja.createRow(i);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
		
		i = i+1;
		fila=hoja.createRow(i);
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);		

		for(int celd=0; celd<=18; celd++)
		hoja.autoSizeColumn((short)celd);	
						
		//Crea la cabecera
		response.addHeader("Content-Disposition","inline; filename=UsuariosServicios.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();
		
		}catch(Exception e){
			e.printStackTrace();
		}		
		
	return  listaUsuarioServicios;		
	}// reporte Excel

	
	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public UsuarioServiciosServicio getUsuarioServiciosServicio() {
		return usuarioServiciosServicio;
	}

	public void setUsuarioServiciosServicio(
			UsuarioServiciosServicio usuarioServiciosServicio) {
		this.usuarioServiciosServicio = usuarioServiciosServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
}
