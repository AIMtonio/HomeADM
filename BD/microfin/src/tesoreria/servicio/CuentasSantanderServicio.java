package tesoreria.servicio;


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;


import seguridad.bean.ConexionOrigenDatosBean;
import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;
import tesoreria.bean.CuentasSantanderBean;
import tesoreria.dao.CuentasSantanderDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

public class CuentasSantanderServicio extends BaseServicio {
	CuentasSantanderDAO cuentasSantanderDAO = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	
	protected ConexionOrigenDatosBean conexionOrigenDatosBean;
	protected JdbcTemplate jdbcTemplate;
	
	public static interface Enum_Tra_CuentaSantander {
		int alta = 1;
		int actualizacion = 2; 
	}
	public static interface Enum_Tra_RespuestaSantander {
		int procesaArchivoRes = 1;
	}
	
	public static interface Enum_Lis_CuentaSantander {
		int principal = 1; 
	}
	
	// GRABA TRANSACCION
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CuentasSantanderBean cuentasSantanderBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) { 
			case Enum_Tra_CuentaSantander.alta:		
				mensaje = cuentasSantanderDAO.altaCtasSantander(cuentasSantanderBean, tipoTransaccion);				
				break;
			case Enum_Tra_CuentaSantander.actualizacion:		
				mensaje = cuentasSantanderDAO.actualizaCtasSantander(cuentasSantanderBean, tipoTransaccion);				
				break;
		}
		return mensaje;
	}
	
	// GRABA TANSACCION RESPUESTA SANTANDER
	public MensajeTransaccionBean grabaRespuestaSantander(int tipoTransaccion, CuentasSantanderBean cuentasSantanderBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) { 
			case Enum_Tra_RespuestaSantander.procesaArchivoRes:		
				mensaje = ProcesaArchivoRes(cuentasSantanderBean);				
				break;
		}
		return mensaje;
	}
	
	// LISTA PARA CREAR ARCHIVO TXT
	public List listaCreaArchivoTxt(int tipoLista, CuentasSantanderBean cuentasSantanderBean){
		List cuentaSantander = null;
		
		switch (tipoLista) {
		    case  Enum_Lis_CuentaSantander.principal:
		    	cuentaSantander = cuentasSantanderDAO.listaPrincipal(cuentasSantanderBean, tipoLista);
		    break;
		   
		}
		return cuentaSantander;
	}
	
	
	// PROCESO PRINCIPAL PARA LOS ARCHIVOS DE RESPUESTA SANTANDER
	public synchronized MensajeTransaccionBean ProcesaArchivoRes(final CuentasSantanderBean cuentasSantanderBean) {
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		try {
			// VALIDAMOS LA CONFIGURACION ARCHIVO PROPETIES
			ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
			paramGeneralesBean = paramGeneralesServicio.consulta(44, paramGeneralesBean);
			
			if(paramGeneralesBean.getValorParametro()==null || paramGeneralesBean.getValorParametro()==""){
				mensaje.setNumero(800);
				mensaje.setDescripcion("El SAFI ha tenido un problema al concretar la operación." +
										" Favor de revisar la Configuración de <b>Conexión</b>");
				
				Utileria.borraArchivo(cuentasSantanderBean.getRutaArchCtasActivas());
				Utileria.borraArchivo(cuentasSantanderBean.getRutaArchCtasPendientes());
				throw new Exception(mensaje.getDescripcion());
			}
		
			//PROCESAMOS LOS ARCHIVOS
			mensaje =cuentasSantanderDAO.procesaArchivoCtas(cuentasSantanderBean, paramGeneralesBean.getValorParametro());
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}

			
		} catch (Exception e) {
			if(mensaje .getNumero()==0){
				mensaje .setNumero(999);
				mensaje.setDescripcion("Error en Proceso el archivo");
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Proceso el archivo", e);
		}
		
		return mensaje;
		
	}


	
	

	public CuentasSantanderDAO getCuentasSantanderDAO() {
		return cuentasSantanderDAO;
	}


	public void setCuentasSantanderDAO(CuentasSantanderDAO cuentasSantanderDAO) {
		this.cuentasSantanderDAO = cuentasSantanderDAO;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}
	
	
	

}
