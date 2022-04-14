package cuentas.reporte;


import herramientas.Utileria;
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
import cuentas.bean.IDEMensualBean;
import cuentas.servicio.CuentasAhoServicio;
import cuentas.servicio.CuentasAhoServicio.Enum_Rep_Cuentas;

public class ReporteIDEMensControlador extends AbstractCommandController{
	
	CuentasAhoServicio cuentasAhoServicio = null;
	String nombreReporte = null;
	String successView = null;		   
	
	public ReporteIDEMensControlador() {
		setCommandClass(IDEMensualBean.class);
		setCommandName("ideMensualBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
			IDEMensualBean IDEMensBean = (IDEMensualBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
					0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;

		switch(tipoReporte){
			case Enum_Rep_Cuentas.excelRep:		
				 List listaReportes = reporteIDEMensualExcel(tipoLista,IDEMensBean,response);
			break;
		}
		return null;			
	}

	// Reporte de IDE Mensual
	public List  reporteIDEMensualExcel(int tipoLista,IDEMensualBean IDEMensBean, HttpServletResponse response){
		List listaAsignaCobranza = null;
		String horaVar			= "";
		String varFechaSistema	="";
		String varUsuario="";
    	int regExport = 0;	
    	int itera=0;
    	
    	  String[] meses = {"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"};
         
    	
		IDEMensualBean RepIDEMensBean = null;
    	
    	// SE EJECUTA EL SP QUE NOS DEVUELVE LOS VALORES DEL REPORTE
		listaAsignaCobranza = cuentasAhoServicio.listaIDEMensual(tipoLista,IDEMensBean); 	
    	
    	try {
			if(!listaAsignaCobranza.isEmpty()){
				for( itera=0; itera<1; itera ++){
					RepIDEMensBean = (IDEMensualBean) listaAsignaCobranza.get(itera);
					
				}
			}
			
			//Asigancion de Variables
			varFechaSistema=IDEMensBean.getFechaReporte();
			varUsuario=IDEMensBean.getNombreUsuario();
			horaVar=IDEMensBean.getHoraEmision();
			
    		/* DECLARACION DE OBJETOS A UTILIZAR */
			XSSFWorkbook libro = new XSSFWorkbook();
			XSSFDataFormat format;
			XSSFCellStyle estiloNeg10;
			XSSFCellStyle estiloNeg8;
			XSSFCellStyle estiloCentrado;
			XSSFCellStyle estiloColor;
			XSSFCellStyle estiloFormatoDecimal;
			XSSFCellStyle estiloNegCentrado10;
			XSSFSheet hoja;
			XSSFFont centradoNegrita10;
			XSSFFont fuenteNegrita10; 
			XSSFFont fuenteNegrita8;
			XSSFCell celda;
			XSSFRow fila;
			
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			// Estilo centrado (S)
			estiloCentrado = libro.createCellStyle();
			estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			
			// Negrita 10 centrado
			centradoNegrita10 = libro.createFont();
			centradoNegrita10.setFontHeightInPoints((short)10);
			centradoNegrita10.setFontName("Negrita");
			centradoNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			estiloNegCentrado10 = libro.createCellStyle();
			estiloNegCentrado10.setFont(fuenteNegrita10);
			estiloNegCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			
			
			//Estilo negrita de 8  y color de fondo
			estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			estiloFormatoDecimal = libro.createCellStyle();
			format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja					
			hoja = libro.createSheet("Reporte IDE");
			fila = hoja.createRow(0);

			celda =fila.createCell((short)3);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue(IDEMensBean.getNombreInstitucion());
			celda.setCellStyle(estiloNegCentrado10);
			hoja.addMergedRegion(new CellRangeAddress(
		            0, //first row (0-based)
		            0, //last row  (0-based)
		            3, //first column (0-based)
		            8  //last column  (0-based)
		    ));
			
			fila	= hoja.createRow(1);	//	FILA 1 ---------------------------------------------------------
			celda	= fila.createCell((short)3);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE PARA LA DECLARACIÓN MENSUAL DE LOS DEPÓSITOS EN EFECTIVO ");
			celda.setCellStyle(estiloNegCentrado10);
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //first row (0-based)
		            1, //last row  (0-based)
		            3, //first column (0-based)
		            8  //last column  (0-based)
		    ));
			
			celda	= fila.createCell((short)1);
			celda	= fila.createCell((short)13);
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)14);
			celda.setCellValue(IDEMensBean.getRfc());

			fila	= hoja.createRow(2);	//	FILA 2 ---------------------------------------------------------
			celda = fila.createCell((short)29);
			celda.setCellValue("USUARIO:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)30);
			celda.setCellValue(varUsuario);
			

			fila = hoja.createRow(3);	//	FILA 3 ---------------------------------------------------------
			celda = fila.createCell((short)0);
			celda.setCellValue("PERIODO REPORTADO:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)1);
			celda.setCellValue(meses[Utileria.convierteEntero(IDEMensBean.getMes())-1] + "-" + IDEMensBean.getAnio());
			
			celda = fila.createCell((short)29);
			celda.setCellValue("FECHA:");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell((short)30);
			celda.setCellValue(varFechaSistema);
			
			
			
			fila = hoja.createRow(4);	//	FILA 4 ---------------------------------------------------------
			celda = fila.createCell((short)29);
			celda.setCellValue("HORA:");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell((short)30);
			celda.setCellValue(horaVar);

			fila = hoja.createRow(5);	//	FILA 5 ---------------------------------------------------------
			
			
			
			
			celda = fila.createCell((short)3);
			
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)6);
							
			celda = fila.createCell((short)7);
			
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)6);
							
			celda = fila.createCell((short)20);
			celda.setCellValue(" DATOS DEL SUSCRIPTOR");
			celda.setCellStyle(estiloNegCentrado10);
			hoja.addMergedRegion(new CellRangeAddress(
		            5, //first row (0-based)
		            5, //last row  (0-based)
		            20, //first column (0-based)
		            31  //last column  (0-based)
		    ));
			
			
			// Creacion de fila
			fila = hoja.createRow(6);	//	FILA 6	---------------------------------------------------------			
			celda = fila.createCell((short)0);
			celda.setCellValue("RFC");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue("CURP");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("TIPO DE CONTRIBUYENTE");
			celda.setCellStyle(estiloNeg8);			

			celda = fila.createCell((short)3);
			celda.setCellValue("NOMBRE");
			celda.setCellStyle(estiloNeg8);		

			celda = fila.createCell((short)4);
			celda.setCellValue("PRIMER APELLIDO");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)5);
			celda.setCellValue("SEGUNDO APELLIDO");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)6);
			celda.setCellValue("FECHA DE NACIMIENTO");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)7);
			celda.setCellValue("RAZÓN SOCIAL");
			celda.setCellStyle(estiloNeg8);	

			celda = fila.createCell((short)8);
			celda.setCellValue("FECHA DE CORTE");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("MONTO DE DEPÓSITOS");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("EXCEDENTE");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("TIPO DE DEPÓSITO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("NUMERO SOCIO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("SUCURSAL");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)14);
			celda.setCellValue("DIRECCIÓN DEL SOCIO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)15);
			celda.setCellValue("NÚMERO SOCIO MENOR");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)16);
			celda.setCellValue("CORREO ELECTRÓNICO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)17);
			celda.setCellValue("TELÉFONO 1");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)18);
			celda.setCellValue("TELÉFONO 2");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)19);
			celda.setCellValue("NÚMERO DE CUENTA");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell((short)20);
			celda.setCellValue("NOMBRE");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)21);
			celda.setCellValue("PRIMER APELLIDO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)22);
			celda.setCellValue("SEGUNDO APELLIDO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)23);
			celda.setCellValue("FECHA DE NACIMIENTO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)24);
			celda.setCellValue("RFC ");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)25);
			celda.setCellValue("CURP");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)26);
			celda.setCellValue("NÚMERO_SOCIO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)27);
			celda.setCellValue("SUCURSAL");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)28);
			celda.setCellValue("DIRECCIÓN DEL SOCIO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)29);
			celda.setCellValue("CORREO ELECTRÓNICO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)30);
			celda.setCellValue("TELÉFONO 1");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)31);
			celda.setCellValue("TELÉFONO 2");
			celda.setCellStyle(estiloNeg8);
			
			int numFilaSig = 7, iter=0;
			int tamanioLista = listaAsignaCobranza.size();
			IDEMensualBean IDEMensual=null;
			for( iter=0; iter<tamanioLista; iter ++){
				
				
			 
				IDEMensual = (IDEMensualBean) listaAsignaCobranza.get(iter);
				fila=hoja.createRow(numFilaSig);
				
				celda=fila.createCell((short)0);
				celda.setCellValue(IDEMensual.getRfc());				
				
				
				celda=fila.createCell((short)1);
				celda.setCellValue(IDEMensual.getCurp());
				
				celda=fila.createCell((short)2);
				celda.setCellValue(IDEMensual.getTipoContr());
				
				celda=fila.createCell((short)3);
				celda.setCellValue(IDEMensual.getPrimerNombre());
				
				celda=fila.createCell((short)4);
				celda.setCellValue(IDEMensual.getApellidoPaterno());
				
				celda=fila.createCell((short)5);
				celda.setCellValue(IDEMensual.getApellidoMaterno());
				
				celda=fila.createCell((short)6);
				celda.setCellValue(IDEMensual.getFechaNac());
				
				celda=fila.createCell((short)7);
				celda.setCellValue(IDEMensual.getRaSocial());
				
				celda=fila.createCell((short)8);
				celda.setCellValue(IDEMensual.getFechaCorte());
				
				celda=fila.createCell((short)9);
				celda.setCellValue(Utileria.convierteDoble(IDEMensual.getMonto()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)10);
				celda.setCellValue(Utileria.convierteDoble(IDEMensual.getExcedente()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)11);
				celda.setCellValue(IDEMensual.getTipoDep());
				
				celda=fila.createCell((short)12);
				celda.setCellValue(IDEMensual.getNumSocio());
				
				celda=fila.createCell((short)13);
				celda.setCellValue(IDEMensual.getSucursalOrigen());
				
				celda=fila.createCell((short)14);
				celda.setCellValue(IDEMensual.getDirCompleta());
				
				celda=fila.createCell((short)15);
				celda.setCellValue(IDEMensual.getEsMenorEdad());
				
				celda=fila.createCell((short)16);
				celda.setCellValue(IDEMensual.getCorreo());
				
				celda=fila.createCell((short)17);
				celda.setCellValue(IDEMensual.getTelCelular());
				
				celda=fila.createCell((short)18);
				celda.setCellValue(IDEMensual.getTelefono());
				
				celda=fila.createCell((short)19);
				celda.setCellValue(IDEMensual.getCuentaAhoID());
				
				celda=fila.createCell((short)20);
				celda.setCellValue(IDEMensual.getNombreTut());
				
				celda=fila.createCell((short)21);
				celda.setCellValue(IDEMensual.getApellidoPaternoTut());
				
				celda=fila.createCell((short)22);
				celda.setCellValue(IDEMensual.getApellidoMaternoTut());
				
				celda=fila.createCell((short)23);
				if(IDEMensual.getFechaNacTut().equals("1900-01-01"))
				celda.setCellValue("");
				else celda.setCellValue(IDEMensual.getFechaNacTut());
				
				celda=fila.createCell((short)24);
				celda.setCellValue(IDEMensual.getRfcTut());
				
				celda=fila.createCell((short)25);
				celda.setCellValue(IDEMensual.getCurpTut());
				
				celda=fila.createCell((short)26);
				celda.setCellValue(IDEMensual.getNumeroSocioTut());
				
				celda=fila.createCell((short)27);
				if(IDEMensual.getSucursalTut().equals("0"))
				celda.setCellValue("");
				else celda.setCellValue(IDEMensual.getSucursalTut());

				
				celda=fila.createCell((short)28);
				celda.setCellValue(IDEMensual.getDirCompletaTut());
				
				celda=fila.createCell((short)29);
				celda.setCellValue(IDEMensual.getCorreoTut());
				
				celda=fila.createCell((short)30);
				celda.setCellValue(IDEMensual.getTelCelularTut());
				
				celda=fila.createCell((short)31);
				celda.setCellValue(IDEMensual.getTelefonoTut());
				
					
				numFilaSig++;
			}
			
			
			numFilaSig = numFilaSig+2;
			fila=hoja.createRow(numFilaSig);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			numFilaSig = numFilaSig+1;
			fila=hoja.createRow(numFilaSig);
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);
			
			// Autoajusta las columnas
			for(int celd=0; celd<=31; celd++)
			hoja.autoSizeColumn((short)celd);
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepIDEMensual.xls");
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

	public String getNombreReporte() {
		return nombreReporte;
	}
	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
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
