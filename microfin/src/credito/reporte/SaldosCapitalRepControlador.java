package credito.reporte;
   
import java.io.ByteArrayOutputStream;
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

public class SaldosCapitalRepControlador extends AbstractCommandController  {
	
	
	CreditosServicio creditosServicio = null;
	String nomReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
		}
	public SaldosCapitalRepControlador () {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
   
	@Override
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
			
			case Enum_Con_TipRepor.ReporPantalla:
				 htmlString = creditosServicio.reporteSaldosCapitalCredito(creditosBean, nomReporte); 
			break;
				
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = SaldosCapitalCreditoPDF(creditosBean, nomReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
				 List<CreditosBean>listaReportes = SaldosCapitalCreditoExcel(tipoLista,creditosBean,response);
			break;
		}
		
		if(tipoReporte == CreditosBean.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
			
	}
	/*
	String htmlString = creditosServicio.reporteSaldosCapitalCredito(creditosBean, nomReporte); 	
	return new ModelAndView(getSuccessView(), "reporte", htmlString);*/
		
	// Reporte de saldos de capital en pdf
	public ByteArrayOutputStream SaldosCapitalCreditoPDF(CreditosBean creditosBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditosServicio.reporteSaldosCapitalCreditoPDF(creditosBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteSaldosDeCartera.pdf");
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
	public List  SaldosCapitalCreditoExcel(int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
		List listaCreditos=null;
		//List listaCreditos = null;
		listaCreditos = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response); 	
		
		int regExport = 0;


			try {
				
			SXSSFWorkbook libro = new SXSSFWorkbook(100);
			
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			Font fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)10);
			fuenteNegrita8.setFontName("Arial");
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
			Sheet hoja = null;
			hoja =libro.createSheet("Reporte Saldos de Capital");
						
			
			Row fila= hoja.createRow(0);
			Cell celdaUsu=fila.createCell((short)1);
			
			
			celdaUsu = fila.createCell((short)15);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)16);
			celdaUsu.setCellValue((!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");

			
			String horaVar="";
			String fechaVar=creditosBean.getParFechaEmision();

			
			int itera=0;
			ReporteCreditosBean creditoHora = null;
			if(!listaCreditos.isEmpty()){
			for( itera=0; itera<1; itera ++){

				creditoHora = (ReporteCreditosBean) listaCreditos.get(itera);
				horaVar= creditoHora.getHora();
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
			//
			
			fila = hoja.createRow(2);
			Cell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)15);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)16);
			celdaHora.setCellValue(horaVar);
			
			
			Cell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE DE SALDOS DE CARTERA AL DIA "+creditosBean.getFechaInicio());
			
		
		    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            7  //ultima celda   (0-based)
		    ));
		    
		   
			// Creacion de fila
			fila = hoja.createRow(3); // Fila Vacia
			fila = hoja.createRow(4);
			celda = fila.createCell((short)1);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)2);
			celda.setCellValue((!creditosBean.getNombreSucursal().equals("")? creditosBean.getNombreSucursal():"TODOS"));
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Promotor:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)5);
			celda.setCellValue((!creditosBean.getNombrePromotor().equals("")? creditosBean.getNombrePromotor():"TODOS"));
			

			celda = fila.createCell((short)7);
			celda.setCellValue("Producto Crédito:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)8);
			celda.setCellValue((!creditosBean.getNombreProducto().equals("")? creditosBean.getNombreProducto():"TODOS"));
			
			celdaUsu = fila.createCell((short)10);
			celdaUsu.setCellValue("Días de Atraso Inicial:");
			celdaUsu.setCellStyle(estiloNeg8);	
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            4, //primera fila (0-based)
			            4, //ultima fila  (0-based)
			            10, //primer celda (0-based)
			            11  //ultima celda   (0-based)
			    ));
			celdaUsu = fila.createCell((short)12);
			celdaUsu.setCellValue((!creditosBean.getAtrasoInicial().isEmpty())?creditosBean.getAtrasoInicial(): "0");
			
			celdaFec = fila.createCell((short)14);
			celdaFec.setCellValue("Días de Atraso Final:");
			celdaFec.setCellStyle(estiloNeg8);	
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            4, //primera fila (0-based)
			            4, //ultima fila  (0-based)
			            14, //primer celda (0-based)
			            15  //ultima celda   (0-based)
			    ));
			celdaFec = fila.createCell((short)16);
			celdaFec.setCellValue((!creditosBean.getAtrasoFinal().isEmpty())?creditosBean.getAtrasoFinal(): "99999");
				
			
			fila = hoja.createRow(5);
			
			celda=fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("Criterio: ");
			String varCriterio="";
			if(creditosBean.getCriterio().equals("O")){
			varCriterio ="Comercial";
			}else{
				varCriterio ="Contable";
			}
				
			celda=fila.createCell((short)2);
			celda.setCellValue(varCriterio);
							
			
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
			
			fila = hoja.createRow(6);
			
			if("S".equals(creditosBean.getEsproducNomina())){
				celda = fila.createCell((short)1);
				celda.setCellValue("Institución Nómina:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)2);
				celda.setCellValue((!creditosBean.getNombreInstit().equals("")? creditosBean.getNombreInstit():"TODOS"));
				if("S".equals(creditosBean.getManejaConvenio()))
				{
				celda = fila.createCell((short)4);
				celda.setCellValue("Convenio Nómina:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)5);
				celda.setCellValue((!creditosBean.getDesConvenio().equals("")? creditosBean.getDesConvenio():"TODOS"));
				}
			}
		

			fila = hoja.createRow(7);
			
			fila = hoja.createRow(8);
			
			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			//	ID Crédito	No.Cliente	NombreCliente	Id producto,	Monto Original,	Fecha Desembolso,,	Saldo Total

			celda = fila.createCell((short)15);
			celda.setCellValue("Saldo Vigente");
			celda.setCellStyle(estiloCentrado);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				8, 8, 15, 20));
			celda = fila.createCell((short)21);
			celda.setCellValue("Saldo Vencido");
			celda.setCellStyle(estiloNeg8);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				8, 8, 21, 27));
			
			celda = fila.createCell((short)28);
			celda.setCellValue("Otros Accesorios");
			celda.setCellStyle(estiloNeg8);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				8, 8, 28, 30));

			fila = hoja.createRow(9);//NUEVA FILA

			celda = fila.createCell((short)1);	
			celda.setCellValue("No. de Crédito");
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
			celda.setCellValue("ID Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Nombre Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("ID Pro.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Nombre Producto.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Tasa");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Monto Original");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Fecha Desemb.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Fecha Vto. Final");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)14);
			celda.setCellValue("Saldo Total");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)15);
			celda.setCellValue("Capital");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)16);
			celda.setCellValue("Intereses");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)17);
			celda.setCellValue("Moratorios");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)18);
			celda.setCellValue("Cargos");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)19);
			celda.setCellValue("IVA");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)20);
			celda.setCellValue("Total Vigente");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)21);
			celda.setCellValue("Capital");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)22);
			celda.setCellValue("Intereses");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)23);
			celda.setCellValue("Moratorios");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)24);
			celda.setCellValue("Cargos");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)25);
			celda.setCellValue("IVA");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)26);
			celda.setCellValue("Total Vencido");
			celda.setCellStyle(estiloNeg8);		
			
			celda = fila.createCell((short)27);
			celda.setCellValue("Capital Atrasado");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)28);
			celda.setCellValue("Accesorios");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)29);
			celda.setCellValue("Interés Accesorio");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)30);
			celda.setCellValue("IVA (Interés) Accesorio");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)31);
			celda.setCellValue("Comisiones");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)32);
			celda.setCellValue("IVA Accesorios");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)33);
			celda.setCellValue("SaldoFinal");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)34);
			celda.setCellValue("Notas de cargo");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)35);
			celda.setCellValue("IVA notas de cargo");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)36);
			celda.setCellValue("Total Notas de cargo");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)37);
			celda.setCellValue("Días de atraso");
			celda.setCellStyle(estiloNeg8);
			/*Auto Ajusto las Comulmnas*/
			Utileria.autoAjustaColumnas(28, hoja);
		
			int i=10,iter=0;
			int tamanioLista = listaCreditos.size();
			ReporteCreditosBean credito = null;
			for( iter=0; iter<tamanioLista; iter ++){

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
					celda.setCellValue(credito.getProductoCreditoID());

					celda=fila.createCell((short)9);
					celda.setCellValue(credito.getProductoCreDescri());

					celda=fila.createCell((short)10);
					celda.setCellValue(Double.parseDouble(credito.getTasaFija()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)11);
					celda.setCellValue(Double.parseDouble(credito.getMontoCredito()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)12);
					celda.setCellValue(credito.getFechaInicio());
					celda.setCellStyle(estiloDatosCentrado);

					celda=fila.createCell((short)13);
					celda.setCellValue(credito.getFechaVencimiento());
					celda.setCellStyle(estiloDatosCentrado);

					celda=fila.createCell((short)14);
					celda.setCellValue(Double.parseDouble(credito.getTotalVencido()) + Double.parseDouble(credito.getTotalVigente()) );
					celda.setCellStyle(estiloFormatoDecimal);
						
					celda=fila.createCell((short)15);
					celda.setCellValue(Double.parseDouble(credito.getCapitalVigente()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)16);
					celda.setCellValue(Double.parseDouble(credito.getInteresesVigente()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)17);
					celda.setCellValue(Double.parseDouble(credito.getMoraVigente()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)18);
					celda.setCellValue(Double.parseDouble(credito.getCargosVigente()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)19);
					celda.setCellValue(Double.parseDouble(credito.getIvaVigente()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)20);
					celda.setCellValue(Double.parseDouble(credito.getTotalVigente()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					//VENCIDOS
					celda=fila.createCell((short)21);
					celda.setCellValue(Double.parseDouble(credito.getCapitalVencido()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)22);
					celda.setCellValue(Double.parseDouble(credito.getInteresesVencido()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)23);
					celda.setCellValue(Double.parseDouble(credito.getMoraVencido()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)24);
					celda.setCellValue(Double.parseDouble(credito.getCargosVencido()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)25);
					celda.setCellValue(Double.parseDouble(credito.getIvaVencido()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)26);
					celda.setCellValue(Double.parseDouble(credito.getTotalVencido()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)27);
					celda.setCellValue(Double.parseDouble(credito.getCapitalAtrasado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)28);
					celda.setCellValue(Double.parseDouble(credito.getAccesorios()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)29);
					celda.setCellValue(Double.parseDouble(credito.getInteresAccesorios()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)30);
					celda.setCellValue(Double.parseDouble(credito.getIvaInteresAccesorios()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)31);
					celda.setCellValue(Double.parseDouble(credito.getComisiones()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)32);
					celda.setCellValue(Double.parseDouble(credito.getIvaComisiones()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)33);
					celda.setCellValue(Double.parseDouble(credito.getTotalVencido()) + Double.parseDouble(credito.getTotalVigente())+
									   Double.parseDouble(credito.getAccesorios())+Double.parseDouble(credito.getIvaComisiones()) + 
									   Double.parseDouble(credito.getInteresAccesorios()) + Double.parseDouble(credito.getIvaInteresAccesorios()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)34);
					celda.setCellValue(Double.parseDouble(credito.getNotasCargo()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)35);
					celda.setCellValue(Double.parseDouble(credito.getIvaNotasCargo()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)36);
					celda.setCellValue(Double.parseDouble(credito.getTotalNotasCargo()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)37);
					celda.setCellValue(credito.getDiasAtraso());
					celda.setCellStyle(estiloDatosCentrado);
					
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
			response.addHeader("Content-Disposition","inline; filename=ReporteSaldosDeCartera.xlsx");
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

