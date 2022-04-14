package fira.reporte;



import general.bean.ParametrosAuditoriaBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
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


import fira.bean.CastigosCarteraAgroBean;
import fira.bean.CreCastigosAgroRepBean;
import fira.servicio.CastigosCarteraAgroServicio;

public class CreCastigosAgroRepControlador extends AbstractCommandController{

	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	CastigosCarteraAgroServicio castigosCarteraAgroServicio = null;
	String nomReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
	}
	public CreCastigosAgroRepControlador () {
		setCommandClass(CreCastigosAgroRepBean.class);
		setCommandName("castigosCarteraAgroBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errors)throws Exception {
		
		CreCastigosAgroRepBean castigosCarteraAgroBean = (CreCastigosAgroRepBean) command;

			int tipoReporte =(request.getParameter("tipoReporte")!=null)?
							Integer.parseInt(request.getParameter("tipoReporte")):
							0;
			int tipoLista =(request.getParameter("tipoLista")!=null)?
							Integer.parseInt(request.getParameter("tipoLista")):
							0;
		
			String htmlString= "";
			loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Entra en controlador: "+ tipoReporte);
		switch(tipoReporte){			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = CreditosCastigadosPDF(castigosCarteraAgroBean, nomReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
				 List listaReportes = listaReporteCastigosExcel(tipoLista,castigosCarteraAgroBean,response);
			break;
		}
		return null;
			
	}
	
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream CreditosCastigadosPDF(CreCastigosAgroRepBean castigosCarteraAgroBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = castigosCarteraAgroServicio.creaRepCastigosPDF(castigosCarteraAgroBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteCreditosAgroCastigados.pdf");
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

	// Reporte de saldos capital de credito en excel
	public List  listaReporteCastigosExcel(int tipoLista,CreCastigosAgroRepBean castigosCarteraAgroBean,  HttpServletResponse response){
		List listaCreditos=null;
		listaCreditos = castigosCarteraAgroServicio.listaReportesCredCastigados(tipoLista,castigosCarteraAgroBean,response); 	
	 
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
		HSSFSheet hoja = libro.createSheet("Reporte Castigos");
		HSSFRow fila= hoja.createRow(0);
		
		// inicio usuario,fecha y hora
		HSSFCell celdaUsu=fila.createCell((short)1);
		
		celdaUsu = fila.createCell((short)14);
		celdaUsu.setCellValue("Usuario:");
		celdaUsu.setCellStyle(estiloNeg8);	
		celdaUsu = fila.createCell((short)15);
		celdaUsu.setCellValue((!castigosCarteraAgroBean.getClaveUsuario().isEmpty())?castigosCarteraAgroBean.getClaveUsuario(): "TODOS");
		
		String horaVar="";
		String fechaVar=castigosCarteraAgroBean.getFechaEmision();

		
		int itera=0;
		CreCastigosAgroRepBean creditoHora = null;
		if(!listaCreditos.isEmpty()){
			for( itera=0; itera<1; itera ++){
				creditoHora = (CreCastigosAgroRepBean) listaCreditos.get(itera);
				horaVar= creditoHora.getHora();
				fechaVar= creditoHora.getFecha();				
			}
		}
		fila = hoja.createRow(1);
		HSSFCell celdaFec=fila.createCell((short)1);
				
		celdaFec = fila.createCell((short)14);
		celdaFec.setCellValue("Fecha:");
		celdaFec.setCellStyle(estiloNeg8);	
		celdaFec = fila.createCell((short)15);
		celdaFec.setCellValue(castigosCarteraAgroBean.getFechaEmision());
		 
		
		// Nombre Institucion	
		HSSFCell celdaInst=fila.createCell((short)1);
		//celdaInst.setCellStyle(estiloNeg10);
		celdaInst.setCellValue(castigosCarteraAgroBean.getNombreInstitucion());
							
		  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            10  //ultima celda   (0-based)
		    ));
		  
		 celdaInst.setCellStyle(estiloCentrado);	
		
		
		fila = hoja.createRow(2);
		HSSFCell celdaHora=fila.createCell((short)1);
		celdaHora = fila.createCell((short)14);
		celdaHora.setCellValue("Hora:");
		celdaHora.setCellStyle(estiloNeg8);	
		celdaHora = fila.createCell((short)15);
		celdaHora.setCellValue(horaVar);
		
		// Titulo del Reporte	
		HSSFCell celda=fila.createCell((short)1);
		celda.setCellValue("REPORTE DE CRÉDITOS CASTIGADOS AGRO DEL "+castigosCarteraAgroBean.getFechaInicio()+" AL "+castigosCarteraAgroBean.getFechaFin());
		celda.setCellStyle(estiloCentrado);
	   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            2, //primera fila (0-based)
	            2, //ultima fila  (0-based)
	            1, //primer celda (0-based)
	            10  //ultima celda   (0-based)
	    ));
	    
		
	   
	   
	   fila = hoja.createRow(3); // Fila vacia
		fila = hoja.createRow(4);// Campos
		celda = fila.createCell((short)1);
		celda.setCellValue("Sucursal:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)2);
		celda.setCellValue((!castigosCarteraAgroBean.getNombreSucursal().equals("")? castigosCarteraAgroBean.getNombreSucursal():"TODOS"));
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Producto Crédito:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)5);
		celda.setCellValue((!castigosCarteraAgroBean.getNombreProducto().equals("")? castigosCarteraAgroBean.getNombreProducto():"TODAS"));
		
		
		
		/*fila = hoja.createRow(5);
		celda = fila.createCell((short)1);
		celda.setCellValue("Moneda:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)2);
		celda.setCellValue((!castigosCarteraAgroBean.getNombreMoneda().equals("")? castigosCarteraAgroBean.getNombreMoneda():"TODOS"));
		*/
		fila = hoja.createRow(5);
		celda = fila.createCell((short)1);
		celda.setCellValue("Promotor:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)2);
		celda.setCellValue((!castigosCarteraAgroBean.getNombrePromotor().equals("")? castigosCarteraAgroBean.getNombrePromotor():"TODOS"));
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Motivo:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)5);
		celda.setCellValue((!castigosCarteraAgroBean.getDesMotivoCastigo().equals("")? castigosCarteraAgroBean.getDesMotivoCastigo():"TODOS"));
		
	   
		// Creacion de fila
		fila = hoja.createRow(6); // Fila vacia
		fila = hoja.createRow(7);// Campos
								

		celda = fila.createCell((short)1);
		celda.setCellValue("ID Crédito Activo");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)2);
		celda.setCellValue("ID Crédito RC");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Tipo de Crédito");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)4);
		celda.setCellValue("No de Cliente");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Nombre del Cliente");
		celda.setCellStyle(estiloNeg8);
				
		celda = fila.createCell((short)6);
		celda.setCellValue("Producto de Crédito");
		celda.setCellStyle(estiloNeg8);			

		celda = fila.createCell((short)7);
		celda.setCellValue("Grupo");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)8);
		celda.setCellValue("Monto Original");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)9);
		celda.setCellValue("Fecha Desembolso"); 
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)10);
		celda.setCellValue("Fecha Castigo");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)11);
		celda.setCellValue("Motivo Castigo"); //
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)12);
		celda.setCellValue("Detalle de Castigo");
		celda.setCellStyle(estiloCentrado);		
		
		hoja.addMergedRegion(new CellRangeAddress(
	    		 7, 7, 12, 15  
	    ));
		
		celda = fila.createCell((short)16);
		celda.setCellValue("Detalle Recuperación");
		celda.setCellStyle(estiloCentrado);		
	   
	    hoja.addMergedRegion(new CellRangeAddress(
	    		 7, 7, 16, 18 
	    ));
		
		fila = hoja.createRow(8);//Fila para los detalles
		
		celda = fila.createCell((short)12);
		celda.setCellValue("Capital");
		celda.setCellStyle(estiloNeg8);

		celda = fila.createCell((short)13);
		celda.setCellValue("Interés");
		celda.setCellStyle(estiloNeg8);	
		
		celda = fila.createCell((short)14);
		celda.setCellValue("Moratorios");
		celda.setCellStyle(estiloNeg8);	
		
		celda = fila.createCell((short)15);
		celda.setCellValue("Comisiones");
		celda.setCellStyle(estiloNeg8);	
		
		celda = fila.createCell((short)16);
		celda.setCellValue("Total");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)17);
		celda.setCellValue("Recuperado");
		celda.setCellStyle(estiloNeg8);	
		
		celda = fila.createCell((short)18);
		celda.setCellValue("Por Recuperar");
		celda.setCellStyle(estiloNeg8);	

		// Recorremos la lista para la parte de los datos 	
		int i=10,iter=0;
		int tamanioLista = listaCreditos.size();
		CreCastigosAgroRepBean credito = null;
		for( iter=0; iter<tamanioLista; iter ++){
		
			credito = (CreCastigosAgroRepBean) listaCreditos.get(iter);
			fila=hoja.createRow(i);
			 String Vacio="";
			 String Grupos="";
			 String nombreGrup="";
			 if ( Utileria.convierteEntero(credito.getGrupoID()) > 0) {
				 	Vacio= " - ";
				 	Grupos=credito.getGrupoID();
				 	nombreGrup=credito.getNombreGrupo();
			 }else{
				 Vacio="";
				 Grupos="";
				 nombreGrup="N/A";
			 }
			
			celda=fila.createCell((short)1);
			celda.setCellValue(credito.getCreditoID());
			
			celda=fila.createCell((short)2);
			celda.setCellValue(credito.getCreditoContID());
			
			celda=fila.createCell((short)3);
			celda.setCellValue(credito.getTipoCredito());
			
			celda=fila.createCell((short)4);
			celda.setCellValue(credito.getClienteID());
			
			celda=fila.createCell((short)5); 
			celda.setCellValue(credito.getNombreCliente());
			
			celda=fila.createCell((short)6);
			celda.setCellValue(credito.getProducCreditoID()+ " - "+ credito.getDesProductoCred()); 
			
			celda=fila.createCell((short)7);
			celda.setCellValue(Grupos + Vacio + nombreGrup);

			celda=fila.createCell((short)8);
			celda.setCellValue(Double.parseDouble(credito.getMontoCredito()));
			celda.setCellStyle(estiloFormatoDecimal);
			
			celda=fila.createCell((short)9);
			celda.setCellValue(credito.getFecha());
			celda.setCellStyle(estiloDatosCentrado);
			
			celda=fila.createCell((short)10);
			celda.setCellValue(credito.getFechaCastigo());
			celda.setCellStyle(estiloDatosCentrado);
			
			celda=fila.createCell((short)11);
			celda.setCellValue(credito.getDescricpion());
						
			celda=fila.createCell((short)12);
			celda.setCellValue(Double.parseDouble(credito.getCapitalCastigado()));
			celda.setCellStyle(estiloFormatoDecimal);
			
			celda=fila.createCell((short)13);
			celda.setCellValue(Double.parseDouble(credito.getInteresCastigado()));
			celda.setCellStyle(estiloFormatoDecimal);
					
			celda=fila.createCell((short)14);
			celda.setCellValue(Double.parseDouble(credito.getIntMoraCastigado()));
			celda.setCellStyle(estiloFormatoDecimal);

			celda=fila.createCell((short)15);
			celda.setCellValue(Double.parseDouble(credito.getAccesorioCastigado()));
			celda.setCellStyle(estiloFormatoDecimal);		
			
			
			celda=fila.createCell((short)16);
			celda.setCellValue(Double.parseDouble(credito.getTotalCastigo()));
			celda.setCellStyle(estiloFormatoDecimal);

			celda=fila.createCell((short)17);
			celda.setCellValue(Double.parseDouble(credito.getMonRecuperado()));
			celda.setCellStyle(estiloFormatoDecimal);
			
			celda=fila.createCell((short)18);
			celda.setCellValue(Double.parseDouble(credito.getMontoRecuperar()));
			celda.setCellStyle(estiloFormatoDecimal);
		 
			i++;
		}
		 
		i = i+2;
		fila=hoja.createRow(i); // Fila Registros Exportados
		celda = fila.createCell((short)0);
		celda.setCellValue("Registros Exportados");
		celda.setCellStyle(estiloNeg8);
		
		i = i+1;
		fila=hoja.createRow(i); // Fila Total de Registros Exportados
		celda=fila.createCell((short)0);
		celda.setCellValue(tamanioLista);
		

		for(int celd=0; celd<=15; celd++)
		hoja.autoSizeColumn((short)celd);
							
		//Creo la cabecera
		response.addHeader("Content-Disposition","inline; filename=RepCredAgroCastigados.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();
		
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Termina Reporte");
		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte: " + e.getMessage());
			e.printStackTrace();
		}//Fin del catch
	//} 
		
		
	return  listaCreditos;
	
	
	}
	
	
	public CastigosCarteraAgroServicio getCastigosCarteraAgroServicio() {
		return castigosCarteraAgroServicio;
	}

	public String getNomReporte() {
		return nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setCastigosCarteraAgroServicio(
			CastigosCarteraAgroServicio castigosCarteraAgroServicio) {
		this.castigosCarteraAgroServicio = castigosCarteraAgroServicio;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
}



