package cliente.servicio;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import cliente.bean.ReportesPATMIRBean;
import cliente.dao.ReportesPATMIRDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Archivos;
import herramientas.Constantes;

public class ReportesPATMIRServicio extends BaseServicio{
	ReportesPATMIRDAO reportesPATMIRDAO =null;

	public static interface Enum_Reporte_PATMIR{
		int socioMenor=1;
		int parteSocial=2;
		int creditos=3;		
		int ahorros=4;
		int bajas=5;
		int sociosMenores = 6;
		int altasMen = 7;
		int ahorrosMen =8;
		int bajasMen =9;
	}
	
	public MensajeTransaccionBean generaReporte(int tipoReporte, ReportesPATMIRBean PATMIRBean,
												HttpServletResponse response){
		MensajeTransaccionBean mensaje = null;
		switch(tipoReporte){
			case Enum_Reporte_PATMIR.socioMenor:
					generaReporteSocioMenor(PATMIRBean, tipoReporte, response);
				break;
			case Enum_Reporte_PATMIR.parteSocial:
					generaReporteParteSocial(PATMIRBean, tipoReporte, response);
				break;
			case Enum_Reporte_PATMIR.creditos:
					generaReporteCreditos(PATMIRBean, tipoReporte, response);
			break;
			case Enum_Reporte_PATMIR.ahorros:
					generaReporteAhorros(PATMIRBean, tipoReporte, response);		
			break;
			case Enum_Reporte_PATMIR.bajas:
					generaReporteBajas(PATMIRBean, tipoReporte, response);
			break;
			case Enum_Reporte_PATMIR.sociosMenores:
					generaRepoteSociosmenores(PATMIRBean, tipoReporte, response);
			break;
			case Enum_Reporte_PATMIR.altasMen:
				generaRepoteAltasSociosMen(PATMIRBean, tipoReporte, response);
			break;
			case Enum_Reporte_PATMIR.ahorrosMen:
				generaReporteAhorrosMen(PATMIRBean, tipoReporte, response);
			break;
			case Enum_Reporte_PATMIR.bajasMen:
				generaReporteBajasMen(PATMIRBean, tipoReporte, response);
			break;
		}		
		return mensaje;
	}	
	private MensajeTransaccionBean generaReporteSocioMenor(ReportesPATMIRBean PATMIRBean,int tipoReporte,
		 	  HttpServletResponse response){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);	
		
		List listaFocopBeans = reportesPATMIRDAO.consultaSocioMenor(PATMIRBean,tipoReporte);				
		
		String[] nombresCamposBean = {"clienteID","curp","nombre","apellidoPaterno","apellidoMaterno",
				"fechaRegistro", "fechaBaja", "fechaNacimiento", "estadoNacimiento",
				"genero", "nombreLocalidad","calle","lengInd",
				"edoCivil","colonia","recibeServVent","idNivEstudios","idNivIngresos"};
		String [] titulosCamposCSV ={
				"No. Socio","Curp","Nombre","ApPaterno","ApMaterno","FechaRegistro","FechaBaja","FechaNacimiento",
				"EntidadNacimiento","Genero","Localidad","Calle","LenguaInd","EdoCivil","Colonia","RecibeServVent",
				"idNivEstudios","idNivIngresos"
		};
		
		String nombreBean=ReportesPATMIRBean.class.getName();
				
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="PATMIRSocios"+PATMIRBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse		
		try {
		rutaArchivo = Archivos.EscribeArchivoTexto(listaFocopBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "/opt/SAFI/temp/",nombreArchivo, "csv", ";",true);		 
		Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}
		
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
	
	private MensajeTransaccionBean generaReporteCreditos(ReportesPATMIRBean PATMIRBean,int tipoReporte,
		 	  HttpServletResponse response){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);	
		
		List listaPatmirBeans = reportesPATMIRDAO.consultaCreditos(PATMIRBean,tipoReporte);				
		
		String[] nombresCamposBean = {"ClavePA","SocioID","Prestamo"};
		String [] titulosCamposCSV ={
				"Clave PA","No. Socio","Monto"
		};
		
		String nombreBean=ReportesPATMIRBean.class.getName();
		
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="PATMIRCreditos"+PATMIRBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse		
		try {
		rutaArchivo = Archivos.EscribeArchivoTexto(listaPatmirBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "/opt/SAFI/temp/",nombreArchivo, "csv", ";",true);		 
		Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}
		
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
		
	private MensajeTransaccionBean generaReporteAhorros(ReportesPATMIRBean PATMIRBean,int tipoReporte,
		 	  HttpServletResponse response){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);	
		
		List listaPatmirBeans = reportesPATMIRDAO.consultaAhorros(PATMIRBean,tipoReporte);				
		
		String[] nombresCamposBean = {"clavePA", "Socio", "Ahorro","montoInv","total" };
		String[] titulosCamposCSV ={
				"Clave PA","No. Socio","Monto","Inversiones","Total"};
			
		String nombreBean=ReportesPATMIRBean.class.getName();
		
		
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="PATMIRAhorros"+PATMIRBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse		
		try {
		rutaArchivo = Archivos.EscribeArchivoTexto(listaPatmirBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "/opt/SAFI/temp/",nombreArchivo, "csv", ";",true);		 
		Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}
		
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}

	private MensajeTransaccionBean generaReporteParteSocial(ReportesPATMIRBean PATMIRBean,int tipoReporte,
		  	  HttpServletResponse response){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		  
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);	
		  
		List listaPatmirBeans = reportesPATMIRDAO.consultaParteSocial(PATMIRBean,tipoReporte);				
		  
		String[] nombresCamposBean = {"ClavePatmir", "ClienteID","ParteSocial"};
		String[] titulosCamposCSV ={
				"Clave PA","No. Socio","Parte Social"
		};  
		String nombreBean=ReportesPATMIRBean.class.getName();
		  
		  
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="PATMIRParteSocial"+PATMIRBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse		
		try {
		rutaArchivo = Archivos.EscribeArchivoTexto(listaPatmirBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "/opt/SAFI/temp/",nombreArchivo, "csv", ";",true);		 
		Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		  
		}catch(Exception e){
		// TODO Auto-generated catch block
		e.printStackTrace();
		}
		
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
	private MensajeTransaccionBean generaReporteBajas(ReportesPATMIRBean PATMIRBean,int tipoReporte,
		 	  HttpServletResponse response){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);	
		
		List listaPatmirBeans = reportesPATMIRDAO.consultaBajas(PATMIRBean,tipoReporte);				
		
		String[] nombresCamposBean = {"socio", "fechaBaja"};
		String[] titulosCamposCSV = {
				"No. Socio","FechaBaja"
		};
		String nombreBean=ReportesPATMIRBean.class.getName();
			
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="PATMIRBajas"+PATMIRBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse		
		try {
			rutaArchivo = Archivos.EscribeArchivoTexto(listaPatmirBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "/opt/SAFI/temp/",nombreArchivo, "csv", ";",true);		 
			Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}		
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
	// Reportes PATMIR para socios menores 
	private MensajeTransaccionBean generaRepoteSociosmenores(ReportesPATMIRBean PATMIRBean,int tipoReporte,
		 	  HttpServletResponse response){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);	
		
		List listaFocopBeans = reportesPATMIRDAO.consultaSociosMenores(PATMIRBean,tipoReporte);				
		
		String[] nombresCamposBean = {"clienteID","curp","nombre","apellidoPaterno","apellidoMaterno",
				"fechaRegistro", "fechaBaja", "fechaNacimiento", "estadoNacimiento",
				"genero", "nombreLocalidad","calle","lengInd",
				"edoCivil","colonia","recibeServVent","idNivEstudios","idNivIngresos"};
		String [] titulosCamposCSV ={
				"No. Socio","Curp","Nombre","ApPaterno","ApMaterno","FechaRegistro","FechaBaja","FechaNacimiento",
				"EntidadNacimiento","Genero","Localidad","Calle","LenguaInd","EdoCivil","Colonia","RecibeServVent",
				"idNivEstudios","idNivIngresos"
		};
		
		String nombreBean=ReportesPATMIRBean.class.getName();
				
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="PATMIRSociosMenores"+PATMIRBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse		
		try {
		rutaArchivo = Archivos.EscribeArchivoTexto(listaFocopBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "/opt/SAFI/temp/",nombreArchivo, "csv", ";",true);		 
		Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}
		
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
	
	private MensajeTransaccionBean generaRepoteAltasSociosMen(ReportesPATMIRBean PATMIRBean,int tipoReporte,
		 	  HttpServletResponse response){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);	
		
		List listaPatmirBeans = reportesPATMIRDAO.consultaAltasMenores(PATMIRBean,tipoReporte);				
		
		String[] nombresCamposBean = {"socio", "fechaAlta"};
		String[] titulosCamposCSV = {
				"No. Socio","FechaAlta"
		};
		String nombreBean=ReportesPATMIRBean.class.getName();
			
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="PATMIRAltasMenore"+PATMIRBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse		
		try {
			rutaArchivo = Archivos.EscribeArchivoTexto(listaPatmirBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "/opt/SAFI/temp/",nombreArchivo, "csv", ";",true);		 
			Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}		
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
	
	private MensajeTransaccionBean generaReporteAhorrosMen(ReportesPATMIRBean PATMIRBean,int tipoReporte,
		 	  HttpServletResponse response){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);	
		
		List listaPatmirBeans = reportesPATMIRDAO.consultaAhorrosMenores(PATMIRBean,tipoReporte);				
		
		String[] nombresCamposBean = {"clavePA", "Socio", "Ahorro"};
		String[] titulosCamposCSV ={
				"Clave PA","No. Socio","Monto"};
			
		String nombreBean=ReportesPATMIRBean.class.getName();
		
		
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="PATMIRAhorrosMenores"+PATMIRBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse		
		try {
		rutaArchivo = Archivos.EscribeArchivoTexto(listaPatmirBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "/opt/SAFI/temp/",nombreArchivo, "csv", ";",true);		 
		Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}
		
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
	private MensajeTransaccionBean generaReporteBajasMen(ReportesPATMIRBean PATMIRBean,int tipoReporte,
		 	  HttpServletResponse response){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);	
		
		List listaPatmirBeans = reportesPATMIRDAO.consultaBajasMenores(PATMIRBean,tipoReporte);				
		
		String[] nombresCamposBean = {"socio", "fechaBaja"};
		String[] titulosCamposCSV = {
				"No. Socio","FechaBaja"
		};
		String nombreBean=ReportesPATMIRBean.class.getName();
			
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="PATMIRBajasMenores"+PATMIRBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos;
		//todo: VALIDAR listaFocopBeans NO SE nula
		//Aleatorio para el nombre, y borrar el archivo despues de usarse		
		try {
			rutaArchivo = Archivos.EscribeArchivoTexto(listaPatmirBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "/opt/SAFI/temp/",nombreArchivo, "csv", ";",true);		 
			Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}		
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
	
	
	public ReportesPATMIRDAO getReportesPATMIRDAO() {
		return reportesPATMIRDAO;
	}
	public void setReportesPATMIRDAO(ReportesPATMIRDAO reportesPATMIRDAO) {
		this.reportesPATMIRDAO = reportesPATMIRDAO;
	}
}
