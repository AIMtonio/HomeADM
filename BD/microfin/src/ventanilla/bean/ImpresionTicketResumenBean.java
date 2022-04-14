package ventanilla.bean;

import inversiones.bean.InversionBean;

import java.util.List;

import aportaciones.bean.AportacionesBean;
import cedes.bean.CedesBean;
import credito.bean.CreditosBean;
import cuentas.bean.CuentasAhoBean;
import general.bean.BaseBean;
import general.bean.MensajeTransaccionBean;

public class ImpresionTicketResumenBean extends BaseBean {

	private String opcionCajaID;
	private String descripcion;
	private String esReversa;
	private String impTicketResumen;
	private String campoPantalla;

	private String clienteID;
	private String nombreCompleto;
	private String transaccionID;
	private String safilocale;
	private String mostrarBtnResumen;

	private MensajeTransaccionBean mensajeTransaccionBean;
	private List<CuentasAhoBean> listaCuentasAhoBean;
	private List<CreditosBean> listaCreditosBean;
	private List<InversionBean> listaInversionBean;
	private List<CedesBean> listaCedesBean;
	private List<AportacionesBean> listaAportacionesBean;

	public String getOpcionCajaID() {
		return opcionCajaID;
	}
	public void setOpcionCajaID(String opcionCajaID) {
		this.opcionCajaID = opcionCajaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEsReversa() {
		return esReversa;
	}
	public void setEsReversa(String esReversa) {
		this.esReversa = esReversa;
	}
	public String getImpTicketResumen() {
		return impTicketResumen;
	}
	public void setImpTicketResumen(String impTicketResumen) {
		this.impTicketResumen = impTicketResumen;
	}
	public String getCampoPantalla() {
		return campoPantalla;
	}
	public void setCampoPantalla(String campoPantalla) {
		this.campoPantalla = campoPantalla;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getTransaccionID() {
		return transaccionID;
	}
	public void setTransaccionID(String transaccionID) {
		this.transaccionID = transaccionID;
	}
	public String getSafilocale() {
		return safilocale;
	}
	public void setSafilocale(String safilocale) {
		this.safilocale = safilocale;
	}
	public String getMostrarBtnResumen() {
		return mostrarBtnResumen;
	}
	public void setMostrarBtnResumen(String mostrarBtnResumen) {
		this.mostrarBtnResumen = mostrarBtnResumen;
	}
	public MensajeTransaccionBean getMensajeTransaccionBean() {
		return mensajeTransaccionBean;
	}
	public void setMensajeTransaccionBean(
			MensajeTransaccionBean mensajeTransaccionBean) {
		this.mensajeTransaccionBean = mensajeTransaccionBean;
	}
	public List<CuentasAhoBean> getListaCuentasAhoBean() {
		return listaCuentasAhoBean;
	}
	public void setListaCuentasAhoBean(List<CuentasAhoBean> listaCuentasAhoBean) {
		this.listaCuentasAhoBean = listaCuentasAhoBean;
	}
	public List<CreditosBean> getListaCreditosBean() {
		return listaCreditosBean;
	}
	public void setListaCreditosBean(List<CreditosBean> listaCreditosBean) {
		this.listaCreditosBean = listaCreditosBean;
	}
	public List<InversionBean> getListaInversionBean() {
		return listaInversionBean;
	}
	public void setListaInversionBean(List<InversionBean> listaInversionBean) {
		this.listaInversionBean = listaInversionBean;
	}
	public List<CedesBean> getListaCedesBean() {
		return listaCedesBean;
	}
	public void setListaCedesBean(List<CedesBean> listaCedesBean) {
		this.listaCedesBean = listaCedesBean;
	}
	public List<AportacionesBean> getListaAportacionesBean() {
		return listaAportacionesBean;
	}
	public void setListaAportacionesBean(
			List<AportacionesBean> listaAportacionesBean) {
		this.listaAportacionesBean = listaAportacionesBean;
	}
}