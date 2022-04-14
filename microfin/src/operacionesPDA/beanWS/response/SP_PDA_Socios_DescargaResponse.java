package operacionesPDA.beanWS.response;

import java.util.ArrayList;
import java.util.List;

import cliente.bean.ClienteBean;
import cliente.bean.GruposNosolidariosBean;
import general.bean.BaseBeanWS;

public class SP_PDA_Socios_DescargaResponse extends BaseBeanWS{

	private ArrayList<GruposNosolidariosBean> socios = new ArrayList<GruposNosolidariosBean>();
	private ArrayList<ClienteBean> cliente = new ArrayList<ClienteBean>();

	
	public void addSocio(GruposNosolidariosBean socio){  
        this.socios.add(socio);  
	}

	public List<GruposNosolidariosBean> getSocios() {
		return socios;
	}

	public void setSocios(ArrayList<GruposNosolidariosBean> socios) {
		this.socios = socios;
	}

	
	public void addCliente(ClienteBean cliente){  
        this.cliente.add(cliente);  
	}
	public ArrayList<ClienteBean> getCliente() {
		return cliente;
	}

	public void setCliente(ArrayList<ClienteBean> cliente) {
		this.cliente = cliente;
	}	
	
	
	
}
