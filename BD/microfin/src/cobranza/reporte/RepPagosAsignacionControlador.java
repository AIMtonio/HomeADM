package cobranza.reporte;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Calendar;
import java.util.List;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cobranza.bean.RepPagosAsignacionBean;
import cobranza.servicio.RepPagosAsignacionServicio;
import cobranza.servicio.RepPagosAsignacionServicio.Enum_Rep_AsignaCartera;
import herramientas.Utileria;
import general.bean.ParametrosSesionBean;
import herramientas.Constantes;


public class RepPagosAsignacionControlador extends AbstractCommandController {
	RepPagosAsignacionServicio repPagosAsignacionServicio = null;
	ParametrosSesionBean parametrosSesionBean;
	String nombreReporte = null;
	String successView = null;	

	public RepPagosAsignacionControlador() {
		setCommandClass(RepPagosAsignacionBean.class);
		setCommandName("repPagosAsignacionBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors)throws Exception {


		RepPagosAsignacionBean repPagosAsignacionBean = (RepPagosAsignacionBean) command;


		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
					0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;
			
		String htmlString= "";
			
		switch(tipoReporte){
			case Enum_Rep_AsignaCartera.excelRep:		// Reporte de Pagos de Asignacion
				 List listaReportes = reportePagosAsignacionExcel(tipoLista,repPagosAsignacionBean,response);
			break;

		}
		return null;			
	}

	// Reporte de Pagos de Asignaciones de Cartera
	public List  reportePagosAsignacionExcel(int tipoLista,RepPagosAsignacionBean repPagosAsignacionBean,  HttpServletResponse response){
		List listaPagoAsignacion = null;

		//RepPagosAsignacionBean repPagosAsignacionBean = null; 

		listaPagoAsignacion = repPagosAsignacionServicio.listaPagosAsignados(tipoLista,repPagosAsignacionBean); 	
    	
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
			estiloNeg8.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  

			// Estilo centrado (S)
			XSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
			
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


			XSSFSheet hoja = libro.createSheet("PagosAsignaciónCartera");
			XSSFRow fila= hoja.createRow(0);

			XSSFCell celda =fila.createCell((short)3);
			celda.setCellStyle(estiloNegCentrado10);
			celda.setCellValue(repPagosAsignacionBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(
		            0, //first row (0-based)
		            0, //last row  (0-based)
		            3, //first column (0-based)
		            8  //last column  (0-based)
		    )); 

			celda	= fila.createCell((short)13);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)14);
			celda.setCellValue(repPagosAsignacionBean.getClaveUsuario());

		


			fila	= hoja.createRow(1);	
			celda	= fila.createCell((short)3);			
			celda.setCellStyle(estiloNegCentrado10);
			celda.setCellValue("REPORTE DE RECUPERACIÓN DE CARTERA DEL " + repPagosAsignacionBean.getFechaInicioAsigna() + " AL " + repPagosAsignacionBean.getFechaFinAsigna());
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //first row (0-based)
		            1, //last row  (0-based)
		            3, //first column (0-based)
		            8  //last column  (0-based)
		    ));

			celda	= fila.createCell((short)13);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)14);
			celda.setCellValue(repPagosAsignacionBean.getFechaSistema());

			fila = hoja.createRow(2);	
			celda = fila.createCell((short)13);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)14);

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

			fila = hoja.createRow(3);	
			celda = fila.createCell((short)0);
			celda.setCellValue("Nombre del Gestor:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)1);
			celda.setCellValue(repPagosAsignacionBean.getNombreGestor());
			celda = fila.createCell((short)2);

			fila = hoja.createRow(4);	
			fila = hoja.createRow(5);	

			celda = fila.createCell((short)0);
			celda.setCellValue("Fecha");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue(Utileria.generaLocale("No. "+Constantes.CLIENTE_SOCIO, parametrosSesionBean.getNomCortoInstitucion()));
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("No. Crédito");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)3);
			celda.setCellValue("Nombre");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)4);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)5);
			celda.setCellValue("Nombre del Gestor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)6);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)7);
			celda.setCellValue("Descripción Movimiento");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)8);
			celda.setCellValue("Capital");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Interés Normal");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)10);
			celda.setCellValue("IVA Interés Normal");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)11);
			celda.setCellValue("Interés Moratorio");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)12);
			celda.setCellValue("IVA Interés Moratorio");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)13);
			celda.setCellValue("% Comisión");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)14);
			celda.setCellValue("Comisión");
			celda.setCellStyle(estiloNeg8);


			int tamanioLista = listaPagoAsignacion.size();
			int row = 6;

			String TotalMonto = "";
			String TotalComision = "";

			for(int iter=0; iter<tamanioLista; iter ++){
				
				repPagosAsignacionBean = (RepPagosAsignacionBean) listaPagoAsignacion.get(iter);
				
				fila=hoja.createRow(row);		

				celda=fila.createCell((short)0);
				celda.setCellValue(repPagosAsignacionBean.getFecha());

				celda=fila.createCell((short)1);
				celda.setCellValue(repPagosAsignacionBean.getClienteID());

				celda=fila.createCell((short)2);
				celda.setCellValue(repPagosAsignacionBean.getCreditoID());

				celda=fila.createCell((short)3);
				celda.setCellValue(repPagosAsignacionBean.getNombreCompleto());

				celda=fila.createCell((short)4);
				celda.setCellValue(repPagosAsignacionBean.getNombreSucursal());

				celda=fila.createCell((short)5);
				celda.setCellValue(repPagosAsignacionBean.getNombreGestor());

				celda=fila.createCell((short)6);
				celda.setCellValue(Utileria.convierteDoble(repPagosAsignacionBean.getMonto()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)7);
				celda.setCellValue(repPagosAsignacionBean.getDescripcionMov());

				celda=fila.createCell((short)8);
				celda.setCellValue(Utileria.convierteDoble(repPagosAsignacionBean.getCapital()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)9);
				celda.setCellValue(Utileria.convierteDoble(repPagosAsignacionBean.getInteresNormal()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)10);
				celda.setCellValue(Utileria.convierteDoble(repPagosAsignacionBean.getIvaInteresNor()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)11);
				celda.setCellValue(Utileria.convierteDoble(repPagosAsignacionBean.getInteresMora()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)12);
				celda.setCellValue(Utileria.convierteDoble(repPagosAsignacionBean.getIvaInteresMora()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)13);
				celda.setCellValue(Utileria.convierteDoble(repPagosAsignacionBean.getPorcComision()));

				celda=fila.createCell((short)14);
				celda.setCellValue(Utileria.convierteDoble(repPagosAsignacionBean.getComision()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				row++;

			} 

				if(listaPagoAsignacion.size()>0){	
					RepPagosAsignacionBean repPagosAsigna;
					repPagosAsigna = (RepPagosAsignacionBean)listaPagoAsignacion.get(0);
					TotalMonto		= repPagosAsigna.getSumaMonto();
					TotalComision 	= repPagosAsigna.getSumaComision();
								
				}

				row = row+2;
				fila=hoja.createRow(row);
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Total Recuperación");
				celda.setCellStyle(estiloNeg8);

				celda=fila.createCell((short)6);
				celda.setCellValue(Utileria.convierteDoble(TotalMonto));
				celda.setCellStyle(estiloFormatoDecimal);

				celda = fila.createCell((short)12);
				celda.setCellValue("Total Comisión");
				celda.setCellStyle(estiloNeg8);

				celda=fila.createCell((short)13);
				celda.setCellValue(Utileria.convierteDoble(TotalComision));
				celda.setCellStyle(estiloFormatoDecimal);

				row = row+1;
				fila=hoja.createRow(row);
				celda=fila.createCell((short)0);
				celda.setCellValue(tamanioLista);
				
				// Autoajusta las columnas
				for(int celd=0; celd<=18; celd++)
				hoja.autoSizeColumn((short)celd);
									
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=RepPagosAsignacion.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				
	    	}catch(Exception e){
	    		e.printStackTrace();
	    	}//Fin del catch
				
			return  listaPagoAsignacion;
			
			
		}



	// Getters y Setters
	public RepPagosAsignacionServicio getRepPagosAsignacionServicio() {
		return repPagosAsignacionServicio;
	}
	public void setRepPagosAsignacionServicio(RepPagosAsignacionServicio repPagosAsignacionServicio) {
		this.repPagosAsignacionServicio = repPagosAsignacionServicio;
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
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
