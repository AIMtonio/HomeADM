package regulatorios.servicio;

import regulatorios.dao.ContaElecCatalogoContaDAO;
import general.servicio.BaseServicio;


public class ContaElecCatalogoContaServicio extends BaseServicio{

	
	ContaElecCatalogoContaDAO contaElecCatalogoContaDAO = null;
	
	public ContaElecCatalogoContaServicio() {
		super();
	}
	
	public ContaElecCatalogoContaDAO getContaElecCatalogoContaDAO() {
		return contaElecCatalogoContaDAO;
	}

	public void setContaElecCatalogoContaDAO(
			ContaElecCatalogoContaDAO contaElecCatalogoContaDAO) {
		this.contaElecCatalogoContaDAO = contaElecCatalogoContaDAO;
	}
	
	
	
	
}
