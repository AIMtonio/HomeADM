package pld.reporte;

import general.bean.ParametrosAuditoriaBean;
import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import java_cup.shift_action;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.FontFamily;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AvalesBean;
import credito.bean.CreditosBean;
import credito.servicio.AvalesServicio;
import credito.servicio.CreditosServicio;
import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;
import pld.bean.SociosAltoRiesgoRepBean;
import pld.servicio.SociosAltoRiesgoRepServicio;

public class ReporteSociosAltoRiesgoControlador extends AbstractCommandController{

	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	SociosAltoRiesgoRepServicio sociosAltoRiesgoRepServicio = null;
	CuentasAhoServicio cuentasAhoServicio = null;
	InversionServicio inversionServicio = null;
	CreditosServicio creditosServicio = null;
	AvalesServicio avalesServicio = null;
	String nombreReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		    int  ReporExcel= 1 ;
	}
	
	public static interface Enum_Con_TipoLista {
		int CuentasAhorro = 4;
		int Inversiones = 2;
		int Creditos = 7;
		int CreditosAvalados = 27;
		int AvalesCliente = 3;
	}
	
	public ReporteSociosAltoRiesgoControlador () {
		setCommandClass(SociosAltoRiesgoRepBean.class);
		setCommandName("sociosAltoRiesgoRepBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errors)throws Exception {
		
		SociosAltoRiesgoRepBean sociosAltoRiesgoRepBean = (SociosAltoRiesgoRepBean) command;

			int tipoReporte =(request.getParameter("tipoReporte")!=null)?
							Integer.parseInt(request.getParameter("tipoReporte")):
							0;
			int tipoLista =(request.getParameter("tipoLista")!=null)?
							Integer.parseInt(request.getParameter("tipoLista")):
							0;
		
			loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Entra en controlador: "+ tipoReporte);
		switch(tipoReporte){			
			case Enum_Con_TipRepor.ReporExcel:		
				 List listaReportes = listaSociosAltoRiesgo(tipoLista,sociosAltoRiesgoRepBean,response);
			break;
		}
		return null;
			
	}

	// Reporte de Socios de Alto Riesgo //
	public List  listaSociosAltoRiesgo(int tipoLista,SociosAltoRiesgoRepBean sociosAltoRiesgoRepBean,  HttpServletResponse response){
		List listaSociosAltoRiesgo = null;
		List listaCuentaAho = null;
		List listaInversiones = null;
		List listaCreditos = null;
		List listaCredAvalados = null;
		List listaAvales = null;
		listaSociosAltoRiesgo = sociosAltoRiesgoRepServicio.listaSociosAltoRiesgoRep(tipoLista,sociosAltoRiesgoRepBean,response); 	
	
		int regExport = 0;
	
		try {
			XSSFWorkbook libro = new XSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFFont fuenteNegrita10= (XSSFFont) libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);		
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8= (XSSFFont) libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Arial");
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			XSSFFont fuenteArial8 = (XSSFFont) libro.createFont();
			fuenteArial8.setFontHeightInPoints((short)8);
			fuenteArial8.setFontName("Arial");
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			XSSFCellStyle estiloNeg10 = (XSSFCellStyle) libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			XSSFCellStyle estiloNeg8 = (XSSFCellStyle) libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			XSSFCellStyle estiloDatosCentrado = (XSSFCellStyle) libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
			
			XSSFCellStyle estiloCentrado = (XSSFCellStyle) libro.createCellStyle();			
			estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			estiloCentrado.setFont(fuenteNegrita10);
			
			//estilo centrado para id y fechas
			XSSFCellStyle estiloCentrado2 = (XSSFCellStyle) libro.createCellStyle();	
			estiloCentrado2.setFont(fuenteArial8);		
			estiloCentrado2.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			
			//estilo para poner fuente Arial al cuerpo de la tabla (datos)
			XSSFCellStyle estiloArial = libro.createCellStyle();
			estiloArial.setVerticalAlignment((short)XSSFCellStyle.ALIGN_LEFT);
			estiloArial.setFont(fuenteArial8);
	
			//estilo alineado a la derecha para cantidades
			XSSFCellStyle estiloAlineaDerecha = (XSSFCellStyle) libro.createCellStyle();
			estiloAlineaDerecha.setFont(fuenteArial8);
			estiloAlineaDerecha.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = (XSSFCellStyle) libro.createCellStyle();
			XSSFDataFormat format = (XSSFDataFormat) libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja					
			XSSFSheet hoja = (XSSFSheet) libro.createSheet("Reporte Socios Alto Riesgo");
			XSSFRow fila= hoja.createRow(0);
		
			// inicio usuario,fecha y hora
			XSSFCell celdaUsu=fila.createCell((short)1);
			
			celdaUsu = fila.createCell((short)9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)10);
			celdaUsu.setCellValue((!sociosAltoRiesgoRepBean.getUsuario().isEmpty())?sociosAltoRiesgoRepBean.getUsuario().toUpperCase(): "TODOS");
			celdaUsu.setCellStyle(estiloArial);
			
			String horaVar=sociosAltoRiesgoRepBean.getHoraEmision();
			String fechaVar=sociosAltoRiesgoRepBean.getFechaEmision();
			String nombreSucursal = sociosAltoRiesgoRepBean.getNombreSucursal();
			int itera=0;
			SociosAltoRiesgoRepBean socioAltoRiesgoHora = null;
			if(!listaSociosAltoRiesgo.isEmpty()){
				for( itera=0; itera<1; itera ++){
					socioAltoRiesgoHora = (SociosAltoRiesgoRepBean) listaSociosAltoRiesgo.get(itera);
					horaVar= socioAltoRiesgoHora.getHoraEmision();								
				}
			}
				
			fila = hoja.createRow(1);
			XSSFCell celdaFec=fila.createCell((short)1);
					
			celdaFec = fila.createCell((short)9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)10);
			celdaFec.setCellValue(fechaVar);
			celdaFec.setCellStyle(estiloArial);
			 
			// Nombre Institucion	
			XSSFCell celdaInst=fila.createCell((short)1);
			celdaInst.setCellValue(sociosAltoRiesgoRepBean.getNombreInstitucion());
								
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            6  //ultima celda   (0-based)
			    ));
			  
			celdaInst.setCellStyle(estiloCentrado);	
			
			fila = hoja.createRow(2);
			XSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)9);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)10);
			celdaHora.setCellValue(horaVar);
			celdaHora.setCellStyle(estiloArial);
			
			// Titulo del Reporte
						XSSFCell celda=fila.createCell((short)1);					
						celda.setCellValue("REPORTE DE SOCIOS DE ALTO RIESGO");
										
						 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
						            2, //primera fila (0-based)
						            2, //ultima fila  (0-based)
						            1, //primer celda (0-based)
						            6  //ultima celda   (0-based)
						    ));
						 
						 celda.setCellStyle(estiloCentrado);
			
			
			// Creacion de fila
			fila = hoja.createRow(3); // Fila vacia
			//fila = hoja.createRow(4);// Campos
	/*
			celda = fila.createCell((short)1);
			celda.setCellValue("NO. SOCIO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("NOMBRE SOCIO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("SUCURSAL");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("NOMBRE SUCURSAL");
			celda.setCellStyle(estiloNeg8);
				
			celda = fila.createCell((short)5);
			celda.setCellValue("FECHA INSCRIPCIÓN");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("DIRECCIÓN SOCIO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("OCUPACIÓN");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("ACTIVIDAD BMX");
			celda.setCellStyle(estiloNeg8);
	*/
	
			// Recorremos la lista para la parte de los datos 	
			int i=4, iter=0;
			int tamanioLista = listaSociosAltoRiesgo.size();
			SociosAltoRiesgoRepBean sociosAltoRiesgo = null;
			regExport = regExport + tamanioLista;
			for(iter=0; iter<tamanioLista; iter ++){
				sociosAltoRiesgo = (SociosAltoRiesgoRepBean) listaSociosAltoRiesgo.get(iter);
				fila=hoja.createRow(i);
	
				celda = fila.createCell((short)1);
				celda.setCellValue("NO. SOCIO");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("NOMBRE SOCIO");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("SUCURSAL");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("NOMBRE SUCURSAL");
				celda.setCellStyle(estiloNeg8);
					
				celda = fila.createCell((short)5);
				celda.setCellValue("FECHA INSCRIPCIÓN");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("DIRECCIÓN SOCIO");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("OCUPACIÓN");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("ACTIVIDAD BMX");
				celda.setCellStyle(estiloNeg8);
				
				i = i + 1;
				fila=hoja.createRow(i);
				celda=fila.createCell((short)1);
				celda.setCellValue(sociosAltoRiesgo.getClienteID());
				celda.setCellStyle(estiloCentrado2);
				
				celda=fila.createCell((short)2);
				celda.setCellValue(sociosAltoRiesgo.getNombreClienteID());
				celda.setCellStyle(estiloArial);
				
				celda=fila.createCell((short)3); 
				celda.setCellValue(sociosAltoRiesgo.getSucursalID());
				celda.setCellStyle(estiloCentrado2);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(sociosAltoRiesgo.getNombreSucursal()); 
				celda.setCellStyle(estiloArial);
				
				celda=fila.createCell((short)5);
				celda.setCellValue(sociosAltoRiesgo.getFechaAlta());
				celda.setCellStyle(estiloArial);		 
				
				celda=fila.createCell((short)6);
				celda.setCellValue(sociosAltoRiesgo.getDireccion());
				celda.setCellStyle(estiloArial);
				
				celda=fila.createCell((short)7);
				celda.setCellValue(sociosAltoRiesgo.getDescOcupacion());
				celda.setCellStyle(estiloArial);
				
				celda=fila.createCell((short)8);
				celda.setCellValue(sociosAltoRiesgo.getActividadBMX());
				celda.setCellStyle(estiloArial);
				
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setClienteID(sociosAltoRiesgo.getClienteID());
				listaCuentaAho = cuentasAhoServicio.lista(Enum_Con_TipoLista.CuentasAhorro, cuentasAho);
				regExport = regExport + listaCuentaAho.size();
				i = i+1;
				if(listaCuentaAho.size()>0){
					//crea encabezado para cuentas de ahorro
					fila=hoja.createRow(i);
					celda = fila.createCell((short)1);
					celda.setCellValue("Cuentas de Ahorro");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("No. Cuenta");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("Tipo");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)4);
					celda.setCellValue("Etiqueta");
					celda.setCellStyle(estiloNeg8);
						
					celda = fila.createCell((short)5);
					celda.setCellValue("Saldo");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)6);
					celda.setCellValue("Saldo Disponible");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)7);
					celda.setCellValue("Saldo SBC");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("Saldo Bloqueado");
					celda.setCellStyle(estiloNeg8);
					
					CuentasAhoBean cuentasbean = null;
					i = i+1;
					for(int iter2=0; iter2<listaCuentaAho.size(); iter2 ++){
						cuentasbean = (CuentasAhoBean) listaCuentaAho.get(iter2);
						fila=hoja.createRow(i);
						celda=fila.createCell((short)2);
						celda.setCellValue(cuentasbean.getCuentaAhoID());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)3); 
						celda.setCellValue(cuentasbean.getTipoCuentaID());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(cuentasbean.getEtiqueta()); 
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)5);
						celda.setCellValue("$" + cuentasbean.getSaldo());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)6);
						celda.setCellValue("$" + cuentasbean.getSaldoDispon());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)7);
						celda.setCellValue("$" + cuentasbean.getSaldoSBC());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)8);
						celda.setCellValue("$" + cuentasbean.getSaldoBloq());
						celda.setCellStyle(estiloAlineaDerecha);
						i = i+1;
					}
				}
				
				InversionBean inversiones = new InversionBean();
				inversiones.setClienteID(sociosAltoRiesgo.getClienteID());
				listaInversiones = inversionServicio.lista(Enum_Con_TipoLista.Inversiones, inversiones);
				regExport = regExport + listaInversiones.size();
				if(listaInversiones.size()>0){
					//crea encabezado para inversiones
					fila=hoja.createRow(i);
					celda = fila.createCell((short)1);
					celda.setCellValue("Inversiones");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("No. Inversión");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("Tipo");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)4);
					celda.setCellValue("Etiqueta");
					celda.setCellStyle(estiloNeg8);
						
					celda = fila.createCell((short)5);
					celda.setCellValue("Inicio");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)6);
					celda.setCellValue("Vencimiento");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)7);
					celda.setCellValue("Monto");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("Tasa Neta");
					celda.setCellStyle(estiloNeg8);
	
					celda = fila.createCell((short)9);
					celda.setCellValue("Interés Generado");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)10);
					celda.setCellValue("Interés a Retener");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)11);
					celda.setCellValue("Interés a Recibir");
					celda.setCellStyle(estiloNeg8);
					
					InversionBean inversionbean = null;
					i = i+1;
					for(int iter2=0; iter2<listaInversiones.size(); iter2 ++){
						inversionbean = (InversionBean) listaInversiones.get(iter2);
						fila=hoja.createRow(i);
						celda=fila.createCell((short)2);
						celda.setCellValue(inversionbean.getInversionID());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)3); 
						celda.setCellValue(inversionbean.getTipoInversionID());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(inversionbean.getEtiqueta()); 
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(inversionbean.getFechaInicio());
						celda.setCellStyle(estiloArial);			 
						
						celda=fila.createCell((short)6);
						celda.setCellValue(inversionbean.getFechaVencimiento());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)7);
						celda.setCellValue("$" + inversionbean.getMontoString());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(inversionbean.getTasaNetaString());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)9);
						celda.setCellValue(inversionbean.getInteresGeneradoString());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)10);
						celda.setCellValue(inversionbean.getInteresRetenerString());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(inversionbean.getInteresRecibirString());
						celda.setCellStyle(estiloAlineaDerecha);
						i = i+1;
					}
				}
				
				CreditosBean creditos = new CreditosBean();
				creditos.setClienteID(sociosAltoRiesgo.getClienteID());
				listaCreditos = creditosServicio.lista(Enum_Con_TipoLista.Creditos, creditos);
				regExport = regExport + listaCreditos.size();
				if(listaCreditos.size()>0){
					//crea encabezado para creditos
					fila=hoja.createRow(i);
					celda = fila.createCell((short)1);
					celda.setCellValue("Créditos");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("No. Crédito");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("Producto Crédito");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)4);
					celda.setCellValue("Fecha Solicitud");
					celda.setCellStyle(estiloNeg8);
						
					celda = fila.createCell((short)5);
					celda.setCellValue("Monto Solicitado");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)6);
					celda.setCellValue("Monto Otorgado");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)7);
					celda.setCellValue("Fecha Desembolso");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("Fecha de Vencimiento");
					celda.setCellStyle(estiloNeg8);
	
					celda = fila.createCell((short)9);
					celda.setCellValue("Saldo Total");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)10);
					celda.setCellValue("Monto Exigible");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)11);
					celda.setCellValue("Fecha Prox. Vto.");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)12);
					celda.setCellValue("Estatus");
					celda.setCellStyle(estiloNeg8);
					
					CreditosBean creditosbean = null;
					i = i+1;
					for(int iter2=0; iter2<listaCreditos.size(); iter2 ++){
						creditosbean = (CreditosBean) listaCreditos.get(iter2);
						fila=hoja.createRow(i);
						celda=fila.createCell((short)2);
						celda.setCellValue(creditosbean.getCreditoID());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)3); 
						celda.setCellValue(creditosbean.getProducCreditoID());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(creditosbean.getFechaAutoriza()); 
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)5);
						celda.setCellValue("$" + creditosbean.getMontoPagar());
						celda.setCellStyle(estiloAlineaDerecha);				 
						
						celda=fila.createCell((short)6);
						celda.setCellValue("$" + creditosbean.getMontoCredito());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(creditosbean.getFechaMinistrado());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(creditosbean.getFechaVencimiento());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)9);
						celda.setCellValue("$" + creditosbean.getMontoDesemb());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)10);
						celda.setCellValue("$" + creditosbean.getPagoExigible());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(creditosbean.getFechaCorte());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)12);
						celda.setCellValue(creditosbean.getEstatus());
						celda.setCellStyle(estiloArial);
						i = i+1;
					}
				}
	
				listaCredAvalados = creditosServicio.lista(Enum_Con_TipoLista.CreditosAvalados, creditos);
				regExport = regExport + listaCredAvalados.size();
				if(listaCredAvalados.size()>0){
					//crea encabezado para creditos avalados
					fila=hoja.createRow(i);
					celda = fila.createCell((short)1);
					celda.setCellValue("Créditos Avalados");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("No. Cliente");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("Nombre Cliente");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)4);
					celda.setCellValue("No. Crédito");
					celda.setCellStyle(estiloNeg8);
						
					celda = fila.createCell((short)5);
					celda.setCellValue("Producto Crédito");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)6);
					celda.setCellValue("Monto Original Crédito");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)7);
					celda.setCellValue("Saldo Capital al Día");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("Estatus");
					celda.setCellStyle(estiloNeg8);
	
					celda = fila.createCell((short)9);
					celda.setCellValue("Días Atraso");
					celda.setCellStyle(estiloNeg8);
					
					CreditosBean creditosbean = null;
					i = i+1;
					for(int iter2=0; iter2<listaCredAvalados.size(); iter2 ++){
						creditosbean = (CreditosBean) listaCredAvalados.get(iter2);
						fila=hoja.createRow(i);
						celda=fila.createCell((short)2);
						celda.setCellValue(creditosbean.getClienteID());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)3); 
						celda.setCellValue(creditosbean.getNombreCliente());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(creditosbean.getCreditoID()); 
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(creditosbean.getProducCreditoID());
						celda.setCellStyle(estiloArial);			 
						
						celda=fila.createCell((short)6);
						celda.setCellValue("$" + creditosbean.getMontoCredito());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)7);
						celda.setCellValue("$" + creditosbean.getSaldoCapVigent());
						celda.setCellStyle(estiloAlineaDerecha);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(creditosbean.getEstatus());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)9);
						celda.setCellValue(creditosbean.getDiasAtraso());
						celda.setCellStyle(estiloArial);
						i = i+1;
					}
				}
				
				AvalesBean avales = new AvalesBean();
				avales.setClienteID(sociosAltoRiesgo.getClienteID());
				listaAvales = avalesServicio.lista(Enum_Con_TipoLista.AvalesCliente, avales);
				regExport = regExport + listaAvales.size();
				if(listaAvales.size()>0){
					//crea encabezado para avales
					fila=hoja.createRow(i);
					celda = fila.createCell((short)1);
					celda.setCellValue("Avales");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("No. Cliente Aval");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("Nombre Cliente");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)4);
					celda.setCellValue("Sucursal");
					celda.setCellStyle(estiloNeg8);
						
					celda = fila.createCell((short)5);
					celda.setCellValue("Teléfonos");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)6);
					celda.setCellValue("Dirección");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)7);
					celda.setCellValue("No. Crédito");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("Estatus");
					celda.setCellStyle(estiloNeg8);
					
					AvalesBean avalesbean = null;
					i = i+1;
					for(int iter2=0; iter2<listaAvales.size(); iter2 ++){
						avalesbean = (AvalesBean) listaAvales.get(iter2);
						fila=hoja.createRow(i);
						celda=fila.createCell((short)2);
						celda.setCellValue(avalesbean.getClienteID());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)3); 
						celda.setCellValue(avalesbean.getNombreCompleto());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(avalesbean.getSucursal()); 
						celda.setCellStyle(estiloArial);
						
						String telefonos = "";
						telefonos = telefonos + ((avalesbean.getTelefono()==null||avalesbean.getTelefono().equals(""))?"" : avalesbean.getTelefono());
						if(telefonos.length()>0)
							telefonos = telefonos + ", ";
						telefonos = telefonos + ((avalesbean.getTelefonoCel()==null||avalesbean.getTelefonoCel().equals(""))?"" : avalesbean.getTelefonoCel());
						
						celda=fila.createCell((short)5);
						celda.setCellValue(telefonos);	
						celda.setCellStyle(estiloArial);					 
						
						celda=fila.createCell((short)6);
						celda.setCellValue(avalesbean.getDireccionCompleta());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(avalesbean.getCreditoID());
						celda.setCellStyle(estiloArial);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(avalesbean.getEstatus());
						celda.setCellStyle(estiloArial);
						i = i+1;
					}
				}
				
				i++;
			}
			 
			i = i+1;
			fila=hoja.createRow(i); // Fila Registros Exportados
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			i = i + 1;
			fila=hoja.createRow(i); // Fila Total de Registros Exportados
			celda=fila.createCell((short)0);
			celda.setCellValue(regExport);
			
	
			for(int celd=0; celd<=15; celd++)
				hoja.autoSizeColumn((short)celd);
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepSociosAltoRiesgo.xlsx");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Termina Reporte");
		} catch(Exception e) {
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte Socios de Alto Riesgo: " + e.getMessage());
			e.printStackTrace();
		}//Fin del catch
		
		return  listaSociosAltoRiesgo;		
	}
	
	// getter y setters //
	
	
	public String getSuccessView() {
		return successView;
	}

	public SociosAltoRiesgoRepServicio getSociosAltoRiesgoRepServicio() {
		return sociosAltoRiesgoRepServicio;
	}

	public void setSociosAltoRiesgoRepServicio(
			SociosAltoRiesgoRepServicio sociosAltoRiesgoRepServicio) {
		this.sociosAltoRiesgoRepServicio = sociosAltoRiesgoRepServicio;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	public InversionServicio getInversionServicio() {
		return inversionServicio;
	}

	public void setInversionServicio(InversionServicio inversionServicio) {
		this.inversionServicio = inversionServicio;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public AvalesServicio getAvalesServicio() {
		return avalesServicio;
	}

	public void setAvalesServicio(AvalesServicio avalesServicio) {
		this.avalesServicio = avalesServicio;
	}
}

