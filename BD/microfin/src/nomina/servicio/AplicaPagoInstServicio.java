package nomina.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import nomina.bean.AplicaPagoInstBean;
import nomina.dao.AplicaPagoInstDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

public class AplicaPagoInstServicio extends BaseServicio {

	AplicaPagoInstDAO aplicaPagoInstDAO= null;
	TransaccionDAO transaccionDAO = null;
	ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	PolizaDAO polizaDAO = null;
	protected TransactionTemplate transactionTemplate;

	String conceptoConManualID = "54"; // numero de concepto contable para la conciliacion Manual
	String conceptoConManualDes = "PAGO DE CREDITO"; // descripcion para el concepto contable de conciliacion manual
	String automatico = "A"; // indica que se trata de una poliza automatica


	// -------------- Tipo Transaccion ----------------
	public static interface Enum_Tipo_Transaccion{
		int alta     = 1;
		int pagar    = 2;
		int cancelar = 3;
	}
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_PagoNomina{
		int porAplicar	= 1;
		int movsTeso	= 2;
		int principal	= 3;
		int noAplicados	= 4;
		int movsConcilia = 5;
		int tipoMov = 6;
	}

	public static interface Enum_Lis_PagosAplica{
		int pagosAplicaExcel = 2;
	}
	//-------------- Tipo Actualizacion ---------
	private static interface Enum_Act_PagoNomina{
		int cancelarPagos=1;
		int pagosMasivos = 2;
		int pagoIndividual = 3;
	}
	//-------------- Tipo Consulta ---------
	public static interface Enum_Con_PagoNomina{
		int principal   = 1;
		int movTeso 	= 5;
		int pagoApli 	= 9;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,AplicaPagoInstBean pagoInstBean, List listaPagos, List listaPagosNoAplicados) {
	 	MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tipo_Transaccion.alta:
			mensaje = aplicaPagoInstDAO.altaPagosInstituciones(pagoInstBean,parametrosAuditoriaBean.getNumeroTransaccion());
			break;
		case Enum_Tipo_Transaccion.pagar:
			mensaje= realizarPagosGrid(pagoInstBean, listaPagos, listaPagosNoAplicados);
			break;
		case Enum_Tipo_Transaccion.cancelar:
			mensaje= cancelarPagosGrid(pagoInstBean, Enum_Act_PagoNomina.cancelarPagos);
			break;
		}
		return mensaje;
	}

	public AplicaPagoInstBean consulta(int tipoConsulta, AplicaPagoInstBean institucionNominaBean){
		AplicaPagoInstBean institucion = null;
		switch (tipoConsulta) {
			case Enum_Con_PagoNomina.principal:
				institucion = aplicaPagoInstDAO.consultaPrincipal(tipoConsulta, institucionNominaBean);
			break;
			case Enum_Con_PagoNomina.movTeso:
				institucion = aplicaPagoInstDAO.consultaMovTeso(tipoConsulta, institucionNominaBean);
			break;
			case Enum_Con_PagoNomina.pagoApli:
				institucion = aplicaPagoInstDAO.consultaMontoAplicado(tipoConsulta, institucionNominaBean);
			break;
		}
		return institucion;
	}


    public List lista(int tipoLista, AplicaPagoInstBean pagoInstBean){
		List pagoInstLista = null;
		 switch (tipoLista) {
		    case  Enum_Lis_PagoNomina.porAplicar:
		    	pagoInstLista = aplicaPagoInstDAO.listaPagosGrid(pagoInstBean, tipoLista);
		    break;
		    case  Enum_Lis_PagoNomina.principal:
		    	pagoInstLista = aplicaPagoInstDAO.listaPrincipal(pagoInstBean, tipoLista);
		    break;
		    case  Enum_Lis_PagoNomina.noAplicados:
		    	pagoInstLista = aplicaPagoInstDAO.listaImportCreditosGrid(pagoInstBean, tipoLista);
		    break;
		    case  Enum_Lis_PagoNomina.movsConcilia:
		    	pagoInstLista = aplicaPagoInstDAO.listaMovsTeso(pagoInstBean, tipoLista);
		    break;
		    case  Enum_Lis_PagoNomina.tipoMov:
		    	pagoInstLista = aplicaPagoInstDAO.listaTiposMovNomina(pagoInstBean, tipoLista);
		    break;
			}
			return pagoInstLista;
	}

    public List listaCombo(int tipoLista, AplicaPagoInstBean pagoInstBean){
    	List pagoInstitLista = null;
		 switch (tipoLista) {
		    case  Enum_Lis_PagoNomina.movsTeso:
		    	pagoInstitLista = aplicaPagoInstDAO.listaMovsTeso(pagoInstBean, tipoLista);
		    break;
			}
			return pagoInstitLista;
    }


// Método para aplicar los pagos Seleccionados en el Grid
    public MensajeTransaccionBean realizarPagosGrid(final AplicaPagoInstBean pagosInstBean,final List listaPagos, final List listaPagosNoAplicados){
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

			mensaje = aplicaPagoInstDAO.realizarPagosGrid(pagosInstBean, listaPagos, listaPagosNoAplicados);

			return mensaje;
		}

// Método para cancelar los pagos Seleccionados en el Grid
   public MensajeTransaccionBean cancelarPagosGrid(final AplicaPagoInstBean pagosInstBean, final int tipoAct){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = aplicaPagoInstDAO.cancelarPagosGrid(pagosInstBean, tipoAct);

		return mensaje;
	}



// ----------------------------- Getters y Setters ------------------------------------------------------------
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

	public TransactionTemplate getTransactionTemplate() {
		return transactionTemplate;
	}

	public void setTransactionTemplate(TransactionTemplate transactionTemplate) {
		this.transactionTemplate = transactionTemplate;
	}


	public AplicaPagoInstDAO getAplicaPagoInstDAO() {
		return aplicaPagoInstDAO;
	}


	public void setAplicaPagoInstDAO(AplicaPagoInstDAO aplicaPagoInstDAO) {
		this.aplicaPagoInstDAO = aplicaPagoInstDAO;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}



}