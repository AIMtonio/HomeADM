package tarjetas.servicio;

import tarjetas.bean.LimitesTarDebIndividualBean;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.dao.LimitesTarDebIndividualDAO;
import tarjetas.servicio.ISOTRXServicio.Enum_Pro_TarPeticion_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Tran_ISOTRX;
import general.bean.MensajeTransaccionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

public class LimitesTarDebIndividualServicio extends BaseServicio {
	LimitesTarDebIndividualDAO limitesTarDebIndividualDAO = null;
	ISOTRXServicio isotrxServicio = null;
	private TransaccionDAO transaccionDAO = null;

	public LimitesTarDebIndividualServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_LimitesTarDeb {
	
		int alta=1;
		int modificacion=2;
	}
	
	public static interface Enum_Lis_LimitesTarDeb{
		int principal 		= 1;

	}
	
	public static interface Enum_Con_LimitesTarDeb{
	
        int principal  =1;
        int limiteTarDeb =12;
    }

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, LimitesTarDebIndividualBean limitesTarDebIndividualBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		    case Enum_LimitesTarDeb.alta:
	        case Enum_LimitesTarDeb.modificacion:
		    	mensaje = procesoLimitesTarjetaDebito(limitesTarDebIndividualBean, tipoTransaccion);
			break;
		}
		return mensaje;
	}

	public LimitesTarDebIndividualBean consulta(int tipoConsulta, LimitesTarDebIndividualBean limitesTarDebIndividualBean){
		LimitesTarDebIndividualBean tarjetaDebito = null;
		switch(tipoConsulta){
			case Enum_Con_LimitesTarDeb.principal:
				tarjetaDebito = limitesTarDebIndividualDAO.consultaLimitesTarDeb(Enum_Con_LimitesTarDeb.principal, limitesTarDebIndividualBean);
			break;
			case Enum_Con_LimitesTarDeb.limiteTarDeb:
				tarjetaDebito = limitesTarDebIndividualDAO.consultaTarDebLimite(Enum_Con_LimitesTarDeb.limiteTarDeb, limitesTarDebIndividualBean);
				
			break;
			}
		return tarjetaDebito;
	}

	
	public MensajeTransaccionBean procesoLimitesTarjetaDebito(final LimitesTarDebIndividualBean limitesTarDebIndividualBean, final int tipoTransaccion){

		MensajeTransaccionBean mensajeTransaccionBean = null;
		String mensajeRespuesta = "";
		String controlRespuesta = "";
		String consecutivoRespuesta  = "";
		
		try {
			Long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
			parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion);
			switch(tipoTransaccion){
			    case Enum_LimitesTarDeb.alta:
			    	mensajeTransaccionBean = limitesTarDebIndividualDAO.altaLimiteTarjetaDebito(limitesTarDebIndividualBean);
				break;
		        case Enum_LimitesTarDeb.modificacion:
		        	mensajeTransaccionBean = limitesTarDebIndividualDAO.modificaLimiteTarjetaDebito(limitesTarDebIndividualBean);
				break;
			}

			if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ) {
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			mensajeRespuesta = mensajeTransaccionBean.getDescripcion();
			controlRespuesta = mensajeTransaccionBean.getNombreControl();
			consecutivoRespuesta  = mensajeTransaccionBean.getConsecutivoString();

			loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
			TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
			tarjetaDebitoBean.setTipoTarjeta(Constantes.tipoTarjeta.debito);
			tarjetaDebitoBean.setTarjetaDebID(limitesTarDebIndividualBean.getTarjetaDebID());
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_TarPeticion_ISOTRX.limitesTarjeta, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.tarjetaPeticion);					
			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				mensajeRespuesta = mensajeRespuesta + " "+ "<br><b>WS ISOTRX:</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
				mensajeTransaccionBean.setDescripcion(mensajeRespuesta);
				mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			mensajeTransaccionBean.setDescripcion(mensajeRespuesta);
			mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
			mensajeTransaccionBean.setNombreControl(controlRespuesta);
			mensajeTransaccionBean.setConsecutivoString(consecutivoRespuesta);

		}
		catch (Exception exception) {
			mensajeTransaccionBean.setDescripcion(exception.getMessage());
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el proceso de Limites de Tarjetas de Debito: ", exception);
		}

		return mensajeTransaccionBean;
	}
//--------------------Getter y setter---------------------------------

	public LimitesTarDebIndividualDAO getLimitesTarDebIndividualDAO() {
		return limitesTarDebIndividualDAO;
	}

	public void setLimitesTarDebIndividualDAO(
			LimitesTarDebIndividualDAO limitesTarDebIndividualDAO) {
		this.limitesTarDebIndividualDAO = limitesTarDebIndividualDAO;
	}

	public ISOTRXServicio getIsotrxServicio() {
		return isotrxServicio;
	}

	public void setIsotrxServicio(ISOTRXServicio isotrxServicio) {
		this.isotrxServicio = isotrxServicio;
	}

	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}
}