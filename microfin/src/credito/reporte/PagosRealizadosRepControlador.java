package credito.reporte;

   
import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import herramientas.Utileria;

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
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.bean.ReporteCreditosBean;
import credito.servicio.CreditosServicio;

public class PagosRealizadosRepControlador extends AbstractCommandController{

	CreditosServicio creditosServicio = null;
	String nomReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
		}
	public PagosRealizadosRepControlador () {
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
				ByteArrayOutputStream htmlStringPDF = RepPagosRealizadosPDF(creditosBean, nomReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
				 List listaReportes = pagosRealizadosExcel(tipoLista,creditosBean,response);
			break;
		}
		
		if(tipoReporte == CreditosBean.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
			
	}

		
	// Reporte de saldos de capital en pdf
	public ByteArrayOutputStream RepPagosRealizadosPDF(CreditosBean creditosBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditosServicio.creaRepPagosRealizadosPDF(creditosBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReportePagosRealizados.pdf");
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
		public List  pagosRealizadosExcel(int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
		List listaCreditos=null;
		//List listaCreditos = null;
  	listaCreditos = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response); 	
		
		int regExport = 0;
		
	//	if(listaCreditos != null){
		

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
			estiloDatosCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);  
			
			
			CellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			
			
			//Estilo negrita de 8  y color de fondo
			CellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(CellStyle.SOLID_FOREGROUND);
			
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja					
			Sheet hoja = libro.createSheet("Reporte de Pagos Realizados");
			Row fila= hoja.createRow(0);
			// inicio usuario,fecha y hora
						Cell celdaUsu=fila.createCell((short)1);
			 
						celdaUsu = fila.createCell((short)15);
						celdaUsu.setCellValue("Usuario:");
						celdaUsu.setCellStyle(estiloNeg8);	
						celdaUsu = fila.createCell((short)16);
						celdaUsu.setCellValue((!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
						
						String fechaVar=creditosBean.getParFechaEmision();
						
						int itera=0;
						ReporteCreditosBean creditoHora = null;
						if(!listaCreditos.isEmpty()){
						for( itera=0; itera<1; itera ++){

							creditoHora = (ReporteCreditosBean) listaCreditos.get(itera);
							fechaVar= creditoHora.getFecha();
							
						}
						}
						fila = hoja.createRow(1);
						Cell celdaFec=fila.createCell((short)1);
						celdaFec = fila.createCell((short)15);
						celdaFec.setCellValue("Fecha:");
						celdaFec.setCellStyle(estiloNeg8);	
						celdaFec = fila.createCell((short)16);
						celdaFec.setCellValue(fechaVar);
						 
						Calendar calendario = new GregorianCalendar();
						fila = hoja.createRow(2);
						Cell celdaHora=fila.createCell((short)1);
						celdaHora = fila.createCell((short)15);
						celdaHora.setCellValue("Hora:");
						celdaHora.setCellStyle(estiloNeg8);	
						celdaHora = fila.createCell((short)16);
						celdaHora.setCellValue(calendario.get(Calendar.HOUR_OF_DAY) + ":" + calendario.get(Calendar.MINUTE));
			    // fin susuario,fecha y hora
			
			Cell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE DE PAGOS DE CRÉDITO AL DÍA "+creditosBean.getFechaInicio()+ " AL " + creditosBean.getFechaVencimien() );
			
		
		    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            7  //ultima celda   (0-based)
		    ));
			
			// Creacion de fila
			fila = hoja.createRow(3);
			celda = fila.createCell((short)1);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloNeg8);
			celdaFec = fila.createCell((short)2);
			celdaFec.setCellValue((!creditosBean.getNombreSucursal().isEmpty())?creditosBean.getNombreSucursal():"TODAS");


			celda = fila.createCell((short)4);
			celda.setCellValue("Promotor:");
			celda.setCellStyle(estiloNeg8);
			celdaFec = fila.createCell((short)5);
			celdaFec.setCellValue((!creditosBean.getNombrePromotor().isEmpty())?creditosBean.getNombrePromotor():"TODOS");

			

			celda = fila.createCell((short)6);
			celda.setCellValue("Producto Crédito:");
			celda.setCellStyle(estiloNeg8);
			celdaFec = fila.createCell((short)7);
			celdaFec.setCellValue((!creditosBean.getNombreProducto().isEmpty())?creditosBean.getNombreProducto():"TODOS");
		
			
			String Nivel="DETALLADO";
			celda = fila.createCell((short)8);
			celda.setCellValue("Nivel de Detalle:");
			celda.setCellStyle(estiloNeg8);
			celdaFec = fila.createCell((short)9);
			celdaFec.setCellValue(Nivel);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Modalidad de pago:");
			celda.setCellStyle(estiloNeg8);
			celdaFec = fila.createCell((short)11);
			celdaFec.setCellValue((!creditosBean.getModalidadPagoID().isEmpty())?creditosBean.getModalidadPagoID():"TODAS");
			
			if("E".equals(creditosBean.getModalidadPagoID())){
				celdaFec.setCellValue("EFECTIVO");
			}
			
			if("C".equals(creditosBean.getModalidadPagoID())){ 
				celdaFec.setCellValue("CARGO A CUENTA");
			}
			if("S".equals(creditosBean.getModalidadPagoID())){ 
				celdaFec.setCellValue("SPEI");
			}
			
			
		    hoja.addMergedRegion(new CellRangeAddress(
		    		 3, 3, 2,3   
		    ));
			
			
			// Creacion de fila
			fila = hoja.createRow(4);
			celda = fila.createCell((short)1);
			celda.setCellValue("Moneda:");
			celda.setCellStyle(estiloNeg8);
			celdaFec = fila.createCell((short)2);
			celdaFec.setCellValue((!creditosBean.getNombreMoneda().isEmpty())?creditosBean.getNombreMoneda():"TODAS");

			

			celda = fila.createCell((short)4);
			celda.setCellValue("Género:");
			celda.setCellStyle(estiloNeg8);
			celdaFec = fila.createCell((short)5);
			celdaFec.setCellValue((!creditosBean.getNombreGenero().isEmpty())?creditosBean.getNombreGenero():"TODOS");

			

			celda = fila.createCell((short)6);
			celda.setCellValue("Estado:");
			celda.setCellStyle(estiloNeg8);
			celdaFec = fila.createCell((short)7);
			celdaFec.setCellValue((!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado():"TODOS");
			

			celda = fila.createCell((short)8);
			celda.setCellValue("Municipio:");
			celda.setCellStyle(estiloNeg8);
			celdaFec = fila.createCell((short)9);
			celdaFec.setCellValue((!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi():"TODOS");

		

			if("S".equals(creditosBean.getEsproducNomina())){
				if("S".equals(creditosBean.getManejaConvenio()))
				{
					celda = fila.createCell((short)10);
					celda.setCellValue("Institución Nómina:");
					celda.setCellStyle(estiloNeg8);
					celdaFec = fila.createCell((short)11);
					celdaFec.setCellValue((!creditosBean.getNombreInstit().isEmpty())?creditosBean.getNombreInstit():"TODAS");
					
					fila = hoja.createRow(5);
					
					celda = fila.createCell((short)1);
					celda.setCellValue("Convenio Nómina:");
					celda.setCellStyle(estiloNeg8);
					celdaFec = fila.createCell((short)2);
					celdaFec.setCellValue((!creditosBean.getDesConvenio().isEmpty())?creditosBean.getDesConvenio():"TODOS");
				}else {
					celda = fila.createCell((short)10);
					celda.setCellValue("Institución Nómina:");
					celda.setCellStyle(estiloNeg8);
					celdaFec = fila.createCell((short)11);
					celdaFec.setCellValue((!creditosBean.getNombreInstit().isEmpty())?creditosBean.getNombreInstit():"TODAS");
					fila = hoja.createRow(5);
					
				}
				
			}else {
				fila = hoja.createRow(5);
			}
			
			
			
		    hoja.addMergedRegion(new CellRangeAddress(
		    		 5,5, 2, 3  
		    ));
			
			
			// Creacion de fila
			fila = hoja.createRow(6);
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
			celda.setCellValue("Institución Nómina");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Convenio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("No.Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Nombre del Cliente");
			celda.setCellStyle(estiloNeg8);			

			
			celda = fila.createCell((short)8);
			celda.setCellValue("Referencia Pago");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Nombre del Producto.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Monto Crédito");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Fecha Venci.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Fecha Pago");
			celda.setCellStyle(estiloNeg8);
			
			/*
			celda = fila.createCell((short)12);
			celda.setCellValue("Detalle del Pago");
			celda.setCellStyle(estiloCentrado);		
			

		    hoja.addMergedRegion(new CellRangeAddress(
		    		 6, 6, 12, 17  
		    ));
		    */
			celda = fila.createCell((short)14);
			celda.setCellValue("Modalidad Pago");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)15);
			celda.setCellValue("Cuenta");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)16);
			celda.setCellValue("Fuentes de Fondeo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)17);
			celda.setCellValue("Linea Fondeo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)18);
			celda.setCellValue("Folio Fondeo");
			celda.setCellStyle(estiloNeg8);
			
			
			celda = fila.createCell((short)19);
			celda.setCellValue("Detalle del Pago");
			celda.setCellStyle(estiloCentrado);		
			

		    hoja.addMergedRegion(new CellRangeAddress(
		    		 7, 7, 19, 24
		    ));
		    
		    
		    
		    
		   //Capital	Intereses	Moratorios	Comisiones	IVA	TOTAL PAGADO

			fila = hoja.createRow(8);//NUEVA FILA
			
			celda = fila.createCell((short)19);
			celda.setCellValue("Capital");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)20);
			celda.setCellValue("Intereses");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)21);
			celda.setCellValue("Moratorios");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)22);
			celda.setCellValue("IVA");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)23);
			celda.setCellValue("Comisiones");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)24);
			celda.setCellValue("IVA Comisiones");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)25);
			celda.setCellValue("Accesorios");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)26);
			celda.setCellValue("Interés Accesorios");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)27);
			celda.setCellValue("IVA (Intereses) Accesorios");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)28);
			celda.setCellValue("Notas de cargo");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)29);
			celda.setCellValue("IVA notas cargo");
			celda.setCellStyle(estiloNeg8);
	
			
			celda = fila.createCell( ( short ) 30 );
			celda.setCellValue( "Total Pagado" );
			celda.setCellStyle( estiloNeg8 );	
					
		    hoja.addMergedRegion(new CellRangeAddress(
		    		 9, 9, 19, 27  
		    ));
			
			Utileria.autoAjustaColumnas(27, hoja);

			int i=10,iter=0;
			int tamanioLista = listaCreditos.size();
			ReporteCreditosBean credito = null;
			for( iter=0; iter<tamanioLista; iter ++){
				//Fecha	ID Crédito	No.Cliente	NombreCliente	Id producto	Sucursal	Monto Credito
					credito = (ReporteCreditosBean) listaCreditos.get(iter);
					fila=hoja.createRow(i);

					

					celda=fila.createCell((short)1);
					celda.setCellValue(credito.getCreditoID());
					
					celda=fila.createCell((short)2);
					celda.setCellValue(credito.getGrupoID());
					
					celda=fila.createCell((short)3);
					celda.setCellValue(credito.getNombreGrupo());
					
					celda=fila.createCell((short)4);
					celda.setCellValue(credito.getNombreInstit());
					
					celda=fila.createCell((short)5);
					celda.setCellValue(credito.getDesConvenio());
					
					celda=fila.createCell((short)6);
					celda.setCellValue(credito.getClienteID());
					
					celda=fila.createCell((short)7);
					celda.setCellValue(credito.getNombreCompleto());

					
					celda=fila.createCell((short)8);
					celda.setCellValue(credito.getRefPago());

					
					celda=fila.createCell((short)9);
					celda.setCellValue(credito.getProductoCreDescri());
					
					celda=fila.createCell((short)10);
					celda.setCellValue(credito.getNombreSucursal());

					celda=fila.createCell((short)11);
					celda.setCellValue(Double.parseDouble(credito.getMontoCredito()));
					celda.setCellStyle(estiloFormatoDecimal);
					 //Capital	Intereses	Moratorios	Comisiones	IVA	TOTAL PAGADO

					celda=fila.createCell((short)12); ///////////////////////////////////////////////////
					celda.setCellValue(credito.getFechaVencimiento());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)13); ///////////////////////////////////////////////////
					celda.setCellValue(credito.getFechaPago());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)14);
					celda.setCellValue(credito.getModalidadPago());
					
					celda=fila.createCell((short)15);
					celda.setCellValue(credito.getCuentaAhoID());
					
					celda=fila.createCell((short)16);
					celda.setCellValue(credito.getFuenteFondeo());
					
					celda=fila.createCell((short)17);
					celda.setCellValue(credito.getLineaFondeo());
					
					celda=fila.createCell((short)18);
					celda.setCellValue(credito.getFolioFondeo());
					
					celda=fila.createCell((short)19);
					celda.setCellValue(Double.parseDouble(credito.getCapital()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)20);
					celda.setCellValue(Double.parseDouble(credito.getIntereses()) );
					celda.setCellStyle(estiloFormatoDecimal);
						
					celda=fila.createCell((short)21);
					celda.setCellValue(Double.parseDouble(credito.getMoratorios()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)22);
					celda.setCellValue(Double.parseDouble(credito.getIVA()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)23);
					celda.setCellValue(Double.parseDouble(credito.getComisiones()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)24);
					celda.setCellValue(Double.parseDouble(credito.getIvaComisiones()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)25);
					celda.setCellValue(Double.parseDouble(credito.getAccesorios()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)26);
					celda.setCellValue(Double.parseDouble(credito.getInteresAccesorios()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)27);
					celda.setCellValue(Double.parseDouble(credito.getIvaInteresAccesorios()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)28);
					celda.setCellValue(Double.parseDouble(credito.getNotasCargo()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)29);
					celda.setCellValue(Double.parseDouble(credito.getIvaNotasCargo()));
					celda.setCellStyle(estiloFormatoDecimal);
					

					celda=fila.createCell((short)30);
					celda.setCellValue(Double.parseDouble(credito.getTotalPagado()));
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
			response.addHeader("Content-Disposition","inline; filename=ReportePagosRealizados.xlsx");
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
}
