package cobranza.reporte;

import herramientas.Utileria;

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

import cobranza.bean.AsignaCarteraBean;
import cobranza.bean.RepAsignaCarteraBean;
import cobranza.servicio.AsignaCarteraServicio;
import cobranza.servicio.AsignaCarteraServicio.Enum_Rep_AsignaCartera;


public class RepAsignaCarteraControlador extends AbstractCommandController{
	
	AsignaCarteraServicio asignaCarteraServicio = null;
	String nombreReporte = null;
	String successView = null;		   
	
	public RepAsignaCarteraControlador() {
		setCommandClass(AsignaCarteraBean.class);
		setCommandName("asignaCarteraBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		AsignaCarteraBean asignaCarteraBean = (AsignaCarteraBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
					0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;

		switch(tipoReporte){
			case Enum_Rep_AsignaCartera.excelRep:			//Reporte Asignaciones cobranza
				 List listaReportes = reporteAsignaCobranzaExcel(tipoLista,asignaCarteraBean,response);
			break;
			case Enum_Rep_AsignaCartera.excelRepGestor:		//Reporte Asignacion por gestor
				 List lisRepIndividual = repAsignaCobranzaExcelGestor(tipoLista,asignaCarteraBean,response);
			break;
		}
		return null;			
	}

	// Reporte de Asignaciones de Cartera (modulo cobranza)
	public List  reporteAsignaCobranzaExcel(int tipoLista,AsignaCarteraBean asignaCarteraBean, HttpServletResponse response){
		List listaAsignaCobranza = null;

		RepAsignaCarteraBean repAsignaCarteraBean = null; 
    	
    	// SE EJECUTA EL SP QUE NOS DEVUELVE LOS VALORES DEL REPORTE
		listaAsignaCobranza = asignaCarteraServicio.listaCreditosAsignados(tipoLista,asignaCarteraBean); 	
    	
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


			XSSFSheet hoja = libro.createSheet("AsignaciónCartera");
			XSSFRow fila= hoja.createRow(0);

			XSSFCell celda =fila.createCell((short)3);
			celda.setCellStyle(estiloNegCentrado10);
			celda.setCellValue(asignaCarteraBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(
		            0, //first row (0-based)
		            0, //last row  (0-based)
		            3, //first column (0-based)
		            8  //last column  (0-based)
		    )); 
			

			//celda	= fila.createCell((short)1);
			celda	= fila.createCell((short)13);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)14);
			celda.setCellValue(asignaCarteraBean.getClaveUsuario());
			Calendar calendario = Calendar.getInstance();
			int hora = calendario.get(Calendar.HOUR_OF_DAY);
			String horaVar = hora+":"+calendario.get(Calendar.MINUTE)+":"+calendario.get(Calendar.SECOND);


			fila	= hoja.createRow(1);	//	FILA 1 ---------------------------------------------------------
			celda	= fila.createCell((short)3);			
			celda.setCellStyle(estiloNegCentrado10);
			celda.setCellValue("REPORTE DE ASIGNACIÓN DE CARTERA DE COBRANZA");
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
			celda.setCellValue(asignaCarteraBean.getFechaSis());

			fila	= hoja.createRow(2);	//	FILA 2 ---------------------------------------------------------
			celda = fila.createCell((short)13);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)14);
			celda.setCellValue(horaVar);

			fila = hoja.createRow(3);	//	FILA 3 ---------------------------------------------------------

			celda = fila.createCell((short)0);
			celda.setCellValue("Tipo Gestor:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)1);
			String tipoGestor = asignaCarteraBean.getTipoGestor();
		     
		     if(tipoGestor.equals("I")){
		    	 tipoGestor = "INTERNO";
		      }
		     else{
		     	 tipoGestor = "EXTERNO";
		     }

			celda.setCellValue(tipoGestor);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)4);
			celda.setCellValue(asignaCarteraBean.getSucursalID() + " - " + asignaCarteraBean.getNombreSucursal());
						
			celda = fila.createCell((short)7);
			celda.setCellValue("Gestor:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)8);
			celda.setCellValue(asignaCarteraBean.getGestorID() + " - " + asignaCarteraBean.getNombreGestor());
			celda = fila.createCell((short)9);

			
			fila = hoja.createRow(4);	//	FILA 4 ---------------------------------------------------------		
			// Creacion de fila
			fila = hoja.createRow(5);	//	FILA 5	---------------------------------------------------------

			celda = fila.createCell((short)0);
			celda.setCellValue("Gestor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue("Nombre Gestor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("Tipo Asignación");
			celda.setCellStyle(estiloNeg8);			

			celda = fila.createCell((short)3);
			celda.setCellValue("Fecha Asignación");
			celda.setCellStyle(estiloNeg8);		

			celda = fila.createCell((short)4);
			celda.setCellValue("Socio/Cliente");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Nombre Socio/Cliente");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)6);
			celda.setCellValue("Sucursal Socio/Cliente");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)7);
			celda.setCellValue("Crédito");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)8);
			celda.setCellValue("Producto Crédito");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Teléfono Fijo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Teléfono Celular");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Domicilio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Nombre Aval");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Domicilio Aval");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)14);
			celda.setCellValue("Teléfono Aval");
			celda.setCellStyle(estiloNeg8);
			
			
			int tamanioLista = listaAsignaCobranza.size();
			int row = 6;
			for(int iter=0; iter<tamanioLista; iter ++){
			 
				repAsignaCarteraBean = (RepAsignaCarteraBean) listaAsignaCobranza.get(iter);
				
				fila=hoja.createRow(row);		
			
				celda=fila.createCell((short)0);
				celda.setCellValue(repAsignaCarteraBean.getGestorID());

				celda=fila.createCell((short)1);
				celda.setCellValue(repAsignaCarteraBean.getNombreGestor());
			
				celda=fila.createCell((short)2);
				celda.setCellValue(repAsignaCarteraBean.getTipoAsignacion());
				
				celda=fila.createCell((short)3);
				celda.setCellValue(repAsignaCarteraBean.getFechaAsignacion());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(repAsignaCarteraBean.getClienteID());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)5);
				celda.setCellValue(repAsignaCarteraBean.getNombreCompleto());

				celda=fila.createCell((short)6);
				celda.setCellValue(repAsignaCarteraBean.getSucursalCliente());
			
				celda=fila.createCell((short)7);
				celda.setCellValue(repAsignaCarteraBean.getCreditoID());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)8);
				celda.setCellValue(repAsignaCarteraBean.getNombreProducto());

				celda=fila.createCell((short)9);
				celda.setCellValue(repAsignaCarteraBean.getTelefonoFijo());
				
				celda=fila.createCell((short)10);
				celda.setCellValue(repAsignaCarteraBean.getTelefonoCelular());

				celda=fila.createCell((short)11);
				celda.setCellValue(repAsignaCarteraBean.getDomicilio());

				celda=fila.createCell((short)12);
				celda.setCellValue(repAsignaCarteraBean.getNombreAval());
				
				celda=fila.createCell((short)13);
				celda.setCellValue(repAsignaCarteraBean.getDomicilioAval());

				celda=fila.createCell((short)14);
				celda.setCellValue(repAsignaCarteraBean.getTelefonoAval());
					
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
			for(int celd=0; celd<=18; celd++)
			hoja.autoSizeColumn((short)celd);
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepAsignaCartera.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			
    	}catch(Exception e){
    		e.printStackTrace();
    	}//Fin del catch
			
		return  listaAsignaCobranza;
		
		
	}

	// Reporte de Asignaciones de Cartera (modulo cobranza)
	public List  repAsignaCobranzaExcelGestor(int tipoLista,AsignaCarteraBean asignaCarteraBean, HttpServletResponse response){
		List listaAsignaCobranza = null;

		AsignaCarteraBean repAsignaCarteraBean = null; 
    	
    	// SE EJECUTA EL SP QUE NOS DEVUELVE LOS VALORES DEL REPORTE
		listaAsignaCobranza = asignaCarteraServicio.listaGrid(tipoLista,asignaCarteraBean);
    	
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


			XSSFSheet hoja = libro.createSheet("AsignaciónCarteraGestor");
			XSSFRow fila= hoja.createRow(0);

			XSSFCell celda =fila.createCell((short)3);
			celda.setCellStyle(estiloNegCentrado10);
			celda.setCellValue(asignaCarteraBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(
		            0, //first row (0-based)
		            0, //last row  (0-based)
		            3, //first column (0-based)
		            8  //last column  (0-based)
		    )); 
			

			//celda	= fila.createCell((short)1);
			celda	= fila.createCell((short)11);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)12);
			celda.setCellValue(asignaCarteraBean.getClaveUsuario());
			Calendar calendario = Calendar.getInstance();
			int hora = calendario.get(Calendar.HOUR_OF_DAY);
			String horaVar = hora+":"+calendario.get(Calendar.MINUTE)+":"+calendario.get(Calendar.SECOND);


			fila	= hoja.createRow(1);	//	FILA 1 ---------------------------------------------------------
			celda	= fila.createCell((short)3);			
			celda.setCellStyle(estiloNegCentrado10);
			celda.setCellValue("Reporte de Asignación de Cartera de Cobranza");
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
			celda.setCellValue(asignaCarteraBean.getFechaSis());

			fila	= hoja.createRow(2);	//	FILA 2 ---------------------------------------------------------
			celda = fila.createCell((short)11);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)12);
			celda.setCellValue(horaVar);

			fila = hoja.createRow(3);	//	FILA 3 ---------------------------------------------------------

			celda = fila.createCell((short)0);
			celda.setCellValue("Gestor:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)1);
			celda.setCellValue(asignaCarteraBean.getGestorID() + " - " + asignaCarteraBean.getNombreCompleto());
			celda = fila.createCell((short)2);

			
			fila = hoja.createRow(4);	//	FILA 4 ---------------------------------------------------------		
			
			// Creacion de fila
			fila = hoja.createRow(5);	//	FILA 5	---------------------------------------------------------

			celda = fila.createCell((short)0);
			celda.setCellValue("Socio/Cliente");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue("Nombre Completo");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("Sucursal Socio/Cliente");
			celda.setCellStyle(estiloNeg8);			

			celda = fila.createCell((short)3);
			celda.setCellValue("Crédito");
			celda.setCellStyle(estiloNeg8);		

			celda = fila.createCell((short)4);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Días Atraso");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)6);
			celda.setCellValue("Monto Otorgado");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)7);
			celda.setCellValue("Fecha de Desembolso");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)8);
			celda.setCellValue("Fecha de Vencimiento");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Fecha de Prox. Vencimiento");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Saldo Capital");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Saldo Interés");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Saldo Moratorios");
			celda.setCellStyle(estiloNeg8);
			
			
			int tamanioLista = listaAsignaCobranza.size();
			int row = 6;
			for(int iter=0; iter<tamanioLista; iter ++){
			 
				repAsignaCarteraBean = (AsignaCarteraBean) listaAsignaCobranza.get(iter);
				
				fila=hoja.createRow(row);		
			
				celda=fila.createCell((short)0);
				celda.setCellValue(repAsignaCarteraBean.getClienteID());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)1);
				celda.setCellValue(repAsignaCarteraBean.getNombreCompleto());
			
				celda=fila.createCell((short)2);
				celda.setCellValue(repAsignaCarteraBean.getNombreSucursal());
				
				celda=fila.createCell((short)3);
				celda.setCellValue(repAsignaCarteraBean.getCreditoID());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(repAsignaCarteraBean.getEstatusCred());

				celda=fila.createCell((short)5);
				celda.setCellValue(repAsignaCarteraBean.getDiasAtraso());

				celda=fila.createCell((short)6);
				celda.setCellValue(Double.parseDouble(repAsignaCarteraBean.getMontoCredito()));
				celda.setCellStyle(estiloFormatoDecimal);
			
				celda=fila.createCell((short)7);
				celda.setCellValue(repAsignaCarteraBean.getFechaDesembolso());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)8);
				celda.setCellValue(repAsignaCarteraBean.getFechaVencimien());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)9);
				celda.setCellValue(repAsignaCarteraBean.getFechaProxVencim());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)10);
				celda.setCellValue(Double.parseDouble(repAsignaCarteraBean.getSaldoCapital()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)11);
				celda.setCellValue(Double.parseDouble(repAsignaCarteraBean.getSaldoInteres()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)12);
				celda.setCellValue(Double.parseDouble(repAsignaCarteraBean.getSaldoMoratorio()));
				celda.setCellStyle(estiloFormatoDecimal);
					
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
			for(int celd=0; celd<=18; celd++)
			hoja.autoSizeColumn((short)celd);
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepAsignaCarteraGestor.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			
    	}catch(Exception e){
    		e.printStackTrace();
    	}//Fin del catch
			
		return  listaAsignaCobranza;
		
		
	}

	// Getters y Setters
	public AsignaCarteraServicio getAsignaCarteraServicio() {
		return asignaCarteraServicio;
	}
	public void setAsignaCarteraServicio(AsignaCarteraServicio asignaCarteraServicio) {
		this.asignaCarteraServicio = asignaCarteraServicio;
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
