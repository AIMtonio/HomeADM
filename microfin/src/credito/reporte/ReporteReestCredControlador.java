 
 
 package credito.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
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

import credito.bean.ReestrucCreditoBean;
import credito.bean.RepReestrucCreBean;
import credito.servicio.ReestrucCreditoServicio;
   
public class ReporteReestCredControlador  extends AbstractCommandController{

	ReestrucCreditoServicio reestrucCreditoServicio = null;
	ParametrosSesionBean parametrosSesionBean;
	String nomReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
		  int  ReporPantalla= 1 ;
		}
	public ReporteReestCredControlador () {
		setCommandClass(ReestrucCreditoBean.class);
		setCommandName("creditosBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		ReestrucCreditoBean reestrucCreditoBean = (ReestrucCreditoBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):
		0;
			
	String htmlString= "";
			
		switch(tipoReporte){
			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = reestrucCreditRepPDF(reestrucCreditoBean, nomReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
				 List listaReportes = reestrucCreditRepExcel(tipoLista,reestrucCreditoBean,response);
			break;
		}
		
		if(tipoReporte == Enum_Con_TipRepor.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
			
	}

		
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream reestrucCreditRepPDF(ReestrucCreditoBean reestrucCreditoBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = reestrucCreditoServicio.reporteReestrucCondPDF(reestrucCreditoBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=RepReestructurasCred.pdf");
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
		 public List  reestrucCreditRepExcel(int tipoLista,ReestrucCreditoBean reestrucCreditoBean,  HttpServletResponse response){
		List listaCreditos=null;
	
    	listaCreditos = reestrucCreditoServicio.reporteExceReestruc(reestrucCreditoBean, tipoLista);
		 
		int regExport = 0;
		
		if(listaCreditos != null){
			
			Calendar calendario = Calendar.getInstance();
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
			estiloNeg10.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
			
			HSSFCellStyle estiloDatosCentradoNeg = libro.createCellStyle();
			estiloDatosCentradoNeg.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
			estiloDatosCentradoNeg.setFont(fuenteNegrita8);
			
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
			HSSFSheet hoja = libro.createSheet("Reporte Reestructuras de Crédito");
			HSSFRow fila= hoja.createRow(0);
			
			// inicio usuario,fecha y hora
			HSSFCell celdaUsu=fila.createCell((short)1);
 
			celdaUsu = fila.createCell((short)15);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)16);
			celdaUsu.setCellValue((!reestrucCreditoBean.getNomUsuario().isEmpty())?reestrucCreditoBean.getNomUsuario(): "");

			
			String horaVar="";
			String fechaVar=reestrucCreditoBean.getFechaEmision();

			
		 
			int hora =calendario.get(Calendar.HOUR_OF_DAY);
			int minutos = calendario.get(Calendar.MINUTE);
			int segundos = calendario.get(Calendar.SECOND);
			
			String h = Integer.toString(hora);
			String m = "";
			String s = "";
			if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
			if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);
			
				 
			horaVar= h+":"+m+":"+s;
				 
				
			 
			fila = hoja.createRow(1);
			HSSFCell celda=fila.createCell((short)1);			
			celda.setCellValue(reestrucCreditoBean.getNomInstitucion());
			celda.setCellStyle(estiloNeg10);
			hoja.addMergedRegion(new CellRangeAddress( 1, 1, 1, 12 ));
			
			celda = fila.createCell((short)15);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)16);
			celda.setCellValue(fechaVar);
			 
			
			fila = hoja.createRow(2);
			celda = fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE REESTRUCTURAS DE CRÉDITO DEL "+reestrucCreditoBean.getFechaInicio()+" AL "+reestrucCreditoBean.getFechaVencimien());
		    hoja.addMergedRegion(new CellRangeAddress( 2, 2, 1, 12 ));
		    
			celda = fila.createCell((short)15);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)16);
			celda.setCellValue(horaVar);
			
			// Creacion de fila
			fila = hoja.createRow(3);					
			fila = hoja.createRow(4);
				    
			celda = fila.createCell((short)1);
			celda.setCellValue("Fecha Reestructura");
			celda.setCellStyle(estiloDatosCentradoNeg);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Socio");
			celda.setCellStyle(estiloDatosCentradoNeg);
			
			celda = fila.createCell((short)3);
			celda.setCellValue(Utileria.generaLocale("Nombre "+Constantes.CLIENTE_SOCIO, parametrosSesionBean.getNomCortoInstitucion()));
			celda.setCellStyle(estiloDatosCentradoNeg);
			
			hoja.addMergedRegion(new CellRangeAddress( 4, 5, 1, 1 ));
			hoja.addMergedRegion(new CellRangeAddress( 4, 5, 2, 2 ));
			hoja.addMergedRegion(new CellRangeAddress( 4, 5, 3, 3 ));
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Crédito Reestructurado");
			celda.setCellStyle(estiloDatosCentradoNeg);			
		    hoja.addMergedRegion(new CellRangeAddress(4, 4, 4, 9 ));			
		    			
			celda = fila.createCell((short)10);
			celda.setCellValue("A la Fecha");
			celda.setCellStyle(estiloDatosCentradoNeg);
			hoja.addMergedRegion(new CellRangeAddress(4, 4, 10, 15 ));
			
		    fila = hoja.createRow(5);
			
		 // ------- Datos credito origen ----------- //
			celda = fila.createCell((short)4);
			celda.setCellValue("No. Crédito");
			celda.setCellStyle(estiloDatosCentradoNeg);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Producto");
			celda.setCellStyle(estiloDatosCentradoNeg);			

			celda = fila.createCell((short)6);
			celda.setCellValue("Monto Original");
			celda.setCellStyle(estiloDatosCentradoNeg);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Saldo Reestructura");
			celda.setCellStyle(estiloDatosCentradoNeg);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Nace Como");
			celda.setCellStyle(estiloDatosCentradoNeg);	
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Días Atraso");
			celda.setCellStyle(estiloDatosCentradoNeg);	
			
			// ------- Datos credito destino ----------- //
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Saldo Capital");
			celda.setCellStyle(estiloDatosCentradoNeg);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Saldo Interés");
			celda.setCellStyle(estiloDatosCentradoNeg);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Saldo Moratorio");
			celda.setCellStyle(estiloDatosCentradoNeg);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloDatosCentradoNeg);
			
			celda = fila.createCell((short)14);
			celda.setCellValue("Pagos Realizados");
			celda.setCellStyle(estiloDatosCentradoNeg);		
			
			celda = fila.createCell((short)15);
			celda.setCellValue("Pagos Sostenidos");
			celda.setCellStyle(estiloDatosCentradoNeg);	
			
				    
			
			int i=6,iter=0;
			int tamanioLista = listaCreditos.size();
			RepReestrucCreBean credito = null;
			for( iter=0; iter<tamanioLista; iter ++){
			 
				credito = (RepReestrucCreBean) listaCreditos.get(iter);
				fila=hoja.createRow(i);
				// CreditoID,ClienteID,NombreCompleto
				celda=fila.createCell((short)1);
				celda.setCellValue(credito.getFecha());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)2);
				celda.setCellValue(credito.getClienteID());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)3);
				celda.setCellValue(credito.getNombreCompleto());
				
				celda=fila.createCell((short)4);
				celda.setCellValue(credito.getCreditoOrigen());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)5);
				celda.setCellValue(credito.getProductoOrigen());
				 				
				celda=fila.createCell((short)6);
				celda.setCellValue(Double.parseDouble(credito.getOtorgadoOrigen()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)7);
				celda.setCellValue(Double.parseDouble(credito.getSaldoReest()));
				celda.setCellStyle(estiloFormatoDecimal);
								
				celda=fila.createCell((short)8);
				celda.setCellValue( credito.getEstatus());
				 				
				celda=fila.createCell((short)9);
				celda.setCellValue( credito.getDiasAtraso());				 
			 
				celda=fila.createCell((short)10);
				celda.setCellValue(Double.parseDouble(credito.getSaldoCapital()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)11);
				celda.setCellValue(Double.parseDouble(credito.getSaldoInteres()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)12);
				celda.setCellValue(Double.parseDouble(credito.getSaldoInteresMora()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)13);
				celda.setCellValue( credito.getNaceComo());
				
				celda=fila.createCell((short)14);
				celda.setCellValue( credito.getPagosReg());
				
				celda=fila.createCell((short)15);
				celda.setCellValue( credito.getPagosSoste());
 
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
			

			for(int celd=0; celd<=18; celd++)
			hoja.autoSizeColumn((short)celd);
		
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepReestructurasCredito.xls");
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
		} 
			
			
		return  listaCreditos;
		
		
		}
 
	
	
	
	public String getNomReporte() {
		return nomReporte;
	}
	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public void setReestrucCreditoServicio(ReestrucCreditoServicio reestrucCreditoServicio) {
		this.reestrucCreditoServicio = reestrucCreditoServicio;
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
	
	
}
 
 
 