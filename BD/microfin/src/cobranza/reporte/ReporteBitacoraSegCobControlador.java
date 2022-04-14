package cobranza.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import cobranza.bean.RepBitacoraSegCobBean;
import cobranza.servicio.BitacoraSegCobServicio;

public class ReporteBitacoraSegCobControlador extends AbstractCommandController {
	BitacoraSegCobServicio bitacoraSegCobServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	public static interface Enum_Rep_BitSegCob{
		int reportePDF = 1;
		int reporteExcel = 2;
	}
	
	public ReporteBitacoraSegCobControlador(){
		setCommandClass(RepBitacoraSegCobBean.class);
 		setCommandName("repBitacoraSegCobBean");			
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		RepBitacoraSegCobBean repBitacoraBean = (RepBitacoraSegCobBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
			
		int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;

			bitacoraSegCobServicio.getBitacoraSegCobDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			String htmlString= "";
				
			switch(tipoReporte){
				case Enum_Rep_BitSegCob.reportePDF:
					ByteArrayOutputStream htmlStringPDF = repBitSegCobPDF(repBitacoraBean, nombreReporte, response);
				break;
				case Enum_Rep_BitSegCob.reporteExcel:		
					 List listaReportes = repBitSegCobExcel(tipoLista,repBitacoraBean,response);
				break;
			}
			
		return null;
	}
	
	// Reporte bitacora de seguimiento de cobranza PDF
	private ByteArrayOutputStream repBitSegCobPDF(RepBitacoraSegCobBean repBitacoraBean, String nombreReporte,
			HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = bitacoraSegCobServicio.reporteBitSegCobPDF(repBitacoraBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteBitacoraSegCob.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return htmlStringPDF;
	}
	
	// Reporte en excel de la bitacora de seguimiento de cobranza
	public List  repBitSegCobExcel(int tipoLista,RepBitacoraSegCobBean repFiltrosBitSegCobBean, HttpServletResponse response){
		List listaResultados = null;

		RepBitacoraSegCobBean repBitacoraSegCobBean = null; 
    	
    	// SE EJECUTA EL SP QUE NOS DEVUELVE LOS VALORES DEL REPORTE
		listaResultados = bitacoraSegCobServicio.listaBitacoraSegCob(tipoLista,repFiltrosBitSegCobBean); 	
    	
    	try {	
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFWorkbook libro = new XSSFWorkbook();
			XSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			XSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);

			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			// Estilo centrado (S)
			XSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER); 
			
			// Negrita 10 centrado
			XSSFFont centradoNegrita10 = libro.createFont();
			centradoNegrita10.setFontHeightInPoints((short)10);
			centradoNegrita10.setFontName("Negrita");
			centradoNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			XSSFCellStyle estiloNegCentrado10 = libro.createCellStyle();
			estiloNegCentrado10.setFont(fuenteNegrita10);
			estiloNegCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			
			//Estilo negrita de 8  y color de fondo
			XSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			XSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			XSSFSheet hoja = libro.createSheet("BitacoraSegCob");
			XSSFRow fila= hoja.createRow(0);

			XSSFCell celda =fila.createCell((short)3);
			celda.setCellStyle(estiloNegCentrado10);
			celda.setCellValue(repFiltrosBitSegCobBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(
		            0, //first row (0-based)
		            0, //last row  (0-based)
		            3, //first column (0-based)
		            8  //last column  (0-based)
		    )); 
			

			celda	= fila.createCell((short)11);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)12);
			celda.setCellValue(repFiltrosBitSegCobBean.getClaveUsuario());
			Calendar calendario = Calendar.getInstance();
			int hora = calendario.get(Calendar.HOUR_OF_DAY);
			String horaVar = hora+":"+calendario.get(Calendar.MINUTE)+":"+calendario.get(Calendar.SECOND);


			fila	= hoja.createRow(1);	//	FILA 1 ---------------------------------------------------------
			celda	= fila.createCell((short)3);			
			celda.setCellStyle(estiloNegCentrado10);
			celda.setCellValue("REPORTE BITACORA DE SEGUIMIENTO DE COBRANZA	");
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //first row (0-based)
		            1, //last row  (0-based)
		            3, //first column (0-based)
		            8  //last column  (0-based)
		    ));
			
			celda	= fila.createCell((short)11);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)12);
			celda.setCellValue(repFiltrosBitSegCobBean.getFechaSis());

			fila	= hoja.createRow(2);	//	FILA 2 ---------------------------------------------------------
			celda = fila.createCell((short)11);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)12);
			celda.setCellValue(horaVar);

			fila = hoja.createRow(3);	//	FILA 3 ---------------------------------------------------------

			celda = fila.createCell((short)0);
			celda.setCellValue("Fecha Inicio Reg:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)1);
			celda.setCellValue(repFiltrosBitSegCobBean.getFechaIniReg());

			celda = fila.createCell((short)2);
			celda.setCellValue("Fecha Final Reg:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)3);
			celda.setCellValue(repFiltrosBitSegCobBean.getFechaFinReg());
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Tipo Acción:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)5);			
			celda.setCellValue(Utileria.convierteEntero(repFiltrosBitSegCobBean.getAccionID())+" - "+repFiltrosBitSegCobBean.getDescAccion());			

			celda = fila.createCell((short)6);
			celda.setCellValue("Tipo Respuesta:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)7);	
			celda.setCellValue(Utileria.convierteEntero(repFiltrosBitSegCobBean.getRespuestaID())+" - "+repFiltrosBitSegCobBean.getDescRespuesta());

			celda = fila.createCell((short)8);
			celda.setCellValue("N° Socio:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)9);
			if(Utileria.convierteEntero(repFiltrosBitSegCobBean.getClienteID()) > 0){
				celda.setCellValue(repFiltrosBitSegCobBean.getClienteID());
			}else{
				celda.setCellValue("0 - TODOS ");
			}
			
			fila = hoja.createRow(4);	//	FILA 4 ---------------------------------------------------------		

			celda = fila.createCell((short)0);
			celda.setCellValue("Crédito:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)1);
			if(Utileria.convierteLong(repFiltrosBitSegCobBean.getCreditoID()) > 0){
				celda.setCellValue(repFiltrosBitSegCobBean.getCreditoID());
			}else{
				celda.setCellValue("0 - TODOS ");
			}

			celda = fila.createCell((short)2);
			celda.setCellValue("Usuario Reg:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)3);	
			celda.setCellValue(Utileria.convierteEntero(repFiltrosBitSegCobBean.getUsuarioReg())+" - "+repFiltrosBitSegCobBean.getDesUsuRec());

			celda = fila.createCell((short)4);
			celda.setCellValue("Fecha Inicio Prom:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)5);
			celda.setCellValue(repFiltrosBitSegCobBean.getFechaIniProm());

			celda = fila.createCell((short)6);
			celda.setCellValue("Fecha Final Prom:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)7);
			celda.setCellValue(repFiltrosBitSegCobBean.getFechaFinProm());

			celda = fila.createCell((short)8);
			celda.setCellValue("Limite Renglones:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)9);
			celda.setCellValue(repFiltrosBitSegCobBean.getLimiteReglones());
			
			fila = hoja.createRow(5);	//	FILA 5	---------------------------------------------------------
			
			fila = hoja.createRow(6);	//	FILA 6	---------------------------------------------------------

			celda = fila.createCell((short)0);
			celda.setCellValue("Fecha Registro");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue("Usuario");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("Sucursal Usuario");
			celda.setCellStyle(estiloNeg8);			

			celda = fila.createCell((short)3);
			celda.setCellValue("Crédito");
			celda.setCellStyle(estiloNeg8);		

			celda = fila.createCell((short)4);
			celda.setCellValue("Socio");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Tipo Acción");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)6);
			celda.setCellValue("Tipo Respuesta");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)7);
			celda.setCellValue("Comentarios");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)8);
			celda.setCellValue("Etapa Cobranza");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Fecha Entrega Doc");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Fecha Promesa Pago");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Monto Promesa Pago           ");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Comentarios Promesa");
			celda.setCellStyle(estiloNeg8);			
			
			int tamanioLista = listaResultados.size();
			int row = 7;
			for(int iter=0; iter<tamanioLista; iter ++){
			 
				repBitacoraSegCobBean = (RepBitacoraSegCobBean) listaResultados.get(iter);
				
				fila=hoja.createRow(row);		
			
				celda=fila.createCell((short)0);
				celda.setCellValue(repBitacoraSegCobBean.getFechaRegistro());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)1);
				celda.setCellValue(repBitacoraSegCobBean.getUsuarioID());
				celda.setCellStyle(estiloDatosCentrado);
			
				celda=fila.createCell((short)2);
				celda.setCellValue(repBitacoraSegCobBean.getNombreSucursal());
			
				celda=fila.createCell((short)3);
				celda.setCellValue(repBitacoraSegCobBean.getCreditoID());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(repBitacoraSegCobBean.getClienteID()+"-"+repBitacoraSegCobBean.getNombreCliente());
				
				celda=fila.createCell((short)5);
				celda.setCellValue(repBitacoraSegCobBean.getDescAccion());

				celda=fila.createCell((short)6);
				celda.setCellValue(repBitacoraSegCobBean.getDescRespuesta());
				
				celda=fila.createCell((short)7);
				celda.setCellValue(repBitacoraSegCobBean.getComentarios());

				celda=fila.createCell((short)8);
				celda.setCellValue(repBitacoraSegCobBean.getEtapaCobranza());

				celda=fila.createCell((short)9);
				celda.setCellValue(repBitacoraSegCobBean.getFechaEntregaDoc());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)10);
				celda.setCellValue(repBitacoraSegCobBean.getFechaPromPago());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)11);
				celda.setCellValue(Double.parseDouble(repBitacoraSegCobBean.getMontoPromPago()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)12);
				celda.setCellValue(repBitacoraSegCobBean.getComentariosProm());
				
				row++;

			} 

			row = row+2;
			fila=hoja.createRow(row);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			row = row+1;
			fila=hoja.createRow(row);
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);

			// Autoajusta las columnas
			for(int celd=0; celd<=12; celd++){
				if(celd != 11){
					hoja.autoSizeColumn((short)celd);
				}
			}
			
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepBitacoraSegCob.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			
    	}catch(Exception e){
    		e.printStackTrace();
    	}//Fin del catch
			
		return  listaResultados;
		
		
	}
	
	public BitacoraSegCobServicio getBitacoraSegCobServicio() {
		return bitacoraSegCobServicio;
	}
	public String getNombreReporte() {
		return nombreReporte;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setBitacoraSegCobServicio(
			BitacoraSegCobServicio bitacoraSegCobServicio) {
		this.bitacoraSegCobServicio = bitacoraSegCobServicio;
	}
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}	
}
