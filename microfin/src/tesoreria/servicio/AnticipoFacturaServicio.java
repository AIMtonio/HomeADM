package tesoreria.servicio;

import java.util.List;
import tesoreria.bean.AnticipoFacturaBean;
import tesoreria.dao.AnticipoFacturaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class AnticipoFacturaServicio extends BaseServicio{
	AnticipoFacturaDAO anticipoFacturaDAO = null;

	private AnticipoFacturaServicio(){
		super();
	}
	public static interface Enum_Tra_AnticipoFactura {
		int alta					= 1;
		int actualizacion			= 2;
	}
	public static interface Enum_Lis_AnticipoFactura{
		int listaAnticipoProv       = 2;
	}
	public static interface Enum_Act_AnticipoFactura {
		int cancelaAnticipo 		= 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AnticipoFacturaBean anticipoFacturaBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){		
	    	case Enum_Tra_AnticipoFactura.alta:
	    		mensaje = anticipoFacturaDAO.anticipoFacturaProv(tipoTransaccion,anticipoFacturaBean);
	    		break;
	    	case Enum_Tra_AnticipoFactura.actualizacion:
				mensaje = cancelaAnticipoFactura(anticipoFacturaBean,tipoActualizacion);
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean cancelaAnticipoFactura(AnticipoFacturaBean anticipoFacturaBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
		case Enum_Act_AnticipoFactura.cancelaAnticipo:
			if(anticipoFacturaBean.getListaAnticipo()!=null){
				List<String> listaAnticipo = anticipoFacturaBean.getListaAnticipo();
				if(!listaAnticipo.isEmpty()){
					for(int i=0; i<listaAnticipo.size(); i++){
						AnticipoFacturaBean anticipoBean = new AnticipoFacturaBean() ;
						anticipoBean.setAnticipoFactID(listaAnticipo.get(i));
					
						int anticipoFactID =  listaAnticipo.size();
							if(anticipoFactID!=0){	
								mensaje = anticipoFacturaDAO.cancelaAnticipoFactura(anticipoBean,tipoActualizacion);	
							}
						}
				}
			}
		break;		
		}
		
		return mensaje;
	}

	
	public List lista(int tipoLista, AnticipoFacturaBean anticipoFacturaBean){		
		List anticipoFacturaProv = null;
		switch (tipoLista) {	
			case Enum_Lis_AnticipoFactura.listaAnticipoProv:		
				anticipoFacturaProv = anticipoFacturaDAO.listaAnticipoFacturas(anticipoFacturaBean, tipoLista);			
				break;			 
		}				
		return anticipoFacturaProv;
	}

	public AnticipoFacturaDAO getAnticipoFacturaDAO() {
		return anticipoFacturaDAO;
	}

	public void setAnticipoFacturaDAO(AnticipoFacturaDAO anticipoFacturaDAO) {
		this.anticipoFacturaDAO = anticipoFacturaDAO;
	}

}
