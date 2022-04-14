package nomina.servicio;

import java.util.List;
import nomina.bean.BitacoraPagoNominaBean;
import nomina.bean.CargaPagoErrorBean;
import nomina.dao.BitacoraPagoNominaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;



public class BitacoraPagoNominaServicio extends BaseServicio {
	BitacoraPagoNominaDAO bitacoraPagoNominaDAO = null;
	
	// -------------- Tipo Transaccion ----------------
	public static interface Enum_Tra_BitacoraPagos {
		int altaArchivos   = 1;
		int altaArchivosBE = 2;
	}
	
	public static interface Enum_Con_BitacoraPagos {
		int conInstitucion = 2;
		int conMonto	   = 3;
	}
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_BitacoraPagos{
		int lisFallos	= 1;
		int porAplicar	= 2;
	}
	
	public MensajeTransaccionBean altaPagosNomina(BitacoraPagoNominaBean bitacoraPagoNominaBean) {
		MensajeTransaccionBean mensaje = null;
		mensaje = bitacoraPagoNominaDAO.altaPagosDetalle(bitacoraPagoNominaBean);
		return mensaje;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,BitacoraPagoNominaBean bitacoraPagoNominaBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_BitacoraPagos.altaArchivos:
			mensaje= altaPagosNomina(bitacoraPagoNominaBean);
			break;
			case Enum_Tra_BitacoraPagos.altaArchivosBE:
				mensaje = bitacoraPagoNominaDAO.altaPagosDetalleBE(bitacoraPagoNominaBean);
			break;
		}
		return mensaje;
	}

	public List lista(int tipoLista, CargaPagoErrorBean cargaPagoErrorBean){
		List bitacoraCargaArchivoLista = null;
		switch (tipoLista) {
	        case  Enum_Lis_BitacoraPagos.lisFallos:          
	        	bitacoraCargaArchivoLista = bitacoraPagoNominaDAO.listaErrorBitacoraArchivo(cargaPagoErrorBean, tipoLista);
	        break;
		}
		return bitacoraCargaArchivoLista;
	}

	public BitacoraPagoNominaBean consulta(int tipoConsulta, BitacoraPagoNominaBean bitacoraPagoNominaBean){
		BitacoraPagoNominaBean consultaInstitucion = null;
		switch(tipoConsulta){
			case Enum_Con_BitacoraPagos.conInstitucion:
				consultaInstitucion = bitacoraPagoNominaDAO.consultaInstitucion(bitacoraPagoNominaBean, tipoConsulta);
			break;
			case Enum_Con_BitacoraPagos.conMonto:
				consultaInstitucion = bitacoraPagoNominaDAO.consultaMonto(bitacoraPagoNominaBean, tipoConsulta);
			break;
		}
		return consultaInstitucion;
	}
	public List listaCombo(int tipoLista, BitacoraPagoNominaBean cargaPagoNomina){
		List cargaPagoNominaLista = null;
		switch (tipoLista) {
	        case Enum_Lis_BitacoraPagos.porAplicar:
	        	cargaPagoNominaLista = bitacoraPagoNominaDAO.listaComboPorAplicar(cargaPagoNomina, tipoLista);
			break;
		}
		return cargaPagoNominaLista;
	}
	
	//------------------ Getters y Setters ------------------------------------
	public BitacoraPagoNominaDAO getBitacoraPagoNominaDAO() {
		return bitacoraPagoNominaDAO;
	}
	public void setBitacoraPagoNominaDAO(BitacoraPagoNominaDAO bitacoraPagoNominaDAO) {
		this.bitacoraPagoNominaDAO = bitacoraPagoNominaDAO;
	}
	
}