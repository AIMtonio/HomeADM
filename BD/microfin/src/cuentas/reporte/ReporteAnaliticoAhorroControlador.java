package cuentas.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.AnaliticoAhorroBean;
import cuentas.servicio.CuentasAhoServicio;
   
public class ReporteAnaliticoAhorroControlador  extends AbstractCommandController{

	CuentasAhoServicio cuentasAhoServicio= null;
	String nomReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2;
		}
	public ReporteAnaliticoAhorroControlador () {
		setCommandClass(AnaliticoAhorroBean.class);
		setCommandName("analiticoAhorroBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		AnaliticoAhorroBean analiticoAhorroBean = (AnaliticoAhorroBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):
		0;
			
	String htmlString= "";
			
		switch(tipoReporte){
			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = AnaliticoAhorroRepPDF(analiticoAhorroBean, nomReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
				List listaReportes = proxAnaliticoAhorroExcel(tipoLista,analiticoAhorroBean,response);
			break;
		}
		

			return null;
		}
			
	

		
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream AnaliticoAhorroRepPDF(AnaliticoAhorroBean analiticoAhorroBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = cuentasAhoServicio.creaRepAnaliticoAhorroPDF(analiticoAhorroBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteAnaliticoAhorro.pdf");
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
		
	
	//Reporte de analitico ahorro en excel
	public List  proxAnaliticoAhorroExcel(int tipoLista, AnaliticoAhorroBean analiticoAhorroBean, HttpServletResponse response){
		List listaAnalitico=null;  
		//List listaCreditos = null;
		listaAnalitico = cuentasAhoServicio.listaReportesCuentas(tipoLista,analiticoAhorroBean,response); 	
		 
		int regExport = 0;
		
	

		try {
			Workbook libro = new SXSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			Font fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)10);
			fuenteNegrita8.setFontName("Arial");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			Font fuenteTexto= libro.createFont();
			fuenteTexto.setFontHeightInPoints((short)10);
			fuenteTexto.setFontName("Arial");
			
			//Estilo negrita de 8  para encabezados del reporte
			CellStyle estiloTexto = libro.createCellStyle();
			estiloTexto.setFont(fuenteTexto);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			
			//Estilo negrita de 8  para encabezados del reporte
			CellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			CellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			
			CellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo negrita de 8  y color de fondo
			CellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			estiloFormatoDecimal.setFont(fuenteTexto);
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja					
			SXSSFSheet hoja = (SXSSFSheet) libro.createSheet("Reporte Analítico Ahorro");
			Row fila= hoja.createRow(0);
			
			// inicio usuario,fecha y hora
			Cell celdaUsu=fila.createCell((short)1);
 
			celdaUsu = fila.createCell((short)10);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)11);
			celdaUsu.setCellValue((!analiticoAhorroBean.getNombreUsuario().isEmpty())?analiticoAhorroBean.getNombreUsuario(): "TODOS");
			celdaUsu.setCellStyle(estiloTexto);

			String horaVar  = analiticoAhorroBean.getHora();
			String fechaVar = analiticoAhorroBean.getFechaEmision();
			
			int itera=0;
			AnaliticoAhorroBean AhorroHora = null;
			if(!listaAnalitico.isEmpty()){
				for( itera=0; itera<1; itera ++){
					AhorroHora = (AnaliticoAhorroBean) listaAnalitico.get(itera);
					horaVar  = AhorroHora.getHora();
					fechaVar = AhorroHora.getFechaEmision();
				}
			}
			
			fila = hoja.createRow(1);
			Cell celdaFec=fila.createCell((short)1);
			celdaFec.setCellValue(analiticoAhorroBean.getNombreInstitucion());
			celdaFec.setCellStyle(estiloNeg10);
			hoja.addMergedRegion(new CellRangeAddress(
				//funcion para unir celdas
				1, //primera fila (0-based)
			    1, //ultima  fila (0-based)
			    1, //primer celda (0-based)
			    9 //ultima celda (0-based)
			));
			
			celdaFec = fila.createCell((short)10);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)11);
			celdaFec.setCellValue(fechaVar);
			celdaFec.setCellStyle(estiloTexto);

			fila = hoja.createRow(2);	
			Cell celda=fila.createCell((short)1);
			celda.setCellValue("REPORTE DE ANALÍTICO AHORRO" );
			celda.setCellStyle(estiloNeg10);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            9  //ultima celda   (0-based)
		    ));
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)11);
			celda.setCellValue(horaVar);
			celda.setCellStyle(estiloTexto);
			
			// Creacion de fila
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			
			Cell celdaParametros = fila.createCell((short)1);
			celdaParametros = fila.createCell((short)1);
			celdaParametros.setCellValue("Cliente:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaParametros = fila.createCell((short)2);
			celdaParametros.setCellValue(analiticoAhorroBean.getNombreCliente());
			celdaParametros.setCellStyle(estiloTexto);
			
			celdaParametros = fila.createCell((short)4);
			celdaParametros.setCellValue("Tipo Cuenta:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaParametros = fila.createCell((short)5);
			celdaParametros.setCellValue(analiticoAhorroBean.getNombreTipocuenta());
			celdaParametros.setCellStyle(estiloTexto);
			
			celdaParametros = fila.createCell((short)7);
			celdaParametros.setCellValue("Sucursal:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaParametros = fila.createCell((short)8);
			celdaParametros.setCellValue(analiticoAhorroBean.getNombreSucursal());
			celdaParametros.setCellStyle(estiloTexto);
			
			celdaParametros = fila.createCell((short)10);
			celdaParametros.setCellValue("Cuenta:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaParametros = fila.createCell((short)11);
			celdaParametros.setCellValue(analiticoAhorroBean.getNombreCuentaAho());
			celdaParametros.setCellStyle(estiloTexto);
			
			fila = hoja.createRow(5);
			Cell celdaParametros2 = fila.createCell((short)1);
			celdaParametros2 = fila.createCell((short)1);
			celdaParametros2.setCellValue("Moneda:");
			celdaParametros2.setCellStyle(estiloNeg8);
			celdaParametros2 = fila.createCell((short)2);
			celdaParametros2.setCellValue(analiticoAhorroBean.getNombreMoneda());
			celdaParametros2.setCellStyle(estiloTexto);
			
			celdaParametros2 = fila.createCell((short)4);
			celdaParametros2.setCellValue("Promotor:");
			celdaParametros2.setCellStyle(estiloNeg8);
			celdaParametros2 = fila.createCell((short)5);
			celdaParametros2.setCellValue(analiticoAhorroBean.getNombrePromotorI());
			celdaParametros2.setCellStyle(estiloTexto);
			
			celdaParametros2 = fila.createCell((short)7);
			celdaParametros2.setCellValue("Genero:");
			celdaParametros2.setCellStyle(estiloNeg8);
			celdaParametros2 = fila.createCell((short)8);
			celdaParametros2.setCellValue(analiticoAhorroBean.getNombreGenero());
			celdaParametros2.setCellStyle(estiloTexto);
			
			celdaParametros2 = fila.createCell((short)10);
			celdaParametros2.setCellValue("Estado:");
			celdaParametros2.setCellStyle(estiloNeg8);
			celdaParametros2 = fila.createCell((short)11);
			celdaParametros2.setCellValue(analiticoAhorroBean.getNombreEstado());
			celdaParametros2.setCellStyle(estiloTexto);
		
			fila = hoja.createRow(6);
			Cell celdaParametros3 = fila.createCell((short)1);
			celdaParametros3 = fila.createCell((short)1);
			celdaParametros3.setCellValue("Municipio:");
			celdaParametros3.setCellStyle(estiloNeg8);
			celdaParametros3 = fila.createCell((short)2);
			celdaParametros3.setCellValue(analiticoAhorroBean.getNombreMunicipio());
			celdaParametros3.setCellStyle(estiloTexto);
			
			fila = hoja.createRow(7);
			fila = hoja.createRow(8);
			celda = fila.createCell((short)1);
			celda.setCellValue("Nombre del Cliente");
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("RFC Oficial");
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("N° Cuenta");
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Etiqueta");
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloDatosCentrado);
	
			celda = fila.createCell((short)6);
			celda.setCellValue("Saldo Ini. Mes");
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Cargos Mes");
			celda.setCellStyle(estiloDatosCentrado);			

			celda = fila.createCell((short)8);
			celda.setCellValue("Abonos del Mes");
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Saldo");
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Saldo Bloq.");
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Saldo Disp.");
			celda.setCellStyle(estiloDatosCentrado);		
			

			int i=9,iter=0;
			int tamanioLista = listaAnalitico.size();
			AnaliticoAhorroBean analiticoAhorro = null;
			for( iter=0; iter<tamanioLista; iter ++){
			 
				analiticoAhorroBean = (AnaliticoAhorroBean) listaAnalitico.get(iter);
				fila=hoja.createRow(i);
				celda=fila.createCell((short)1);
				celda.setCellValue(analiticoAhorroBean.getNombreCliente());
				celda.setCellStyle(estiloTexto);
				
				celda=fila.createCell((short)2);
				celda.setCellValue(analiticoAhorroBean.getRFOficial());
				celda.setCellStyle(estiloTexto);
				
				celda=fila.createCell((short)3);
				celda.setCellValue(analiticoAhorroBean.getCuentasAho());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(analiticoAhorroBean.getEtiqueta());
				celda.setCellStyle(estiloTexto);
				
				celda=fila.createCell((short)5);
				celda.setCellValue(analiticoAhorroBean.getEstatus());
				celda.setCellStyle(estiloTexto);
				
				celda=fila.createCell((short)6);
				celda.setCellValue(Utileria.convierteDoble(analiticoAhorroBean.getSaldoInicioMes()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)7);
				celda.setCellValue(Utileria.convierteDoble(analiticoAhorroBean.getCargoEnMes()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)8);
				celda.setCellValue(Utileria.convierteDoble(analiticoAhorroBean.getAbonoEnMes()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)9);
				celda.setCellValue(Utileria.convierteDoble(analiticoAhorroBean.getSaldoAlDia()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)10);
				celda.setCellValue(Utileria.convierteDoble(analiticoAhorroBean.getSaldoBloqueado()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)11);
			    celda.setCellValue(Utileria.convierteDoble(analiticoAhorroBean.getSaldoDisponible()));
				celda.setCellStyle(estiloFormatoDecimal);
				i++;
			}
			 
			i = i+1;
			fila=hoja.createRow(i);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			i = i+1;
			fila=hoja.createRow(i);
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);
			celda.setCellStyle(estiloTexto);
			

			for(int celd=0; celd<=19; celd++)
			hoja.autoSizeColumn((short)celd);
		
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepAnaliticoAhorro.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			}catch(Exception e){
				loggerSAFI.info("Error al crear el reporte: " + e.getMessage());
				e.printStackTrace();
			}
		
		return  listaAnalitico;

	}
	
	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
