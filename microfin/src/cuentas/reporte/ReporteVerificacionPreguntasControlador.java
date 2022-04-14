package cuentas.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Calendar;

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
import herramientas.Constantes;

import cuentas.bean.RepVerificacionPreguntasBean;
import cuentas.servicio.RepVerificacionPreguntasServicio;

public class ReporteVerificacionPreguntasControlador extends AbstractCommandController{
	
	RepVerificacionPreguntasServicio repVerificacionPreguntasServicio = null;

	ParametrosSesionBean parametrosSesionBean;
	String nombreReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipoReporte {
		  int  ReporteExcel	= 1;
	}
	
	public  ReporteVerificacionPreguntasControlador () {
		setCommandClass(RepVerificacionPreguntasBean.class);
		setCommandName("repVerificacionPreguntasBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		RepVerificacionPreguntasBean repVerificacionPreguntasBean = (RepVerificacionPreguntasBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):0;
				
		switch(tipoReporte){
			case Enum_Con_TipoReporte.ReporteExcel:		
				 List listaReportes = verificacionPreguntasExcel(tipoLista,repVerificacionPreguntasBean,response);
			break;
			}
			return null;
		}
		
	// Reporte de Verfificacion de Preguntas en Excel
	public List verificacionPreguntasExcel(int tipoLista,RepVerificacionPreguntasBean repVerificacionPreguntasBean,  HttpServletResponse response){
		List listaVerificacionPreguntas=null;

		listaVerificacionPreguntas = repVerificacionPreguntasServicio.listaVerificacionPreguntas(tipoLista,repVerificacionPreguntasBean); 	
	 
		int regExport = 0;
	
		try {
			
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
						
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			XSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("VerificacionPreguntas");
			XSSFRow fila= hoja.createRow(1);

			// Nombre Usuario
			XSSFCell celdaini = fila.createCell((short)1);
			celdaini = fila.createCell((short)8);
			celdaini.setCellValue("Usuario:");
			celdaini.setCellStyle(estiloNeg8);	
			celdaini = fila.createCell((short)9);
			celdaini.setCellValue(repVerificacionPreguntasBean.getNombreUsuario());
			
			// Nombre Institucion
			XSSFCell celdaInst=fila.createCell((short)1);
			celdaInst=fila.createCell((short)1);
			celdaInst.setCellStyle(estiloNegCentrado10);
			celdaInst.setCellValue(repVerificacionPreguntasBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //first row (0-based)
		            1, //last row  (0-based)
		            1, //first column (0-based)
		            6  //last column  (0-based)
		    )); 

			// Descripcion del Reporte
			fila	= hoja.createRow(2);	
			
			// Fecha en que se genera el reporte
			XSSFCell celdafin = fila.createCell((short)8);
			celdafin.setCellValue("Fecha:");
			celdafin.setCellStyle(estiloNeg8);	
			celdafin = fila.createCell((short)9);
			celdafin.setCellValue(repVerificacionPreguntasBean.getFechaEmision());
			
			XSSFCell celdaR=fila.createCell((short)2);
			celdaR	= fila.createCell((short)1);			
			celdaR.setCellStyle(estiloNegCentrado10);
			celdaR.setCellValue("REPORTE DE MOVIMIENTOS DE PADEMOBILE DEL " + repVerificacionPreguntasBean.getFechaInicio() + " AL " + repVerificacionPreguntasBean.getFechaFin());
			hoja.addMergedRegion(new CellRangeAddress(
		            2, //first row (0-based)
		            2, //last row  (0-based)
		            1, //first column (0-based)
		            6  //last column  (0-based)
		    ));
			
			
			// Hora en que se genera el reporte
			fila = hoja.createRow(3);	
			XSSFCell celda=fila.createCell((short)1);
			celda = fila.createCell((short)8);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)9);
			
			String horaVar = "";
			
			Calendar calendario = Calendar.getInstance();	 
			int hora =calendario.get(Calendar.HOUR_OF_DAY);
			int minutos = calendario.get(Calendar.MINUTE);
			int segundos = calendario.get(Calendar.SECOND);
			
			String h = Integer.toString(hora);
			String m = "";
			String s = "";
			if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
			if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);		
				 
			horaVar= h+":"+m+":"+s;
			
			celda.setCellValue(horaVar);
			
			// Creacion de fila
			fila = hoja.createRow(4);
			fila = hoja.createRow(5);
			
			celda = fila.createCell((short)1);
			celda.setCellValue("No. "+Utileria.generaLocale(Constantes.CLIENTE_SOCIO, parametrosSesionBean.getNomCortoInstitucion()));
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)2);
			celda.setCellValue("Nombre Completo");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Teléfono Celular");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Número Cuenta");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Fecha");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Hora");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Tipo de Soporte");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Usuario");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Resultado");
			celda.setCellStyle(estiloNeg8);	
			
			int row = 6,iter=0;
			int tamanioLista = listaVerificacionPreguntas.size();
			RepVerificacionPreguntasBean verificaPregunta = null;
			for(iter=0; iter<tamanioLista; iter ++){
				verificaPregunta = (RepVerificacionPreguntasBean) listaVerificacionPreguntas.get(iter);

				fila=hoja.createRow(row);
				
				celda = fila.createCell((short)1);
				celda.setCellValue(verificaPregunta.getClienteID());
				
				celda = fila.createCell((short)2);
				celda.setCellValue(verificaPregunta.getNombreCliente());
				
				celda = fila.createCell((short)3);
				celda.setCellValue(verificaPregunta.getTelefonoCelular());
				
				celda = fila.createCell((short)4);
				celda.setCellValue(verificaPregunta.getCuentaAhoID());
				
				celda = fila.createCell((short)5);
				celda.setCellValue(verificaPregunta.getFecha());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)6);
				celda.setCellValue(verificaPregunta.getHora());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)7);
				celda.setCellValue(verificaPregunta.getTipoSoporte());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)8);
				celda.setCellValue(verificaPregunta.getUsuario());
				
				celda = fila.createCell((short)9);
				celda.setCellValue(verificaPregunta.getResultado());
				
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
			
			hoja.autoSizeColumn((short)0);
			hoja.autoSizeColumn((short)1);
			hoja.autoSizeColumn((short)2);
			hoja.autoSizeColumn((short)3);
			hoja.autoSizeColumn((short)4);
			hoja.autoSizeColumn((short)5);
			hoja.autoSizeColumn((short)6);
			hoja.autoSizeColumn((short)7);
			hoja.autoSizeColumn((short)8);
			hoja.autoSizeColumn((short)9);
			hoja.autoSizeColumn((short)10);
			hoja.autoSizeColumn((short)11);
			
			//Se crea la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepVerificacionPreguntas.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			}catch(Exception e){
	    		e.printStackTrace();
	    	}//Fin del catch
			
		return  listaVerificacionPreguntas;		
	}
	
	// ============= GETTER & SETTER ============ //

	public RepVerificacionPreguntasServicio getRepVerificacionPreguntasServicio() {
		return repVerificacionPreguntasServicio;
	}

	public void setRepVerificacionPreguntasServicio(
			RepVerificacionPreguntasServicio repVerificacionPreguntasServicio) {
		this.repVerificacionPreguntasServicio = repVerificacionPreguntasServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
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

	public void setSuccessView(String successView) {
		this.successView = successView;
	}	
}
