package cliente.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Archivos;
import herramientas.Constantes;
import cliente.bean.ReportesFOCOOPBean;
import cliente.dao.ReportesFOCOOPDAO;
import java.util.Calendar;
import java.util.GregorianCalendar;

public class ReportesFOCOOPServicio extends BaseServicio{
	ReportesFOCOOPDAO reportesFOCOOPDAO=null;

	
	public static interface Enum_Reporte_FOCOOP{
		int Cartera = 1;
		int Captacion = 2;	
		int Aportacion = 3;
	}
	
	public static interface Enum_Lis_FOCOOP {
        int carteraRepEx= 1;      // Reporte de Cartera en Excel FOCOOP
        int captacionRepEx= 2;    // Reporte de Captacion en Excel FOCOOP
        int aportacionRepEx= 3;   // Reporte de Aportacion en Excel FOCOOP
	}
	
	public MensajeTransaccionBean generaReporte(int tipoReporte, ReportesFOCOOPBean FOCOOPBean,
												HttpServletResponse response){
		MensajeTransaccionBean mensaje = null;
		switch (tipoReporte) {
			case Enum_Reporte_FOCOOP.Cartera:
				mensaje = generaReporteCartera(FOCOOPBean,tipoReporte,response);
				break;
			case Enum_Reporte_FOCOOP.Captacion:		
				mensaje = generaReporteCaptacion(FOCOOPBean,tipoReporte,response);
				break;
			case Enum_Reporte_FOCOOP.Aportacion:		
				mensaje = generaReporteAportacion(FOCOOPBean,tipoReporte,response);
				break;
		}
		return mensaje;
	}	
	
	private MensajeTransaccionBean generaReporteCaptacion(ReportesFOCOOPBean FOCOOPBean,int tipoReporte,
													 	  HttpServletResponse response){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);	
		
		List listaFocopBeans = reportesFOCOOPDAO.consultaCaptacion(FOCOOPBean,tipoReporte);				
		
		String[] nombresCamposBean = {"numSocio", "nombreSocio", "numCuenta", "sucursal", "fechaApertura",
									   "tipoCuenta", "fechaUltDeposito", "fechaVencimiento", "plazoDeposito",
									   "formaPagRendimientos", "tasaNominal","saldoPromedio",
									   "capital","intDevenNoPagados","saldoTotalCieMes","interesesGeneradoMes"};
		String[] titulosCamposCSV={
				"Número de socio","Nombre del socio","Núm. Contrato o Cuenta","Sucursal","Fecha de apertura o contratación",
				"Tipo de depósito (cuenta o producto)","Fecha del depósito (último) ","Fecha de vencimiento","Plazo del depósito (días)",
				"Forma de pago de rendimientos (días)","Tasa de interés nominal pactada (anual) en %","Saldo Promedio (para determinar intereses mens)",
				"Monto del Ahorro o Depósito Plazo(capital)","Intereses Devengados No Pagados al cierre del mes Dep a Plazo(acumulados)",
				"Saldo Total al cierre del mes (capital + Int Dev No Pag en los Dep a Plazo)","Intereses Generados en el mes (devengados pagados y no pagados del mes)"
		};
		
		String nombreBean=ReportesFOCOOPBean.class.getName();
		
		
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="FOCOOPCaptacion"+FOCOOPBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse		
		try {
		  rutaArchivo = Archivos.EscribeArchivoTexto(listaFocopBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "",nombreArchivo, "csv", ";",true);		 
		  Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		  
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
	
	private MensajeTransaccionBean generaReporteCartera(ReportesFOCOOPBean FOCOOPBean,int tipoReporte,HttpServletResponse response){
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);
		List listaFocopBeans = reportesFOCOOPDAO.consultaCartera(FOCOOPBean,tipoReporte);
		String[] nombresCamposBean = { "nombreCompleto", "numSocio", 	"contrato", 	"sucursal","clasificacion",
				"producto","modalidaPago","fechaOtorgamiento","montoOriginal","fechaVencimien", "formula",
				"tasaOrdinaria",  "tasaMoratoria","plazoCredito","frecuenciaPagoCapital","frecuenciaPagoIn",
				"diasMora", "saldoCapitalVigente","saldoCapitalVencido","interesDevNoCobVig","interesDevNoCobVen",
				"interesDevenNoCobCuentasOrden","fechaUltPagCap","montoUltPagCap","fechaUltPagoInteres",
				"montoUltPagInteres","renReesNor","numeroReest","numeroRenov","emproblemado","vigenteVencido","cargoDelAcreditado",
				"montoGarantiaLiquida","garantiaLiquida","montoGarantiaPrendaria","montoGarantiaHipoteca",
				"eprCubierta", "eprExpuesta","eprInteresesCaVe"
		};
		
		String[] titulosCamposCSV={
				"NOMBRE DEL ACREDITADO","NÚMERO DE SOCIO","NO. CONTRATO","SUCURSAL","CLASIFICACIÓN DEL CRÉDITO",
				"PRODUCTO DE CRÉDITO","MODALIDAD DE PAGO","FECHA DE OTORGAMIENTO","MONTO ORIGINAL","FECHA DE VENCIMIENTO","FORMULA",
				"TASA ORDINARIA NOMINAL ANUAL%","TASA MORATORIA NOMINAL ANUAL%","PLAZO DEL CREDITO (meses)","FRECUENCIA DE PAGO CAPITAL","FRECUENCIA DE PAGO INTERESES",
				"DÍAS DE MORA","CAPITAL VIGENTE","CAPITAL VENCIDO","INTERESES DEVENGADOS NO COBRADOS VIGENTE","INTERESES DEVENGADOS NO COBRADOS VENCIDO",
				"INTERESES DEVENGADOS NO COBRADOS CUENTAS DE ORDEN","Fecha Último Pago Capital","Monto Último Pago Capital","Fecha Último Pago Intereses",
				"Monto Último Pago Intereses","Renovado Reestructurado  o Normal", "No. de veces reestructurado","No. de veces renovado","Emproblemado","Vigente o Vencido",
				"CARGO DEL ACREDITADO PARTE RELACIONADA art.26 LRASCAP",
				"MONTO GARANTÍA LÍQUIDA","CUENTA(S) SOBRE LA(S) QUE SE CONSTITUYO GARANTÍA LÍQUIDA","MONTO GARANTÍA PRENDARIA","MONTO GARANTÍA HIPOTECARIA",
				"EPRC PARA PARTE CUBIERTA","EPRC PARA PARTE EXPUESTA","EPRC X INTERESES DE CaVe"
		};
		
		// Reorganiza campos y parametros para las columnas de numero de resstructura y renovación
		if(FOCOOPBean.getTipoRepCar().equals("N")){
			String[] auxNomCampos = nombresCamposBean;
			String[] auxTitomCampos = titulosCamposCSV;
			int auxCellmovs = 2;
			
			for(int i=0;i<27;i++){
				nombresCamposBean[i] = auxNomCampos[i];
				titulosCamposCSV[i] = auxTitomCampos[i];
			}
			
			for(int i=27;i<(nombresCamposBean.length-auxCellmovs);i++){
				nombresCamposBean[i] = auxNomCampos[i + auxCellmovs];
				titulosCamposCSV[i] = auxTitomCampos[i + auxCellmovs];
			}
		}
		
		
		String nombreBean=ReportesFOCOOPBean.class.getName();
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="FOCOOPCartera"+FOCOOPBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse
		try {
		  rutaArchivo = Archivos.EscribeArchivoTexto(listaFocopBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "",nombreArchivo, "csv", ";",true);
		  Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
	
	private MensajeTransaccionBean generaReporteAportacion(ReportesFOCOOPBean FOCOOPBean,int tipoReporte,HttpServletResponse response){
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);
		List listaFocopBeans = reportesFOCOOPDAO.aportacionSocio(FOCOOPBean,tipoReporte);
		String[] nombresCamposBean = { "numSocio", "nombreSocio", "apellidoPaterno", "apellidoMaterno","CURP","tipoAportacion",
										"fechaIngreso","sexo","aporteSocio"
										};
		String[] titulosCamposCSV={
				"No. Socio","Nombre","Apellido Paterno","Apellido Materno","CURP","Tipo Aportación",
				"Fecha Ingreso","Sexo","Parte Social"
				};
		String nombreBean=ReportesFOCOOPBean.class.getName();
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="FOCOOPAportacionesSocios"+"-"+FOCOOPBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse
		try {
		  rutaArchivo = Archivos.EscribeArchivoTexto(listaFocopBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "",nombreArchivo, "csv", ";",true);
		  Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
	

	/* Case para listas de reportes de FOCOOP */
	public List listaReportesFOCOOP(int tipoLista, ReportesFOCOOPBean FOCOOPBean){
		 List listaFOCOOP=null;
	
		switch(tipoLista){
			case Enum_Lis_FOCOOP.carteraRepEx:
				listaFOCOOP = reportesFOCOOPDAO.consultaCartera(FOCOOPBean, tipoLista); 
				break;	
			case Enum_Lis_FOCOOP.captacionRepEx:
				listaFOCOOP = reportesFOCOOPDAO.consultaCaptacion(FOCOOPBean, tipoLista); 
				break;	
			case Enum_Lis_FOCOOP.aportacionRepEx:
				listaFOCOOP = reportesFOCOOPDAO.aportacionSocio(FOCOOPBean, tipoLista); 
				break;	
		}
		
		return listaFOCOOP;
	}
	
	// ------------ GETTERS Y SETTERS ---------------------------------------------
	
	public ReportesFOCOOPDAO getReportesFOCOOPDAO() {
		return reportesFOCOOPDAO;
	}

	public void setReportesFOCOOPDAO(ReportesFOCOOPDAO reportesFOCOOPDAO) {
		this.reportesFOCOOPDAO = reportesFOCOOPDAO;
	}
}