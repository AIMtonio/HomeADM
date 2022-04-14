package cliente.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

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



import cliente.bean.ReportesFOCOOPBean;
import cliente.servicio.ReportesFOCOOPServicio;

public class ReportesFOCOOPRepControlador extends AbstractCommandController{
	ReportesFOCOOPServicio reportesFOCOOPServicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public ReportesFOCOOPRepControlador() {
		setCommandClass(ReportesFOCOOPBean.class);
		setCommandName("FOCOOPRep");
	}
	
	public static interface Enum_Reporte_TipRepor{
		int cartera=1;
		int captacion=2;
		int aportaciones=3;
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command, BindException errors)throws Exception{
		MensajeTransaccionBean mensaje = null;
		ReportesFOCOOPBean reportesFOCOOPBean= (ReportesFOCOOPBean) command;		
		
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		int tipoPresentacion = Utileria.convierteEntero(request.getParameter("tipoPresentacion"));

		String fechaReporte=request.getParameter("fechaReporte");			
		String empresaID=request.getParameter("empresa");
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
			0;

		reportesFOCOOPBean.setEmpresaID(empresaID);
		reportesFOCOOPBean.setFechaReporte(fechaReporte);
		
		String htmlString= "";
		
		switch(tipoPresentacion){
		case Enum_Reporte_TipRepor.cartera:		
				 List listaReportes = carteraExcel(tipoLista,reportesFOCOOPBean,response);
			break;
			case Enum_Reporte_TipRepor.captacion:		
				 List listaReportes2 = captacionExcel(tipoLista,reportesFOCOOPBean,response);
			break;
			case Enum_Reporte_TipRepor.aportaciones:		
				 List listaReportes3 = aportacionExcel(tipoLista,reportesFOCOOPBean,response);
			break;
		}
		
		switch(tipoReporte){
			case Enum_Reporte_TipRepor.cartera:
				mensaje=reportesFOCOOPServicio.generaReporte(tipoReporte,reportesFOCOOPBean,response);
				break;
			case Enum_Reporte_TipRepor.captacion:
				mensaje=reportesFOCOOPServicio.generaReporte(tipoReporte,reportesFOCOOPBean,response);
				break;
			case Enum_Reporte_TipRepor.aportaciones:
				mensaje=reportesFOCOOPServicio.generaReporte(tipoReporte,reportesFOCOOPBean,response);
				break;
		}

		return null;
	}
	


	 /* ==================================== Reporte de Cartera en Excel ================================= */
		public List  carteraExcel(int tipoLista,ReportesFOCOOPBean reportesFOCOOPBean,  HttpServletResponse response){
		List listaCartera=null;
		listaCartera = reportesFOCOOPServicio.listaReportesFOCOOP(tipoLista,reportesFOCOOPBean); 	
		
		int regExport = 0;
		int auxCellMovs = 0;
		
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
			XSSFSheet hoja = libro.createSheet("Reporte de Cartera");
			XSSFRow fila= hoja.createRow(0);
			// inicio usuario,fecha y hora
			XSSFCell celdaUsu=fila.createCell((short)1);
			 
			celdaUsu = fila.createCell((short)7);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)8);
			celdaUsu.setCellValue((!reportesFOCOOPBean.getNombreUsuario().isEmpty())?reportesFOCOOPBean.getNombreUsuario(): "TODOS");
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            8, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
			 
				String horaVar="";
				String fechaVar=reportesFOCOOPBean.getParFechaEmision();

				
				int itera=0;
				ReportesFOCOOPBean aportacionHora = null;
				if(!listaCartera.isEmpty()){
				for( itera=0; itera<1; itera ++){

					aportacionHora = (ReportesFOCOOPBean) listaCartera.get(itera);
					horaVar= aportacionHora.getHora();
					
				}
				}
				
				fila = hoja.createRow(1);
				XSSFCell celdaFec=fila.createCell((short)1);
				celdaFec = fila.createCell((short)7);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg8);	
				celdaFec = fila.createCell((short)8);
				celdaFec.setCellValue(fechaVar);
				 
				
				// Nombre Institucion	
				XSSFCell celdaInst=fila.createCell((short)2);
				celdaInst.setCellStyle(estiloNeg10);
				celdaInst.setCellValue(reportesFOCOOPBean.getNombreInstitucion());
				celdaInst.setCellStyle(estiloDatosCentrado);

									
				  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            2, //primer celda (0-based)
				            6  //ultima celda   (0-based)
				    ));
					

				fila = hoja.createRow(2);
				XSSFCell celdaHora=fila.createCell((short)1);
				celdaHora = fila.createCell((short)7);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNeg8);	
				celdaHora = fila.createCell((short)8);
				celdaHora.setCellValue(horaVar);
				   // fin susuario,fecha y hora
				
				XSSFCell celda=fila.createCell((short)2);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("REPORTE DE CARTERA DEL " + reportesFOCOOPBean.getFechaReporte());
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
				celda.setCellValue("Nombre del Acreditado");
				celda.setCellStyle(estiloNeg8);
			
				celda = fila.createCell((short)1);
				celda.setCellValue("Número de Socio");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Núm. Contrato");
				celda.setCellStyle(estiloNeg8);
			
				celda = fila.createCell((short)3);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Clasificación del Crédito");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Producto de Crédito");
			    celda.setCellStyle(estiloNeg8);
				
			    celda = fila.createCell((short)6);
				celda.setCellValue("Modalidad de Pago");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)7);
				celda.setCellValue("Fecha de Otorgamiento");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)8);
				celda.setCellValue("Monto Original");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)9);
				celda.setCellValue("Fecha de Vencimiento");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)10);
				celda.setCellValue("Formula");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)11);
				celda.setCellValue("Tasa Ordinaria Nominal Anual %");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)12);
				celda.setCellValue("Tasa Moratoria Nominal Anual %");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)13);
				celda.setCellValue("Plazo del Crédito(Meses)");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)14);
				celda.setCellValue("Frecuencia de Pago Capital");
			    celda.setCellStyle(estiloNeg8);
				
			    celda = fila.createCell((short)15);
				celda.setCellValue("Frecuencia de Pago Intereses");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)16);
				celda.setCellValue("Días Mora");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)17);
				celda.setCellValue("Capital Vigente");
			    celda.setCellStyle(estiloNeg8);
				
			    celda = fila.createCell((short)18);
				celda.setCellValue("Capital Vencido");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)19);
				celda.setCellValue("Intereses Devengados no Cobrados Vigente");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)20);
				celda.setCellValue("Intereses Devengados no Cobrados Vencido");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)21);
				celda.setCellValue("Intereses Devengados no Cobrados Cuentas de Orden");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)22);
				celda.setCellValue("Fecha Último Pago Capital");
			    celda.setCellStyle(estiloNeg8);
				
			    celda = fila.createCell((short)23);
				celda.setCellValue("Monto Último Pago Capital");
			    celda.setCellStyle(estiloNeg8);
				
			    celda = fila.createCell((short)24);
				celda.setCellValue("Fecha Último Pago Intereses");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)25);
				celda.setCellValue("Monto Último Pago Intereses");
			    celda.setCellStyle(estiloNeg8);
				
			    celda = fila.createCell((short)26);
				celda.setCellValue("Renovado Reestructurado  o Normal");
			    celda.setCellStyle(estiloNeg8);
			    
			    // Sección para determinar si agrega las nuevas columnas
			    if(reportesFOCOOPBean.getTipoRepCar().equals("A")){
			    	auxCellMovs = 2;
			    	
			    	celda = fila.createCell((short)27);
			    	celda.setCellValue("No. de veces reestructurado");
			    	celda.setCellStyle(estiloNeg8);
			    	
			    	celda = fila.createCell((short)28);
			    	celda.setCellValue("No. de veces renovado");
			    	celda.setCellStyle(estiloNeg8);
			    }
				
			    celda = fila.createCell((short)27 + auxCellMovs);
				celda.setCellValue("Emproblemado");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)28 + auxCellMovs);
				celda.setCellValue("Vigente o Vencido");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)29 + auxCellMovs);
				celda.setCellValue("Cargo del Acreditado Parte Relacionada art.26 LRASCAP");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)30 + auxCellMovs);
				celda.setCellValue("Monto Garantía Líquida");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)31 + auxCellMovs);
				celda.setCellValue("Cuenta(s) sobre la(s) que se Constituyo Garantía Líquida"); 
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)32 + auxCellMovs);
				celda.setCellValue("Monto Garantía Prendaria"); 
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)33 + auxCellMovs);
				celda.setCellValue("Monto Garantía Hipotecaria"); 
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)34 + auxCellMovs);
				celda.setCellValue("EPRC para Parte Cubierta"); 
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)35 + auxCellMovs);
				celda.setCellValue("EPRC para Parte Expuesta"); 
			    celda.setCellStyle(estiloNeg8);
			  
			    celda = fila.createCell((short)36 + auxCellMovs);
				celda.setCellValue("EPRC x Intereses de CaVe"); 
			    celda.setCellStyle(estiloNeg8);
			  
				int i=6,iter=0;
				int tamanioLista = listaCartera.size();
				ReportesFOCOOPBean cartera = null;
				for( iter=0; iter<tamanioLista; iter ++){
					
						cartera = (ReportesFOCOOPBean) listaCartera.get(iter);
						fila=hoja.createRow(i);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(cartera.getNombreCompleto());
						
						celda=fila.createCell((short)1);
						celda.setCellValue(cartera.getNumSocio());
						
						celda=fila.createCell((short)2);
						celda.setCellValue(cartera.getContrato());
						
						celda=fila.createCell((short)3);
						celda.setCellValue(cartera.getSucursal());
						
						celda=fila.createCell((short)4);
						celda.setCellValue(cartera.getClasificacion());
						
						celda=fila.createCell((short)5);
						celda.setCellValue(cartera.getProducto());
						
						celda=fila.createCell((short)6);
						celda.setCellValue(cartera.getModalidaPago());
						
						celda=fila.createCell((short)7);
						celda.setCellValue(cartera.getFechaOtorgamiento());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(Utileria.convierteDoble(cartera.getMontoOriginal()));
						celda.setCellStyle(estiloFormatoDecimal);

						celda=fila.createCell((short)9);
						celda.setCellValue(cartera.getFechaVencimien());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)10);
						celda.setCellValue(cartera.getFormula());
						
						celda=fila.createCell((short)11);
						celda.setCellValue(cartera.getTasaOrdinaria());
						
						celda=fila.createCell((short)12);
						celda.setCellValue(cartera.getTasaMoratoria());
						
						celda=fila.createCell((short)13);
						celda.setCellValue(cartera.getPlazoCredito());
						
						celda=fila.createCell((short)14);
						celda.setCellValue(cartera.getFrecuenciaPagoCapital());
						
						celda=fila.createCell((short)15);
						celda.setCellValue(cartera.getFrecuenciaPagoIn());
						
						celda=fila.createCell((short)16);
						celda.setCellValue(cartera.getDiasMora());
						
						celda=fila.createCell((short)17);
						celda.setCellValue(Utileria.convierteDoble(cartera.getSaldoCapitalVigente()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)18);
						celda.setCellValue(Utileria.convierteDoble(cartera.getSaldoCapitalVencido()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)19);
						celda.setCellValue(Utileria.convierteDoble(cartera.getInteresDevNoCobVig()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)20);
						celda.setCellValue(Utileria.convierteDoble(cartera.getInteresDevNoCobVen()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)21);
						celda.setCellValue(Utileria.convierteDoble(cartera.getInteresDevenNoCobCuentasOrden()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)22);
						celda.setCellValue(cartera.getFechaUltPagCap());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)23);
						celda.setCellValue(Utileria.convierteDoble(cartera.getMontoUltPagCap()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)24);
						celda.setCellValue(cartera.getFechaUltPagoInteres());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)25);
						celda.setCellValue(Utileria.convierteDoble(cartera.getMontoUltPagInteres()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)26);
						celda.setCellValue(cartera.getRenReesNor());
						
						// Sección correspondiente a las columnas de Renovación y Reestructura
						 if(reportesFOCOOPBean.getTipoRepCar().equals("A")){						    	
					    	celda = fila.createCell((short)27);
					    	celda.setCellValue(cartera.getNumeroReest());
					    	
					    	celda = fila.createCell((short)28);
					    	celda.setCellValue(cartera.getNumeroRenov());
					    }
						
						celda=fila.createCell((short)27 + auxCellMovs);
						celda.setCellValue(cartera.getEmproblemado());
						
						celda=fila.createCell((short)28 + auxCellMovs);
						celda.setCellValue(cartera.getVigenteVencido());
						
						celda=fila.createCell((short)29 + auxCellMovs);
						celda.setCellValue(cartera.getCargoDelAcreditado());
						
						celda=fila.createCell((short)30 + auxCellMovs);
						celda.setCellValue(Utileria.convierteDoble(cartera.getMontoGarantiaLiquida()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)31 + auxCellMovs);
						celda.setCellValue(cartera.getGarantiaLiquida());
						
						celda=fila.createCell((short)32 + auxCellMovs);
						celda.setCellValue(Utileria.convierteDoble(cartera.getMontoGarantiaPrendaria()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)33 + auxCellMovs);
						celda.setCellValue(Utileria.convierteDoble(cartera.getMontoGarantiaHipoteca()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)34 + auxCellMovs);
						celda.setCellValue(Utileria.convierteDoble(cartera.getEprCubierta()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)35 + auxCellMovs);
						celda.setCellValue(Utileria.convierteDoble(cartera.getEprExpuesta()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)36 + auxCellMovs);
						celda.setCellValue(Utileria.convierteDoble(cartera.getEprInteresesCaVe()));
						celda.setCellStyle(estiloFormatoDecimal);
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
				response.addHeader("Content-Disposition","inline; filename=ReporteCartera.xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			//	log.info("Termina Reporte");
				}catch(Exception e){
				//	log.info("Error al crear el reporte: " + e.getMessage());
					e.printStackTrace();
				}//Fin del catch
			//}
			return  listaCartera;
			
			
			}
			
	 /* ==================================== Reporte de Captacion en Excel ================================= */
		public List  captacionExcel(int tipoLista,ReportesFOCOOPBean reportesFOCOOPBean,  HttpServletResponse response){
		List listaCaptacion=null;
		listaCaptacion = reportesFOCOOPServicio.listaReportesFOCOOP(tipoLista,reportesFOCOOPBean); 	
		
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
			XSSFSheet hoja = libro.createSheet("Reporte de Captación");
			XSSFRow fila= hoja.createRow(0);
			// inicio usuario,fecha y hora
			XSSFCell celdaUsu=fila.createCell((short)1);
			 
			celdaUsu = fila.createCell((short)7);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)8);
			celdaUsu.setCellValue((!reportesFOCOOPBean.getNombreUsuario().isEmpty())?reportesFOCOOPBean.getNombreUsuario(): "TODOS");
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            8, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
			 
				String horaVar="";
				String fechaVar=reportesFOCOOPBean.getParFechaEmision();

				
				int itera=0;
				ReportesFOCOOPBean aportacionHora = null;
				if(!listaCaptacion.isEmpty()){
				for( itera=0; itera<1; itera ++){

					aportacionHora = (ReportesFOCOOPBean) listaCaptacion.get(itera);
					horaVar= aportacionHora.getHora();
					
				}
				}
				
				fila = hoja.createRow(1);
				XSSFCell celdaFec=fila.createCell((short)1);
				celdaFec = fila.createCell((short)7);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg8);	
				celdaFec = fila.createCell((short)8);
				celdaFec.setCellValue(fechaVar);
				 
				
				// Nombre Institucion	
				XSSFCell celdaInst=fila.createCell((short)2);
				celdaInst.setCellStyle(estiloNeg10);
				celdaInst.setCellValue(reportesFOCOOPBean.getNombreInstitucion());
				celdaInst.setCellStyle(estiloDatosCentrado);

									
				  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            2, //primer celda (0-based)
				            6  //ultima celda   (0-based)
				    ));
					

				fila = hoja.createRow(2);
				XSSFCell celdaHora=fila.createCell((short)1);
				celdaHora = fila.createCell((short)7);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNeg8);	
				celdaHora = fila.createCell((short)8);
				celdaHora.setCellValue(horaVar);
				   // fin susuario,fecha y hora
				
				XSSFCell celda=fila.createCell((short)2);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("REPORTE DE CAPTACIÓN DEL " + reportesFOCOOPBean.getFechaReporte());
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
				celda.setCellValue("Número de Socio");
				celda.setCellStyle(estiloNeg8);
			
				celda = fila.createCell((short)1);
				celda.setCellValue("Nombre del Socio");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Núm. Contrato o Cuenta");
				celda.setCellStyle(estiloNeg8);
			
				celda = fila.createCell((short)3);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Fecha de Apertura o Contratación");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Tipo de Depósito (Cuenta o Producto)");
			    celda.setCellStyle(estiloNeg8);
				
			    celda = fila.createCell((short)6);
				celda.setCellValue("Fecha del Depósito (Último)");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)7);
				celda.setCellValue("Fecha de Vencimiento");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)8);
				celda.setCellValue("Plazo del Depósito (Días)");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)9);
				celda.setCellValue("Forma de Pago de Rendimientos (Días)");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)10);
				celda.setCellValue("Tasa de Interés Nominal Pactada (Anual) en %");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)11);
				celda.setCellValue("Saldo Promedio (Para Determinar Intereses Mens)");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)12);
				celda.setCellValue("Monto del Ahorro o Depósito Plazo(Capital)");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)13);
				celda.setCellValue("Intereses Devengados No Pagados al Cierre del Mes Dep a Plazo(Acumulados)");
			    celda.setCellStyle(estiloNeg8);
				
			    celda = fila.createCell((short)14);
				celda.setCellValue("Saldo Total al Cierre del Mes (Capital + Int Dev No Pag en los Dep a Plazo)");
			    celda.setCellStyle(estiloNeg8);
			    
			    celda = fila.createCell((short)15);
				celda.setCellValue("Intereses Generados en el Mes (Devengados Pagados y no Pagados del Mes)");
			    celda.setCellStyle(estiloNeg8);
			    
				
				int i=6,iter=0;
				int tamanioLista = listaCaptacion.size();
				ReportesFOCOOPBean captacion = null;
				for( iter=0; iter<tamanioLista; iter ++){
					
						captacion = (ReportesFOCOOPBean) listaCaptacion.get(iter);
						fila=hoja.createRow(i);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(captacion.getNumSocio());
						
						celda=fila.createCell((short)1);
						celda.setCellValue(captacion.getNombreSocio());
						
						celda=fila.createCell((short)2);
						celda.setCellValue(captacion.getNumCuenta());
						
						celda=fila.createCell((short)3);
						celda.setCellValue(captacion.getSucursal());
						
						celda=fila.createCell((short)4);
						celda.setCellValue(captacion.getFechaApertura());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(captacion.getTipoCuenta());
						
						celda=fila.createCell((short)6);
						celda.setCellValue(captacion.getFechaUltDeposito());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(captacion.getFechaVencimiento());
						celda.setCellStyle(estiloCentrado);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(captacion.getPlazoDeposito());
						
						celda=fila.createCell((short)9);
						celda.setCellValue(captacion.getFormaPagRendimientos());
						
						celda=fila.createCell((short)10);
						celda.setCellValue(captacion.getTasaNominal());
						
						celda=fila.createCell((short)11);
						celda.setCellValue(Utileria.convierteDoble(captacion.getSaldoPromedio()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)12);
						celda.setCellValue(Utileria.convierteDoble(captacion.getCapital()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)13);
						celda.setCellValue(Utileria.convierteDoble(captacion.getIntDevenNoPagados()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)14);
						celda.setCellValue(Utileria.convierteDoble(captacion.getSaldoTotalCieMes()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)15);
						celda.setCellValue(Utileria.convierteDoble(captacion.getInteresesGeneradoMes()));
						celda.setCellStyle(estiloFormatoDecimal);
						
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
				response.addHeader("Content-Disposition","inline; filename=ReporteCaptacion.xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			//	log.info("Termina Reporte");
				}catch(Exception e){
				//	log.info("Error al crear el reporte: " + e.getMessage());
					e.printStackTrace();
				}//Fin del catch
			//}
			return  listaCaptacion;
			
			
			}
			
	
	     /* ==================================== Reporte Aportaciones Sociales en Excel ================================= */
			public List  aportacionExcel(int tipoLista,ReportesFOCOOPBean reportesFOCOOPBean,  HttpServletResponse response){
			List listaAportacion=null;
			//List listaCreditos = null;
			listaAportacion = reportesFOCOOPServicio.listaReportesFOCOOP(tipoLista,reportesFOCOOPBean); 	
			
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
				XSSFSheet hoja = libro.createSheet("Reporte de Partes Sociales");
				XSSFRow fila= hoja.createRow(0);
				// inicio usuario,fecha y hora
				XSSFCell celdaUsu=fila.createCell((short)1);
				 
				celdaUsu = fila.createCell((short)7);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg8);	
				celdaUsu = fila.createCell((short)8);
				celdaUsu.setCellValue((!reportesFOCOOPBean.getNombreUsuario().isEmpty())?reportesFOCOOPBean.getNombreUsuario(): "TODOS");
				 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            8, //primer celda (0-based)
				            10  //ultima celda   (0-based)
				    ));
				 
					String horaVar="";
					String fechaVar=reportesFOCOOPBean.getParFechaEmision();

					
					int itera=0;
					ReportesFOCOOPBean aportacionHora = null;
					if(!listaAportacion.isEmpty()){
					for( itera=0; itera<1; itera ++){

						aportacionHora = (ReportesFOCOOPBean) listaAportacion.get(itera);
						horaVar= aportacionHora.getHora();
						
					}
					}
					
					fila = hoja.createRow(1);
					XSSFCell celdaFec=fila.createCell((short)1);
					celdaFec = fila.createCell((short)7);
					celdaFec.setCellValue("Fecha:");
					celdaFec.setCellStyle(estiloNeg8);	
					celdaFec = fila.createCell((short)8);
					celdaFec.setCellValue(fechaVar);
					 
					
					// Nombre Institucion	
					XSSFCell celdaInst=fila.createCell((short)2);
					celdaInst.setCellStyle(estiloNeg10);
					celdaInst.setCellValue(reportesFOCOOPBean.getNombreInstitucion());
					celdaInst.setCellStyle(estiloDatosCentrado);

										
					  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            1, //primera fila (0-based)
					            1, //ultima fila  (0-based)
					            2, //primer celda (0-based)
					            6  //ultima celda   (0-based)
					    ));
						

					fila = hoja.createRow(2);
					XSSFCell celdaHora=fila.createCell((short)1);
					celdaHora = fila.createCell((short)7);
					celdaHora.setCellValue("Hora:");
					celdaHora.setCellStyle(estiloNeg8);	
					celdaHora = fila.createCell((short)8);
					celdaHora.setCellValue(horaVar);
					   // fin susuario,fecha y hora
					
					XSSFCell celda=fila.createCell((short)2);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("REPORTE DE PARTES SOCIALES DEL " + reportesFOCOOPBean.getFechaReporte());
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
					celda.setCellValue("No. Socio");
					celda.setCellStyle(estiloNeg8);
				
					celda = fila.createCell((short)1);
					celda.setCellValue("Nombre del Socio");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("Apellido Paterno");
					celda.setCellStyle(estiloNeg8);
				
					celda = fila.createCell((short)3);
					celda.setCellValue("Apellido Materno");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)4);
					celda.setCellValue("CURP");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)5);
					celda.setCellValue("Tipo Aportación");
				    celda.setCellStyle(estiloNeg8);
					
				    celda = fila.createCell((short)6);
					celda.setCellValue("Fecha Ingreso");
				    celda.setCellStyle(estiloNeg8);
				    
				    celda = fila.createCell((short)7);
					celda.setCellValue("Sexo");
				    celda.setCellStyle(estiloNeg8);
				    
				    celda = fila.createCell((short)8);
					celda.setCellValue("Parte Social");
				    celda.setCellStyle(estiloNeg8);
					
					int i=6,iter=0;
					int tamanioLista = listaAportacion.size();
					ReportesFOCOOPBean aportacion = null;
					for( iter=0; iter<tamanioLista; iter ++){
						
						    aportacion = (ReportesFOCOOPBean) listaAportacion.get(iter);
							fila=hoja.createRow(i);
									
							celda=fila.createCell((short)0);
							celda.setCellValue(aportacion.getNumSocio());
							
							celda=fila.createCell((short)1);
							celda.setCellValue(aportacion.getNombreSocio());
							
							celda=fila.createCell((short)2);
							celda.setCellValue(aportacion.getApellidoPaterno());
							
							celda=fila.createCell((short)3);
							celda.setCellValue(aportacion.getApellidoMaterno());
							
							celda=fila.createCell((short)4);
							celda.setCellValue(aportacion.getCURP());
							
							celda=fila.createCell((short)5);
							celda.setCellValue(aportacion.getTipoAportacion());
							
							celda=fila.createCell((short)6);
							celda.setCellValue(aportacion.getFechaIngreso());
							celda.setCellStyle(estiloCentrado);
							
							celda=fila.createCell((short)7);
							celda.setCellValue(aportacion.getSexo());
							
							celda=fila.createCell((short)8);
							celda.setCellValue(Utileria.convierteDoble(aportacion.getAporteSocio()));
							celda.setCellStyle(estiloFormatoDecimal);
							
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
					response.addHeader("Content-Disposition","inline; filename=ReporteAportacion.xlsx");
					response.setContentType("application/vnd.ms-excel");
					
					ServletOutputStream outputStream = response.getOutputStream();
					hoja.getWorkbook().write(outputStream);
					outputStream.flush();
					outputStream.close();
					
				//	log.info("Termina Reporte");
					}catch(Exception e){
					//	log.info("Error al crear el reporte: " + e.getMessage());
						e.printStackTrace();
					}//Fin del catch
				//}
				return  listaAportacion;
				
				
				}
				
	
	public ReportesFOCOOPServicio getReportesFOCOOPServicio() {
		return reportesFOCOOPServicio;
	}
	public void setReportesFOCOOPServicio(
			ReportesFOCOOPServicio reportesFOCOOPServicio) {
		this.reportesFOCOOPServicio = reportesFOCOOPServicio;
	}	
}
