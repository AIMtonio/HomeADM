package activos.reporte;

import herramientas.Utileria;

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
import org.springframework.web.servlet.mvc.SimpleFormController;

import activos.bean.AplicacionDepreciacionBean;
import activos.servicio.AplicacionDepreciacionServicio;


public class AplicacionDepreciacionRepControlador extends AbstractCommandController{
	
	AplicacionDepreciacionServicio aplicacionDepreciacionServicio = null;
	
	String nombreReporte = null;
	String successView = null;
	
	public AplicacionDepreciacionRepControlador(){
		setCommandClass(AplicacionDepreciacionBean.class);
 		setCommandName("aplicacionDepreciacionBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

			AplicacionDepreciacionBean aplicacionDepreciacionBean =(AplicacionDepreciacionBean)command;
		
			int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;
			
			List<AplicacionDepreciacionBean>listaReportes = repDepAmortizaActivosExcel(tipoLista,aplicacionDepreciacionBean,response,request);

			return null;
	}
	
	// Reporte Previo Aplicacion de Depreciacion y Amortizacion de Activos en Excel
	public List repDepAmortizaActivosExcel(int tipoLista,AplicacionDepreciacionBean aplicacionDepreciacionBean,  HttpServletResponse response,HttpServletRequest request){
		String mesEnLetras	= "";
		String anio		= "";

		mesEnLetras = aplicacionDepreciacionServicio.descripcionMes(aplicacionDepreciacionBean.getMes());
		anio	= aplicacionDepreciacionBean.getAnio();

		List listaActivos = null;

		listaActivos = aplicacionDepreciacionServicio.listaDepreciaActivos(tipoLista,aplicacionDepreciacionBean,response); 	

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
			estiloNegCentrado8.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
						
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			XSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));

			XSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
			
			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("AplicaDepreciaAmortizaActivos");
			XSSFRow fila= hoja.createRow(0);

			// Nombre Usuario
			XSSFCell celdaini = fila.createCell((short)1);
			celdaini = fila.createCell((short)21);
			celdaini.setCellValue("Usuario:");
			celdaini.setCellStyle(estiloNeg8);	
			celdaini = fila.createCell((short)22);
			celdaini.setCellValue(aplicacionDepreciacionBean.getClaveUsuario());
			
			// Descripcion del Reporte
			fila	= hoja.createRow(1);	
			
			// Fecha en que se genera el reporte
			XSSFCell celdafin = fila.createCell((short)21);
			celdafin.setCellValue("Fecha:");
			celdafin.setCellStyle(estiloNeg8);	
			celdafin = fila.createCell((short)22);
			celdafin.setCellValue(aplicacionDepreciacionBean.getFechaSistema());
   
			// Nombre Institucion
			XSSFCell celdaInst=fila.createCell((short)1);
			celdaInst=fila.createCell((short)1);
			celdaInst.setCellStyle(estiloNegCentrado10);
			celdaInst.setCellValue(aplicacionDepreciacionBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //first row (0-based)
		            1, //last row  (0-based)
		            1, //first column (0-based)
		            13  //last column  (0-based)
		    )); 
			
			// Hora en que se genera el reporte
			fila = hoja.createRow(2);	
			XSSFCell celda=fila.createCell((short)1);
			celda = fila.createCell((short)21);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)22);
			
			String horaVar="";
			
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
			
			XSSFCell celdaR=fila.createCell((short)2);
			celdaR	= fila.createCell((short)1);			
			celdaR.setCellStyle(estiloNegCentrado10);
			celdaR.setCellValue("REPORTE PREVIO DE DEPRECIACIÓN Y AMORTIZACIÓN DE ACTIVOS AL MES DE " + mesEnLetras + " DEL " + anio);
			hoja.addMergedRegion(new CellRangeAddress(
		            2, //first row (0-based)
		            2, //last row  (0-based)
		            1, //first column (0-based)
		            13  //last column  (0-based)
		    ));
			
			// Encabezado del Reporte
			fila = hoja.createRow(3);	
			fila = hoja.createRow(4);	

			celda = fila.createCell((short)0);
			celda.setCellValue("Tipo de Activo");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            0, //first column (0-based)
		            0  //last column  (0-based)
		    ));

			celda = fila.createCell((short)1);
			celda.setCellValue("Descripción Activo");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            1, //first column (0-based)
		            1  //last column  (0-based)
		    ));

			celda = fila.createCell((short)2);
			celda.setCellValue("Fecha de\n Adquisición");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            2, //first column (0-based)
		            2  //last column  (0-based)
		    ));


			celda = fila.createCell((short)3);
			celda.setCellValue("Número Factura");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            3, //first column (0-based)
		            3  //last column  (0-based)
		    ));

			celda = fila.createCell((short)4);
			celda.setCellValue("Póliza");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            4, //first column (0-based)
		            4  //last column  (0-based)
		    ));

			celda = fila.createCell((short)5);
			celda.setCellValue("Centro de Costos");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            5, //first column (0-based)
		            5  //last column  (0-based)
		    ));	

			celda = fila.createCell((short)6);
			celda.setCellValue("MOI");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            6, //first column (0-based)
		            6  //last column  (0-based)
		    ));

			celda = fila.createCell((short)7);
			celda.setCellValue("%\n Depreciación\n Anual");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            7, //first column (0-based)
		            7  //last column  (0-based)
		    ));	
	
			celda = fila.createCell((short)8);
			celda.setCellValue("Tiempo\n Amortizar\n en Meses");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            8, //first column (0-based)
		            8  //last column  (0-based)
		    ));	

			celda = fila.createCell((short)9);
			celda.setCellValue("Depreciación\n Contable\n Anual");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            9, //first column (0-based)
		            9  //last column  (0-based)
		    ));	

		    celda = fila.createCell((short)10);
			celda.setCellValue("MESES");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            4, //last row  (0-based)
		            10, //first column (0-based)
		            21  //last column  (0-based)
		    ));	

		    celda = fila.createCell((short)22);
			celda.setCellValue("Depreciado\n Acumulado");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            22, //first column (0-based)
		            22  //last column  (0-based)
		    ));	

			celda = fila.createCell((short)23);
			celda.setCellValue("Saldo por\n Depreciar");
			celda.setCellStyle(estiloNegCentrado8);	
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //first row (0-based)
		            5, //last row  (0-based)
		            23, //first column (0-based)
		            23  //last column  (0-based)
		    ));	


			fila = hoja.createRow(5);	

		    celda = fila.createCell((short)10);
			celda.setCellValue("ENERO");
			celda.setCellStyle(estiloNegCentrado8);

			celda = fila.createCell((short)11);
			celda.setCellValue("FEBRERO");
			celda.setCellStyle(estiloNegCentrado8);

			celda = fila.createCell((short)12);
			celda.setCellValue("MARZO");
			celda.setCellStyle(estiloNegCentrado8);	

			celda = fila.createCell((short)13);
			celda.setCellValue("ABRIL");
			celda.setCellStyle(estiloNegCentrado8);	

			celda = fila.createCell((short)14);
			celda.setCellValue("MAYO");
			celda.setCellStyle(estiloNegCentrado8);

			celda = fila.createCell((short)15);
			celda.setCellValue("JUNIO");
			celda.setCellStyle(estiloNegCentrado8);

			celda = fila.createCell((short)16);
			celda.setCellValue("JULIO");
			celda.setCellStyle(estiloNegCentrado8);

			celda = fila.createCell((short)17);
			celda.setCellValue("AGOSTO");
			celda.setCellStyle(estiloNegCentrado8);

			celda = fila.createCell((short)18);
			celda.setCellValue("SEPTIEMBRE");
			celda.setCellStyle(estiloNegCentrado8);

			celda = fila.createCell((short)19);
			celda.setCellValue("OCTUBRE");
			celda.setCellStyle(estiloNegCentrado8);

			celda = fila.createCell((short)20);
			celda.setCellValue("NOVIEMBRE");
			celda.setCellStyle(estiloNegCentrado8);

			celda = fila.createCell((short)21);
			celda.setCellValue("DICIEMBRE");
			celda.setCellStyle(estiloNegCentrado8);

			int row = 6,iter=0;
			int tamanioLista = listaActivos.size();
			AplicacionDepreciacionBean activos = null;
			for(iter=0; iter<tamanioLista; iter ++){
				activos = (AplicacionDepreciacionBean) listaActivos.get(iter);

				fila=hoja.createRow(row);
				
				celda = fila.createCell((short)0);
				celda.setCellValue(activos.getDescTipoActivo());
				
				celda = fila.createCell((short)1);
				celda.setCellValue(activos.getDescActivo());
				
				celda = fila.createCell((short)2);
				celda.setCellValue(activos.getFechaAdquisicion());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue(activos.getNumFactura());
								
				celda = fila.createCell((short)4);
				celda.setCellValue(activos.getPoliza());
				
				celda = fila.createCell((short)5);
				celda.setCellValue(activos.getCentroCostoID());
				
				celda = fila.createCell((short)6);
				celda.setCellValue(Utileria.convierteDoble(activos.getMoi()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)7);
				celda.setCellValue(activos.getDepreciacionAnual()+"%");
				
				celda = fila.createCell((short)8);
				celda.setCellValue(activos.getTiempoAmortiMeses());
				
				celda = fila.createCell((short)9);
				celda.setCellValue(Utileria.convierteDoble(activos.getDepreciaContaAnual()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)10);
				celda.setCellValue(Utileria.convierteDoble(activos.getEnero()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)11);
				celda.setCellValue(Utileria.convierteDoble(activos.getFebrero()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)12);
				celda.setCellValue(Utileria.convierteDoble(activos.getMarzo()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)13);
				celda.setCellValue(Utileria.convierteDoble(activos.getAbril()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)14);
				celda.setCellValue(Utileria.convierteDoble(activos.getMayo()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)15);
				celda.setCellValue(Utileria.convierteDoble(activos.getJunio()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)16);
				celda.setCellValue(Utileria.convierteDoble(activos.getJulio()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)17);
				celda.setCellValue(Utileria.convierteDoble(activos.getAgosto()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)18);
				celda.setCellValue(Utileria.convierteDoble(activos.getSeptiembre()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)19);
				celda.setCellValue(Utileria.convierteDoble(activos.getOctubre()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)20);
				celda.setCellValue(Utileria.convierteDoble(activos.getNoviembre()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)21);
				celda.setCellValue(Utileria.convierteDoble(activos.getDiciembre()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)22);
				celda.setCellValue(Utileria.convierteDoble(activos.getDepreciadoAcumulado()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)23);
				celda.setCellValue(Utileria.convierteDoble(activos.getSaldoPorDepreciar()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				row++;
			}
			
			for(int celd=0; celd<=5; celd++){
				hoja.autoSizeColumn((short)celd);
			}

			hoja.setColumnWidth(1, 40 * 256);	
			hoja.setColumnWidth(6, 25 * 256);					
			hoja.setColumnWidth(9, 25 * 256);					
			hoja.setColumnWidth(10, 20 * 256);					
			hoja.setColumnWidth(11, 20 * 256);					
			hoja.setColumnWidth(12, 20 * 256);					
			hoja.setColumnWidth(13, 20 * 256);					
			hoja.setColumnWidth(14, 20 * 256);					
			hoja.setColumnWidth(15, 20 * 256);					
			hoja.setColumnWidth(16, 20 * 256);					
			hoja.setColumnWidth(17, 20 * 256);					
			hoja.setColumnWidth(18, 20 * 256);					
			hoja.setColumnWidth(19, 20 * 256);					
			hoja.setColumnWidth(20, 20 * 256);					
			hoja.setColumnWidth(21, 20 * 256);					
			hoja.setColumnWidth(22, 25 * 256);					
			hoja.setColumnWidth(23, 25 * 256);	
			
			//Se crea la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepAplicaDepAmortizaActivos.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			}catch(Exception e){
	    		e.printStackTrace();
	    	}//Fin del catch

		return listaActivos;
	}

	
	// ================== GETTER & SETTER ============== //

	public AplicacionDepreciacionServicio getAplicacionDepreciacionServicio() {
		return aplicacionDepreciacionServicio;
	}

	public void setAplicacionDepreciacionServicio(
			AplicacionDepreciacionServicio aplicacionDepreciacionServicio) {
		this.aplicacionDepreciacionServicio = aplicacionDepreciacionServicio;
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
