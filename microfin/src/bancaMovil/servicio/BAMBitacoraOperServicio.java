package bancaMovil.servicio;

import java.util.List;

import org.apache.log4j.Logger;

import bancaMovil.bean.BAMOperacionBean;
import bancaMovil.dao.BAMBitacoraOperDAO;
import general.servicio.BaseServicio;

public class BAMBitacoraOperServicio extends BaseServicio{
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	BAMBitacoraOperDAO bitacoraDAO=null;
	
	public static interface Enum_Tra_BitacoraOper {
		int alta		 = 1;
		int modificacion = 2;
	}
	
	public static interface Enum_Lis_BitacoraOper {
		int principal 		= 1;	
		int tiposOpe 		= 2;
	}
	
	public static interface Enum_TiposOperaciones {
		int allOperaciones	= 0;
		int inicioSesion	= 1;
	}
	
	public static interface Enum_Tipo_Operaciones {
		int inicio_sesion = 1;
		int transfer_interna = 2;
		int itransfer_spei = 3;
		int pago_servicios = 4;
		int compras = 5;
		int cambio_nip = 6;
		int cambio_frase = 7;
		int cambio_imagenAnt = 8;
		int cambio_pregSecreta = 9;		
	}


	public BAMBitacoraOperServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public List lista(BAMOperacionBean operacionBean, int tipoLista){		
		List listaPerfiles = null;
		switch (tipoLista) {
		case Enum_Lis_BitacoraOper.principal:		
			listaPerfiles = bitacoraDAO.listaPrincipal(operacionBean, operacionBean.getFechaInicio(),operacionBean.getFechaFin());				
			break;
		case Enum_Lis_BitacoraOper.tiposOpe:		
			listaPerfiles = bitacoraDAO.listaTiposOperaciones();				
			break;
		}
		
		return listaPerfiles;
	}
	
	public BAMBitacoraOperDAO getBitacoraDAO() {
		return bitacoraDAO;
	}

	public void setBitacoraDAO(BAMBitacoraOperDAO bitacoraDAO) {
		this.bitacoraDAO = bitacoraDAO;
	}	


}
