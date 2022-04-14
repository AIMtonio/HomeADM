package pld.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
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

import pld.bean.PersInvListasBean;
import pld.servicio.PersInvListasServicio;

public class PersInvListasRepControlador extends AbstractCommandController {
	
	String nombreReporte = null;
	String successView = null;
	PersInvListasServicio persInvListasServicio	= null;
	ParametrosSesionBean parametrosSesionBean = null;

	public static interface Enum_Con_TipRepor {
		int	PDF		= 1;
		int	EXCEL	= 2;
	}
	public PersInvListasRepControlador() {
		setCommandClass(PersInvListasBean.class);
		setCommandName("PersInvListas");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		PersInvListasBean persInvListasBean = (PersInvListasBean) command;
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		String htmlString = "";
		switch (tipoReporte) {
			case Enum_Con_TipRepor.PDF:
				reportePDF(persInvListasBean, nombreReporte, response);
				break;
			case Enum_Con_TipRepor.EXCEL:
				reporteExcel(persInvListasBean, response);
				break;
		}

		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}

	public ByteArrayOutputStream reportePDF(PersInvListasBean persInvListasBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = persInvListasServicio.reportePDF(persInvListasBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=RepPersInvListasPLD.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	return htmlStringPDF;
	}

	private ByteArrayOutputStream reporteExcel(PersInvListasBean persInvListasBean, HttpServletResponse response) {
		List<PersInvListasBean> listaPersonas= null;
		try{
			listaPersonas=persInvListasServicio.lista(persInvListasBean);
			String safilocalecliente = "safilocale.cliente";
			safilocalecliente = Utileria.generaLocale(safilocalecliente, parametrosSesionBean.getNomCortoInstitucion());
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");	
			persInvListasBean.setHoraEmision(postFormater.format(calendario.getTime()));
			XSSFSheet hoja = null;
			XSSFWorkbook libro=null;
			libro = new XSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			XSSFFont fuenteNegrita10Izq= libro.createFont();
			fuenteNegrita10Izq.setFontHeightInPoints((short)10);
			fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10Izq.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			//Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente8= libro.createFont();
			fuente8.setFontHeightInPoints((short)8);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);
			
			XSSFFont fuente8Cuerpo= libro.createFont();
			fuente8Cuerpo.setFontHeightInPoints((short)8);
			fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);

			//Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente10= libro.createFont();
			fuente8.setFontHeightInPoints((short)10);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			XSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			
			//Alineado a la izq
			XSSFCellStyle estiloNeg10Izq = libro.createCellStyle();
			estiloNeg10Izq.setFont(fuenteNegrita10Izq);
			estiloNeg10Izq.setAlignment(XSSFCellStyle.ALIGN_LEFT);
			
			//Estilo negrita de 8  para encabezados del reporte
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			

			XSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);
			
			XSSFCellStyle estilo10 = libro.createCellStyle();
			estilo8.setFont(fuente10);
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			XSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));	
			estiloFormatoDecimal.setFont(fuente8);
			
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimalTit = libro.createCellStyle();
			XSSFDataFormat formatTit = libro.createDataFormat();
			estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
			estiloFormatoDecimalTit.setFont(fuenteNegrita8);
				

			// Creacion de hoja					
			hoja = libro.createSheet("Reporte "+safilocalecliente+" en Listas PLD");
			
		  	// inicio fecha, usuario,institucion y hora
			XSSFRow fila= hoja.createRow(0);
			XSSFCell celdaUsu= fila.createCell((short)5);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg10Izq);	
			celdaUsu = fila.createCell((short)6);
			celdaUsu.setCellValue(((!persInvListasBean.getUsuario().isEmpty())?persInvListasBean.getUsuario(): "TODOS").toUpperCase());
			
			fila = hoja.createRow(1);
			String fechaVar = persInvListasBean.getFechaSistema().toString();
		  	XSSFCell celdaFec= fila.createCell((short)5);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg10Izq);	
			celdaFec = fila.createCell((short)6);
			celdaFec.setCellValue(fechaVar);
			
			
			XSSFCell celdaInst=fila.createCell((short)1);
			celdaInst.setCellValue(persInvListasBean.getNombreInstitucion());
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));
			 celdaInst.setCellStyle(estiloNeg10);


				fila = hoja.createRow(2);
				XSSFCell celdaHora= fila.createCell((short)5);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNeg10Izq);	
				celdaHora = fila.createCell((short)6);
				celdaHora.setCellValue(persInvListasBean.getHoraEmision());
				// fin fecha usuario,institucion y hora
				XSSFCell celda=fila.createCell((short)1);
				celda.setCellValue(safilocalecliente.toUpperCase()+"S EN LISTAS PLD");
				celda.setCellStyle(estiloNeg10);
				
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4 //ultima celda   (0-based)
			    ));
				celda.setCellStyle(estiloNeg10);	
			
			
			fila = hoja.createRow(4);
			celda=fila.createCell((short)0);
			celda.setCellStyle(estiloNeg10Izq);
			celda.setCellValue("Sucursal:");
			celda=fila.createCell((short)1);
			celda.setCellStyle(estilo10);
			celda.setCellValue(persInvListasBean.getSucursalDes().toUpperCase());
			
			celda=fila.createCell((short)3);
			celda.setCellStyle(estiloNeg10Izq);
			celda.setCellValue("Tipo Lista:");
			
			celda=fila.createCell((short)4);
			
			celda.setCellStyle(estilo10);
			
			String lista = "";
			if(persInvListasBean.getTipoLista().trim().isEmpty() || persInvListasBean.getTipoLista().trim().equals("3")){
				lista = "TODAS";
			} else if(persInvListasBean.getTipoLista().trim().equals("1")){
				lista = "LISTAS NEGRAS";
			} else if(persInvListasBean.getTipoLista().trim().equals("2")){
				lista = "LISTAS DE PERSONAS BLOQUEADAS";
			}
			
			celda.setCellValue(lista);
			
			fila = hoja.createRow(6);

			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			celda = fila.createCell((short)0);
			celda.setCellValue(safilocalecliente);
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue("Nombre Completo");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("Fecha Alta");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Fecha Inicio Trans.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Lista");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("No. Oficio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Origen Detección");
			celda.setCellStyle(estiloNeg8);

			int tamanioLista=listaPersonas.size();
			int i=7;
			
			PersInvListasBean pers = null;
			for(int iter=0; iter<tamanioLista; iter++){
				pers = (PersInvListasBean) listaPersonas.get(iter);
				
				fila=hoja.createRow(i);				
				celda=fila.createCell((short)0);
				celda.setCellValue(pers.getClavePersonaInv());
				celda.setCellStyle(estilo8);
				celda.getCellStyle().setFont(fuente8Cuerpo);
				
				celda=fila.createCell((short)1);
				celda.setCellValue(pers.getNombreCompleto());
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)2);
				celda.setCellValue(pers.getFechaAlta());
				celda.setCellStyle(estilo8);
				celda.getCellStyle().setFont(fuente8Cuerpo);
				

				celda=fila.createCell((short)3);
				celda.setCellValue(pers.getFechaIniTran());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)4);
				celda.setCellValue(pers.getTipoLista());
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)5);
				celda.setCellValue(pers.getNumeroOficio());
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)6);
				celda.setCellValue(pers.getOrigenDeteccion());
				celda.setCellStyle(estilo8);
				i++;
			}
			 
			i = i++;
			fila=hoja.createRow(i);				
			celda = fila.createCell((short)0);				
			celda.setCellValue("Registros Exportados:");
			celda.setCellStyle(estiloNeg8);
			i++;
			fila=hoja.createRow(i);		
			celda = fila.createCell((short)0);
			celda.setCellValue(listaPersonas.size());
			celda.setCellStyle(estilo8);
			
			for(int celd=0; celd<=i; celd++){
				hoja.autoSizeColumn((short)celd);
			}
			if(listaPersonas != null){
			}
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReportePersInvListasPLD.xlsx");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return null;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setPersInvListasServicio(PersInvListasServicio persInvListasServicio) {
		this.persInvListasServicio = persInvListasServicio;
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
