package tesoreria.servicio;

import java.util.List;

import tesoreria.bean.DetalleImpuestoBean;
import tesoreria.dao.DetalleImpuestoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class DetalleImpuestoServicio extends BaseServicio{
	
	private DetalleImpuestoServicio(){
		super();
	}
	
	DetalleImpuestoDAO detalleImpuestoDAO = null;
	
	public static interface Enum_Tra_DetalleImpuesto{
		int alta 			= 1;
	}
	
	public static interface Enum_Lis_DetalleImpuesto{
		int principal 		= 1;

	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,DetalleImpuestoBean detalleimpuestoBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_DetalleImpuesto.alta:
			mensaje = altaDetalleImpuesto(detalleimpuestoBean);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaDetalleImpuesto(DetalleImpuestoBean detalleimpuestoBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = detalleImpuestoDAO.altaDetalleImpuesto(detalleimpuestoBean);		
		return mensaje;
	}
	
	public List lista(int tipoLista, DetalleImpuestoBean detalleimpuestoBean){
		List detalleImpuestoLista = null;
		switch (tipoLista) {
	        case  Enum_Lis_DetalleImpuesto.principal:
	        	detalleImpuestoLista = detalleImpuestoDAO.listaImporteImp(detalleimpuestoBean, tipoLista);
	        break;
		}
		return detalleImpuestoLista;
	}
	
	//lista de detalles de factura, se utiliza al consultarla en la requisicion
	public  Object[] listaDetalleImpuesto(int tipoLista, DetalleImpuestoBean detalleimpuestoBean) {
		List detalleImpuestoLista = null;
		switch(tipoLista){
			case Enum_Lis_DetalleImpuesto.principal:
				detalleImpuestoLista = detalleImpuestoDAO.listaImporteImp(detalleimpuestoBean, tipoLista);
				break;	
		}		
		return detalleImpuestoLista.toArray();		
	}

	public DetalleImpuestoDAO getDetalleImpuestoDAO() {
		return detalleImpuestoDAO;
	}

	public void setDetalleImpuestoDAO(DetalleImpuestoDAO detalleImpuestoDAO) {
		this.detalleImpuestoDAO = detalleImpuestoDAO;
	}
	
	

}
