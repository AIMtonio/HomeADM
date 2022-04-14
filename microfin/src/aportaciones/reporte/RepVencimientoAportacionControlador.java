package aportaciones.reporte;

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

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;

public class RepVencimientoAportacionControlador extends AbstractCommandController{
	
	public ParametrosSesionBean parametrosSesionBean = null;
	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	AportacionesServicio aportacionesServicio = null;
	String nombreReporte = null;
	String successView   = null;
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF   = 2 ;
		  int  ReporExcel = 3 ;
	}
	 
	public RepVencimientoAportacionControlador(){
		setCommandClass(AportacionesBean.class);
		setCommandName("vencimientoAportaciones");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		AportacionesBean aportacionesBean=(AportacionesBean) command;
		
		int tipoReporte=(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):0;	
		
		switch(tipoReporte){
		  case Enum_Con_TipRepor.ReporPDF:
			  ByteArrayOutputStream htmlStringPDF = reporteVencimientoDiaPDF(aportacionesBean, nombreReporte, response);
		  break;
			
		  case Enum_Con_TipRepor.ReporExcel:
			  List listaAportacionesVencidas= listaReporteAportacionesVencidas(tipoLista,aportacionesBean, response);
			
		  break;
		}
		
		return null;
	}
	
	public ByteArrayOutputStream reporteVencimientoDiaPDF(AportacionesBean aportacionesBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = aportacionesServicio.repVencimientoPDF(aportacionesBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=RepVencimientoAportaciones.pdf");
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
	
	public List listaReporteAportacionesVencidas(int tipoLista,AportacionesBean aportacionesBean, HttpServletResponse response){
		List listaAportacionesVencidas=null;
	
	    listaAportacionesVencidas= aportacionesServicio.lista(tipoLista, aportacionesBean);
	 
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
			Sheet hoja = libro.createSheet("Reporte Vencimiento de Aportaciones");
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
			celda.setCellValue("Reporte de Vencimientos del"+" "+aportacionesBean.getFechaInicio()+" "+"al"+" "+aportacionesBean.getFechaVencimiento());
							
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
			 
			 celda.setCellStyle(estiloCentrado);
			 
			 fila = hoja.createRow(3); // Fila Vacia
			 fila = hoja.createRow(4); // Fila Vacia
			 
			 fila = hoja.createRow(5);  // Fila de Aportación, Sucursal, Promotor
			 celda = fila.createCell((short)1);
			 celda.setCellValue("Tipo Aportación:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)2);
			 celda.setCellValue((!aportacionesBean.getDescripcion().equals("")? aportacionesBean.getDescripcion():"##"));
				
			 celda = fila.createCell((short)7);
			 celda.setCellValue("Sucursal:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)8);
			 celda.setCellValue((!aportacionesBean.getNombreSucursal().equals("")? aportacionesBean.getNombreSucursal():"##"));
				

			 celda = fila.createCell((short)14);
			 celda.setCellValue("Promotor:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)15);
			 celda.setCellValue((!aportacionesBean.getNombrePromotor().equals("")? aportacionesBean.getNombrePromotor():"##"));
			 
	    	 fila = hoja.createRow(6); //Fila de Moneda y Estatus
	    	 celda = fila.createCell((short)1);
	    	 celda.setCellValue("Moneda:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)2);
			 celda.setCellValue((!aportacionesBean.getNombreMoneda().equals("")? aportacionesBean.getNombreMoneda():"##"));
				
			 celda = fila.createCell((short)7);
			 celda.setCellValue("Estatus:");
			 celda.setCellStyle(estiloNeg8);	
			 celda = fila.createCell((short)8);
			 celda.setCellValue((!aportacionesBean.getDesEstatus().equals("")? aportacionesBean.getDesEstatus():"##"));
			 
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
				celda.setCellValue("Tipo de Aportación");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Cuenta");
				celda.setCellStyle(estiloEncabezado);

				celda = fila.createCell((short)7);
				celda.setCellValue("Número de Aportación");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Fecha Inicio");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Plazo (Días)");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Fecha Vencimiento");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Monto Inicial");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Capital a Recibir");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Tasa de Interés");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("Tasa de ISR");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("Tipo Documento");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("Cantidad");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("Tipo Documento Renovación");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)18);
				celda.setCellValue("Cantidad Renovación");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)19);
				celda.setCellValue("Total a renovar");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)20);
				celda.setCellValue("Interés Devengado");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)21);
				celda.setCellValue("ISR a Retener");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)22);
				celda.setCellValue("Intereses a Recibir");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)23);
				celda.setCellValue("Total a Recibir");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)24);
				celda.setCellValue("Tipo de interés");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)25);
				celda.setCellValue("Reinversión Aut");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)26);
				celda.setCellValue("Notas");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)27);
				celda.setCellValue("Especificaciones");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)28);
				celda.setCellValue("Condiciones");
				celda.setCellStyle(estiloEncabezado);
				
				/*Auto Ajusto las Comulmnas*/
				Utileria.autoAjustaColumnas(28, hoja);
				
				int i=9; 
				int iter=0;
				int tamanioLista=listaAportacionesVencidas.size();
				AportacionesBean reporteAportaciones=null;
				
				for(iter=0; iter<tamanioLista; iter++){
					reporteAportaciones=(AportacionesBean)listaAportacionesVencidas.get(iter);
					fila=hoja.createRow(i);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(reporteAportaciones.getSucursalID()+"-"+reporteAportaciones.getNombreSucursal());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(reporteAportaciones.getNombrePromotor());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)3);
					celda.setCellValue(Utileria.convierteLong(reporteAportaciones.getClienteID()));
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)4);
					celda.setCellValue(reporteAportaciones.getNombreCliente());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)5);
					celda.setCellValue(reporteAportaciones.getTipoAportacionID()+"-"+reporteAportaciones.getDescripcion());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)6); //cuenta
					celda.setCellValue(reporteAportaciones.getCuentaAhoID());
					celda.setCellStyle(estiloDatosCliente);
					
					
					celda=fila.createCell((short)7);
					celda.setCellValue(Utileria.convierteLong(reporteAportaciones.getAportacionID()));
					celda.setCellStyle(estiloDatosCliente);   
					
					celda=fila.createCell((short)8);
					celda.setCellValue(reporteAportaciones.getFechaInicio());
					celda.setCellStyle(estiloCentrado2);
					  
					celda=fila.createCell((short)9);
					celda.setCellValue(Utileria.convierteEntero(reporteAportaciones.getPlazoOriginal()));
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(reporteAportaciones.getFechaVencimiento());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)11);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getMonto()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)12);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getCapital()));
					celda.setCellStyle(estiloFormatoDecimal);

					
					celda=fila.createCell((short)13);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getTasaFija()));
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)14);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getTasaISR()));
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)15);
					celda.setCellValue(reporteAportaciones.getTipoDocumento());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)16);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getCantidad()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)17);
					celda.setCellValue(reporteAportaciones.getTipoDocReno());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)18);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getCantidadReno()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)19);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getTotalReno()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)20);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getInteresGenerado()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)21);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getInteresRetener()));
					celda.setCellStyle(estiloFormatoDecimal);
				
					celda=fila.createCell((short)22);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getInteresRecibir()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)23);
					celda.setCellValue(Utileria.convierteDoble(reporteAportaciones.getTotalRecibir()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)24);
					celda.setCellValue(reporteAportaciones.getTipoInteres());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)25);
					celda.setCellValue(reporteAportaciones.getReinversionAutom());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)26);
					celda.setCellValue(reporteAportaciones.getNotas());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)27);
					celda.setCellValue(reporteAportaciones.getEspecificaciones());
					celda.setCellStyle(estiloDatosCliente);
					
					celda=fila.createCell((short)28);
					celda.setCellValue(reporteAportaciones.getCondiciones());
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
				
//				for(int celd=0; celd<=28; celd++)
//				hoja.autoSizeColumn((short)celd);
				
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteVencimientoAportacion.xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				loggerSAFI.debug("Termina Reporte");
	    	
	    }catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte de Aportaciones Vencidas: " + e.getMessage());
			e.printStackTrace();
		}
	    
	    return listaAportacionesVencidas;
		
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
