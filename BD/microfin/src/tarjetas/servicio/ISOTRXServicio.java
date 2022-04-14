package tarjetas.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.dao.ISOTRXDAO;

public class ISOTRXServicio extends BaseServicio {

	ISOTRXDAO isotrxDAO = null;

	public static interface Enum_Tran_ISOTRX {
		int tarjetaPeticion	  = 1;
		int operacionPeticion = 2;
	}

	public static interface Enum_Con_ISOTRX {
		int tarjetaPeticion	  = 1;
		int operacionPeticion = 2;
	}
	
	public static interface Enum_Pro_TarPeticion_ISOTRX {
		int activacionTarjeta	= 1;
		int cancelacionTarjeta	= 2;
		int bloqueoTarjeta		= 3;
		int desbloqueoTarjeta	= 4;
		int limitesTarjeta		= 5;
	}
	
	public static interface Enum_Pro_OpePeticion_ISOTRX {
		int activacionTarjeta		= 1;
		int desbloqueoTarjeta		= 2;
		int abonoCuenta				= 3;
		int retiroCuenta			= 4;
		int desembolsoCredito		= 5;
		int aperturaInversion		= 6;
		int cancelaInversion		= 7;
		int vencimientoAntInversion	= 8;
		int aperturaCede			= 9;
		int cancelaCede				= 10;
		int vencimientoAntCede		= 11;
		int dispersionTesoreria		= 12;
		int cobranzaAutomatica		= 13;
		int cobranzaReferencia		= 14;
		int bonificaciones			= 15;
		int transCuentaAbono		= 16;
		int transCuentaCargo		= 17;
		int bloqueoSaldo			= 18;
		int desbloqueoSaldo			= 19;
		int procesoMasivoCierre		= 20;
		int notificaSaldoCuenta		= 21;
		int reinversion				= 22;
		int reinversionCede			= 23;
	}

	public static interface Cat_Instrumentos_ISOTRX {
		String cuentaAhorro	= "1";
		String inversion	= "2";
		String cede			= "3";
		String credito		= "4";
	}

	public MensajeTransaccionBean grabaTransaccion( TarjetaDebitoBean tarjetaDebitoBean, int tipoProceso, long numeroTransaccion, int tipoTransaccion){

		MensajeTransaccionBean mensajeTransaccionBean = null;
		try{
			loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
			switch(tipoTransaccion){
				case Enum_Tran_ISOTRX.tarjetaPeticion:
					mensajeTransaccionBean = isotrxDAO.tarjetaPeticion(tarjetaDebitoBean, tipoProceso, numeroTransaccion);
				break;
				case Enum_Tran_ISOTRX.operacionPeticion:
					mensajeTransaccionBean = isotrxDAO.operacionPeticion(tarjetaDebitoBean, tipoProceso, numeroTransaccion);
				break;
				default:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean.setNumero(999);
					mensajeTransaccionBean.setDescripcion("Tipo de Transacción desconocida.");
				break;
			}
		} catch(Exception exception){
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Ha ocurrido un Error en la Operación con Tarjetas");
			}
			loggerISOTRX.error(mensajeTransaccionBean.getDescripcion(), exception);
			exception.printStackTrace();
		}
		return mensajeTransaccionBean;
	}

	public ISOTRXDAO getIsotrxDAO() {
		return isotrxDAO;
	}

	public void setIsotrxDAO(ISOTRXDAO isotrxDAO) {
		this.isotrxDAO = isotrxDAO;
	}
}
