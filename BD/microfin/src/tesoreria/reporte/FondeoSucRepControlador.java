package tesoreria.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
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
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import tesoreria.bean.ReqGastosSucBean;
import tesoreria.servicio.TesoMovimientosServicio;




public class FondeoSucRepControlador  extends AbstractCommandController{
	TesoMovimientosServicio tesoMovimientosServicio=null;
	String nombreReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2;
		}
	public FondeoSucRepControlador () {
		setCommandClass(ReqGastosSucBean.class);
 		setCommandName("reqGastosSucBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		ReqGastosSucBean reqGastosSucBean = (ReqGastosSucBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):
		0;
			
	String htmlString= "";
			
		switch(tipoReporte){
			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = FondeoSucursalRepPDF(reqGastosSucBean, nombreReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
				List listaReportes = proxFondeoSucursalExcel(tipoLista,reqGastosSucBean, response);
			break;
		}
		

			return null;
		}
			

		
	// Reporte de  pdf
	public ByteArrayOutputStream FondeoSucursalRepPDF(ReqGastosSucBean reqGastosSucBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {

			htmlStringPDF = tesoMovimientosServicio.creaFondeoSucursalPDF(reqGastosSucBean, nombreReporte);
					
			response.addHeader("Content-Disposition","inline; filename=ReporteFodeo.pdf");
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
		public List  proxFondeoSucursalExcel(int tipoLista,ReqGastosSucBean reqGastosSucBean, HttpServletResponse response){
			List listaFondeo = null;  
			
		listaFondeo = tesoMovimientosServicio.listaReportesFondeo(tipoLista, reqGastosSucBean);
				
		int regExport = 0;
		
	

			try {
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
			
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Reporte Fondeo Sucursales");
			HSSFRow fila= hoja.createRow(0);
			
			// inicio usuario,fecha y hora
			HSSFCell celdaUsu=fila.createCell((short)1);
 
			celdaUsu = fila.createCell((short)6);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)7);
			celdaUsu.setCellValue((!reqGastosSucBean.getNombreUsuario().isEmpty())?reqGastosSucBean.getNombreUsuario(): "TODOS");

			
			String horaVar="";
			String fechaVar=reqGastosSucBean.getParFechaEmision();

			
			int itera=0;
			ReqGastosSucBean AhorroHora = null;
			if(!listaFondeo.isEmpty()){
			for( itera=0; itera<1; itera ++){

				AhorroHora = (ReqGastosSucBean) listaFondeo.get(itera);
				//horaVar= AhorroHora.getHora();
				//fechaVar= AhorroHora.getParFechaEmision();
				
				
				
			}
			}
			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
			celdaFec = fila.createCell((short)6);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)7);
			celdaFec.setCellValue(fechaVar);
			 
			
//			fila = hoja.createRow(2);
//			HSSFCell celdaHora=fila.createCell((short)1);
//			celdaHora = fila.createCell((short)10);
//			celdaHora.setCellValue("Hora:");
//			celdaHora.setCellStyle(estiloNeg8);	
//			celdaHora = fila.createCell((short)11);
//			celdaHora.setCellValue(horaVar);
    // fin susuario,fecha y hora
			fila = hoja.createRow(2);
			HSSFCell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE PARA FONDEO DE SUCURSALES POR DESEMBOLSOS" );
			celda.setCellStyle(estiloCentrado);
	
	
			

		
		   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            7  //ultima celda   (0-based)
		    ));
		    
			
			// Creacion de fila
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			
		//						
			celda = fila.createCell((short)1);
			celda.setCellValue("Núm. Sucursal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Nombre Sucursal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Saldo Caja Atención a Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Saldo Caja Principal");
			celda.setCellStyle(estiloNeg8);
			
		
			celda = fila.createCell((short)5);
			celda.setCellValue("Monto Autorizado Pendiente de Desembolsar en Efectivo");
			celda.setCellStyle(estiloNeg8);
		
	
			celda = fila.createCell((short)6);
			celda.setCellValue("Monto Desembolsado por el Ejecutivo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Recepciones de Bancos del Día ");
			celda.setCellStyle(estiloNeg8);			

	
			

		
			int i=5,iter=0;
			int tamanioLista = listaFondeo.size();
			ReqGastosSucBean reqGastosSuc = null;
			for( iter=0; iter<tamanioLista; iter ++){
			 
				reqGastosSucBean = (ReqGastosSucBean) listaFondeo.get(iter);
				fila=hoja.createRow(i);
				celda=fila.createCell((short)1);
				celda.setCellValue(reqGastosSucBean.getSucursalID());
				
				celda=fila.createCell((short)2);
				celda.setCellValue(reqGastosSucBean.getNombreSucursal());
				
				
				celda=fila.createCell((short)3);
				celda.setCellValue(Utileria.convierteDoble(reqGastosSucBean.getSaldoCajaAntenc()));
				celda.setCellStyle(estiloFormatoDecimal);
			
				
				celda=fila.createCell((short)4);
				celda.setCellValue(Utileria.convierteDoble(reqGastosSucBean.getSaldoCajaPrin()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)5);
				celda.setCellValue(Utileria.convierteDoble(reqGastosSucBean.getPorDesembo()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)6);
				celda.setCellValue(Utileria.convierteDoble(reqGastosSucBean.getDesemboHoy()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)7);
				celda.setCellValue(Utileria.convierteDoble(reqGastosSucBean.getMtoBancosRec()));
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
			

			for(int celd=0; celd<=19; celd++)
			hoja.autoSizeColumn((short)celd);
		
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=FondeoSucursal.xls");
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
			
			
		return  listaFondeo;
		
		
		}

		

		public void setSuccessView(String successView) {
			this.successView = successView;
		}

		

		 public TesoMovimientosServicio getTesoMovimientosServicio() {
		return tesoMovimientosServicio;
	}


	public void setTesoMovimientosServicio(
			TesoMovimientosServicio tesoMovimientosServicio) {
		this.tesoMovimientosServicio = tesoMovimientosServicio;
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

}
