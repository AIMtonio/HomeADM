package credito.reporte;

import herramientas.Utileria;
import soporte.dao.GenDinamicoRepDAO.Enum_Con_Reporte;
import soporte.dao.GenDinamicoRepDAO.Enum_Tipo_Dato;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.bean.RepVencimiBean;
import credito.servicio.CreditosServicio;
   
public class RepVencimientosControlador  extends AbstractCommandController{

	CreditosServicio creditosServicio = null;
	String nomReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
		}
	public RepVencimientosControlador () {
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
				ByteArrayOutputStream htmlStringPDF = VencimientosRepPDF(creditosBean, nomReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
				 List listaReportes = proxVencimientosExcel(tipoLista,creditosBean,response);
			break;
		}
		
		if(tipoReporte == CreditosBean.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
			
	}

		
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream VencimientosRepPDF(CreditosBean creditosBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditosServicio.creaRepVencimientosPDF(creditosBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteProxVencimientos.pdf");
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
		

	public List  proxVencimientosExcel(int tipoLista,CreditosBean bean,  HttpServletResponse response){
		List listaCreditos=null;
		try {
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			String hora = postFormater.format(calendario.getTime());

			//List listaCreditos = null;
			CreditosBean bean2 = bean;
			listaCreditos = creditosServicio.listaReportesCreditos(tipoLista,bean2,response); 

			SXSSFSheet hoja = null;
			SXSSFWorkbook libro = null;
			libro = new SXSSFWorkbook();
			/********************** DECLARACION DE LOS ELEMENTOS PARA EL DISEÑO DEL REPORTE *************************************/
			// Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);

			Font fuenteNegrita10Izq = libro.createFont();
			fuenteNegrita10Izq.setFontHeightInPoints((short) 10);
			fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10Izq.setBoldweight(Font.BOLDWEIGHT_BOLD);

			// Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			Font fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short) 8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);

			// Fuente encabezado del reporte
			Font fuenteEncabezado = libro.createFont();
			fuenteEncabezado.setFontHeightInPoints((short) 8);
			fuenteEncabezado.setFontName(HSSFFont.FONT_ARIAL);
			fuenteEncabezado.setBoldweight(Font.BOLDWEIGHT_BOLD);

			Font fuentecentrado = libro.createFont();
			fuentecentrado.setFontHeightInPoints((short) 8);
			fuentecentrado.setFontName(HSSFFont.FONT_ARIAL);
			Font fuentecentradoSinResultados = libro.createFont();
			fuentecentradoSinResultados.setFontHeightInPoints((short) 8);
			fuentecentradoSinResultados.setFontName(HSSFFont.FONT_ARIAL);
			fuentecentradoSinResultados.setColor(HSSFColor.GREY_40_PERCENT.index);

			// Crea un Fuente con tamaño 8 para informacion del reporte.
			Font fuente8 = libro.createFont();
			fuente8.setFontHeightInPoints((short) 8);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);

			Font fuenteDatos = libro.createFont();
			fuenteDatos.setFontHeightInPoints((short) 8);
			fuenteDatos.setFontName(HSSFFont.FONT_ARIAL);

			Font fuente8Decimal = libro.createFont();
			fuente8Decimal.setFontHeightInPoints((short) 8);
			fuente8Decimal.setFontName(HSSFFont.FONT_ARIAL);

			Font fuente8Cuerpo = libro.createFont();
			fuente8Cuerpo.setFontHeightInPoints((short) 8);
			fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);

			// Crea un Fuente con tamaño 8 para informacion del reporte.
			Font fuente10 = libro.createFont();
			fuente10.setFontHeightInPoints((short) 10);
			fuente10.setFontName(HSSFFont.FONT_ARIAL);

			// La fuente se mete en un estilo para poder ser usada.
			// Estilo negrita de 10 para el titulo del reporte
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);

			//Alineado a la izq
			CellStyle estiloNeg10Izq = libro.createCellStyle();
			estiloNeg10Izq.setFont(fuenteNegrita10Izq);
			estiloNeg10Izq.setAlignment(CellStyle.ALIGN_LEFT);

			//Estilo negrita de 8  para encabezados del reporte
			CellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			// Estilo de datos centrados 
			CellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteEncabezado);
			estiloCentrado.setAlignment(CellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

			CellStyle estiloCentradoDatos = libro.createCellStyle();
			estiloCentradoDatos.setFont(fuentecentrado);
			estiloCentradoDatos.setAlignment(CellStyle.ALIGN_CENTER);
			estiloCentradoDatos.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

			CellStyle estiloCentradoSinresultados = libro.createCellStyle();
			estiloCentradoSinresultados.setFont(fuentecentradoSinResultados);
			estiloCentradoSinresultados.setAlignment(CellStyle.ALIGN_CENTER);
			estiloCentradoSinresultados.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

			CellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuenteDatos);
			estilo8.setAlignment(CellStyle.ALIGN_LEFT);
			estilo8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

			CellStyle estilo10 = libro.createCellStyle();
			estilo10.setFont(fuente10);
			estilo10.setAlignment(CellStyle.ALIGN_LEFT);
			estilo10.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
			estiloFormatoDecimal.setFont(fuente8);

			CellStyle estiloDecimalSinSimbol = libro.createCellStyle();
			DataFormat format2 = libro.createDataFormat();
			estiloDecimalSinSimbol.setDataFormat(format2.getFormat("#,###,##0.00"));
			estiloDecimalSinSimbol.setFont(fuente8Decimal);
			estiloDecimalSinSimbol.setAlignment(CellStyle.ALIGN_RIGHT);

			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimalTit = libro.createCellStyle();
			DataFormat formatTit = libro.createDataFormat();
			estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
			estiloFormatoDecimalTit.setFont(fuenteNegrita8);

			/********************** FIN DECLARACION DE LOS ELEMENTOS PARA EL DISEÑO DEL REPORTE ********************************* */
			/************************************************ ENCABEZADO DEL REPORTE ******************************************** */
			String nombreHoja="Reporte Vencimientos";

			hoja = (SXSSFSheet) libro.createSheet(nombreHoja);

			int tam=22;

			int columnaInfo		= tam - 1;
			int filaN=1;
			Row fila = hoja.createRow(filaN);
			/** ========= FIN NOMBRE INSTITUCION ===========**/
			Cell celdaInst = fila.createCell((short) 1);
			celdaInst.setCellValue(bean.getNombreInstitucion());
			celdaInst.setCellStyle(estiloNeg10);

			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					1, //primera fila (0-based)
					1, //ultima fila  (0-based)
					1, //primer celda (0-based)
					tam -3 //ultima celda   (0-based)
					));
			celdaInst.setCellStyle(estiloNeg10);
			/** ========= FIN NOMBRE INSTITUCION ===========**/
			Cell celdaUsu = fila.createCell(columnaInfo);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg10Izq);
			celdaUsu = fila.createCell(columnaInfo+1);
			System.out.println("USua:"+bean.getNombreUsuario());
			celdaUsu.setCellValue(bean.getNombreUsuario());
			celdaUsu.setCellStyle(estilo10);
			filaN++;
			fila = hoja.createRow(filaN);
			/** ============ NOMBRE REPORTE ================**/
			Cell celda2 = fila.createCell((short) 1);
			celda2.setCellValue("REPORTE DE VENCIMIENTOS DEL DÍA "+bean.getFechaInicio()+" AL DÍA "+bean.getFechaVencimien());
			celda2.setCellStyle(estiloNeg10);

			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					2, //primera fila (0-based)
					2, //ultima fila  (0-based)
					1, //primer celda (0-based)
					tam -3 //ultima celda   (0-based)
					));
			celda2.setCellStyle(estiloNeg10);
			/** ============ FIN NOMBRE REPORTE ==============**/
			String fechaVar = (bean.getFechaSistema()!=null?bean.getFechaSistema().toString():"");
			Cell celdaFec = fila.createCell(columnaInfo);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg10Izq);
			celdaFec = fila.createCell(columnaInfo+1);
			celdaFec.setCellValue(fechaVar);
			celdaFec.setCellStyle(estilo10);
			filaN++;
			fila = hoja.createRow(filaN);
			Cell celdaHora = fila.createCell(columnaInfo);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg10Izq);
			celdaHora = fila.createCell(columnaInfo+1);
			celdaHora.setCellValue(hora);
			celdaHora.setCellStyle(estilo10);



			/************************************************FIN ENCABEZADO DEL REPORTE ******************************************** */
			/****************************************************** FILTRO REPORTE ************************************************* */
			int col=1;
			int ncel=1;
			filaN=5;
			fila = hoja.createRow(filaN++);

			/*Nombre Filtro*/
			Cell cel= fila.createCell(col);
			cel.setCellValue("Sucursal:");
			cel.setCellStyle(estiloNeg10Izq);
			/*Valor Filtro*/
			col=col + 1;
			Cell celVal= fila.createCell(col);
			celVal.setCellValue(bean.getNombreSucursal());
			celVal.setCellStyle(estilo10);
			col+=1;
			ncel++;
			col++;
			/*Nombre Filtro*/
			cel= fila.createCell(col);
			cel.setCellValue("Moneda:");
			cel.setCellStyle(estiloNeg10Izq);
			/*Valor Filtro*/
			col+=1;
			celVal= fila.createCell(col);
			celVal.setCellValue(bean.getNombreMoneda());
			celVal.setCellStyle(estilo10);
			col+=1;
			ncel++;
			col++;
			/*Nombre Filtro*/
			cel= fila.createCell(col);
			cel.setCellValue("Producto:");
			cel.setCellStyle(estiloNeg10Izq);
			/*Valor Filtro*/
			col+=1;
			celVal= fila.createCell(col);
			celVal.setCellValue(bean.getNombreProducto());
			celVal.setCellStyle(estilo10);
			col+=1;
			ncel++;
			col++;
			/*Nombre Filtro*/
			cel= fila.createCell(col);
			cel.setCellValue("Promotor:");
			cel.setCellStyle(estiloNeg10Izq);
			/*Valor Filtro*/
			col+=1;
			celVal= fila.createCell(col);
			celVal.setCellValue(bean.getNombrePromotor());
			celVal.setCellStyle(estilo10);
			col+=1;
			ncel++;
			col++;
			/*Nombre Filtro*/
			cel= fila.createCell(col);
			cel.setCellValue("Genero:");
			cel.setCellStyle(estiloNeg10Izq);
			/*Valor Filtro*/
			col+=1;
			celVal= fila.createCell(col);
			celVal.setCellValue(bean.getNombreGenero());
			celVal.setCellStyle(estilo10);
			col+=1;
			ncel++;
			col++;

			/*Nombre Filtro*/
			cel= fila.createCell(col);
			cel.setCellValue("Estado:");
			cel.setCellStyle(estiloNeg10Izq);
			/*Valor Filtro*/
			col+=1;
			celVal= fila.createCell(col);
			celVal.setCellValue(bean.getNombreEstado());
			celVal.setCellStyle(estilo10);
			col+=1;
			ncel++;
			col++;
			/*Nombre Filtro*/
			cel= fila.createCell(col);
			cel.setCellValue("Municipio:");
			cel.setCellStyle(estiloNeg10Izq);
			/*Valor Filtro*/
			col+=1;
			celVal= fila.createCell(col);
			celVal.setCellValue(bean.getNombreMunicipi());
			celVal.setCellStyle(estilo10);
			col+=1;
			ncel++;
			col++;
			col=1;
			ncel=1;
			fila = hoja.createRow(filaN);
			/*Nombre Filtro*/
			cel= fila.createCell(col);
			cel.setCellValue("Días de Atraso Inicial:");
			cel.setCellStyle(estiloNeg10Izq);
			/*Valor Filtro*/
			col+=1;
			celVal= fila.createCell(col);
			celVal.setCellValue((!bean.getAtrasoInicial().isEmpty())?bean.getAtrasoInicial(): "99999");
			celVal.setCellStyle(estilo10);
			col+=1;
			ncel++;
			col++;
			/*Nombre Filtro*/
			cel= fila.createCell(col);
			cel.setCellValue("Días de Atraso Final:");
			cel.setCellStyle(estiloNeg10Izq);
			/*Valor Filtro*/
			col+=1;
			celVal= fila.createCell(col);
			celVal.setCellValue((!bean.getAtrasoFinal().isEmpty())?bean.getAtrasoFinal(): "99999");
			celVal.setCellStyle(estilo10);
			col+=1;
			ncel++;
			col++;
				if("S".equals(bean.getEsNomina())){
				/*Nombre Filtro*/
				cel= fila.createCell(col);
				cel.setCellValue("Institución Nómina:");
				cel.setCellStyle(estiloNeg10Izq);
				/*Valor Filtro*/
				col+=1;
				celVal= fila.createCell(col);
				celVal.setCellValue((!bean.getNombreInstit().isEmpty())?bean.getNombreInstit():"TODAS");
				celVal.setCellStyle(estilo10);
				col+=1;
				ncel++;
				col++;
				if("S".equals(bean.getManejaConvenio()))
					{	
				/*Nombre Filtro*/
				cel= fila.createCell(col);
				cel.setCellValue("Convenio Nómina:");
				cel.setCellStyle(estiloNeg10Izq);
				/*Valor Filtro*/
				col+=1;
				celVal= fila.createCell(col);
				celVal.setCellValue((!bean.getDesConvenio().isEmpty())?bean.getDesConvenio():"TODOS");
				celVal.setCellStyle(estilo10);
				col+=1;
				ncel++;
				col++;
				}
			}


						
			/**************************************************** FIN FILTRO REPORTE *********************************************** */
			/********************************************************** COLUMNAS *************************************************** */
			filaN++;
			filaN++;
			fila = hoja.createRow(filaN);
			Cell celda = fila.createCell(ncel++);
			celda = fila.createCell((short)1);
			celda.setCellValue("Crédito ID");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)2);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)3);
			celda.setCellValue("Grupo ID");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)(4));
			celda.setCellValue("Nombre Grupo");
			celda.setCellStyle(estiloCentrado);
			//////////// Producto de nomina			
			int ultCol=4;
			int incCol=0;

			if(bean.getEsNomina().equalsIgnoreCase("S")){
				incCol=incCol+1;
				celda = fila.createCell((short)(ultCol+incCol));
				celda.setCellValue("Institución Nómina");
				celda.setCellStyle(estiloCentrado);
	
				incCol=incCol+1;
				celda = fila.createCell((short)(ultCol+incCol));
				celda.setCellValue("Convenio");
				celda.setCellStyle(estiloCentrado);
			}

			celda = fila.createCell((short)(5+incCol));
			celda.setCellValue("Cliente ID");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)(6+incCol));
			celda.setCellValue("Nombre del Cliente");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)(7+incCol));
			celda.setCellValue("Monto Original");
			celda.setCellStyle(estiloCentrado);			

			celda = fila.createCell((short)(8+incCol));
			celda.setCellValue("Fecha Desembolso");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)(9+incCol));
			celda.setCellValue("Fecha vto Final");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)(10+incCol));
			celda.setCellValue("Saldo Total");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)(11+incCol));
			celda.setCellValue("Detalle de Vencimientos");
			celda.setCellStyle(estiloCentrado);		


			hoja.addMergedRegion(new CellRangeAddress(
					filaN, filaN, (11+incCol), (18+incCol)  
					));

			celda = fila.createCell((short)19);
			celda.setCellValue("Pago");
			celda.setCellStyle(estiloCentrado);		


			hoja.addMergedRegion(new CellRangeAddress(
					filaN, filaN, (19+incCol), (20+incCol) 
					));

			//	  Comisiones	Otros cargos	
			filaN++;
			fila = hoja.createRow(filaN);//NUEVA FILA

			celda = fila.createCell((short)(11+incCol));
			celda.setCellValue("Fecha Vto");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)(12+incCol));
			celda.setCellValue("Capital");
			celda.setCellStyle(estiloCentrado);	

			celda = fila.createCell((short)(13+incCol));
			celda.setCellValue("Interés");
			celda.setCellStyle(estiloCentrado);	

			celda = fila.createCell((short)(14+incCol));
			celda.setCellValue("Moratorios");
			celda.setCellStyle(estiloCentrado);	

			celda = fila.createCell((short)(15+incCol));
			celda.setCellValue("Comisiones");
			celda.setCellStyle(estiloCentrado);	

			celda = fila.createCell((short)(16+incCol));
			celda.setCellValue("Cargos");
			celda.setCellStyle(estiloCentrado);	


			celda = fila.createCell((short)(17+incCol));
			celda.setCellValue("IVA");
			celda.setCellStyle(estiloCentrado);	

			celda = fila.createCell((short)(18+incCol));
			celda.setCellValue("Total Cuota");
			celda.setCellStyle(estiloCentrado);	

			celda = fila.createCell((short)(19+incCol));
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)(20+incCol));
			celda.setCellValue("Fecha");
			celda.setCellStyle(estiloCentrado);	

			celda = fila.createCell((short)(21+incCol));
			celda.setCellValue("Días Atraso");
			celda.setCellStyle(estiloCentrado);	
			/******************************************************* FIN COLUMNAS ************************************************** */
			/*********************************************************** FILAS ***************************************************** */
			int totalFilas;
			int i=filaN,iter=0;
			int tamanioLista = listaCreditos.size();
			RepVencimiBean credito = null;
			totalFilas=listaCreditos.size();
			for( iter=0; iter<tamanioLista; iter ++){
				filaN++;
				credito = (RepVencimiBean) listaCreditos.get(iter);
				fila=hoja.createRow(filaN);
				// CreditoID,ClienteID,NombreCompleto,MontoCredito,FechaInicio,
				celda=fila.createCell((short)1);
				celda.setCellValue(credito.getCreditoID());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)2);
				celda.setCellValue(credito.getEstatus());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)3); //Agragado
				celda.setCellValue(credito.getGrupoID());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)4);
				celda.setCellValue(credito.getNombreGrupo()); //Agregado
				celda.setCellStyle(estilo8);
				//////Si es producto de nomina
				if(bean.getEsNomina().equalsIgnoreCase("S")){
					celda=fila.createCell((short)5);
					celda.setCellValue(credito.getInstitucionNominaID());
					celda.setCellStyle(estilo8);
					celda=fila.createCell((short)6);
					celda.setCellValue(credito.getConvenioNominaID());
					celda.setCellStyle(estilo8);
				}
				//fin si es producto de nomina

				celda=fila.createCell((short)5+incCol);
				celda.setCellValue(credito.getClienteID());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)(6+incCol));
				celda.setCellValue(credito.getNombreCompleto());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)(7+incCol));
				celda.setCellValue(Double.parseDouble(credito.getMontoCredito()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)(8+incCol));
				celda.setCellValue(credito.getFechaInicio());
				celda.setCellStyle(estiloCentradoDatos);

				celda=fila.createCell((short)(9+incCol));
				celda.setCellValue(credito.getFechaVencimien());
				celda.setCellStyle(estiloCentradoDatos);

				celda=fila.createCell((short)(10+incCol));
				celda.setCellValue(Double.parseDouble(credito.getSaldoTotal()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)(11+incCol));
				celda.setCellValue(credito.getFechaVencim());
				celda.setCellStyle(estiloCentradoDatos);

				celda=fila.createCell((short)(12+incCol));
				celda.setCellValue(Double.parseDouble(credito.getCapital()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)(13+incCol));
				celda.setCellValue(Double.parseDouble(credito.getInteres()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)(14+incCol));
				celda.setCellValue(Double.parseDouble(credito.getMoratorios()));
				celda.setCellStyle(estiloFormatoDecimal);

				// Comisiones,Cargos,AmortizacionID,IVATotal,CobraIVAMora,
				celda=fila.createCell((short)(15+incCol));
				celda.setCellValue(Double.parseDouble(credito.getComisiones()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)(16+incCol));
				celda.setCellValue(Double.parseDouble(credito.getCargos()));
				celda.setCellStyle(estiloFormatoDecimal);


				celda=fila.createCell((short)(17+incCol));
				celda.setCellValue(Double.parseDouble(credito.getIVATotal()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)(18+incCol));
				celda.setCellValue(Double.parseDouble(credito.getTotalCuota()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)(19+incCol));
				celda.setCellValue(Double.parseDouble(credito.getPago()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)(20+incCol));
				celda.setCellValue(credito.getFechaPago());
				celda.setCellStyle(estiloCentradoDatos);	

				celda=fila.createCell((short)(21+incCol));
				celda.setCellValue(credito.getDiasAtraso());
				celda.setCellStyle(estilo8);
				i++;
			}
			
			filaN=filaN+2;
			fila = hoja.createRow(filaN);
			Cell celdaF = fila.createCell((short) 1);
			celdaF.setCellValue("Registros Exportados:");
			celdaF.setCellStyle(estiloNeg8);
			filaN=filaN+1;
			fila = hoja.createRow(filaN);
			celdaF = fila.createCell((short) 1);
			celdaF.setCellValue(totalFilas);
			
			/******************************************************** FIN FILAS *************************************************** */
			/************************************************** CREACION DEL ARCHIVO *********************************************** */
			response.addHeader("Content-Disposition", "inline; filename=RepVencimientos.xlsx");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			/************************************************ FIN ARCHIVO ******************************************** */
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
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
