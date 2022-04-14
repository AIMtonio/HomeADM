package tarjetas.servicio;


import tarjetas.dao.EdoCtaCredClienteDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class EdoCtaCredClienteServicio extends BaseServicio{

	EdoCtaCredClienteDAO edoCtaCredClienteDAO = null;
	
	public static interface Enum_Con_Genera{
		int principal	= 1;
		int foranea		= 2;
		int rango 		= 3;		
	}
	
	public EdoCtaCredClienteServicio(){
		super();
	}

	
	
	
	
	
	
	
	
	public EdoCtaCredClienteDAO getEdoCtaCredClienteDAO() {
		return edoCtaCredClienteDAO;
	}

	public void setEdoCtaCredClienteDAO(EdoCtaCredClienteDAO edoCtaCredClienteDAO) {
		this.edoCtaCredClienteDAO = edoCtaCredClienteDAO;
	}
	

	
	
}