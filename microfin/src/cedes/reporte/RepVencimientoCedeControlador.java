package cedes.reporte;

import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import cedes.bean.CedesBean;
import cedes.servicio.CedesServicio;
 
public class RepVencimientoCedeControlador extends AbstractCommandController{
	public ParametrosSesionBean parametrosSesionBean = null;
	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	CedesServicio cedesServicio = null;
	String nombreReporte = null;
	String successView   = null;
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF   = 2 ;
		  int  ReporExcel = 3 ;
	}
	 
	public RepVencimientoCedeControlador(){
		setCommandClass(CedesBean.class);
		setCommandName("vencimientoCedes");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		CedesBean cedesBean=(CedesBean) command;
		
		int tipoReporte=(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):0;	
		
		switch(tipoReporte){
		  case Enum_Con_TipRepor.ReporPDF:
			  ByteArrayOutputStream htmlStringPDF = reporteVencimientoDiaPDF(cedesBean, nombreReporte, response);
		  break;
			
		  case Enum_Con_TipRepor.ReporExcel:
			  List listaCedesVencidas= listaReporteCedesVencidas(tipoLista,cedesBean, response);
			
		  break;
		}
		
		return null;
	}
	
	public ByteArrayOutputStream reporteVencimientoDiaPDF(CedesBean cedesBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = cedesServicio.repVencimientoPDF(cedesBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=RepVencimientoCedes.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	return htmlStringPDF;
	}
	
	public List listaReporteCedesVencidas(int tipoLista,CedesBean cedesBean, HttpServletResponse response){
		List listaCedesVencidas=null;
	
	    listaCedesVencidas= cedesServicio.lista(tipoLista, cedesBean);
	 
	    try{
	    	SXSSFWorkbook libro = new SXSSFWorkbook(100);
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);		
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			Font fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo EncabezadoBorde
			CellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setAlignment((short)CellStyle.ALIGN_LEFT);
			estiloEncabezado.setFont(fuenteNegrita8);
			estiloEncabezado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloEncabezado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			
			//Estilo negrita de 8  para encabezados del reporte
			CellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			CellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);  
			
			CellStyle estiloDatosCliente= libro.createCellStyle();
			estiloDatosCliente.setAlignment((short)CellStyle.ALIGN_LEFT);
			
			CellStyle estiloCentrado = libro.createCellStyle();			
			estiloCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			estiloCentrado.setFont(fuenteNegrita10);
			
			//estilo centrado para id y fechas
			CellStyle estiloCentrado2 = libro.createCellStyle();			
			estiloCentrado2.setAlignment((short)CellStyle.ALIGN_CENTER);
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			estiloFormatoDecimal.setAlignment((short)CellStyle.ALIGN_RIGHT);  
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			

	
			// Creacion de hoja					
			Sheet hoja = libro.createSheet("Reporte Vencimiento de CEDES");
			Row fila= hoja.createRow(0);
			
			// inicio usuario,fecha y hora
			Cell celdaUsu=fila.createCell((short)1);
			celdaUsu = fila.createCell((short)16);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)17);
			
			celdaUsu.setCellValue(((!parametrosSesionBean.getClaveUsuario().isEmpty())?parametrosSesionBean.getClaveUsuario(): "TODOS").toUpperCase());
			String fechaVar=parametrosSesionBean.getFechaAplicacion().toString(); // 

			
			fila = hoja.createRow(1);
			Cell celdaFec=fila.createCell((short)1);
					
			celdaFec = fila.createCell((short)16);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)17);
			celdaFec.setCellValue(fechaVar);

			Cell celdaInst=fila.createCell((short)1);
			celdaInst=fila.createCell((short)1);
			celdaInst.setCellValue(parametrosSesionBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            10  //ultima celda (0-based)
			    ));
			celdaInst.setCellStyle(estiloCentrado);
			 
			fila = hoja.createRow(2);
			Cell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)16);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)17);
			Date date = new Date();
			DateFormat hourFormat = new SimpleDateFormat("HH:mm");
			celdaHora.setCellValue(hourFormat.format(date));
			
			// Titulo del Reporte
			Cell celda=fila.createCell((short)1);					
			celda.setCellValue("Reporte de Vencimientos del"+" "+cedesBean.getFechaInicio()+" "+"al"+" "+cedesBean.getFechaVencimiento());
							
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
			 
			 celda.setCellStyle(estiloCentrado);
			 
			 fila = hoja.createRow(3); // Fila Vacia
			 fila = hoja.createRow(4); // Fila Vacia
			 
			 fila = hoja.createRow(5);  // Fila de CEDE, Sucursal, Promotor
			 celda = fila.createCell((short)1);
			 celda.setCellValue("Tipo CEDE:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)2);
			 celda.setCellValue((!cedesBean.getDescripcion().equals("")? cedesBean.getDescripcion():"##"));
				
			 celda = fila.createCell((short)7);
			 celda.setCellValue("Sucursal:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)8);
			 celda.setCellValue((!cedesBean.getNombreSucursal().equals("")? cedesBean.getNombreSucursal():"##"));
				

			 celda = fila.createCell((short)14);
			 celda.setCellValue("Promotor:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)15);
			 celda.setCellValue((!cedesBean.getNombrePromotor().equals("")? cedesBean.getNombrePromotor():"##"));
			 
	    	 fila = hoja.createRow(6); //Fila de Moneda y Estatus
	    	 celda = fila.createCell((short)1);
	    	 celda.setCellValue("Moneda:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)2);
			 celda.setCellValue((!cedesBean.getNombreMoneda().equals("")? cedesBean.getNombreMoneda():"##"));
				
			 celda = fila.createCell((short)7);
			 celda.setCellValue("Estatus:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)8);
			 celda.setCellValue((!cedesBean.getDesEstatus().equals("")? cedesBean.getDesEstatus():"##"));
			 
			 fila = hoja.createRow(7);
			 fila = hoja.createRow(8); // Fila de todos los atributos a Listar
			 
				celda = fila.createCell((short)1);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloEncabezado);
				 
				celda = fila.createCell((short)2);
				celda.setCellValue("Promotor");
				celda.setCellStyle(estiloEncabezado);
				 
				celda = fila.createCell((short)3);
				celda.setCellValue("Número de Cliente");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Nombre del Cliente");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Tipo de CEDE");
				celda.setCellStyle(estiloEncabezado);

				celda = fila.createCell((short)6);
				celda.setCellValue("Número de Constancia");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Fecha Inicio");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Plazo (Días)");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Fecha Vencimiento");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Monto Invertido");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Capital a Recibir");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Tasa de Interés");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Tasa de ISR");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("Interés Devengado");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("ISR a Retener");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("Intereses a Recibir");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("Total a Recibir");
				celda.setCellStyle(estiloEncabezado);
			
				/*Auto Ajusto las Comulmnas*/
				Utileria.autoAjustaColumnas(18, hoja);
				
				int i=10; 
				int iter=0;
				int tamanioLista=listaCedesVencidas.size();
				CedesBean reporteCedes=null;
				
				for(iter=0; iter<tamanioLista; iter++){
					reporteCedes=(CedesBean)listaCedesVencidas.get(iter);
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
					celda.setCellValue(reporteCedes.getNombreCliente());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)5);
					celda.setCellValue(reporteCedes.getTipoCedeID()+"-"+reporteCedes.getDescripcion());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)6);
					celda.setCellValue(Utileria.convierteLong(reporteCedes.getCedeID()));
					celda.setCellStyle(estiloDatosCliente);   
					
					celda=fila.createCell((short)7);
					celda.setCellValue(reporteCedes.getFechaInicio());
					celda.setCellStyle(estiloCentrado2);
					  
					celda=fila.createCell((short)8);
					celda.setCellValue(Utileria.convierteEntero(reporteCedes.getPlazo()));
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(reporteCedes.getFechaVencimiento());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(Utileria.convierteDoble(reporteCedes.getMonto()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)11);
					celda.setCellValue(Utileria.convierteDoble(reporteCedes.getCapital()));
					celda.setCellStyle(estiloFormatoDecimal);

					
					celda=fila.createCell((short)12);
					celda.setCellValue(Utileria.convierteDoble(reporteCedes.getTasaFija()));
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)13);
					celda.setCellValue(Utileria.convierteDoble(reporteCedes.getTasaISR()));
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)14);
					celda.setCellValue(Utileria.convierteDoble(reporteCedes.getInteresGenerado()));
					celda.setCellStyle(estiloFormatoDecimal);

					
					celda=fila.createCell((short)15);
					celda.setCellValue(Utileria.convierteDoble(reporteCedes.getInteresRetener()));
					celda.setCellStyle(estiloFormatoDecimal);

					
					celda=fila.createCell((short)16);
					celda.setCellValue(Utileria.convierteDoble(reporteCedes.getInteresRecibir()));
					celda.setCellStyle(estiloFormatoDecimal);

					
					celda=fila.createCell((short)17);
					celda.setCellValue(Utileria.convierteDoble(reporteCedes.getTotalRecibir()));
					celda.setCellStyle(estiloFormatoDecimal);

					
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
				
              
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteVencimientoCede.xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				loggerSAFI.debug("Termina Reporte");
	    	
	    }catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte de Cedes Vencidas: " + e.getMessage());
			e.printStackTrace();
		}
	    
	    return listaCedesVencidas;
		
	}

	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}

	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
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
