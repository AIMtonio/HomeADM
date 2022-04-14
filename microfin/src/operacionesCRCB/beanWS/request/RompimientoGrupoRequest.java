package operacionesCRCB.beanWS.request;

import operacionesCRCB.bean.RG_ListaClienteBean;
import operacionesCRCB.bean.RG_ListaCreditoBean;
public class RompimientoGrupoRequest extends BaseRequestBean {
	
	private RG_ListaCreditoBean creditoID;
	private RG_ListaClienteBean clienteID ;
	private String grupoID;
	private String numCiclo;
	
	public RG_ListaCreditoBean getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(RG_ListaCreditoBean creditoID) {
		this.creditoID = creditoID;
	}
	public RG_ListaClienteBean getClienteID() {
		return clienteID;
	}
	public void setClienteID(RG_ListaClienteBean clienteID) {
		this.clienteID = clienteID;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getNumCiclo() {
		return numCiclo;
	}
	public void setNumCiclo(String numCiclo) {
		this.numCiclo = numCiclo;
	}

}
