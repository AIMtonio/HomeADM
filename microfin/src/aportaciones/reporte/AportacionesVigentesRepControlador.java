package aportaciones.reporte;

import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;

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
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;

public class AportacionesVigentesRepControlador extends AbstractCommandController{
	
	public ParametrosSesionBean parametrosSesionBean = null;
	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	AportacionesServicio aportacionesServicio = null;
	String nombreReporte = null;
	String successView = null;		 
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF   = 2 ;
		  int  ReporExcel = 3 ;
	}
  
 	public AportacionesVigentesRepControlador(){
 		setCommandClass(AportacionesBean.class);
 		setCommandName("AportacionesVig");
 	}
 	
 	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
 		AportacionesBean aportacionesBean = (AportacionesBean) command;
 		
		int tipoReporte=(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):0;
	    
		switch(tipoReporte){
		  case Enum_Con_TipRepor.ReporPDF:
			  ByteArrayOutputStream htmlStringPDF = reporteAportacionesVigentesPDF(aportacionesBean, nombreReporte, response);
		  break;
		  
		  case Enum_Con_TipRepor.ReporExcel:
			  List listaAportacionesVIgentes= listaReporteAportacionesVigentes(tipoLista, aportacionesBean, response);
		  break;
		}

		return null;	
 	}
 	
 	// método para crear el reporte en PDF
 	public ByteArrayOutputStream reporteAportacionesVigentesPDF(AportacionesBean aportacionesBean, String nombreReporte, HttpServletResponse response){
 		ByteArrayOutputStream htmlStringPDF = null;
 		try{
 			htmlStringPDF = aportacionesServicio.reporteAportacionesVigPDF(aportacionesBean,nombreReporte);
 	 		response.addHeader("Content-Disposition", "inline; filename=AportacionesVigentes.pdf");
 			response.setContentType("application/pdf");
 			
 			byte[] bytes = htmlStringPDF.toByteArray();
 			response.getOutputStream().write(bytes,0,bytes.length);
 			response.getOutputStream().flush();
 			response.getOutputStream().close();
 			
 		}catch (Exception e){
 			e.printStackTrace();
 		}
 	 return htmlStringPDF;
 	}
 	
 	//método para crear el reporte en excel
	public List listaReporteAportacionesVigentes(int tipoLista, AportacionesBean aportacionesBean,HttpServletResponse response){
 		List listaAportacionesVigentes=null;
 		
 		listaAportacionesVigentes= aportacionesServicio.lista(tipoLista, aportacionesBean);
 		
 		try{
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);		
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  

			HSSFCellStyle estiloDatosCliente = libro.createCellStyle();
			estiloDatosCliente.setAlignment((short)HSSFCellStyle.ALIGN_LEFT); 
			
			HSSFCellStyle estiloCentrado = libro.createCellStyle();			
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			estiloCentrado.setFont(fuenteNegrita10);
			
			//estilo centrado para id y fechas
			HSSFCellStyle estiloCentrado2 = libro.createCellStyle();			
			estiloCentrado2.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));

	
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Reporte de Aportaciones Vigentes");
			HSSFRow fila= hoja.createRow(0);
			
			// inicio usuario,fecha y hora
			HSSFCell celdaUsu=fila.createCell((short)1);
			celdaUsu = fila.createCell((short)14);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)15);
			
			celdaUsu.setCellValue(((!parametrosSesionBean.getClaveUsuario().isEmpty())?parametrosSesionBean.getClaveUsuario(): "TODOS").toUpperCase());
			String fechaVar=parametrosSesionBean.getFechaAplicacion().toString(); // 

			
			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
					
			celdaFec = fila.createCell((short)14);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)15);
			celdaFec.setCellValue(fechaVar);

			HSSFCell celdaInst=fila.createCell((short)1);
			celdaInst=fila.createCell((short)1);
			celdaInst.setCellValue(parametrosSesionBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            7  //ultima celda (0-based)
			    ));
			celdaInst.setCellStyle(estiloCentrado);
			 
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)14);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)15);
			Date date = new Date();
			DateFormat hourFormat = new SimpleDateFormat("HH:mm:ss");
			celdaHora.setCellValue(hourFormat.format(date));
			
			// Titulo del Reporte
			HSSFCell celda=fila.createCell((short)1);					
			celda.setCellValue("Reporte de Aportaciones al"+" "+aportacionesBean.getFechaApertura());
							
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            7  //ultima celda   (0-based)
			    ));
			 
			 celda.setCellStyle(estiloCentrado);
			 
			 fila = hoja.createRow(3); // Fila Vacia
			 fila = hoja.createRow(4); // Fila Vacia
			 
			 fila = hoja.createRow(5); // FILA Sucursal, Tipo Aportación, Cliente, Promotor 
			 
			 celda = fila.createCell((short)1);
			 celda.setCellValue("Fecha:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)2);
			 celda.setCellValue((!aportacionesBean.getFechaApertura().equals("")? aportacionesBean.getFechaApertura():"##"));
			 
			 celda = fila.createCell((short)4);
			 celda.setCellValue("Sucursal:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)5);
			 celda.setCellValue((!aportacionesBean.getNombreSucursal().equals("")? aportacionesBean.getNombreSucursal():"##"));
			
			 celda = fila.createCell((short)7);
			 celda.setCellValue("Tipo Aportación:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)8);
			 celda.setCellValue((!aportacionesBean.getDescripcion().equals("")? aportacionesBean.getDescripcion():"##"));
			 
			 celda = fila.createCell((short)10);
			 celda.setCellValue("Cliente:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)11);
			 celda.setCellValue((!aportacionesBean.getNombreCompleto().equals("")? aportacionesBean.getNombreCompleto():"##"));
			 
			 celda = fila.createCell((short)13);
			 celda.setCellValue("Promotor:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)14);
			 celda.setCellValue((!aportacionesBean.getNombrePromotor().equals("")? aportacionesBean.getNombrePromotor():"##"));
			 
			 fila = hoja.createRow(7);
			 fila = hoja.createRow(8); // Fila de todos los atributos a Listar
			 
				celda = fila.createCell((short)1);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Promotor");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Fecha Creación Cte.");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Número de Cliente");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Nombre de Cliente");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
			 
				celda = fila.createCell((short)6);
				celda.setCellValue("Tipo Aportación");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("No. Aportación");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				 
				celda = fila.createCell((short)8);
				celda.setCellValue("Fecha Apertura");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Fecha Vencimiento");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Fecha Prevencimiento");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Estatus");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Plazo (Días)");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Plazo Real (Días)");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
							
				celda = fila.createCell((short)14);
				celda.setCellValue("Monto");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("Monto Liquidación Aportación Anterior");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("Intereses provenientes de Increm de Renov");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("Dinero Nuevo");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
			 
				celda = fila.createCell((short)18);
				celda.setCellValue("Formula Interés");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)19);
				celda.setCellValue("Tasa Fija");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)20);
				celda.setCellValue("Tasa Base");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)21);
				celda.setCellValue("Sobre Tasa");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)22);
				celda.setCellValue("Piso");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)23);
				celda.setCellValue("Techo");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);

				celda = fila.createCell((short)24);
				celda.setCellValue("Intereses Totales");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
							
				celda = fila.createCell((short)25);
				celda.setCellValue("ISR Total");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
			 
				celda = fila.createCell((short)26);
				celda.setCellValue("Total a Recibir");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)27);
				celda.setCellValue("Intereses pagados en el perido");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)28);
				celda.setCellValue("Intereses devengados no pagados en el periodo");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)29);
				celda.setCellValue("Intereses por denvengar en el periodo");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)30);
				celda.setCellValue("Interés Devengado en el mes");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)31);
				celda.setCellValue("Tipo de Interés");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)32);
				celda.setCellValue("Tasa Sugerida");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)33);
				celda.setCellValue("Diferencia de Tasa");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)34);
				celda.setCellValue("Tipo Documento");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)35);
				celda.setCellValue("Cantidad");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)36);
				celda.setCellValue("Monto renovado");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)37);
				celda.setCellValue("Monto Global");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)38);
				celda.setCellValue("Saldo Capital");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)39);
				celda.setCellValue("Día de Pago");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)40);
				celda.setCellValue("Reinversión Aut");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)41);
				celda.setCellValue("Institución 1");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)42);
				celda.setCellValue("Cta. Dispersar 1");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)43);
				celda.setCellValue("Institución 2");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
			
				celda = fila.createCell((short)44);
				celda.setCellValue("Cta. Dispersar 2");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)45);
				celda.setCellValue("Institución 3");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)46);
				celda.setCellValue("Cta. Dispersar 3");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)47);
				celda.setCellValue("Notas");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)48);
				celda.setCellValue("Especificaciones");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				
				int i=10;
				int iter=0;
				int tamanioLista=listaAportacionesVigentes.size();
				AportacionesBean reporteAportaciones = null;
				
				for(iter=0; iter<tamanioLista; iter++){
					reporteAportaciones=(AportacionesBean) listaAportacionesVigentes.get(iter);
					fila=hoja.createRow(i);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(reporteAportaciones.getSucursalID()+"-"+reporteAportaciones.getNombreSucursal());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)2);
					celda.setCellValue(reporteAportaciones.getNombrePromotor());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)3);
					celda.setCellValue(reporteAportaciones.getFechaAlta());
					celda.setCellStyle(estiloDatosCliente);  
					
					
					celda=fila.createCell((short)4);
					celda.setCellValue(Utileria.convierteLong(reporteAportaciones.getClienteID()));
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)5);
					celda.setCellValue(reporteAportaciones.getNombreCompleto());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)6);
					celda.setCellValue(reporteAportaciones.getTipoAportacionID()+"-"+reporteAportaciones.getDescripcionTipoInv());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)7);
					celda.setCellValue(Utileria.convierteLong(reporteAportaciones.getAportacionID()));
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)8);
					celda.setCellValue(reporteAportaciones.getFechaInicio());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(reporteAportaciones.getFechaVencimiento());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(reporteAportaciones.getFechaPrevencimiento());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)11);
					celda.setCellValue(reporteAportaciones.getEstatus());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)12);
					celda.setCellValue(reporteAportaciones.getPlazo());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)13);
					celda.setCellValue(reporteAportaciones.getPlazoReal());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)14);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getMonto()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)15);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getMontoLiqAporAnterior()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)16);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getInteresesProvIncremRenov()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)17);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getDineroNuevo()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)18);
					celda.setCellValue(reporteAportaciones.getFormulaInteres());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)19);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getTasaFija()));
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)20);
					celda.setCellValue(reporteAportaciones.getDesTasaBase());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)21);
					celda.setCellValue(reporteAportaciones.getSobreTasa());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)22);
					celda.setCellValue(reporteAportaciones.getPisoTasa());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)23);
					celda.setCellValue(reporteAportaciones.getTechoTasa());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)24);
					celda.setCellValue(reporteAportaciones.getInteres());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)25);
					celda.setCellValue(reporteAportaciones.getIsr());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)26);
					celda.setCellValue(reporteAportaciones.getTotalRecibir());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)27);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getIntPagadosPeriodo()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)28);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getIntDevNoPagadoPeriodo()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)29);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getIntDevPeriodo()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)30);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getIntDevMes()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)31);
					celda.setCellValue(reporteAportaciones.getTipoPagoInt());
					celda.setCellStyle(estiloDatosCliente);					
					
					celda=fila.createCell((short)32);
					celda.setCellValue(reporteAportaciones.getTasaBruta());
					celda.setCellStyle(estiloDatosCliente);  
										
					celda=fila.createCell((short)33);
					celda.setCellValue(reporteAportaciones.getDescripcion());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)34);
					celda.setCellValue(reporteAportaciones.getOpcionAport());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)35);
					celda.setCellValue(reporteAportaciones.getCantidadReno());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)36);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getMontoRenovado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)37);
					celda.setCellValue(reporteAportaciones.getMontoGlobal());
					celda.setCellStyle(estiloFormatoDecimal);  
					
					celda=fila.createCell((short)38);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getSaldoCapital()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)39);
					celda.setCellValue(reporteAportaciones.getDiasPagoInt());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)40);
					celda.setCellValue(reporteAportaciones.getReinversionAutom());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)41);
					celda.setCellValue(reporteAportaciones.getInstitucionUNO());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)42);
					celda.setCellValue(reporteAportaciones.getCuentaDestinoUNO());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)43);
					celda.setCellValue(reporteAportaciones.getInstitucionDOS());
					celda.setCellStyle(estiloDatosCliente);

					celda=fila.createCell((short)44);
					celda.setCellValue(reporteAportaciones.getCuentaDestinoDOS());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)45);
					celda.setCellValue(reporteAportaciones.getInstitucionTRES());
					celda.setCellStyle(estiloDatosCliente);

					celda=fila.createCell((short)46);
					celda.setCellValue(reporteAportaciones.getCuentaDestinoTRES());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)47);
					celda.setCellValue(reporteAportaciones.getNotasNuevaAport());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)48);
					celda.setCellValue(reporteAportaciones.getEspecificaciones());
					celda.setCellStyle(estiloDatosCliente);
					
					i++;
					
				}
				i = i+2;
				fila=hoja.createRow(i); // Fila Registros Exportados
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				i = i+1;
				fila=hoja.createRow(i); // Fila Total de Registros Exportados
				celda=fila.createCell((short)0);
				celda.setCellValue(tamanioLista);
				

				for(int celd=0; celd<=48; celd++)
				hoja.autoSizeColumn((short)celd);
									
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteAportaciones.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				loggerSAFI.debug("Termina Reporte");
 			
 		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte de Aportaciones Vigentes: " + e.getMessage());
			e.printStackTrace();
		}
 		
 		return listaAportacionesVigentes;
 	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
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
