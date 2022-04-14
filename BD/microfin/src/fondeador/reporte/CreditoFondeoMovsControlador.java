package fondeador.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Calendar;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import fondeador.bean.CreditoFondeoBean;
import fondeador.servicio.CreditoFondeoServicio;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

public class CreditoFondeoMovsControlador extends AbstractCommandController{
	
	CreditoFondeoServicio creditoFondeoServicio = null;
	ParametrosSesionBean parametrosSesionBean;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporExcel= 1 ;
		}
	public CreditoFondeoMovsControlador(){
		setCommandClass(CreditoFondeoBean.class);
		setCommandName("CreditoFondeoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
	CreditoFondeoBean creditosBean = (CreditoFondeoBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
	int tipoLista =(request.getParameter("tipoLista")!=null)?Integer.parseInt(request.getParameter("tipoLista")):0;
	creditosBean.setCreditoFondeoID(request.getParameter("creditoFondeoID"));
	creditosBean.setInstitutFon(request.getParameter("institucionFon"));
	
		switch(tipoReporte){
		
			case Enum_Con_TipRepor.ReporExcel:		
				 List listaReportes = creditosFondeoMovs(tipoLista,creditosBean,response);
			break;
		}
		return null;
	}
	
	public List creditosFondeoMovs(int tipoLista,CreditoFondeoBean creditosBean,  HttpServletResponse response){
		List listaCreditosFondeMovsBean = null;
		
		listaCreditosFondeMovsBean = creditoFondeoServicio.listaReportesCreditos(tipoLista, creditosBean, response);
		Calendar calendario = Calendar.getInstance();
		
		if(listaCreditosFondeMovsBean !=null){
			try{
				XSSFWorkbook libro = new XSSFWorkbook();
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				XSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				XSSFCellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				// Negrita 10 centrado
				XSSFFont centradoNegrita10 = libro.createFont();
				centradoNegrita10.setFontHeightInPoints((short)10);
				centradoNegrita10.setFontName("Negrita");
				centradoNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				XSSFCellStyle estiloNegCentrado10 = libro.createCellStyle();
				estiloNegCentrado10.setFont(centradoNegrita10);
				estiloNegCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				
				// Negrita 8 centrado
				XSSFFont centradoNegrita8= libro.createFont();
				centradoNegrita8.setFontHeightInPoints((short)8);
				centradoNegrita8.setFontName("Negrita");
				centradoNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				XSSFCellStyle estiloNegCentrado8 = libro.createCellStyle();
				estiloNegCentrado8.setFont(centradoNegrita8);
				estiloNegCentrado8.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
				estiloNegCentrado8.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
							
				//Estilo Formato decimal (0.00)
				XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
				XSSFDataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$ #,##0.00"));

				XSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
				estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
				
				// Creacion de hoja
				XSSFSheet hoja = libro.createSheet("Movimiento de Crédito Pasivo");
				
				XSSFRow fila= hoja.createRow(0);

				fila	= hoja.createRow(1);			
				XSSFCell celdaR=fila.createCell((short)2);
				celdaR	= fila.createCell((short)0);
				celdaR.setCellValue("REPORTE DE MOVIMIENTO DE CRÉDITO PASIVO AL DÍA " + parametrosSesionBean.getFechaAplicacion());
				celdaR.setCellStyle(estiloNegCentrado10);
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //first row (0-based)
			            1, //last row  (0-based)
			            0, //first column (0-based)
			            5  //last column  (0-based)
			    ));
				
				fila = hoja.createRow(3);
				// Nombre Usuario
				XSSFCell celdaini = fila.createCell((short)1);
				celdaini = fila.createCell((short)4);
				celdaini.setCellValue("Usuario:");
				celdaini.setCellStyle(estiloNeg8);	
				celdaini = fila.createCell((short)5);
				celdaini.setCellValue(parametrosSesionBean.getClaveUsuario());
				
				// Encabezado del Reporte
				fila = hoja.createRow(4);	
				
				celdaini = fila.createCell((short)0);
				celdaini.setCellValue("Crédito Pasivo:");
				celdaini.setCellStyle(estiloNeg8);
				celdaini = fila.createCell((short)1);
				celdaini.setCellValue(creditosBean.getCreditoFondeoID());
				
				// Fecha en que se genera el reporte
				XSSFCell celdafin = fila.createCell((short)5);
				celdafin = fila.createCell((short)4);
				celdafin.setCellValue("Fecha:");
				celdafin.setCellStyle(estiloNeg8);	
				celdafin = fila.createCell((short)5);
				String mes = "0";
				if((calendario.get(Calendar.MONTH)+1) > 9)
				{
					mes = String.valueOf(calendario.get(Calendar.MONTH)+1);
				}
				else
				{
					mes = "0" + String.valueOf(calendario.get(Calendar.MONTH)+1);
				}
				celdafin.setCellValue(calendario.get(Calendar.DAY_OF_MONTH) + "/" + mes + "/" + calendario.get(Calendar.YEAR));
				
				fila = hoja.createRow(5);
				
				celdafin = fila.createCell((short)0);
				celdafin.setCellValue("Institución Fondeo:");
				celdafin.setCellStyle(estiloNeg8);
				celdafin = fila.createCell((short)1);
				celdafin.setCellValue(creditosBean.getInstitutFon());
				
				// Hora en que se genera el reporte
				celdaini = fila.createCell((short)4);
				celdaini.setCellValue("Hora:");
				celdaini.setCellStyle(estiloNeg8);	
				celdaini = fila.createCell((short)5);
				
				String horaVar="";
				
				int hora =calendario.get(Calendar.HOUR_OF_DAY);
				int minutos = calendario.get(Calendar.MINUTE);
				int segundos = calendario.get(Calendar.SECOND);
				
				String h = Integer.toString(hora);
				String m = "";
				String s = "";
				if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
				if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);		
					 
				horaVar= h+":"+m+":"+s;
				
				celdaini.setCellValue(horaVar);
				
				fila = hoja.createRow(7);
				
				celdaini = fila.createCell((short)0);
				celdaini.setCellValue("No. Amortización");
				celdaini.setCellStyle(estiloNegCentrado8);
				
				celdaini = fila.createCell((short)1);
				celdaini.setCellValue("Fecha Operación");
				celdaini.setCellStyle(estiloNegCentrado8);
				
				celdaini = fila.createCell((short)2);
				celdaini.setCellValue("Descripción");
				celdaini.setCellStyle(estiloNegCentrado8);
				
				celdaini = fila.createCell((short)3);
				celdaini.setCellValue("Tipo");
				celdaini.setCellStyle(estiloNegCentrado8);
				
				celdaini = fila.createCell((short)4);
				celdaini.setCellValue("Naturaleza");
				celdaini.setCellStyle(estiloNegCentrado8);
				
				celdaini = fila.createCell((short)5);
				celdaini.setCellValue("Cantidad");
				celdaini.setCellStyle(estiloNegCentrado8);
								
				int row = 8,iter=0;
				int tamanioLista = listaCreditosFondeMovsBean.size();
				CreditoFondeoBean creditoFondeoBean = null;
				for(iter=0; iter<tamanioLista; iter ++){
					creditoFondeoBean = (CreditoFondeoBean) listaCreditosFondeMovsBean.get(iter);
					
					fila = hoja.createRow(row);
					celdaini = fila.createCell((short)0);
					celdaini.setCellValue(creditoFondeoBean.getNumAmortizacion());
					
					celdaini = fila.createCell((short)1);
					celdaini.setCellValue(creditoFondeoBean.getFechaOperacion());
					
					celdaini = fila.createCell((short)2);
					celdaini.setCellValue(creditoFondeoBean.getDescripcion());
					
					celdaini = fila.createCell((short)3);
					celdaini.setCellValue(creditoFondeoBean.getDescripTipMov());
					
					celdaini = fila.createCell((short)4);
					celdaini.setCellValue(creditoFondeoBean.getNatMovimientoDes());
					
					celdaini = fila.createCell((short)5);
					celdaini.setCellValue(Utileria.convierteDoble(creditoFondeoBean.getCantidad().equals(null) || creditoFondeoBean.getCantidad().equals("") ? "-" : creditoFondeoBean.getCantidad()));
					celdaini.setCellStyle(estiloFormatoDecimal);
										
					row++;
				}
				
				for(int celd=0; celd<=18; celd++){
					hoja.autoSizeColumn((short)celd);
				}
				
				for(int celd=8; celd<=10; celd++){
					hoja.autoSizeColumn((short)celd);
				}				
				hoja.setColumnWidth(1, 20 * 256);
				hoja.setColumnWidth(7, 25 * 256);					
				hoja.setColumnWidth(11, 25 * 256);					
				hoja.setColumnWidth(12, 25 * 256);
				
				//Se crea la cabecera
				response.addHeader("Content-Disposition","inline; filename=RepCreditosFondMovs.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		return listaCreditosFondeMovsBean;
	}
	
	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	public CreditoFondeoServicio getCreditoFondeoServicio() {
		return creditoFondeoServicio;
	}

	public void setCreditoFondeoServicio(CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
	}
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
