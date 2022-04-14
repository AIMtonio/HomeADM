package credito.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.bean.RepCalificacionPorcResBean;
import credito.bean.RepEstimacionesCredPrevBean;
import credito.servicio.CreditosServicio;

public class EstimacionesCredPrevRepControlador extends AbstractCommandController{

	CreditosServicio creditosServicio = null;
	String nomReporte= null;
	String nombReporteCal = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
		  int  ReporPDF2= 4 ;
		  int  ReporExcel2= 5 ;
		}
	public EstimacionesCredPrevRepControlador () {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	   
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
	CreditosBean creditosBean = (CreditosBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):
		0;
			
	String htmlString= "";
			
		switch(tipoReporte){
			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = RepEstimacionesCredPrevPDF(creditosBean, nomReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
				 List listaReportes = estimacionesCredPrevExcel(tipoLista,creditosBean,response);
			break;
			case Enum_Con_TipRepor.ReporPDF2:
				ByteArrayOutputStream htmlStringPDF2 = RepCalificaPorcentResPDF(creditosBean, nombReporteCal, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel2:		
				 List listaReportes2 = calificacionesPorcResExcel(tipoLista,creditosBean,response);
			break;
		}
		
		if(tipoReporte == CreditosBean.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
			
	}

		
	// Reporte de saldos de capital en pdf
	public ByteArrayOutputStream RepEstimacionesCredPrevPDF(CreditosBean creditosBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditosServicio.creaRepEstimacionesCredPrevPDF(creditosBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteEstimacionesCredPrev.pdf");
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
	// Reporte de saldos de capital en pdf
		public ByteArrayOutputStream RepCalificaPorcentResPDF(CreditosBean creditosBean, String nombReporteCal, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = creditosServicio.creaRepCalificaPorcentResPDF(creditosBean, nombReporteCal);
				response.addHeader("Content-Disposition","inline; filename=ReporteCalificaPorcenRes.pdf");
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

		// Reporte de saldos capital de credito en excel
		public List  estimacionesCredPrevExcel(int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
		List listaCreditos=null;

		listaCreditos = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response); 	
		
		int regExport = 0;
		
			try {
			
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
			
			//Estilo negrita de 8  para encabezados del reporte
			CellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			CellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			
			
			CellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			
			
			//Estilo negrita de 8  y color de fondo
			CellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			CellStyle estiloFormatoTasa = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			estiloFormatoTasa.setDataFormat(format.getFormat("###0.00"));
			
			// Creacion de hoja					
			Sheet hoja = libro.createSheet("Reporte de Estimaciones Crediticias Preventivas");
			Row fila= hoja.createRow(0);
			// inicio usuario,fecha y hora
						Cell celdaUsu=fila.createCell((short)1);
			
						celdaUsu = fila.createCell((short)13);
						celdaUsu.setCellValue("Usuario:");
						celdaUsu.setCellStyle(estiloNeg8);	
						celdaUsu = fila.createCell((short)14);
						celdaUsu.setCellValue((!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
						 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
						            0, //primera fila (0-based)
						            0, //ultima fila  (0-based)
						            14, //primer celda (0-based)
						            17  //ultima celda   (0-based)
						    ));
						
						String horaVar="";
						String fechaVar=creditosBean.getParFechaEmision();

						
						int itera=0;
						RepEstimacionesCredPrevBean creditoHora = null;
						if(!listaCreditos.isEmpty()){
						for( itera=0; itera<1; itera ++){

							creditoHora = (RepEstimacionesCredPrevBean) listaCreditos.get(itera);
							horaVar= creditoHora.getHora();
							
						}
						}
						fila = hoja.createRow(1);
						Cell celdaFec=fila.createCell((short)1);
						celdaFec = fila.createCell((short)13);
						celdaFec.setCellValue("Fecha:");
						celdaFec.setCellStyle(estiloNeg8);	
						celdaFec = fila.createCell((short)14);
						celdaFec.setCellValue(fechaVar);
						 
						
						// Nombre Institucion	
						Cell celdaInst=fila.createCell((short)3);
						celdaInst.setCellStyle(estiloNeg10);
						celdaInst.setCellValue(creditosBean.getNombreInstitucion());
						celdaInst.setCellStyle(estiloDatosCentrado);

											
						  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
						            1, //primera fila (0-based)
						            1, //ultima fila  (0-based)
						            3, //primer celda (0-based)
						            10  //ultima celda   (0-based)
						    ));						
											
						
						fila = hoja.createRow(2);
						Cell celdaHora=fila.createCell((short)1);
						celdaHora = fila.createCell((short)13);
						celdaHora.setCellValue("Hora:");
						celdaHora.setCellStyle(estiloNeg8);	
						celdaHora = fila.createCell((short)14);
						celdaHora.setCellValue(horaVar);
						
			    // fin susuario,fecha y hora
			Cell celda=fila.createCell((short)3);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE DE ESTIMACIONES CREDITICIAS PREVENTIVAS DEL " + creditosBean.getFechaInicio());
			celda.setCellStyle(estiloDatosCentrado);
		
		    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            3, //primer celda (0-based)
		            10  //ultima celda   (0-based)
		    ));
		    
			
		    fila = hoja.createRow(3); // Fila vacia
			fila = hoja.createRow(4);// Campos
			celda = fila.createCell((short)3);
			celda.setCellValue("Cliente:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)4);
			celda.setCellValue((!creditosBean.getNombreCliente().equals("")? creditosBean.getNombreCliente():"TODOS"));
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)7);
			celda.setCellValue((!creditosBean.getNombreSucursal().equals("")? creditosBean.getNombreSucursal():"TODAS"));
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Promotor:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)10);
			celda.setCellValue((!creditosBean.getNombrePromotor().equals("")? creditosBean.getNombrePromotor():"TODOS"));
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Producto de Crédito:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)13);
			celda.setCellValue((!creditosBean.getNombreProducto().equals("")? creditosBean.getNombreProducto():"TODOS"));
			
			
			fila = hoja.createRow(5);
			celda = fila.createCell((short)3);
			celda.setCellValue("Grupo:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)4);
			celda.setCellValue((!creditosBean.getNombreGrupo().equals("")? creditosBean.getNombreGrupo():"TODOS"));
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Moneda:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)7);
			celda.setCellValue((!creditosBean.getNombreMoneda().equals("")? creditosBean.getNombreMoneda():"TODAS"));
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Género:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)10);
			celda.setCellValue((!creditosBean.getNombreGenero().equals("")? creditosBean.getNombreGenero():"TODOS"));
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Estado:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)13);
			celda.setCellValue((!creditosBean.getNombreEstado().equals("")? creditosBean.getNombreEstado():"TODOS"));
			
			celda = fila.createCell((short)15);
			celda.setCellValue("Municipio:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)16);
			celda.setCellValue((!creditosBean.getNombreMunicipi().equals("")? creditosBean.getNombreMunicipi():"TODOS"));
			
		    
			// Creacion de fila
			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			
			celda = fila.createCell((short)0);
			celda.setCellValue("Tiene Hipotecaria");
			celda.setCellStyle(estiloNeg8);
		
			celda = fila.createCell((short)1);
			celda.setCellValue("Clasificación");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Tipo de Crédito");
			celda.setCellStyle(estiloNeg8);
		
			celda = fila.createCell((short)3);
			celda.setCellValue("ID Crédito");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Grupo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Estatus");
		    celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("No. Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Nombre del Cliente");
			celda.setCellStyle(estiloNeg8);			
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Zona Marginada");
			celda.setCellStyle(estiloNeg8);			 

			celda = fila.createCell((short)9);
			celda.setCellValue("Producto de Crédito.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Fecha Desembolso");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Fecha Vto Final");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Saldo Capital");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Saldo Interés a Reservar");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)14);
			celda.setCellValue("Saldo Interés Vencido");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)15);
			celda.setCellValue("Días de Atraso");
			celda.setCellStyle(estiloNeg8);		
			
			celda = fila.createCell((short)16);
			celda.setCellValue("Calificación");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)17);
			celda.setCellValue("Monto Base Estimación Parte Expuesta");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)18);
			celda.setCellValue("Monto Base Estimación Parte Cubierta");
			celda.setCellStyle(estiloNeg8);				
			
			celda = fila.createCell((short)19);
			celda.setCellValue("% de Reserva Expuesta");
			celda.setCellStyle(estiloNeg8);	
						
			celda = fila.createCell((short)20);
			celda.setCellValue("% de Reserva Cubierta");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)21);
			celda.setCellValue("Garantías Parte Cubierta");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)22);
			celda.setCellValue("Reserva Capital");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)23);
			celda.setCellValue("Reserva Interés Mes Actual");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)24);
			celda.setCellValue("Reserva de Interés Meses Anteriores");
			celda.setCellStyle(estiloNeg8);	
					
			celda = fila.createCell((short)25);
			celda.setCellValue("Total Reserva");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)26);
			celda.setCellValue("Reserva Cubierta");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)27);
			celda.setCellValue("Reserva Expuesta");
			celda.setCellStyle(estiloNeg8);	
			
			/*Numero de Columnas, Sheet*/		
			Utileria.autoAjustaColumnas(26,hoja);
				
			int i=8,iter=0;
			int tamanioLista = listaCreditos.size();
			RepEstimacionesCredPrevBean credito = null;
			for( iter=0; iter<tamanioLista; iter ++){
				//Fecha	ID Crédito	No.Cliente	NombreCliente	Id producto	Sucursal	Monto Credito
					credito = (RepEstimacionesCredPrevBean) listaCreditos.get(iter);
					fila=hoja.createRow(i);
						
					 String Vacio="";
					 String Grupos="";
					 String nombreGrup="";
					 if ( Utileria.convierteEntero(credito.getGrupoID()) > 0) {
						 	Vacio= " - ";
						 	Grupos=credito.getGrupoID();
						 	nombreGrup=credito.getNombreGrupo();
					 }else{
						 Vacio="";
						 Grupos="";
						 nombreGrup="N/A";
					 }
					
					
					
					celda=fila.createCell((short)0);
					celda.setCellValue(credito.getEsHipotecado());
					
					celda=fila.createCell((short)1);
					celda.setCellValue(credito.getClasificacion()+" - "+credito.getSubClasificacion());
					
					celda=fila.createCell((short)2);
					celda.setCellValue(credito.getTipoCredito());
					
					celda=fila.createCell((short)3);
					celda.setCellValue(credito.getCreditoID());
					
					celda=fila.createCell((short)4);
					celda.setCellValue(Grupos+Vacio+nombreGrup);
				
					celda=fila.createCell((short)5);
				    celda.setCellValue(credito.getEstatus());
					
					celda=fila.createCell((short)6);
					celda.setCellValue(credito.getClienteID());				
										
					celda=fila.createCell((short)7);
					celda.setCellValue(credito.getNombreCompleto());
					
					celda=fila.createCell((short)8);
					celda.setCellValue(credito.getZonaMarginada());

					celda=fila.createCell((short)9);
					celda.setCellValue(credito.getProductoCreditoID()+ " - " + credito.getDescripcion());
					
					celda=fila.createCell((short)10);
					celda.setCellValue(credito.getFechaInicio());

					celda=fila.createCell((short)11);
					celda.setCellValue(credito.getFechaVencim());
					
					celda=fila.createCell((short)12);
					celda.setCellValue(Utileria.convierteDoble(credito.getCapital()));
					celda.setCellStyle(estiloFormatoDecimal);
					 //Capital	Intereses	Moratorios	Comisiones	IVA	TOTAL PAGADO

					celda=fila.createCell((short)13);
					celda.setCellValue(Utileria.convierteDoble(credito.getInteres()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)14);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoInteresVencido()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)15);
					celda.setCellValue(credito.getDiasAtraso());
					celda.setCellStyle(estiloCentrado);
					
					celda=fila.createCell((short)16);
					celda.setCellValue(credito.getCalificacion());
					celda.setCellStyle(estiloCentrado);
					
					celda=fila.createCell((short)17);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoBaseEstExp()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)18);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoBaseEstCub()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)19);
					celda.setCellValue(Utileria.convierteDoble(credito.getPorcReserva()));
					celda.setCellStyle(estiloFormatoTasa);
					
					celda=fila.createCell((short)20);
					celda.setCellValue(Utileria.convierteDoble(credito.getPorcReservaCub()));
					celda.setCellStyle(estiloFormatoTasa);

					celda=fila.createCell((short)21);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoGarantia()));
					celda.setCellStyle(estiloFormatoDecimal);
						
					celda=fila.createCell((short)22);
					celda.setCellValue(Utileria.convierteDoble(credito.getReserva()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)23);
					celda.setCellValue(Utileria.convierteDoble(credito.getReservaInteres()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)24);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoInteresAnterior()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)25);
					celda.setCellValue(Utileria.convierteDoble(credito.getTotalReserva()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					
					celda=fila.createCell((short)26);
					celda.setCellValue(Utileria.convierteDoble(credito.getReservaTotCubierto()));
					celda.setCellStyle(estiloFormatoDecimal);
					

					celda=fila.createCell((short)27);
					celda.setCellValue(Utileria.convierteDoble(credito.getReservaTotExpuesto()));
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
											
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteEstimaCredPrev.xlsx");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			}catch(Exception e){

				e.printStackTrace();
			}//Fin del catch
		//}
		return  listaCreditos;
		
		
		}

		// Reporte de calificaciones de credito en excel
				public List  calificacionesPorcResExcel(int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
				List listaCreditos=null;

				listaCreditos = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response); 	
				
				int regExport = 0;
			
				

					try {
					SXSSFWorkbook libro = new SXSSFWorkbook(100);;
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
					
					//Estilo negrita de 8  para encabezados del reporte
					CellStyle estiloNeg8 = libro.createCellStyle();
					estiloNeg8.setFont(fuenteNegrita8);
					
					CellStyle estiloDatosCentrado = libro.createCellStyle();
					estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
					estiloDatosCentrado.setFont(fuenteNegrita10);
					estiloDatosCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
					
					
					CellStyle estiloCentrado = libro.createCellStyle();
					estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
					estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
					
					
					//Estilo negrita de 8  y color de fondo
					CellStyle estiloColor = libro.createCellStyle();
					estiloColor.setFont(fuenteNegrita8);
					estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
					estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
					
					
					//Estilo Formato decimal (0.00)
					CellStyle estiloFormatoDecimal = libro.createCellStyle();
					CellStyle estiloFormatoTasa = libro.createCellStyle();
					DataFormat format = libro.createDataFormat();
					estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
					estiloFormatoTasa.setDataFormat(format.getFormat("###0.00"));
					// Creacion de hoja					
					Sheet hoja = libro.createSheet("Reporte Calificación y Porcentaje de Reservas");
					Row fila= hoja.createRow(0);
					// inicio usuario,fecha y hora
					Cell celdaUsu=fila.createCell((short)1);
		 
					celdaUsu = fila.createCell((short)11);
					celdaUsu.setCellValue("Usuario:");
					celdaUsu.setCellStyle(estiloNeg8);	
					celdaUsu = fila.createCell((short)12);
					celdaUsu.setCellValue((!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            12, //primer celda (0-based)
				            15  //ultima celda   (0-based)
				    ));
					
					String horaVar="";
					String fechaVar=creditosBean.getParFechaEmision();

					
					int itera=0;
					RepCalificacionPorcResBean creditoHora = null;
					if(!listaCreditos.isEmpty()){
					for( itera=0; itera<1; itera ++){

						creditoHora = (RepCalificacionPorcResBean) listaCreditos.get(itera);
						horaVar= creditoHora.getHora();
						//fechaVar= creditoHora.getFecha();
						
					}
					}
					fila = hoja.createRow(1);
					Cell celdaFec=fila.createCell((short)1);
					celdaFec = fila.createCell((short)11);
					celdaFec.setCellValue("Fecha:");
					celdaFec.setCellStyle(estiloNeg8);	
					celdaFec = fila.createCell((short)12);
					celdaFec.setCellValue(fechaVar);
					
					
					// Nombre Institucion	
					Cell celdaInst=fila.createCell((short)1);
					celdaInst.setCellStyle(estiloNeg10);
					celdaInst.setCellValue(creditosBean.getNombreInstitucion());
					celdaInst.setCellStyle(estiloDatosCentrado);

										
					  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            1, //primera fila (0-based)
					            1, //ultima fila  (0-based)
					            1, //primer celda (0-based)
					            10  //ultima celda   (0-based)
					    ));						
					
					 
					
					fila = hoja.createRow(2);
					Cell celdaHora=fila.createCell((short)1);
					celdaHora = fila.createCell((short)11);
					celdaHora.setCellValue("Hora:");
					celdaHora.setCellStyle(estiloNeg8);	
					celdaHora = fila.createCell((short)12);
					celdaHora.setCellValue(horaVar);

					Cell celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("REPORTE CALIFICACIÓN Y PORCENTAJE DE RESERVAS " + creditosBean.getFechaInicio());
					celda.setCellStyle(estiloDatosCentrado);
				
				    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            2, //primera fila (0-based)
				            2, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            10  //ultima celda   (0-based)
				    ));
				    
					
					// Creacion de fila
					fila = hoja.createRow(4);
					
				    fila = hoja.createRow(3); // Fila vacia
				    
					fila = hoja.createRow(4);// Campos
					celda = fila.createCell((short)1);
					celda.setCellValue("Cliente:");
					celda.setCellStyle(estiloNeg8);	
					celda = fila.createCell((short)2);
					celda.setCellValue((!creditosBean.getNombreCliente().equals("")? creditosBean.getNombreCliente():"TODOS"));
					
					celda = fila.createCell((short)4);
					celda.setCellValue("Sucursal:");
					celda.setCellStyle(estiloNeg8);	
					celda = fila.createCell((short)5);
					celda.setCellValue((!creditosBean.getNombreSucursal().equals("")? creditosBean.getNombreSucursal():"TODAS"));
					
					celda = fila.createCell((short)7);
					celda.setCellValue("Promotor:");
					celda.setCellStyle(estiloNeg8);	
					celda = fila.createCell((short)8);
					celda.setCellValue((!creditosBean.getNombrePromotor().equals("")? creditosBean.getNombrePromotor():"TODOS"));
					
					celda = fila.createCell((short)10);
					celda.setCellValue("Producto de Crédito:");
					celda.setCellStyle(estiloNeg8);	
					celda = fila.createCell((short)11);
					celda.setCellValue((!creditosBean.getNombreProducto().equals("")? creditosBean.getNombreProducto():"TODOS"));
					
					
					fila = hoja.createRow(5);
					celda = fila.createCell((short)1);
					celda.setCellValue("Grupo:");
					celda.setCellStyle(estiloNeg8);	
					celda = fila.createCell((short)2);
					celda.setCellValue((!creditosBean.getNombreGrupo().equals("")? creditosBean.getNombreGrupo():"TODOS"));
					
					celda = fila.createCell((short)4);
					celda.setCellValue("Moneda:");
					celda.setCellStyle(estiloNeg8);	
					celda = fila.createCell((short)5);
					celda.setCellValue((!creditosBean.getNombreMoneda().equals("")? creditosBean.getNombreMoneda():"TODAS"));
					
					celda = fila.createCell((short)7);
					celda.setCellValue("Género:");
					celda.setCellStyle(estiloNeg8);	
					celda = fila.createCell((short)8);
					celda.setCellValue((!creditosBean.getNombreGenero().equals("")? creditosBean.getNombreGenero():"TODOS"));
					
					celda = fila.createCell((short)10);
					celda.setCellValue("Estado:");
					celda.setCellStyle(estiloNeg8);	
					celda = fila.createCell((short)11);
					celda.setCellValue((!creditosBean.getNombreEstado().equals("")? creditosBean.getNombreEstado():"TODOS"));
					
					celda = fila.createCell((short)13);
					celda.setCellValue("Municipio:");
					celda.setCellStyle(estiloNeg8);	
					celda = fila.createCell((short)14);
					celda.setCellValue((!creditosBean.getNombreMunicipi().equals("")? creditosBean.getNombreMunicipi():"TODOS"));
		
									
					
					fila = hoja.createRow(7);
								
				
					celda = fila.createCell((short)1);
					celda.setCellValue("ID Crédito");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("ID Grupo");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("Nombre Grupo");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)4);
					celda.setCellValue("No. Cliente");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)5);
					celda.setCellValue("Nombre del Cliente");
					celda.setCellStyle(estiloNeg8);			

					celda = fila.createCell((short)6);
					celda.setCellValue("Producto de Crédito.");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)7);
					celda.setCellValue("Fecha Desembolso");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("Fecha Vto Final");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)9);
					celda.setCellValue("Saldo Capital");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)10);
					celda.setCellValue("Saldo Interés");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)11);
					celda.setCellValue("Días de Atraso");
					celda.setCellStyle(estiloNeg8);		
					
					celda = fila.createCell((short)12);
					celda.setCellValue("Clasificación");
					celda.setCellStyle(estiloNeg8);	
					
					celda = fila.createCell((short)13);
					celda.setCellValue("Calificación");
					celda.setCellStyle(estiloNeg8);	
					
					celda = fila.createCell((short)14);
					celda.setCellValue("% de Reserva");
					celda.setCellStyle(estiloNeg8);					

					Utileria.autoAjustaColumnas(13, hoja);
					
					int i=8,iter=0;
					int tamanioLista = listaCreditos.size();
					RepCalificacionPorcResBean credito = null;
					for( iter=0; iter<tamanioLista; iter ++){
						//Fecha	ID Crédito	No.Cliente	NombreCliente	Id producto	Sucursal	Monto Credito
							credito = (RepCalificacionPorcResBean) listaCreditos.get(iter);
							fila=hoja.createRow(i);

							
							celda=fila.createCell((short)1);
							celda.setCellValue(credito.getCreditoID());
							
							celda=fila.createCell((short)2);
							celda.setCellValue(credito.getGrupoID());
							
							celda=fila.createCell((short)3);
							celda.setCellValue(credito.getNombreGrupo());
							
							celda=fila.createCell((short)4);
							celda.setCellValue(credito.getClienteID());
							
							celda=fila.createCell((short)5);
							celda.setCellValue(credito.getNombreCompleto());

							celda=fila.createCell((short)6);
							celda.setCellValue(credito.getDescripcion());
							
							celda=fila.createCell((short)7);
							celda.setCellValue(credito.getFechaInicio());

							celda=fila.createCell((short)8);
							celda.setCellValue(credito.getFechaVencim());
							
							celda=fila.createCell((short)9);
							celda.setCellValue(Utileria.convierteDoble(credito.getCapital()));
							celda.setCellStyle(estiloFormatoDecimal);
							 //Capital	Intereses	Moratorios	Comisiones	IVA	TOTAL PAGADO

							celda=fila.createCell((short)10);
							celda.setCellValue(Utileria.convierteDoble(credito.getInteres()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)11);
							celda.setCellValue(credito.getDiasAtraso());
							celda.setCellStyle(estiloCentrado);

							celda=fila.createCell((short)12);
							celda.setCellValue(credito.getClasificacion() + " - "+ credito.getSubClasificacion());
							
							celda=fila.createCell((short)13);
							celda.setCellValue(credito.getCalificacion());
							celda.setCellStyle(estiloCentrado);
							
							celda=fila.createCell((short)14);
							celda.setCellValue(Utileria.convierteDoble(credito.getPorcReserva()));
							celda.setCellStyle(estiloFormatoTasa);
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
								
					//Creo la cabecera
					response.addHeader("Content-Disposition","inline; filename=ReporteCalificaPorcRes.xlsx");
					response.setContentType("application/vnd.ms-excel");
					
					ServletOutputStream outputStream = response.getOutputStream();
					hoja.getWorkbook().write(outputStream);
					outputStream.flush();
					outputStream.close();
					
					}catch(Exception e){
						e.printStackTrace();
					}//Fin del catch
				//}
				return  listaCreditos;
				
				
				}	
	
	
	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}


	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}



	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}


	public String getNombReporteCal() {
		return nombReporteCal;
	}


	public void setNombReporteCal(String nombReporteCal) {
		this.nombReporteCal = nombReporteCal;
	}
}
