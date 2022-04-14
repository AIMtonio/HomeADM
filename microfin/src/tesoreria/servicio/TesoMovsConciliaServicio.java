package tesoreria.servicio;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
 
import credito.servicio.TasasBaseServicio.Enum_Con_TasasBase;
import cuentas.bean.CuentasAhoBean;
import cuentas.bean.CuentasFirmaBean;
import tesoreria.bean.ReqGastoGridBean;
import tesoreria.bean.ReqGastosSucBean;
import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;
import tesoreria.bean.TesoMovsArchConciliaBean;
import tesoreria.bean.TesoMovsConciliaBean;
import tesoreria.bean.TiposMovTesoBean;
import tesoreria.dao.TesoMovsConciliaDAO;
import tesoreria.servicio.ReqGastosSucServicio.Enum_Act_ReqGastos;
import tesoreria.servicio.ReqGastosSucServicio.Enum_TipoDeposito;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class TesoMovsConciliaServicio extends BaseServicio {
	TiposMovTesoBean  tipoMovTeso;
	TesoMovsConciliaDAO tesoMovsConciliaDAO=null;
	TransaccionDAO transaccionDAO = null;
	ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	PolizaDAO polizaDAO = null;
	protected TransactionTemplate transactionTemplate;

	String conceptoConManualID = "75"; // numero de concepto contable para la conciliacion Manual
	String conceptoConManualDes = "CONCILIACION BANCARIA MANUAL"; // descripcion para el concepto contable de conciliacion manual
	String conceptoConManualDesI;
	String automatico = "A"; // indica que se trata de una poliza automatica

	//---------- Tipos de transacciones---------------------------------------------------------------
	public static interface Enum_Tra_TesoMovsConc {
		int banamex		= 9;
		int banorte 	= 24;
		int bancomer	= 37;
		int scotiabank  = 44;
	}
	public static interface Enum_Con_TesoMovsConc {
		int principal   = 1;
		int cancelacion	= 2;
	}
	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_TesoMovsConc {
		int movsNoConciliados   = 1;
	}
	public static interface Enum_Lis_CtaBancaria {
		int ctaBanco1   = 1;
		int ctaBanco   = 2;
		int ctaAhoID	= 4;
	}
	public static interface Enum_Con_CuentasAho{
		int principa 		= 1;
		int foranea 		= 2;
		int pantTesoMovs 	= 3;
	}
	public static interface Enum_FormatoArchivo {
		String Banco		= "B";
		String Estandar		= "E";
	}
	public static interface Enum_VersionArchivo {
		int Anterior		= 1;
		int Actual			= 2;
	}

	public ResultadoCargaArchivosTesoreriaBean grabaTransaccion(int tipoTransaccion,TesoMovsArchConciliaBean tesoMovsConc,String rutaArchivo,String bancoEstandar){
		ResultadoCargaArchivosTesoreriaBean mensaje = null;
		// si el formato que se escogio en pantalla es de algun banco 
		// del que se tenga la rutina entra al case
		if(bancoEstandar.equals(Enum_FormatoArchivo.Banco)){
			switch(tipoTransaccion){
			case Enum_Tra_TesoMovsConc.banamex:
				mensaje = tesoMovsConciliaDAO.cargaArchivoBanamex(tesoMovsConc,rutaArchivo);
				if(mensaje.getNumero()!=0){

				}else{
					mensaje.setNumero(0);
					mensaje.setConsecutivoInt("123");
					mensaje.setConsecutivoString("0000123");
					if(mensaje.getExitosos() <= 0){
						mensaje.setDescripcion(mensaje.getDescripcion());
					}
					mensaje.setDescripcion("Proceso Exitoso."+
							" <br> "+mensaje.getDescripcion());
					mensaje.setNombreControl("institucionID");
				}

				break;
			case Enum_Tra_TesoMovsConc.banorte:
				mensaje = tesoMovsConciliaDAO.cargaArchTesoMovsConcBanorte(tesoMovsConc,rutaArchivo);
				if(mensaje.getNumero()!=0){

				}else{
					mensaje.setNumero(0);
					mensaje.setConsecutivoInt("123");
					mensaje.setConsecutivoString("0000123");
					if(mensaje.getExitosos() <= 0){
						mensaje.setDescripcion(mensaje.getDescripcion());
					}
					mensaje.setDescripcion("Proceso Exitoso."+
							" <br> "+mensaje.getDescripcion());
					mensaje.setNombreControl("institucionID");
				}

				break;		
			case Enum_Tra_TesoMovsConc.bancomer:
				mensaje = tesoMovsConciliaDAO.cargaArchTesoMovsConcBancomer(tesoMovsConc,rutaArchivo);
				if(mensaje.getNumero()!=0){

				}else{
					mensaje.setNumero(0);
					mensaje.setConsecutivoInt("123");
					mensaje.setConsecutivoString("0000123");
					if(mensaje.getExitosos() <= 0){
						mensaje.setDescripcion(mensaje.getDescripcion());
					}
					mensaje.setDescripcion("Proceso Exitoso."+
							" <br> "+mensaje.getDescripcion());
					mensaje.setNombreControl("institucionID");
				}
				break;
			case Enum_Tra_TesoMovsConc.scotiabank:
			
				mensaje = tesoMovsConciliaDAO.cargaArchTesoMovsConcScotiabank(tesoMovsConc,rutaArchivo);
				if(mensaje.getNumero()!=0){

				}else{
					mensaje.setNumero(0);
					mensaje.setConsecutivoInt("123");
					mensaje.setConsecutivoString("0000123");
					if(mensaje.getExitosos() <= 0){
						mensaje.setDescripcion(mensaje.getDescripcion());
					}
					mensaje.setDescripcion("Proceso Exitoso"+
							" <br> "+mensaje.getDescripcion( ));
					mensaje.setNombreControl("institucionID");
				}
				break;	
			default:
				mensaje = new ResultadoCargaArchivosTesoreriaBean();
				mensaje.setNumero(1);
				mensaje.setConsecutivoString("0");
				mensaje.setConsecutivoInt("0");
				mensaje.setNombreControl("file");
				mensaje.setDescripcion("No se encuentra diseñada la carga para este Banco");
				break;
			} 
		}else{
			// si en la pantalla no se selecciono formato banco, quiere decir que seleccionaron el 
			// formato estandar entonces se ejecuta el metodo de la cargar por formato estandar
			mensaje = tesoMovsConciliaDAO.cargaArchTesoMovsConcEstandar(tesoMovsConc,rutaArchivo);
			if(mensaje.getNumero()!=0){

			}else{
				mensaje.setNumero(0);
				mensaje.setConsecutivoInt("123");
				mensaje.setConsecutivoString("0000123");
				if(mensaje.getExitosos() <= 0){
					mensaje.setDescripcion(mensaje.getDescripcion());
				}
				mensaje.setDescripcion("Proceso Exitoso."+
						" <br> "+mensaje.getDescripcion());
				mensaje.setNombreControl("institucionID");
			}
		}	
		return mensaje;
	}

	public TesoMovsArchConciliaBean consulta(int tipoConsulta, TesoMovsArchConciliaBean tesoMovsConcBean){
		TesoMovsArchConciliaBean tesoMovsBean = null;
		switch(tipoConsulta){
		case Enum_Con_TesoMovsConc.principal:
			tesoMovsBean = tesoMovsConciliaDAO.consultaPrincipal(tesoMovsConcBean, Enum_Con_TasasBase.principal);
			break;

		}
		return tesoMovsBean;
	}

	public CuentasAhoBean consultaCtaAhorro(int tipoConsulta, CuentasAhoBean cuentasAho){
		CuentasAhoBean cuentasAhorro = null;
		switch(tipoConsulta){
		case Enum_Con_CuentasAho.pantTesoMovs:
			cuentasAhorro=tesoMovsConciliaDAO.consultaCuentaAho(cuentasAho, tipoConsulta);
			break;

		}
		return cuentasAhorro;
	}

	public List listaCuentasAhoTeso(int tipoLista, TesoMovsArchConciliaBean tesoMovsConcBean){
		List tesoMovsConcLista = null;
		switch (tipoLista) {
		case  Enum_Lis_CtaBancaria.ctaBanco:
			tesoMovsConcLista = tesoMovsConciliaDAO.listaTesoMovsConc(tesoMovsConcBean, tipoLista);
			break;
		case  Enum_Lis_CtaBancaria.ctaAhoID:
			tesoMovsConcLista = tesoMovsConciliaDAO.listaTesoMovsConc(tesoMovsConcBean, tipoLista);
			break;

		}
		return tesoMovsConcLista;
	}

	public List lista(int tipoLista, TesoMovsConciliaBean tesoMovsConciliaBean){
		List tesoMovsConcLista = null;
		switch (tipoLista) {
		case  Enum_Lis_TesoMovsConc.movsNoConciliados:
			tesoMovsConcLista = tesoMovsConciliaDAO.listaMovsNoConciliados(tesoMovsConciliaBean, tipoLista);
			break;	        
		}
		return tesoMovsConcLista;
	}

	// proceso hacer la conciliacion manual
	public MensajeTransaccionBean grabaTransaccion(final TesoMovsConciliaBean tesoConcilia, int tipoTransaccion){
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		switch(tipoTransaccion){
			case Enum_Con_TesoMovsConc.principal:	
				mensaje=tesoMovsConciliaDAO.guardaConciliacion(tesoConcilia);
				break;
			case Enum_Con_TesoMovsConc.cancelacion:
				mensaje = tesoMovsConciliaDAO.cancelaConciliacionManual(tesoConcilia); 
				break;						
		}
		return mensaje;
	}




	public void setTesoMovsConciliaDAO(TesoMovsConciliaDAO tesoMovsConciliaDAO) {
		this.tesoMovsConciliaDAO = tesoMovsConciliaDAO;
	}

	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public TesoMovsConciliaDAO getTesoMovsConciliaDAO() {
		return tesoMovsConciliaDAO;
	}

	public TransactionTemplate getTransactionTemplate() {
		return transactionTemplate;
	}

	public void setTransactionTemplate(TransactionTemplate transactionTemplate) {
		this.transactionTemplate = transactionTemplate;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}


}
