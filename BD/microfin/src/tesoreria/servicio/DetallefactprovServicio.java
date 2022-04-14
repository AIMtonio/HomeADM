package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import cuentas.servicio.TiposCuentaServicio.Enum_Lis_TiposCuenta;

import tesoreria.bean.DetallefactprovBean;
import tesoreria.dao.DetallefactprovDAO;

public class DetallefactprovServicio  extends BaseServicio {
	private DetallefactprovServicio(){
		super();
	}

	DetallefactprovDAO detallefactprovDAO = null;

	public static interface Enum_Tra_DetalleFactura{
		int alta 			= 1;
		int modifica 		= 2;
	}
	
	public static interface Enum_Lis_DetalleFactura{
		int principal 		= 1;
		int detalleFac 		= 2;
		int detalleImp 		= 3;
		int importeImp 		= 4;
	}
	
	
	public static interface Enum_Con_DetalleFactura{
		int principal 		= 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,DetallefactprovBean detallefactprovBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_DetalleFactura.alta:
			mensaje = altaDetalleFactura(detallefactprovBean);
			break;
		}
		return mensaje;
	}
	
	

	public MensajeTransaccionBean altaDetalleFactura(DetallefactprovBean detallefactprovBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = detallefactprovDAO.altaDetalleFactura(detallefactprovBean);		
		return mensaje;
	}
	
	

	public List lista(int tipoLista, DetallefactprovBean detallefactprovBean){
		List detalleFacturaLista = null;
		switch (tipoLista) {
	        case  Enum_Lis_DetalleFactura.principal:
	        	//detalleFacturaLista = detallefactprovDAO.lista(detallefactprovBean, tipoLista);
	        break;
	        case  Enum_Lis_DetalleFactura.detalleFac:
	        	  detalleFacturaLista = detallefactprovDAO.listaDetalleFact(detallefactprovBean, tipoLista);
	        break;
	        case  Enum_Lis_DetalleFactura.detalleImp:
	        	  detalleFacturaLista = detallefactprovDAO.listaDetalleImp(detallefactprovBean, tipoLista);
	        break;
            case  Enum_Lis_DetalleFactura.importeImp:
	        	  detalleFacturaLista = detallefactprovDAO.listaImporteImp(detallefactprovBean, tipoLista);
	        break;
		}
		return detalleFacturaLista;
	}
	
	//lista de detalles de factura, se utiliza al consultarla en la requisicion
	public  Object[] listaDetalleFacturaProv(int tipoLista, DetallefactprovBean detallefactprovBean) {
		List detalleFacturaLista = null;
		switch(tipoLista){
			case Enum_Lis_DetalleFactura.detalleFac:
				detalleFacturaLista = detallefactprovDAO.listaDetalleFact(detallefactprovBean, tipoLista);
				break;	
			case Enum_Lis_DetalleFactura.detalleImp:
				detalleFacturaLista = detallefactprovDAO.listaDetalleImp(detallefactprovBean, tipoLista);
				break;	
			case Enum_Lis_DetalleFactura.importeImp:
				detalleFacturaLista = detallefactprovDAO.listaImporteImp(detallefactprovBean, tipoLista);
				break;
		}		
		return detalleFacturaLista.toArray();		
	}
	
	

	public DetallefactprovDAO getDetallefactprovDAO() {
		return detallefactprovDAO;
	}

	public void setDetallefactprovDAO(DetallefactprovDAO detallefactprovDAO) {
		this.detallefactprovDAO = detallefactprovDAO;
	}
}
