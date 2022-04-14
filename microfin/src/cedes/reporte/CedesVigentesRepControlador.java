package cedes.reporte;

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

import cedes.bean.CedesBean;
import cedes.reporte.RepVencimientoCedeControlador.Enum_Con_TipRepor;
import cedes.servicio.CedesServicio;

public class CedesVigentesRepControlador  extends AbstractCommandController {
	public ParametrosSesionBean parametrosSesionBean = null;
	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	CedesServicio cedesServicio = null;
	String nombreReporte = null;
	String successView = null;		 
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF   = 2 ;
		  int  ReporExcel = 3 ;
	}
  
 	public CedesVigentesRepControlador(){
 		setCommandClass(CedesBean.class);
 		setCommandName("CedesVig");
 	}

 	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
 		CedesBean cedesBean = (CedesBean) command;
 		
		int tipoReporte=(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):0;
	    
		switch(tipoReporte){
		  case Enum_Con_TipRepor.ReporPDF:
			  ByteArrayOutputStream htmlStringPDF = reporteCedesVigentesPDF(cedesBean, nombreReporte, response);
		  break;
		  
		  case Enum_Con_TipRepor.ReporExcel:
			  List listaCedesVIgentes= listaReporteCedesVigentes(tipoLista, cedesBean, response);
		  break;
		}

		return null;	
 	}
 	
 	public ByteArrayOutputStream reporteCedesVigentesPDF(CedesBean cedesBean, String nombreReporte, HttpServletResponse response){
 		ByteArrayOutputStream htmlStringPDF = null;
 		try{
 			htmlStringPDF = cedesServicio.reporteCedesVigPDF(cedesBean,nombreReporte);
 	 		response.addHeader("Content-Disposition", "inline; filename=CedesVigentes.pdf");
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
	
 	public List listaReporteCedesVigentes(int tipoLista, CedesBean cedesBean,HttpServletResponse response){
 		List listaCedesVigentes=null;
 		
 		listaCedesVigentes= cedesServicio.lista(tipoLista, cedesBean);
 		
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
			HSSFSheet hoja = libro.createSheet("Reporte de Cedes Vigentes");
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
			celda.setCellValue("Reporte de Cedes Vigentes al"+" "+cedesBean.getFechaApertura());
							
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            7  //ultima celda   (0-based)
			    ));
			 
			 celda.setCellStyle(estiloCentrado);
			 
			 fila = hoja.createRow(3); // Fila Vacia
			 fila = hoja.createRow(4); // Fila Vacia
			 
			 fila = hoja.createRow(5); // FILA Sucursal, Tipo CEDE, Cliente, Promotor 
			 
			 celda = fila.createCell((short)1);
			 celda.setCellValue("Fecha:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)2);
			 celda.setCellValue((!cedesBean.getFechaApertura().equals("")? cedesBean.getFechaApertura():"##"));
			 
			 celda = fila.createCell((short)4);
			 celda.setCellValue("Sucursal:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)5);
			 celda.setCellValue((!cedesBean.getNombreSucursal().equals("")? cedesBean.getNombreSucursal():"##"));
			
			 celda = fila.createCell((short)7);
			 celda.setCellValue("Tipo CEDE:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)8);
			 celda.setCellValue((!cedesBean.getDescripcion().equals("")? cedesBean.getDescripcion():"##"));
			 
			 celda = fila.createCell((short)10);
			 celda.setCellValue("Cliente:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)11);
			 celda.setCellValue((!cedesBean.getNombreCompleto().equals("")? cedesBean.getNombreCompleto():"##"));
			 
			 celda = fila.createCell((short)13);
			 celda.setCellValue("Promotor:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)14);
			 celda.setCellValue((!cedesBean.getNombrePromotor().equals("")? cedesBean.getNombrePromotor():"##"));
			 
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
				celda.setCellValue("Número de Cliente");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Nombre de Cliente");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
			 
				celda = fila.createCell((short)5);
				celda.setCellValue("Tipo Cede");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("No. CEDE");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				 
				celda = fila.createCell((short)7);
				celda.setCellValue("Fecha Apertura");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Fecha Vencimiento");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Monto");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
			 
				celda = fila.createCell((short)10);
				celda.setCellValue("Formula Interés");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Tasa Fija");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Tasa Base");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Sobre Tasa");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("Piso");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("Techo");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				int i=10;
				int iter=0;
				int tamanioLista=listaCedesVigentes.size();
				CedesBean reporteCedes = null;
				
				for(iter=0; iter<tamanioLista; iter++){
					reporteCedes=(CedesBean) listaCedesVigentes.get(iter);
					fila=hoja.createRow(i);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(reporteCedes.getSucursalID()+"-"+reporteCedes.getNombreSucursal());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)2);
					celda.setCellValue(reporteCedes.getNombrePromotor());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)3);
					celda.setCellValue(Utileria.convierteLong(reporteCedes.getClienteID()));
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)4);
					celda.setCellValue(reporteCedes.getNombreCompleto());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)5);
					celda.setCellValue(reporteCedes.getTipoCedeID()+"-"+reporteCedes.getDescripcion());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)6);
					celda.setCellValue(Utileria.convierteLong(reporteCedes.getCedeID()));
					celda.setCellStyle(estiloDatosCliente);  
					
					
					celda=fila.createCell((short)7);
					celda.setCellValue(reporteCedes.getFechaApertura());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)8);
					celda.setCellValue(reporteCedes.getFechaVencimiento());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(Utileria.convierteDoble(reporteCedes.getMonto()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(reporteCedes.getFormulaInteres());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)11);
					celda.setCellValue(Utileria.convierteDoble(reporteCedes.getTasaFija()));
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)12);
					celda.setCellValue(reporteCedes.getDesTasaBase());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)13);
					celda.setCellValue(reporteCedes.getSobreTasa());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)14);
					celda.setCellValue(reporteCedes.getPisoTasa());
					celda.setCellStyle(estiloDatosCliente);  
					
					celda=fila.createCell((short)15);
					celda.setCellValue(reporteCedes.getTechoTasa());
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
				

				for(int celd=0; celd<=16; celd++)
				hoja.autoSizeColumn((short)celd);
									
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteCedesVigentes.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				loggerSAFI.debug("Termina Reporte");
 			
 		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte de Cedes Vigentes: " + e.getMessage());
			e.printStackTrace();
		}
 		
 		return listaCedesVigentes;
 	}
	
	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}

	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	private String getSuccessView() {
		return successView;
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
	public void setParametrosAuditoriaBean(ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}	

}
