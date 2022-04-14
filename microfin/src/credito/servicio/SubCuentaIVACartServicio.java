package credito.servicio;

import credito.bean.SubCuentaIVACartBean;
import credito.dao.SubCuentaIVACartDAO;
import general.servicio.BaseServicio;

public class SubCuentaIVACartServicio extends BaseServicio {
	
	SubCuentaIVACartDAO subCuentaIVACartDAO = null; 
	
	public SubCuentaIVACartServicio(){
		super();
	}
	
	public static interface Enum_Con_SubCuentaIVA{
			int principal = 1;
	}
	
	public SubCuentaIVACartBean consulta(int tipoConsulta, SubCuentaIVACartBean subCuentaIVACart){
		SubCuentaIVACartBean subCuentaBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCuentaIVA.principal:
				subCuentaBean = subCuentaIVACartDAO.consultaPrincipal(subCuentaIVACart,tipoConsulta);
				break;
		}
		
		return subCuentaBean;
	}

	public SubCuentaIVACartDAO getSubCuentaIVACartDAO() {
		return subCuentaIVACartDAO;
	}

	public void setSubCuentaIVACartDAO(SubCuentaIVACartDAO subCuentaIVACartDAO) {
		this.subCuentaIVACartDAO = subCuentaIVACartDAO;
	}
	
}
