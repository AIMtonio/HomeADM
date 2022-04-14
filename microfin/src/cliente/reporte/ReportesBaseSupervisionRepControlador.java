package cliente.reporte;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.BaseCaptacionBean;
import cliente.servicio.BaseCaptacionServicio;

public class ReportesBaseSupervisionRepControlador extends AbstractCommandController{
	BaseCaptacionServicio baseCaptacionServicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public ReportesBaseSupervisionRepControlador() {
		setCommandClass(BaseCaptacionBean.class);
		setCommandName("RepBasesup");
	}

	public static interface Enum_Reporte_TipRepor{
		int captacion=1;
		int captacionCSV =2;
	}
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command, BindException errors)throws Exception{
		MensajeTransaccionBean mensaje = null;
		BaseCaptacionBean baseCaptacionBean= (BaseCaptacionBean) command;		
		
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		int tipoPresentacion = Utileria.convierteEntero(request.getParameter("tipoPresentacion"));

		String fechaReporte=request.getParameter("fechaReporte");			
		String empresaID=request.getParameter("empresa");
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
			0;

				baseCaptacionBean.setEmpresaID(empresaID);
				baseCaptacionBean.setFechaReporte(fechaReporte);
		
		String htmlString= "";
		
		switch(tipoPresentacion){
			case Enum_Reporte_TipRepor.captacion:		
				 List listaReportes2 = captacionExcel(tipoLista,baseCaptacionBean,response);
			break;
		}
		
		switch(tipoReporte){
			case Enum_Reporte_TipRepor.captacionCSV:
				List listReportes =baseCaptacionServicio.generaReporte(tipoReporte,baseCaptacionBean,response);
				break;
		}

		return null;
	}
	
	 /* ==================================== Reporte de Captacion en Excel ================================= */
		public List  captacionExcel(int tipoLista,BaseCaptacionBean baseCaptacionBean,  HttpServletResponse response){
		List listaCaptacion=null;
		listaCaptacion = baseCaptacionServicio.listaReportesFOCOOP(tipoLista,baseCaptacionBean); 	
		
		int regExport = 0;
		
		try {
			XSSFWorkbook libro = new XSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			XSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			XSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			
			
			XSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			
			XSSFCellStyle estiloDerecha = libro.createCellStyle();
			estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			
			
			//Estilo negrita de 8  y color de fondo
			XSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			
			
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			XSSFCellStyle estiloFormatoTasa = libro.createCellStyle();
			XSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			estiloFormatoTasa.setDataFormat(format.getFormat("###0.00"));
			// Creacion de hoja					
			XSSFSheet hoja = libro.createSheet("Reporte Base Captación");
			XSSFRow fila= hoja.createRow(0);
			// inicio usuario,fecha y hora
			XSSFCell celdaUsu=fila.createCell((short)1);
			 
			celdaUsu = fila.createCell((short)28);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)29);
			celdaUsu.setCellValue((!baseCaptacionBean.getNombreUsuario().isEmpty())?baseCaptacionBean.getNombreUsuario(): "TODOS");
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            8, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
			 
				String horaVar="";
				String fechaVar=baseCaptacionBean.getParFechaEmision();

				
				int itera=0;
				BaseCaptacionBean aportacionHora = null;
				if(!listaCaptacion.isEmpty()){
				for( itera=0; itera<1; itera ++){

					aportacionHora = (BaseCaptacionBean) listaCaptacion.get(itera);
					horaVar= aportacionHora.getHora();
					
				}
				}
				
				fila = hoja.createRow(1);
				XSSFCell celdaFec=fila.createCell((short)1);
				celdaFec = fila.createCell((short)28);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg8);	
				celdaFec = fila.createCell((short)29);
				celdaFec.setCellValue(fechaVar);
				 
				
				// Nombre Institucion	
				XSSFCell celdaInst=fila.createCell((short)2);
				celdaInst.setCellStyle(estiloNeg10);
				celdaInst.setCellValue(baseCaptacionBean.getNombreInstitucion());
				celdaInst.setCellStyle(estiloDatosCentrado);

									
				  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            2, //primer celda (0-based)
				            6  //ultima celda   (0-based)
				    ));
					

				fila = hoja.createRow(2);
				XSSFCell celdaHora=fila.createCell((short)1);
				celdaHora = fila.createCell((short)28);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNeg8);	
				celdaHora = fila.createCell((short)29);
				celdaHora.setCellValue(horaVar);
				   // fin susuario,fecha y hora
				
				XSSFCell celda=fila.createCell((short)2);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("REPORTE BASE CAPTACIÓN DEL " + baseCaptacionBean.getFechaReporte());
				celda.setCellStyle(estiloDatosCentrado);
			
			    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            2, //primer celda (0-based)
			            6  //ultima celda   (0-based)
			    ));
			    
			    // Creacion de fila
				fila = hoja.createRow(4);
				fila = hoja.createRow(5);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("NumCliente");
				celda.setCellStyle(estiloNeg8);
			
				celda = fila.createCell((short)1);
				celda.setCellValue("NumCuenta");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("NombreCliente");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("NombreSucursal");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("NumeroSucursal");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Producto");
			    celda.setCellStyle(estiloNeg8);
				
			    celda = fila.createCell((short)6);
				celda.setCellValue("TipoPersona");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)7);
				celda.setCellValue("GradoRiesgo");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)8);
				celda.setCellValue("Actividad");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)9);
				celda.setCellValue("Localidad");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)10);
				celda.setCellValue("Nacionalidad");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)11);
				celda.setCellValue("FechaNacimiento");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)12);
				celda.setCellValue("RFC");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)13);
				celda.setCellValue("TipoDeposito");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)14);
				celda.setCellValue("TipoInversion");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)15);
				celda.setCellValue("FechaApertura");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("FechaVencimiento");
				celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)17);
				celda.setCellValue("Plazo");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)18);
				celda.setCellValue("FormaPagRendimientos");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)19);
				celda.setCellValue("TasaAnual");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)20);
				celda.setCellValue("DiasPorVencer");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)21);
				celda.setCellValue("FechaUltDeposito");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)22);
				celda.setCellValue("MontoUltDeposito");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)23);
				celda.setCellValue("Capital");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)24);
				celda.setCellValue("IntDevengados");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)25);
				celda.setCellValue("IntDevengadosMes");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)26);
				celda.setCellValue("SaldoPromedio");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)27);
				celda.setCellValue("SaldoTotalCieMes");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)28);
				celda.setCellValue("GarantiaLiquida");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)29);
				celda.setCellValue("PorcentajeGarantia");
			    celda.setCellStyle(estiloNeg8);
			    
				
				int i=6,iter=0;
				int tamanioLista = listaCaptacion.size();
				BaseCaptacionBean captacion = null;
				for( iter=0; iter<tamanioLista; iter ++){
					
						captacion = (BaseCaptacionBean) listaCaptacion.get(iter);
						fila=hoja.createRow(i);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(Utileria.convierteEntero(captacion.getNumCliente()));
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(captacion.getNumCuenta());
						celda.setCellStyle(estiloDerecha);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(captacion.getNombreCliente());
						
						celda=fila.createCell((short)3);
						celda.setCellValue(captacion.getNombreSucursal());
						
						celda=fila.createCell((short)4);
						celda.setCellValue(Utileria.convierteEntero(captacion.getNumeroSucursal()));
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(captacion.getProducto());
						
						celda=fila.createCell((short)6);
						celda.setCellValue(captacion.getTipoPersona());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(captacion.getGradoRiesgo());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(captacion.getActividad());
						
						celda=fila.createCell((short)9);
						celda.setCellValue(captacion.getLocalidad());
						
						celda=fila.createCell((short)10);
						celda.setCellValue(captacion.getNacionalidad());
						
						celda=fila.createCell((short)11);
						celda.setCellValue(captacion.getFechaNacimiento());
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)12);
						celda.setCellValue(captacion.getRFC());
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)13);
						celda.setCellValue(captacion.getTipoDeposito());
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)14);
						celda.setCellValue(captacion.getTipoInversion());
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)15);
						celda.setCellValue(captacion.getFechaApertura());
						
						celda=fila.createCell((short)16);
						celda.setCellValue(captacion.getFechaVencimiento());
						
						celda=fila.createCell((short)17);
						celda.setCellValue(Utileria.convierteEntero(captacion.getPlazo()));
						
						celda=fila.createCell((short)18);
						celda.setCellValue(captacion.getFormaPagRend());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)19);
						celda.setCellValue(Utileria.convierteDoble(captacion.getTasaAnual()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)20);
						celda.setCellValue(captacion.getDiasPorVencer());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)21);
						celda.setCellValue(captacion.getFechaUltDep());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)22);
						celda.setCellValue(captacion.getMontoUltDep());
						
						celda=fila.createCell((short)23);
						celda.setCellValue(Utileria.convierteDoble(captacion.getCapital()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)24);
						celda.setCellValue(Utileria.convierteDoble(captacion.getIntDevengados()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)25);
						celda.setCellValue(Utileria.convierteDoble(captacion.getIntDevengadosMes()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)26);
						celda.setCellValue(Utileria.convierteDoble(captacion.getSaldoPromedio()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)27);
						celda.setCellValue(Utileria.convierteDoble(captacion.getSaldoTotalCMes()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)28);
						celda.setCellValue(captacion.getGarantiaLiquida());
						
						celda=fila.createCell((short)29);
						celda.setCellValue(captacion.getPorcentajeGta());
						
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
				

				for(int celd=0; celd<=13; celd++)
				hoja.autoSizeColumn((short)celd);
			
									
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=BaseCaptacion.xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				}catch(Exception e){	
					e.printStackTrace();
				}//Fin del catch
			//}
			return  listaCaptacion;
			
			
			}

		public BaseCaptacionServicio getBaseCaptacionServicio() {
			return baseCaptacionServicio;
		}

		public void setBaseCaptacionServicio(BaseCaptacionServicio baseCaptacionServicio) {
			this.baseCaptacionServicio = baseCaptacionServicio;
		}
			

}
